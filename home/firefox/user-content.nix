{

  programs.firefox.profiles.default.userContent = # css
    ''
      /* dark background for default tabs */
      @-moz-document url("about:home"), url("about:blank"), url("about:newtab") {
        body {
          background-color: #24273a !important;
        }
      }
    '';

}
