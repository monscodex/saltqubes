{
  packageOverrides = pkgs: with pkgs; {
    developmentPackages = pkgs.buildEnv {
      name = "development-packages";
      paths = [
        hugo
        deno
        lunarvim
        black
        nodePackages.cspell
        nodePackages.prettier
      ];
    };
  };
}
