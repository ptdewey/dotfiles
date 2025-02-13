#!/bin/sh

base00="14/14/15" #141415
base01="c4/82/82" #c48282
base02="ab/9d/bd" #ab9dbd
base03="e8/b5/89" #e8b589
base04="7e/98/e8" #7e96c8
base05="9b/b4/bc" #9bb4bc
base06="9c/a6/7d" #9ca67d
base07="cd/cd/cd" #cdcdcd
base08="33/37/38" #333738
base09=$base01
base0A=$base02
base0B=$base03
base0C=$base04
base0D=$base05
base0E=$base06
base0F=$base07

color00=$base00
color01=$base01
color02=$base02
color03=$base03
color04=$base04
color05=$base05
color06=$base06
color07=$base07
color08=$base08
color09=$base09
color10=$base0A
color11=$base0B
color12=$base0C
color13=$base0D
color14=$base0E
color15=$base0F


if [ -n "$BASE16_SHELL_SET_BACKGROUND" ]; then
  if [ "$BASE16_SHELL_SET_BACKGROUND" = true ]; then
    color16=$base00
    color17=$base00
  else
    color16=$base01
    color17=$base01
  fi
else
  color16=$base01
  color17=$base01
fi

color18=$base01
color19=$base02
color20=$base03
color21=$base04

# 16 color space
if [ -n "$TMUX" ]; then
  put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
  put_template() { printf '\033P\033]4;%d;rgb:%s\033\\\033\\' $@; }
  put_template_var() { printf '\033P\033]%d;rgb:%s\033\\\033\\' $@; }
  put_template_custom() { printf '\033P\033]%s%s\033\\\033\\' $@; }
elif [ "${TERM%%-*}" = "linux" ]; then
  put_template() { [ $1 -lt 16 ] && printf '\033]P%x%s' $1 $(echo $2 | sed 's/\///g'); }
  put_template_var() { true; }
  put_template_custom() { true; }
else
  put_template() { printf '\033]4;%d;rgb:%s\033\\' $@; }
  put_template_var() { printf '\033]%d;rgb:%s\033\\' $@; }
  put_template_custom() { printf '\033]%s%s\033\\' $@; }
fi

put_template 0  $color00
put_template 1  $color01
put_template 2  $color02
put_template 3  $color03
put_template 4  $color04
put_template 5  $color05
put_template 6  $color06
put_template 7  $color07
put_template 8  $color08
put_template 9  $color09
put_template 10 $color10
put_template 11 $color11
put_template 12 $color12
put_template 13 $color13
put_template 14 $color14
put_template 15 $color15

put_template_var 10 $base05
if [ "$BASE16_SHELL_SET_BACKGROUND" != false ]; then
  put_template_var 11 $base00
fi
put_template_custom 12 ";7"

unset -f put_template
unset -f put_template_var
unset -f put_template_custom
unset color00
unset color01
unset color02
unset color03
unset color04
unset color05
unset color06
unset color07
unset color08
unset color09
unset color10
unset color11
unset color12
unset color13
unset color14
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
