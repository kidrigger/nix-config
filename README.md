# Bob's Nix Config

- 

## Usage

- Clone the repository
- Add a `nixos/hardware-<host>.nix` with your system's configuration
- Import it in `nixos/conf-<host>.nix`
- Run
  ```
  sudo nixos-rebuild switch --flake .#<hostname>
  ```
- Enjoy
