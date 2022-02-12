local styles = data.raw["gui-style"].default

-- from https://github.com/raiguard/Factorio-SmallMods/wiki/GUI-Style-Guide
styles.rs_titlebar_drag_handle = {
  type = "empty_widget_style",
  parent = "draggable_space",
  left_margin = 4,
  right_margin = 4,
  height = 24,
  horizontally_stretchable = "on"
}

styles.rs_product_label = {
	type = "label_style",
  parent = "bold_label"
  -- TODO
}

styles.rs_stage_label = {
	type = "label_style",
	parent = "bold_label",
	bottom_padding = 2
}
