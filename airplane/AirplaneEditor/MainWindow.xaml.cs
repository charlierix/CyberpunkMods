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
    public partial class MainWindow : Window
    {
        #region Declaration Section

        private const string CONTEXT_FUSELAGE = "treeview_contextmenu_fuselage";
        private const string CONTEXT_WING = "treeview_contextmenu_wing";
        private const string CONTEXT_COMPONENT = "treeview_contextmenu_component";

        private PlanePart _root = null;

        private Viewer _viewer = null;

        #endregion

        #region Constructor

        public MainWindow()
        {
            InitializeComponent();

            Background = SystemColors.ControlBrush;
        }

        #endregion

        #region Event Listeners

        private void New_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                treeview.Items.Clear();

                _root = new PlanePart()
                {
                    PartType = PlanePartType.Fuselage,
                    IsCenterline = true,
                };

                treeview.Items.Add(new TreeViewItem()
                {
                    IsExpanded = true,
                    Header = GetTreenodeHeader("root"),
                    Tag = _root,
                    ContextMenu = FindResource(CONTEXT_FUSELAGE) as ContextMenu,
                });

                if (_viewer != null)
                    _viewer.NewPlane(_root);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Viewer_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (_viewer == null)        // the user can close the viewer any time they want
                {
                    _viewer = new Viewer();
                    _viewer.Closed += Viewer_Closed;

                    if (_root != null)
                        _viewer.NewPlane(_root);

                    _viewer.Show();
                }
                else
                {
                    _viewer.Activate();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Viewer_Closed(object sender, EventArgs e)
        {
            try
            {
                _viewer.Closed -= Viewer_Closed;
                _viewer = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
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
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Fuselage_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart()
                {
                    PartType = PlanePartType.Fuselage,
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                clicked_item.tree_item.Items.Add(new TreeViewItem()
                {
                    IsExpanded = true,
                    Header = GetTreenodeHeader("fuselage"),
                    Tag = child_part,
                    ContextMenu = FindResource(CONTEXT_FUSELAGE) as ContextMenu,
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Wing_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart()
                {
                    PartType = PlanePartType.Wing,
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                clicked_item.tree_item.Items.Add(new TreeViewItem()
                {
                    IsExpanded = true,
                    Header = GetTreenodeHeader("wing"),
                    Tag = child_part,
                    ContextMenu = FindResource(CONTEXT_WING) as ContextMenu,
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Engine_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart()
                {
                    PartType = PlanePartType.Engine,
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                clicked_item.tree_item.Items.Add(new TreeViewItem()
                {
                    IsExpanded = true,
                    Header = GetTreenodeHeader("engine"),
                    Tag = child_part,
                    ContextMenu = FindResource(CONTEXT_COMPONENT) as ContextMenu,
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Gun_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart()
                {
                    PartType = PlanePartType.Gun,
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                clicked_item.tree_item.Items.Add(new TreeViewItem()
                {
                    IsExpanded = true,
                    Header = GetTreenodeHeader("gun"),
                    Tag = child_part,
                    ContextMenu = FindResource(CONTEXT_COMPONENT) as ContextMenu,
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Bomb_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart()
                {
                    PartType = PlanePartType.Bomb,
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                clicked_item.tree_item.Items.Add(new TreeViewItem()
                {
                    IsExpanded = true,
                    Header = GetTreenodeHeader("bomb"),
                    Tag = child_part,
                    ContextMenu = FindResource(CONTEXT_COMPONENT) as ContextMenu,
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);
                if (clicked_item.part.Parent == null)
                {
                    MessageBox.Show("Can't delete the root fuselage", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (clicked_item.tree_item.Parent is TreeViewItem parent_item)
                {
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
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private static (TreeViewItem tree_item, PlanePart part) FindClickedItem(object sender)
        {
            if (sender is MenuItem menu_item)
            {
                if (menu_item.CommandParameter is ContextMenu context_menu)
                {
                    if (context_menu.PlacementTarget is TreeViewItem tree_item)
                    {
                        if (tree_item.Tag is PlanePart part)
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

        #endregion
    }
}
