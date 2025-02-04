import sys, os, io, re

import collections
import glob
import yaml

def main(_, yaml_name=None):
	if yaml_name is None:
		yaml_name = f'{os.path.splitext(__file__)[0]}.yaml'

	# Read config file
	with io.open(yaml_name, 'r', encoding='utf-8') as file:
		config = yaml.safe_load(file)

	INSTALLFOLDER_KEY = 'install_folder'
	output = ''
	for key, value in config.items():
		if key == INSTALLFOLDER_KEY:
			output = value
			break

	# Create stores
	for name, store in config.items():
		if name != INSTALLFOLDER_KEY:
			print(f'Generating >{name}< store')
			Store(name, output, store).export(output + '/')

	print(f'All done!')

# Define '!append' and '!prepend' tags in Yaml

Append = collections.namedtuple('Append', 'value')
Prepend = collections.namedtuple('Prepend', 'value')

def yaml_create_append(loader, node):
	return Append(node.value)

def yaml_create_prepend(loader, node):
	return Prepend(node.value)

yaml.SafeLoader.add_constructor('!append', yaml_create_append)
yaml.SafeLoader.add_constructor('!prepend', yaml_create_prepend)

class Util:
	# List based get
	def lget(obj, list, default=None):
		try:
			for index in list:
				obj = obj[index]
			return obj
		except (KeyError, ValueError, IndexError):
			return default

	# Turns a string into a quoted string literal
	@staticmethod
	def enquote(s):
		return '"{}"'.format(s.replace('\\', '\\\\').replace('"', '\\"'))

	@staticmethod
	def dequote(s):
		if (s[1], s[-1]) == ('"', '"'):
			return s[1:-1].replace('\\"', '"').replace('\\\\', '\\')

	# Matches a value to a string pattern with wildcards (*)
	@staticmethod
	def match(value, pattern):
		pattern = str.split(pattern, '*')	# Force str type
		# No wildcards
		if len(pattern) == 1:
			return value == pattern[0]
		# Match start and end
		start, end = len(pattern[0]), len(value) - len(pattern[-1])
		if start > end or not value.startswith(pattern[0]) or not value.endswith(pattern[-1]):
			return False
		elif len(pattern) == 2:
			return True
		# Match middle parts
		pattern.pop()
		matches, forward = [(0, start)], True
		while 0 < len(matches) < len(pattern):
			i = len(matches) - 1
			if forward:
				# Forward mode, match next pattern
				pos, size = str.find(pattern[i + 1], matches[i][1], end), len(pattern[i + 1])
				if pos >= 0:
					matches.append((pos, pos + size))
				else:
					forward = False
			else:
				# Reverse mode, find new match for current pattern
				pos, size = str.find(pattern[i], matches[i][0] + 1, end), len(pattern[i])
				if pos >= 0:
					matches[i], forward = (pos, pos + size), True
				else:
					matches.pop()
		# If all parts were eventually match, its a success
		return bool(matches)

	@staticmethod
	def findfiles(root, patterns):
		files = []
		for pattern in patterns:
			pattern = os.path.join(root, pattern).replace('\\', '/').lower()
			matches = glob.glob(pattern, recursive=True)		# NOTE: the recurse only works if the filename pattern is something like '**/*.yaml' after the specified folder
			files.extend(matches)
		return files

# Simulates a Tweak Database for TweakXL, for to recognize item types better
class TweakXLSimulator:

	def __init__(self):
		self.db = {}

	def load(self, text):
		# Parse yaml
		data = None
		try:
			data = yaml.safe_load(text)
		except:
			return

		# Apply definitions
		for k, v in data.items():
			self.define(self.db, k, v)

	def loadf(self, file):
		# Handle filename
		if isinstance(file, str):
			with io.open(file, 'r', encoding='utf-8') as file:
				return self.loadf(file)
		# Handle file like object
		self.load(file.read())

	def get(self, base, attr, default=None):
		for part in attr.split('.'):
			try:
				base = base[part]
			except (KeyError, IndexError):
				return default
		return base

	def copy(self, obj):
		# Deepcopy object
		if isinstance(obj, dict):
			return {k : self.copy(v) for k, v in obj.items()}
		elif isinstance(obj, (list, tuple)):
			return [self.copy(x) for x in obj]
		else:
			return obj

	def items(self, base=None):
		if base is None:
			base = self.db
		stack = [((), base)]
		while stack:
			path, item = stack.pop()
			yield '.'.join(path), item
			if isinstance(item, dict):
				stack += [((*path, k), v) for k, v in item.items()]

	def define(self, base, attr, value, decode=True):
		# Resolve all but the last attribute in the chain
		attr = attr.split('.')
		for part in attr[:-1]:
			base, prev = base.get(part), base
			if base is None:
				prev[part] = base = {}
		attr = attr[-1]
		# Assign value
		if isinstance(value, dict):
			base, prev = base.get(attr), base
			basename = value.get('$base')
			if basename is not None:
				template = self.get(self.db, basename)
				if template is not None:
					prev[attr] = base = self.copy(template)
			if not isinstance(base, dict):
				prev[attr] = base = {}
			for k, v in value.items():
				if k != '$base':
					self.define(base, k, v)
			if basename:
				base['$base'] = [basename]
				if template:
					base['$base'] += template.get('$base', [])

		elif isinstance(value, (list, tuple)):
			prepend, append, replace = [], [], []
			for item in value:
				if isinstance(item, Append):
					append.append(item.value)
				elif isinstance(item, Prepend):
					prepend.append(item.value)
				else:
					replace.append(item)
			if replace:
				base[attr] = prepend + replace + append
			elif prepend or append:
				base[attr] = prepend + base.get(attr, []) + append
			else:
				base[attr] = []

		elif decode:
			base[attr] = self.decode(value)
		else:
			base[attr] = value

	@staticmethod
	def match(name, obj, filters):
		if not filters:
			return True
		for filter in filters:
			field, filter = filter.split(':', 1)
			if field == '$name':
				if Util.match(name, filter):
					return True
			else:
				value = obj.get(field)
				if isinstance(value, (int, str)):
					if Util.match(str(item), filter):
						return True
				elif isinstance(value, (list, tuple)):
					for item in value:
						if Util.match(str(item), filter):
							return True
		return False

	@staticmethod
	def decode(value, CName=True, TweakDBID=True):
		if isinstance(value, str):
			if CName:
				if value.startswith('n"') and value.endswith('"'):
					return Util.dequote(value[1:])
				elif value.startswith('CName(') and value.endswith(')'):
					return value.dequote(value[6:].strip())
			if TweakDBID:
				if value.startswith('t"') and value.endswith('"'):
					return Util.dequote(value[1:])
				elif value.startswith('TweakDBID(') and value.endswith(')'):
					return value.dequote(value[10:].strip())
			if value == 'None':
				return None
		return value

class Store:

	Template = '\n'.join([
		'// AUTOMATICALLY GENERATED CODE',
		'@addMethod(gameuiInGameMenuGameController)',
		'protected cb func Register{id}Store(event: ref<VirtualShopRegistration>) -> Bool {{',
		'  event.AddStore(',
		'    n"{id}",',
		'    {name},',
		'    [{items}],',
		'    [{prices}],',
		'    r{atlas},',
		'    n{icon},',
		'    [{qualities}],',
		'    [{supplies}]',
		'  );',
		'}}'
	])

	QualityToIndex = {
		'Quality.Common' : 0,
		'Quality.Uncommon' : 1,
		'Quality.Rare' : 2,
		'Quality.Epic' : 3,
		'Quality.Legendary' : 4,
		'Quality.Random' : 4,
		None : 0
	}

	def __init__(self, name, root, config):
		self.name = name
		self.root = root
		self.config = config
		self.store = None

	def build(self):
		# Find source files
		files = sorted(Util.findfiles(self.root, self.config.get('sources', ())))
		# Load source files into TweakXL simulator
		self.tweakxl = TweakXLSimulator()
		for file in files:
			self.tweakxl.loadf(file)

		# Build the store
		self.store = {
			'id' : self.config.get('id', self.makeid(self.name)),
			'name' : self.name,
			'atlas' : self.config['icon'][0],
			'icon' : self.config['icon'][1],
			'items' : [],
			'prices' : [],
			'qualities' : [],
			'supplies' : [],
			'types' : [],
		}

		# Process TweakXL database
		filters = self.config.get('filters', [])
		blacklist = set(self.config.get('blacklist', []))
		price_list = Util.lget(self.config, ['pricing', 'categories'], {})
		price_multiplier = Util.lget(self.config, ['pricing', 'multiplier'], 1.0)
		iconic_price = Util.lget(self.config, ['pricing', 'iconic'])
		default_price = Util.lget(self.config, ['pricing', 'default'], [0, 0, 0, 0, 0])
		supply_list = Util.lget(self.config, ['supply', 'categories'], {})
		iconic_supply = Util.lget(self.config, ['supply', 'iconic'])
		default_supply = Util.lget(self.config, ['supply', 'default'], [1, 1, 1, 1, 1])

		for k, v in self.tweakxl.items():
			# Keep only full objects
			if not k or not isinstance(v, dict):
				continue
			type_name = v.get('$type') or v.get('$base')
			if type_name is None:
				continue
			# Apply blacklist
			if k in blacklist:
				continue
			# Apply filters
			if not self.tweakxl.match(k, v, filters):
				continue
			# Get attributes
			iconic = ('Quality.IconicItem' in v.get('statModifiers', []))
			quality = self.QualityToIndex[v.get('quality')]
			# Lookup base price
			price = default_price[quality]
			for category, entry in price_list.items():
				if self.tweakxl.match(k, v, [category]):
					price = entry[quality]
					break
			# Apply price modifiers
			if price > 0:
				if iconic and iconic_price is not None:
					price += iconic_price[quality]
				price = max(1, int(price * price_multiplier))
			else:
				price = 0
			# Calculate supply
			supply = default_supply[quality]
			for category, entry in supply_list.items():
				if self.tweakxl.match(k, v, [category]):
					supply = entry[quality]
					break
			if iconic and iconic_supply is not None:
				supply = iconic_supply[quality]
			# Add item to store
			self.store['items'].append(k)
			self.store['prices'].append(price)
			self.store['qualities'].append(['Common', 'Uncommon', 'Rare', 'Epic', 'Legendary'][quality])
			self.store['supplies'].append(supply)
			self.store['types'].append(re.sub(r'^\w+\.', '', type_name[0]))		# strip off 'Items.' from 'Items.GenericFootClothing'

	def export(self, prefix):
		# Build store when needed
		if self.store is None:
			self.build()

		# Group by type of clothing (shoes, pants, etc)
		distinct_types = list(set(self.store['types']))

		# Create a unique file for each of those types
		for distinct_type in distinct_types:
			# Find all indices where this type occurs
			indices = [i for i, t in enumerate(self.store['types']) if t == distinct_type]

			# Collect data for this type using the indices
			items_for_type = [self.store['items'][i] for i in indices]
			prices_for_type = [self.store['prices'][i] for i in indices]
			qualities_for_type = [self.store['qualities'][i] for i in indices]
			supplies_for_type = [self.store['supplies'][i] for i in indices]

			# Create the data dictionary
			data = {
				'id': f"{self.store['id']}_{distinct_type}",
				'name': Util.enquote(f"{self.store['name']} - {distinct_type}"),
				'atlas': Util.enquote(self.store['atlas']),
				'icon': Util.enquote(self.store['icon']),
				'items': ', '.join([Util.enquote(x) for x in items_for_type]),
				'prices': ', '.join(map(str, prices_for_type)),
				'qualities': ', '.join([Util.enquote(x) for x in qualities_for_type]),
				'supplies': ', '.join(map(str, supplies_for_type))
			}

			# Export store to file

			# Get base filename and extension
			base_filename = self.config['filename']
			name_part, ext = os.path.splitext(base_filename)

			# Insert distinct_type into the filename
			new_filename = f"{name_part}-{distinct_type}{ext}"

			# Export store to file with new filename
			with io.open(prefix + new_filename, 'w', encoding='utf-8') as file:
				file.write(self.Template.format(**data))			

	@staticmethod
	def makeid(text, charset = set('ABCDEFGHIJKLMNOPQRSTUVWXYZ_')):
		return ''.join(char for char in text.upper() if char in charset)

if __name__ == '__main__':
	main(*sys.argv)