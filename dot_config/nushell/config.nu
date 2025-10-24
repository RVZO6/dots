#config.nu
# Shell options
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.completions.algorithm = "fuzzy"

# Vi mode cursor shapes
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"

# Starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Zoxide integration
mkdir ($nu.data-dir | path join "vendor/autoload")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

# yazi integration
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}

# keys
$env.config.keybindings = [
  {
    modifier: control
    keycode: char_y
    mode: [vi_insert vi_normal]
    event: { send: Enter }
  }
  {
    modifier: control
    keycode: char_f
    mode: [vi_insert vi_normal]
    event: { send: executehostcommand, cmd: "~/.local/bin/tmux-sessionizer" }
  }
  {
    modifier: control
    keycode: char_o
    mode: [vi_insert vi_normal]
    event: { send: executehostcommand, cmd: "y" }
  }
]
