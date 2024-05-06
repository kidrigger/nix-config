# (import (builtins.fetchTarball {
#   url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
#   sha256 = "sha256:1bbi2c2c6d3h9d90izkdlknrva2w8m07s2w6932igfi07b2p4nlm";
# }))
(import (builtins.fetchGit {
  url = "https://github.com/nix-community/emacs-overlay.git";
  ref = "master";
  rev = "efbc49e6be628b0a4ef55b731255a266bdaafd97"; # change the revision
  }))
