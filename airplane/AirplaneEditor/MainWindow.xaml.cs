﻿using AirplaneEditor.Models;
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
                    Header = "root",
                    Tag = _root,
                    ContextMenu = FindResource(CONTEXT_FUSELAGE) as ContextMenu,
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Save_Click(object sender, RoutedEventArgs e)
        {

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
                    Header = "fuselage",
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
                    Header = "wing",
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
                    Header = "engine",
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
                    Header = "gun",
                    Tag = child_part,
                    ContextMenu = FindResource(CONTEXT_COMPONENT) as ContextMenu,
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void BombBay_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var clicked_item = FindClickedItem(sender);

                var child_part = new PlanePart()
                {
                    PartType = PlanePartType.BombBay,
                    IsCenterline = false,
                    Parent = clicked_item.part,
                };

                clicked_item.part.Children.Add(child_part);

                clicked_item.tree_item.Items.Add(new TreeViewItem()
                {
                    IsExpanded = true,
                    Header = "bomb bay",
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
                if(clicked_item.part.Parent == null)
                {
                    MessageBox.Show("Can't delete the root fuselage", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if(clicked_item.tree_item.Parent is TreeViewItem parent_item)
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

        #endregion
    }
}
