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
  pname = "gridcraft";
  version = "0.1.0";  # TODO: Replace with actual version

  src = fetchurl {
    url = "https://github.com/storytold/gridcraft/releases/download/v${version}/gridcraft-linux-x86_64";
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
    install -m755 $src $out/bin/gridcraft

    # Wrap with necessary library paths
    wrapProgram $out/bin/gridcraft \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source Excel alternative (ArtCraft suite)";
    homepage = "https://github.com/storytold/gridcraft";
    license = with licenses; [ mit asl20 ];
    platforms = platforms.linux;
    mainProgram = "gridcraft";
  };
}
