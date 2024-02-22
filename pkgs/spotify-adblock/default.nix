{
  spotify,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  xorg,
}: let
  spotify-adblock = rustPlatform.buildRustPackage {
    pname = "spotify-adblock";
    version = "1.0.3";
    src = fetchFromGitHub {
      owner = "abba23";
      repo = "spotify-adblock";
      rev = "5a3281dee9f889afdeea7263558e7a715dcf5aab";
      hash = "sha256-5tZ+Y7dhzb6wmyQ+5FIJDHH0KqkXbiB259Yo7ATGjSU=";
    };
    cargoSha256 = "sha256-q6Z7lfVNs2MEhq8lOMqFBNDRCLmvH0lxoTJX9L/wbuU=";

    patchPhase = ''
      substituteInPlace src/lib.rs \
        --replace 'config.toml' $out/etc/spotify-adblock/config.toml
    '';

    buildPhase = ''
      make
    '';

    installPhase = ''
      mkdir -p $out/etc/spotify-adblock
      install -D --mode=644 config.toml $out/etc/spotify-adblock
      mkdir -p $out/lib
      install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib

    '';
  };
  spotifywm = stdenv.mkDerivation {
    name = "spotifywm";
    src = fetchFromGitHub {
      owner = "dasj";
      repo = "spotifywm";
      rev = "8624f539549973c124ed18753881045968881745";
      hash = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
    };
    buildInputs = [xorg.libX11];
    installPhase = "mv spotifywm.so $out";
  };
in
  spotify.overrideAttrs (
    old: {
      postInstall =
        (old.postInstall or "")
        + ''
          ln -s ${spotify-adblock}/lib/libspotifyadblock.so $libdir
          sed -i "s:^Name=Spotify.*:Name=Spotify-adblock:" "$out/share/spotify/spotify.desktop"
          wrapProgram $out/bin/spotify \
            --set LD_PRELOAD "${spotify-adblock}/lib/libspotifyadblock.so"
        '';
    }
  )
