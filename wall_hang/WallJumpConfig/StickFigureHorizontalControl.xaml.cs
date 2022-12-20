﻿using System;
using System.Windows;
using System.Windows.Controls;

namespace WallJumpConfig
{
    public partial class StickFigureHorizontalControl : UserControl
    {
        private const string TITLE = "StickFigureHorizontalControl";

        public StickFigureHorizontalControl()
        {
            InitializeComponent();
        }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                Redraw();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void UserControl_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            try
            {
                Redraw();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Redraw()
        {
            canvas.Children.Clear();

            double width = canvas.ActualWidth;
            double height = canvas.ActualHeight;
            Point center = new Point(width / 2, height / 2);

            canvas.Children.Add(StickFigureUtil.GetGraphic_Stickman(center));

            canvas.Children.Add(StickFigureUtil.GetGraphic_Horizontal_Arrows_Four(center));

            canvas.Children.Add(StickFigureUtil.GetGraphic_Horizontal_Wall(center + new Vector(0, -(Math.Max(StickFigureUtil.HORZ_RADIUS1, StickFigureUtil.HORZ_RADIUS2) + 24))));
        }
    }
}
