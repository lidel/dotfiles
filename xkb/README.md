# Custom XKB layouts

## pllidel - Polish QWERTY with custom tweaks

Based on `xkb/symbols/pl`, US QWERTY with Polish diacritics via Right Alt.

### Features

Polish diacritics (RAlt + letter):

- `RAlt+a` → ą, `RAlt+e` → ę, `RAlt+o` → ó
- `RAlt+s` → ś, `RAlt+c` → ć, `RAlt+n` → ń
- `RAlt+z` → ż, `RAlt+x` → ź

Quotation marks:

- `RAlt+v` → „, `RAlt+Shift+v` → " (Polish quotes)
- `RAlt+b` → ", `RAlt+Shift+b` → ß
- `RAlt+9` → «, `RAlt+0` → » (guillemets)

Arrow keys (vim-like):

- `RAlt+y` → ←, `RAlt+u` → ↓, `RAlt+i` → →
- `RAlt+Shift+u` → ↑, `RAlt+Shift+i` → ↔

Math/comparison:

- `RAlt+=` → ≈
- `RAlt+,` → ≤, `RAlt+Shift+,` → ×
- `RAlt+.` → ≥, `RAlt+Shift+.` → ÷

Other:

- `RAlt+4` → €, `RAlt+Shift+4` → ¢
- `RAlt+-` → – (en-dash), `RAlt+Shift+-` → — (em-dash)
- `RAlt+Shift+/` → ¿
- `RAlt+Space` → non-breaking space

### Dependencies

```sh
emerge x11-apps/setxkbmap
```

### Installation

```sh
sudo cp symbols/pllidel /usr/share/X11/xkb/symbols/
```

### Usage

e.g. in `.xinitrc`:

```sh
setxkbmap -layout pllidel -option '' &  # -option '' clears inherited options
```

Note: `-option ''` resets XKB options to prevent interference from previous sessions.
The layout already includes `level3(ralt_switch)` so no extra flags needed.

### If layout stops working

1. Check setxkbmap is installed: `which setxkbmap`
2. Check symbols file exists: `ls /usr/share/X11/xkb/symbols/pllidel`
3. Reinstall from this backup if needed
