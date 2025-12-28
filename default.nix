{ lib,
  stdenv,
  python3,
  sourceDir ? ./.,
  fetchgit,
  git,
}:


let
  # TODO add something to split them between the target platforms
  googletest = fetchgit {
    url = "https://android.googlesource.com/platform/external/googletest.git";
    rev = "609281088cfefc76f9d0ce82e1ff6c30cc3591e5";
    sha256 = "sha256-P8l4pv8z1n/XUBYpdpLumX8VTnzO+AvBLg+8wD4+ldg=";
  };

  protobuf = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/protocolbuffers/protobuf.git"; 
    rev = "74211c0dfc2777318ab53c2cd2c317a2ef9012de";# refs/tags/v31.1
  };

  abseil-cpp = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/abseil/abseil-cpp.git";
    rev = "76bb24329e8bf5f39704eb10d21b9a80befa7c81";
  };

  libcxx = fetchgit {
    url  = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxx.git";
    rev = "852bc6746f45add53fec19f3a29280e69e358d44";
  };

  libcxxabi = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxxabi.git";
    rev = "a37a3aa431f132b02a58656f13984d51098330a2";
  };


  libunwind = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libunwind.gitl";
    rev = "419b03c0b8f20d6da9ddcb0d661a94a97cdd7dad";
  };

  libfuzzer = fetchgit {
    url = "https://chromium.googlesource.com/chromium/llvm-project/compiler-rt/lib/fuzzer.git";
    rev = "debe7d2d1982e540fbd6bd78604bf001753f9e74";
  };

  benchmark = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/google/benchmark.git";
    rev = "e991355c02b93fe17713efe04cbc2e278e00fdbd";
  };

  libbacktrace = fetchgit {
    url = "https://storage.googleapis.com/perfetto/libbacktrace-14818b7783eeb9a56c3f0fca78cefd3143f8c5f6.zip";
    rev = "0d09295938155aa84d9a6049f63df8cd2def3a28302b3550ea3ead9100b3d086";
  };


  sqlite = fetchgit {
    url = "https://storage.googleapis.com/perfetto/sqlite-amalgamation-3500300.zip";
    rev = "9ad6d16cbc1df7cd55c8b55127c82a9bca5e9f287818de6dc87e04e73599d754";
  };


  sqlite_src = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/sqlite/sqlite.git";
    rev = "a4643b451a2941f5e6965ab095d3057bc7cb2222";
  };

  jsoncpp = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/open-source-parsers/jsoncpp.git";
    rev = "6aba23f4a8628d599a9ef7fa4811c4ff6e4070e2"; # refs/tags/1.9.3.
  };
  libexpat = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/libexpat/libexpat.git";
    rev = "fa75b96546c069d17b8f80d91e0f4ef0cde3790d";# refs/tags/upstream/R_2_6_2.
  };
  llvm-project = fetchgit {
    url = "https://storage.googleapis.com/perfetto/llvm-project-617a15a9eac96088ae5e9134248d8236e34b91b1.tgz";
    rev = "7e2541446a27f2a09a84520da7bc93cd71749ba0f17318f2d5291fbf45b97956";
  };
  android-core = fetchgit {
    url = "https://android.googlesource.com/platform/system/core.git";
    rev = "9e6cef7f07d8c11b3ea820938aeb7ff2e9dbaa52";
  };
  android-unwinding = fetchgit {
    url = "https://android.googlesource.com/platform/system/unwinding.git";
    rev = "4b59ea8471e89d01300481a92de3230b79b6d7c7";
  };
  android-logging = fetchgit {
    url = "https://android.googlesource.com/platform/system/logging.git";
    rev = "7b36b566c9113fc703d68f76e8f40c0c2432481c";
  };
  android-libbase = fetchgit {
    url = "https://android.googlesource.com/platform/system/libbase.git";
    rev = "78f1c2f83e625bdf66d55b48bdb3a301c20d2fb3";
  };
  android-libprocinfo = fetchgit {
    url = "https://android.googlesource.com/platform/system/libprocinfo.git";
    rev = "fd214c13ededecae97a3b15b5fccc8925a749a84";
  };
  lzma = fetchgit {
    url = "https://android.googlesource.com/platform/external/lzma.git";
    rev = "7851dce6f4ca17f5caa1c93a4e0a45686b1d56c3";
  };

  zstd = fetchgit {
    url = "https://android.googlesource.com/platform/external/zstd.git";
    rev = "77211fcc5e08c781734a386402ada93d0d18d093";
  };

  bionic = fetchgit {
    url = "https://android.googlesource.com/platform/bionic.git";
    rev = "a0d0355105cb9d4a4b5384897448676133d7b8e2";
  };

  zlib = fetchgit {
    url = "https://chromium.googlesource.com/chromium/src/third_party/zlib.git";
    rev ="6f9b4e61924021237d474569027cfb8ac7933ee6";
  };
  linenoise = fetchgit {
    url = "https://fuchsia.googlesource.com/third_party/linenoise.git";
    rev = "c894b9e59f02203dbe4e2be657572cf88c4230c3";
  };
  bloaty = fetchgit {
    url = "https://storage.googleapis.com/perfetto/bloaty-1.1-b3b829de35babc2fe831b9488ad2e50bca939412-mac.zip";
    rev = "2d301bd72a20e3f42888c9274ceb4dca76c103608053572322412c2c65ab8cb8";
  };
  open_csd = fetchgit {
    url = "https://android.googlesource.com/platform/external/OpenCSD.git";
    rev = "0ce01e934f95efb6a216a6efa35af1245151c779";
  };



  # TODO add the other dependencies
in
stdenv.mkDerivation rec {
  pname = "perfetto"; 
  version = "53.0";

  src = "${sourceDir}";

  unpackPhase = "true";

  nativeBuildInputs = [
    git
    python3
  ];
  meta = with lib; {
    description = "Production-grade client-side tracing, profiling, and analysis for complex software systems.";
    license = licenses.asl20;
    platforms = platforms.unix;
  };

  configurePhase = ''
 cp -r $src/* $TMP/.
 chmod -R 777  $TMP
 ln -s ${googletest} buildtools/googletest
 ln -s ${protobuf} buildtools/protobuf
 ln -s ${abseil-cpp} buildtools/abseil-cpp
 ln -s ${libcxx} buildtools/libcxx
 ln -s ${libcxxabi} buildtools/libcxxabi
 ln -s ${libunwind} buildtools/libunwind
 ln -s ${libfuzzer} buildtools/libfuzzer
 ln -s ${benchmark} buildtools/benchmark
 ln -s ${libbacktrace} buildtools/libbacktrace
 ln -s ${sqlite} buildtools/sqlite
 ln -s ${sqlite_src} buildtools/sqlite_src
 ln -s ${jsoncpp} buildtools/jsoncpp
 ln -s ${libexpat} buildtools/libexpat
 ln -s ${llvm-project} buildtools/llvm-project
 ln -s ${android-core} buildtools/android-core
 ln -s ${android-logging} buildtools/android-logging
 ln -s ${android-libbase} buildtools/android-libbase
 ln -s ${android-unwinding} buildtools/android-unwinding
 ln -s ${android-libprocinfo} buildtools/android-libprocinfo
 ln -s ${lzma} buildtools/lzma
 ln -s ${zstd} buildtools/zstd
 ln -s ${bionic} buildtools/bionic
 ln -s ${zlib} buildtools/zlib
 ln -s ${linenoise} buildtools/linenoise
 ln -s ${bloaty} buildtools/bloaty
 ln -s ${open_csd} buildtools/open_csd
 '';

  buildPhase = ''
 cd $TMP
 ls -ahl buildtools
 exit 1
 '';
}
