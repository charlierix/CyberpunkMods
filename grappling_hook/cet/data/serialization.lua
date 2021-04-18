-- This serializes a table into json
--
-- Copied from psiberx's project (NonameNonumber)
-- https://github.com/psiberx/cp2077-cet-kit/tree/main/mods/GameSession-KillStats
--
-- NOTE: The table's keys must be strings
function Serialize_Table(t, maxDepth, depth)
	if type(t) ~= 'table' then
		return ''
	end

	maxDepth = maxDepth or 63
	depth = depth or 0      -- how many indentations it's at (useful when recursing)

	local dumpStr = '{\n'
	local indent = string.rep('\t', depth)

	for k, v in pairs(t) do
		local ktype = type(k)
		local vtype = type(v)

        -- Key
		local kstr = ''
		if ktype == 'string' then
			kstr = string.format('[%q] = ', k)
        else
            print("Serialization Error: Unexpected key's type: " .. tostring(ktype) .. " (" .. tostring(k) .. ")")
            return nil
		end

        -- Value
		local vstr = ''
		if vtype == 'string' then
			vstr = string.format('%q', v)       -- %q looks like it escapes the text so it can be deserialized later

		elseif vtype == 'table' then
			if depth < maxDepth then
				vstr = Serialize_Table(v, maxDepth, depth + 1)
			end

		-- elseif vtype == 'userdata' then
		-- 	vstr = tostring(v)
		-- 	if vstr:find('^userdata:') or vstr:find('^sol%.') then
		-- 		if not sessionDataRelaxed then
		-- 			--vtype = vstr:match('^sol%.(.+):')
		-- 			if ktype == 'string' then
		-- 				raiseError(('Cannot store userdata in the %q field.'):format(k))
		-- 			else
		-- 				raiseError(('Cannot store userdata in the list.'))
		-- 			end
		-- 		else
		-- 			vstr = ''
		-- 		end
		-- 	end

		-- elseif vtype == 'function' or vtype == 'thread' then
		-- 	if not sessionDataRelaxed then
		-- 		if ktype == 'string' then
		-- 			raiseError(('Cannot store %s in the %q field.'):format(vtype, k))
		-- 		else
		-- 			raiseError(('Cannot store %s.'):format(vtype))
		-- 		end
		-- 	end

		else
			vstr = tostring(v)
		end

		if vstr ~= '' then
			dumpStr = string.format('%s\t%s%s%s,\n', dumpStr, indent, kstr, vstr)
		end
	end

	return string.format('%s%s}', dumpStr, indent)
end

function Deserialize_Table(json)
	local chunk = loadstring('return ' .. json, '')
	return chunk and chunk() or {}
end