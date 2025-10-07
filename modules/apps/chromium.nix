{
  pkgs,
  ...
}:
{

  environment.systemPackages = [ pkgs.chromium ];

  programs.chromium = {
    enable = true;

    extensions = [
      "cmpdlhmnmjhihmcfnigoememnffkimlk" # Catppuccin Macchiato Theme
      "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture-in-Picture
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      "enamippconapkdmgfgjchkhakpfinmaj" # DeArrow
      "oldceeleldhonbafppcapldpdifcinji" # LanguageTool
      "jehmdpemhgfgjblpkilmeoafmkhbckhi" # ScrollAnywhere
    ];

    extraOpts = {
      # Miscellaneous
      BrowserLabsEnabled = false;
      SiteSearchSettings = [
        {
          name = "GitHub";
          shortcut = "gh";
          url = "https://github.com/search?q={searchTerms}";
        }
        {
          name = "YouTube";
          shortcut = "yt";
          url = "https://www.youtube.com/results?search_query={searchTerms}";
        }
        {
          name = "My NixOS";
          shortcut = "mn";
          url = "https://mynixos.com/search?q={searchTerms}";
        }
        {
          name = "NixOS Packages";
          shortcut = "np";
          url = "https://search.nixos.org/packages?query={searchTerms}";
        }
        {
          name = "NixOS Options";
          shortcut = "no";
          url = "https://search.nixos.org/options?query={searchTerms}";
        }
        {
          name = "NixOS Wiki";
          shortcut = "nw";
          url = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
        }
        {
          name = "GitHub nixpkgs";
          shortcut = "ghnp";
          url = "https://github.com/search?q=repo%3ANixOS%2Fnixpkgs {searchTerms}&type=code";
        }
        {
          name = "Home Manager Options";
          shortcut = "ho";
          url = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
        }
        {
          name = "Freedium.cfd";
          shortcut = "fd";
          url = "https://freedium.cfd/{searchTerms}";
        }
        {
          name = "ProtonDB";
          shortcut = "pd";
          url = "https://protondb.com/search?q={searchTerms}";
        }
      ];
      RestoreOnStartup = 1;
    };
  };

}
