{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, libGL
, libxkbcommon
, wayland
, xorg
, vulkan-loader
}:

stdenv.mkDerivation rec {
  pname = "photocraft";
  version = "0.1.0";  # TODO: Replace with actual version

  src = fetchurl {
    url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-linux-x86_64";
    sha256 = lib.fakeSha256;  # TODO: Replace with actual hash after first build attempt
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libGL
    libxkbcommon
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    vulkan-loader
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 $src $out/bin/photocraft

    wrapProgram $out/bin/photocraft \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source Photoshop alternative (ArtCraft suite)";
    homepage = "https://github.com/storytold/photocraft";
    license = with licenses; [ mit asl20 ];
    platforms = platforms.linux;
    mainProgram = "photocraft";
  };
}
