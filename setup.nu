# quaso setup

## Copy config from quaso to system
# usage: nu quaso.nu setup
def setup [] {
  rsync -av --progress --exclude ".git" --exclude "setup.nu" . ~/.config/nixcfg/
}

## Copy config from system to quaso
# usage: nu quaso.nu copy
def copy [] {
  rsync -av --progress ~/.config/nixcfg/ .
}

## Main entry point
def main [command: string, ...args: string] {
  match $command {
    "setup" => { setup }
    "copy" => { copy }
    _ => { echo $"Unknown command: ($command)" }
  }
}
