hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 1,
    border_size = 2,
    col = {
      active_border = "rgba(d79921ff)",
      inactive_border = "rgba(595959ff)",
    },
    resize_on_border = true,
    extend_border_grab_area = 10,
    resize_corner = 3,
    allow_tearing = false,
    layout = "scrolling",
  },
  misc = {
    focus_on_activate = true,
    animate_manual_resizes = true,
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
  scrolling = {
    column_width = 1,
  },
  group = {
    col = {
      border_active = "rgba(fabd2fff)",
      border_inactive = "rgba(595959ff)",
    },
    groupbar = {
      gradients = true,
      font_family = "MonoLisa",
      font_weight_active = "bold",
      font_weight_inactive = "medium",
      font_size = 14,
      height = 25,
      text_color_inactive = "rgba(fbf1c7ff)",
      text_color = "rgba(fbf1c7ff)",
      col = {
        active = "rgba(98971aff)",
        inactive = "rgba(1d2021ff)",
      },
      gaps_in = 0,
      gaps_out = 0,
      indicator_gap = 0,
      indicator_height = 0,
    },
  },
  decoration = {
    rounding = 5,
    rounding_power = 10,
    active_opacity = 1,
    inactive_opacity = 1,
    shadow = {
      enabled = false,
    },
    blur = {
      enabled = false,
    },
  },
  animations = {
    enabled = false,
  },
})
