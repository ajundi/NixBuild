{
  config,
  pkgs,
  ...
}: {
  home.username = "family";
  home.homeDirectory = "/home/family";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.sessionVariables = {
    EDITOR = "codium";
    SUDO_EDITOR = "kate";
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
    ];
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    includes = [
      {
        contents = {
          user = {
            name = "Ayman Jundi";
            email = "ajundi@gmail.com";
          };
          init = {
            defaultBranch = "main";
          };
        };
      }
    ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions =
      pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (import ./vscodeExtensions.nix).extensions;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
