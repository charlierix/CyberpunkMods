using AirplaneEditor.Models;
using AirplaneEditor.Models_viewmodels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace AirplaneEditor
{
    public partial class PartTree : UserControl
    {
        #region Declaration Section

        private const string TITLE = "Part TreeView";

        private const string CONTEXT_FUSELAGE = "treeview_contextmenu_fuselage";
        private const string CONTEXT_WING = "treeview_contextmenu_wing";
        private const string CONTEXT_COMPONENT = "treeview_contextmenu_component";

        #endregion

        #region Constructor

        public PartTree()
        {
            InitializeComponent();
        }

        #endregion

        #region Event Listeners

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                Blackboard.Instance.NewPlane += Blackboard_NewPlane;
                Blackboard.Instance.SelectedPartChanged += Blackboard_SelectedPartChanged;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Blackboard_NewPlane(object sender, EventArgs e)
        {
            try
            {
                treeview.Items.Clear();

                AddTreeItem(treeview.Items, Blackboard.PlaneRoot, CONTEXT_FUSELAGE);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Blackboard_SelectedPartChanged(object sender, Models_viewmodels.PlanePart_VM e)
        {
            try
            {
                foreach (TreeViewItem node in treeview.Items)
                {
                    if (FindAndSelectNode(node, e))
                        return;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void treeview_PreviewMouseRightButtonDown(object sender, MouseButtonEventArgs e)
        {
            try
            {
                TreeViewItem treeViewItem = VisualUpwardSearch(e.OriginalSource as DependencyObject);

                if (treeViewItem != null)
                {
                    treeViewItem.Focus();
                    e.Handled = true;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void treeview_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {
            try
            {
                if (e.NewValue is TreeViewItem item && item.Tag is PlanePart_VM part)
                    Blackboard.PartSelected(part);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Fuselage_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart_Fuselage_VM()
                {
                    Name = "fuselage",
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                AddTreeItem(clicked_item.tree_item.Items, child_part, GetContextMenuKey(child_part.PartType));
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Wing_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart_Wing_VM()
                {
                    Name = "wing",
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                AddTreeItem(clicked_item.tree_item.Items, child_part, GetContextMenuKey(child_part.PartType));
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Engine_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart_Engine_VM()
                {
                    Name = "engine",
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                AddTreeItem(clicked_item.tree_item.Items, child_part, GetContextMenuKey(child_part.PartType));
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Gun_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart_Gun_VM()
                {
                    Name = "gun",
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                AddTreeItem(clicked_item.tree_item.Items, child_part, GetContextMenuKey(child_part.PartType));
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Bomb_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart_Bomb_VM()
                {
                    Name = "bomb",
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                AddTreeItem(clicked_item.tree_item.Items, child_part, GetContextMenuKey(child_part.PartType));
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);
                if (clicked_item.part.Parent == null)
                {
                    MessageBox.Show("Can't delete the root fuselage", TITLE, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (clicked_item.tree_item.Parent is TreeViewItem parent_item)
                {
                    UnhookEvents(clicked_item.part);
                    parent_item.Items.Remove(clicked_item.tree_item);
                    clicked_item.part.Parent.Children.Remove(clicked_item.part);
                }
                else
                {
                    throw new ApplicationException($"Expected parent to be TreeViewItem: {clicked_item.tree_item.Parent?.ToString() ?? ""}");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Part_NameChanged(object sender, EventArgs e)
        {
            try
            {
                if (sender is PlanePart_VM part)
                {
                    TreeViewItem item = FindPart(part);
                    if (item == null)       // should never happen
                        return;

                    if (item.Header is TextBlock textblock)
                        textblock.Text = part.Name;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private void AddTreeItem(ItemCollection items, PlanePart_VM part, string contextMenuName)
        {
            var tree_item = new TreeViewItem()
            {
                IsExpanded = true,
                Header = GetTreenodeHeader(part.Name),
                Tag = part,
                ContextMenu = FindResource(contextMenuName) as ContextMenu,
            };

            items.Add(tree_item);

            HookEvents(part);

            foreach(var child in part.Children)
            {
                AddTreeItem(tree_item.Items, child, GetContextMenuKey(child.PartType));
            }
        }

        private void HookEvents(PlanePart_VM part)
        {
            part.NameChanged += Part_NameChanged;
        }
        private void UnhookEvents(PlanePart_VM part)
        {
            part.NameChanged -= Part_NameChanged;

            foreach (PlanePart_VM child in part.Children)
            {
                UnhookEvents(child);
            }
        }

        private TreeViewItem FindPart(PlanePart_VM part)
        {
            foreach (TreeViewItem item in treeview.Items)
            {
                var retVal = FindPart(item, part);
                if (retVal != null)
                    return retVal;
            }

            return null;
        }
        private static TreeViewItem FindPart(TreeViewItem item, PlanePart_VM part)
        {
            if (item.Tag is PlanePart_VM item_part && item_part == part)
                return item;

            foreach (TreeViewItem child in item.Items)
            {
                var retVal = FindPart(child, part);
                if (retVal != null)
                    return retVal;
            }

            return null;
        }

        private static (TreeViewItem tree_item, PlanePart_VM part) FindClickedItem(object sender)
        {
            if (sender is MenuItem menu_item)
            {
                if (menu_item.CommandParameter is ContextMenu context_menu)
                {
                    if (context_menu.PlacementTarget is TreeViewItem tree_item)
                    {
                        if (tree_item.Tag is PlanePart_VM part)
                        {
                            return (tree_item, part);
                        }
                    }
                }
            }

            throw new ApplicationException($"Couldn't identify sender: {sender?.ToString() ?? ""}");
        }

        private static TreeViewItem VisualUpwardSearch(DependencyObject source)
        {
            while (source != null && !(source is TreeViewItem))
                source = VisualTreeHelper.GetParent(source);

            return source as TreeViewItem;
        }

        private static FrameworkElement GetTreenodeHeader(string text)
        {
            return new TextBlock()
            {
                Text = text,
                FontSize = 14,
                Padding = new Thickness(4, 2, 4, 2),
            };
        }

        private static bool FindAndSelectNode(TreeViewItem current, PlanePart_VM part)
        {
            if (current.Tag is PlanePart_VM current_part && part == current_part)
            {
                current.IsSelected = true;
                return true;
            }

            foreach (TreeViewItem child in current.Items)
            {
                if (FindAndSelectNode(child, part))
                    return true;
            }

            return false;
        }

        private static string GetContextMenuKey(PlanePartType partType)
        {
            switch(partType)
            {
                case PlanePartType.Fuselage:
                    return CONTEXT_FUSELAGE;

                case PlanePartType.Wing:
                    return CONTEXT_WING;

                default:
                    return CONTEXT_COMPONENT;
            }
        }

        #endregion
    }
}
