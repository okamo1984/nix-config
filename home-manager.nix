{ config, lib, pkgs, nixpkgs-unstable, ... }:

let
  pkgsUnstable = import nixpkgs-unstable {};
in
{
  home.stateVersion = "23.05";

  xdg.enable = true;

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.bat
    pkgs.fd
    pkgs.fzf
    pkgs.jq
    pkgs.unar
    pkgs.ripgrep
    pkgs.tree
    
    # Go
    pkgs.gopls
    pkgs.delve
    pkgs.go-tools

    # Zig
    pkgs.zigpkgs.master

    # Rust
    pkgs.cargo
    pkgs.clippy
    pkgs.rustc
    pkgs.rustfmt
    pkgs.rust-analyzer
    
    # Node.js
    pkgs.nodejs

    # JVM
    pkgs.gradle
    pkgs.maven

    # IaC
    pkgs.terraform
    pkgs.terraform-ls

    # GCP
    pkgs.google-cloud-sdk

    # Container
    pkgs.colima
    pkgs.docker
    pkgs.cosign

    # VPN
    pkgs.tailscale
  ];

  programs.direnv = {
    enable = true;
  };

  programs.fish = {
    enable = true;
     interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" ([
      "source ${pkgs.fishPlugins.bobthefish}/share/fish/vendor_functions.d/fish_prompt.fish"
      "source ${pkgs.fishPlugins.bobthefish}/share/fish/vendor_functions.d/fish_right_prompt.fish"
      "source ${pkgs.fishPlugins.bobthefish}/share/fish/vendor_functions.d/fish_title.fish"
      (builtins.readFile ./config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]));

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };

    plugins = [
      { name = "fzh-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "fish-foreign-env"; src = pkgs.fishPlugins.foreign-env.src; }
      { name = "theme-bobthefish"; src = pkgs.fishPlugins.bobthefish.src; }
    ];
  };

  programs.git = {
    enable = true;
    userName = "okamo";
    userEmail = "okamo1984@gmail.com";
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
      change-commits = "!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch -f --env-filter \"if [[ \\\"$`echo $VAR`\\\" = '$OLD' ]]; then export $VAR='$NEW'; fi\" \$@; }; f";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askpass = "";
      credential.helper = "store";
      github.user = "okamo1984";
      push.default = "upstream";
      init.defaultBranch = "main";
      core.editor = "code --wait";
    };
  };

  programs.gh = {
    enable = true;

    settings = {
      aliases = {
        co = "pr checkout";
        pv = "pr view";
        rv = "repo view";
        pc = "pr create";
      };
    
      editor = "code --wait";
    };
  };

  programs.go = {
    enable = true;
    goPath = "code/go";
  };

  programs.java = {
    enable = true;
    package = pkgs.temurin-bin-17;
  };

  programs.vscode = {
    enable = true;
    package = pkgsUnstable.vscode;

    extensions = with pkgs.vscode-extensions; [
      # Maintained by Organization
      github.github-vscode-theme
      github.vscode-pull-request-github
      github.vscode-github-actions
      github.copilot
      golang.go
      rust-lang.rust-analyzer
      hashicorp.terraform
      ms-azuretools.vscode-docker
      redhat.vscode-yaml

      # Maintained by Individual
      mhutchie.git-graph
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "ruby-lsp";
        publisher = "Shopify";
        version = "0.4.2"; 
        sha256 = "Q7ZZs/81+VrHKs3rpMwMfE3+DOS9bDJaoHEpYHoRqoo=";
      }
      {
        name = "kotlin";
        publisher = "fwcd";
        version = "0.2.31";
        sha256 = "Y20Uqje/NzjBh23I9cXczlWFPEpb3qkqY/KsZvHKz/o=";
      }
    ];

    userSettings = builtins.fromJSON (builtins.readFile ./vscode/settings.json);
  };

  programs.rbenv = {
    enable = true;
  };
}
