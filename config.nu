# setup.nu

## Simplified Nix Commands

def rbs [] {
  nixos-rebuild switch --flake . --use-remote-sudo
}

def rbs-debug [] {
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose
}

def up-flake [] {
  nix flake update --flake .
}

## Update specific input
# usage: nu setup.nu up-pkg home-manager
def up-pkg [i: string] {
  nix flake update $i
}

def history [] {
  nix profile history --profile /nix/var/nix/profiles/system
}

def repl [] {
  nix repl -f flake:nixpkgs
}

def clean [] {
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
}

def gc [] {
  # garbage collect all unused nix store entries
  sudo nix-collect-garbage --delete-old
}

# Update everything
def up-all [] {
  up-flake
  rbs-debug
}

## Main entry point
def main [command: string, ...args: string] {
  match $command {
    "rbs" => { rbs }
    "rbs-debug" => { rbs-debug }
    "up-flake" => { up-flake }
    "up-pkg" => { up-pkg $args.0 }
    "history" => { history }
    "repl" => { repl }
    "clean" => { clean }
    "gc" => { gc }
    _ => { echo $"Unknown command: ($command)" }
  }
}
