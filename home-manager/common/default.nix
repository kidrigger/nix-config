{
  self,
  pkgs,
  config,
  ...
}: {
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./git.nix
    ./terminal
    ./hyprland
  ];

  # Emacs
  # TODO Add emacs nativecomp  
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  home.file = {
    "${config.home.homeDirectory}/.config/emacs/init.el".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home-manager/common/emacs/init.el";
    "${config.home.homeDirectory}/.config/emacs/early-init.el".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home-manager/common/emacs/early-init.el";      
    "${config.home.homeDirectory}/.config/emacs/config.org".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home-manager/common/emacs/config.org";
  };

  # TODO Add emacs as a service.
}
