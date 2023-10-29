namespace grapple_ui.models.stylesheet
{
    public record ComboBox
    {
        public double padding { get; init; }

        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public string border_color { get; init; }

        public string background_color_standard { get; init; }

        // dropdown items being interacted with
        public string background_color_selected { get; init; }
        public string background_color_hover { get; init; }
        public string background_color_click { get; init; }

        // color of the text
        public string foreground_color { get; init; }

        // the button with the down arrow
        public string button_color_standard { get; init; }
        public string button_color_hover { get; init; }

        /// <summary>
        /// NOTE: The scrollbar's background color is applied over top of the listbox's background color.  So an opacity of
        /// zero would make this background the same as the listbox's
        /// </summary>
        /// <remarks>
        /// I didn't test the other scrollbar colors to see if they overwrite or lay over this background
        /// </remarks>
        public string scrollbar_background_color { get; init; }
        public string scrollbar_grab_color_standard { get; init; }
        public string scrollbar_grab_color_hover { get; init; }
        public string scrollbar_grab_color_click { get; init; }
    }
}
