{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, qhull
, flann
, boost
, vtk
, eigen
, pkg-config
, qtbase
, libusb1
, libpcap
, libXt
, libpng
, Cocoa
, AGL
, OpenGL
}:

stdenv.mkDerivation rec {
  pname = "pcl";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    rev = "${pname}-${version}";
    sha256 = "1cli2rxqsk6nxp36p5mgvvahjz8hm4fb68yi8cf9nw4ygbcvcwb1";
  };

  nativeBuildInputs = [ pkg-config cmake wrapQtAppsHook ];
  buildInputs = [
    qhull
    flann
    boost
    eigen
    libusb1
    libpcap
    libpng
    vtk
    qtbase
    libXt
  ]
  ++ lib.optionals stdenv.isDarwin [ Cocoa AGL ];

  cmakeFlags = lib.optionals stdenv.isDarwin [
    "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks"
  ];

  meta = {
    homepage = "https://pointclouds.org/";
    description = "Open project for 2D/3D image and point cloud processing";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
