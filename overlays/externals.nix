{ symlinkJoin
, makeWrapper
, plugins
}:

symlinkJoin {
  name = "puredata-externals";
  paths = plugins;
  nativeBuildInputs = [ makeWrapper ];
}
