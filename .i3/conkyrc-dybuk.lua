conky.config = {
-- Conky config for i3
-- Updates: http://github.com/lidel/dotfiles/

-- vim: ts=4 et sw=4

--out_to_x no
--own_window no
	out_to_console = true,
	background = false,
	max_text_width = 0,

-- Update interval in seconds
	update_interval = 1.0,

-- This is the number of times Conky will update before quitting.
-- Set to zero to run forever.
	total_run_times = 0,

-- Shortens units to a single character (kiB->k, GiB->G, etc.). Default is off.
	short_units = true,

-- How strict should if_up be when testing an interface for being up?
-- The value is one of up, link or address, to check for the interface
-- being solely up, being up and having link or being up, having link
-- and an assigned IP address.
	if_up_strictness = 'address',

-- Add spaces to keep things from moving about?  This only affects certain objects.
-- use_spacer should have an argument of left, right, or none
	use_spacer = 'left',

-- number of cpu samples to average
-- set to 1 to disable averaging
	cpu_avg_samples = 2,

-- number of net samples to average
-- set to 1 to disable averaging
	net_avg_samples = 2,

-- Stuff after 'TEXT' will be formatted on screen
};

conky.text = [[

# JSON for i3bar

[
${if_mpd_playing}
  {
    "full_text": "♪ $mpd_artist – $mpd_title",
    "color": "\#a89984"
  },
${endif}
${if_up eth0}
  {
    "full_text": "${downspeedf eth0}↓",
    "color":
    ${if_match ${downspeedf eth0}>1000}
        "\#d79921"
    ${else}
        ${if_match ${downspeedf eth0}>10}
            "\#98971a"
        ${else}
            "\#a89984"
        ${endif}
    ${endif}
  },
  {
    "full_text": "${upspeedf eth0}↑",
    "color":
    ${if_match ${upspeedf eth0}>1000}
        "\#d79921"
    ${else}
        ${if_match ${upspeedf eth0}>10}
            "\#d79921"
        ${else}
            "\#a89984"
        ${endif}
    ${endif}
  },
${endif}
${if_up wlan0}
  {
    "full_text": "≈ ${wireless_essid wlan0}[${wireless_link_qual_perc wlan0}%]"
    "color": "\#a89984"
  },
  {
    "full_text": "${downspeedf wlan0}↓",
    "color":
    ${if_match ${downspeedf wlan0}>1000}
        "\#cc241d"
    ${else}
        ${if_match ${downspeedf wlan0}>10}
            "\#d79921"
        ${else}
            "\#a89984"
        ${endif}
    ${endif}
  },
  {
    "full_text": "${upspeedf wlan0}↑",
    "color":
    ${if_match ${upspeedf wlan0}>1000}
        "\#cc241d"
    ${else}
        ${if_match ${upspeedf wlan0}>10}
            "\#98971a"
        ${else}
            "\#a89984"
        ${endif}
    ${endif}
  },
${endif}
  {
    "full_text": "♪ ${exec amixer get Master | grep "Front Left:" | awk '{print $5}' | sed 's:^.\(.*\).$:\1:'}",
    "color": "\#a89984"
  },
  {
    "full_text": "≣ ${memperc}%",
    "color":
    ${if_match ${memperc}>50}
        "\#cc241d"
    ${else}
        ${if_match ${memperc}>85}
            "\#d79921"
        ${else}
            "\#a89984"
        ${endif}
    ${endif}
  },
  {
    "full_text": "⊞",
    "color": "\#a89984"
  },
  {
    "full_text": "R${diskio_read nvme0n1}",
    "color": "\#a89984"
  },
  {
    "full_text": "W${diskio_write nvme0n1}",
    "color": "\#a89984"
  },
  {
    "full_text": "GPU${hwmon 2 temp 1}℃",
    "color":
      ${if_match ${hwmon 2 temp 1}>65}
        "\#cc241d"
      ${else}
        ${if_match ${hwmon 2 temp 1}>50}
          "\#d79921"
        ${else}
          "\#a89984"
        ${endif}
      ${endif}
  },
  {
    "full_text": "CPU${hwmon 0 temp 4}℃",
    "color":
      ${if_match ${hwmon 0 temp 4}>65}
        "\#cc241d"
      ${else}
        ${if_match ${hwmon 0 temp 4}>50}
          "\#d79921"
        ${else}
          "\#a89984"
        ${endif}
      ${endif}
  },
  {
    "full_text": "MB1${hwmon 0 temp 1}℃",
    "color":
      ${if_match ${hwmon 0 temp 1}>65}
        "\#cc241d"
      ${else}
        ${if_match ${hwmon 0 temp 1}>50}
          "\#d79921"
        ${else}
          "\#a89984"
        ${endif}
      ${endif}
  },
  {
    "full_text": "MB2${hwmon 0 temp 2}℃",
    "color":
      ${if_match ${hwmon 0 temp 2}>65}
        "\#cc241d"
      ${else}
        ${if_match ${hwmon 0 temp 2}>50}
          "\#d79921"
        ${else}
          "\#a89984"
        ${endif}
      ${endif}
  },
  {
    "full_text": "MB3${hwmon 0 temp 3}℃",
    "color":
      ${if_match ${hwmon 0 temp 3}>65}
        "\#cc241d"
      ${else}
        ${if_match ${hwmon 0 temp 3}>50}
          "\#d79921"
        ${else}
          "\#a89984"
        ${endif}
      ${endif}
  },
  {
    "full_text": "SSD${hwmon 1 temp 1}℃",
    "color":
      ${if_match ${hwmon 1 temp 1}>65}
        "\#cc241d"
      ${else}
        ${if_match ${hwmon 1 temp 1}>50}
          "\#d79921"
        ${else}
          "\#a89984"
        ${endif}
      ${endif}
  },
  {
    "full_text": "${loadavg 1}",
    "color":
    ${if_match ${loadavg 1}>32}
        "\#cc241d"
    ${else}
        ${if_match ${loadavg 1}>16}
            "\#d79921"
        ${else}
            "\#a89984"
        ${endif}
    ${endif}
  },
  {
    "full_text": "${loadavg 2} ${loadavg 3}",
    "color": "\#a89984"
  },
  {
    "full_text": "${time %Y-%m-%d}",
    "color": "\#a89984"
  },
  {
    "full_text": "${time %H:%M:%S}",
    "color": "\#ebdbb2"
  },
  {
    "full_text": ""
  }
],

]];
