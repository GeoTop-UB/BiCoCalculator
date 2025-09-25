{
    stdenv,
    sage
}: stdenv.mkDerivation {
    name = "bico-compute";
    pname = "bico-compute";
    # version = "0.7.5";
    # src = fetchurl {
    #   url = "https://github.com/Solo5/solo5/releases/download/v${version}/solo5-v${version}.tar.gz";
    #   sha256 = "sha256-viwrS9lnaU8sTGuzK/+L/PlMM/xRRtgVuK5pixVeDEw=";
    # };
    # nativeBuildInputs = [ makeWrapper pkg-config ];
    # buildInputs = [ sage ];
    propagatedBuildInputs = [ sage ];
    dontUnpack = true;
    installPhase = "install -Dm755 ${./bico_compute.py.sage} $out/bin/bico-compute";
    meta.mainProgram = "bico-compute";
    # installPhase = ''
    #   mkdir -p $out/bin
    #   cp foo $out/bin
    # '';
}