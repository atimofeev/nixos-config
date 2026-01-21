_final: prev: {
  curl-ws = prev.curl.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags ++ [ "--enable-websockets" ];
  });
}
