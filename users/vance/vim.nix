self: super:

let sources = import ../../nix/sources.nix; in rec {
  # My vim config
  customVim = with self; {
    vim-fish = vimUtils.buildVimPlugin {
      name = "vim-fish";
      src = sources.vim-fish;
    };

    vim-fugitive = vimUtils.buildVimPlugin {
      name = "vim-fugitive";
      src = sources.vim-fugitive;
    };

    vim-misc = vimUtils.buildVimPlugin {
      name = "vim-misc";
      src = sources.vim-misc;
    };

    vim-pgsql = vimUtils.buildVimPlugin {
      name = "vim-pgsql";
      src = sources.vim-pgsql;
    };

    solarized8 = vimUtils.buildVimPlugin {
      name = "solarized8";
      src = pkgs.fetchFromGitHub {
        owner = "lifepillar";
        repo = "vim-solarized8";
        rev = "28b81a4263054f9584a98f94cca3e42815d44725";
        sha256 = "usnDuV0EJ7jD0eB+/NLIhLRle865hbbuF7MC33R3AG8=";
      };
    };

    vim-nord = vimUtils.buildVimPlugin {
      name = "vim-nord";
      src = sources.vim-nord;
    };

    nvim-comment = vimUtils.buildVimPlugin {
      name = "nvim-comment";
      src = sources.nvim-comment;
      buildPhase = ":";
    };

    nvim-plenary = vimUtils.buildVimPlugin {
      name = "nvim-plenary";
      src = sources.nvim-plenary;
      buildPhase = ":";
    };

    nvim-telescope = vimUtils.buildVimPlugin {
      name = "nvim-telescope";
      src = sources.nvim-telescope;
      buildPhase = ":";
    };

    nvim-treesitter = vimUtils.buildVimPlugin {
      name = "nvim-treesitter";
      src = sources.nvim-treesitter;
    };

    nvim-treesitter-playground = vimUtils.buildVimPlugin {
      name = "nvim-treesitter-playground";
      src = sources.nvim-treesitter-playground;
    };

    nvim-lspconfig = vimUtils.buildVimPlugin {
      name = "nvim-lspconfig";
      src = sources.nvim-lspconfig;

      # We have to do this because the build phase runs tests which require
      # git and I don't know how to get git into here.
      buildPhase = ":";
    };

    nvim-lspinstall = vimUtils.buildVimPlugin {
      name = "nvim-lspinstall";
      src = sources.nvim-lspinstall;
    };

    nvim-treesitter-textobjects = vimUtils.buildVimPlugin {
      name = "nvim-treesitter-textobjects";
      src = sources.nvim-treesitter-textobjects;
    };
  };

  tree-sitter-proto = self.callPackage
    (sources.nixpkgs + /pkgs/development/tools/parsing/tree-sitter/grammar.nix) { } {
    language = "proto";
    version  = "0.1.0";
    source   = sources.tree-sitter-proto;
  };

  tree-sitter-hcl = self.callPackage
    (sources.nixpkgs + /pkgs/development/tools/parsing/tree-sitter/grammar.nix) { } {
    language = "hcl";
    version  = "0.1.0";
    source   = sources.tree-sitter-hcl;
  };
}
