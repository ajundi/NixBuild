{
  config,
  pkgs,
  ...
}: {
  users.users.family = {
    isNormalUser = true;
    description = "Family";
    packages = with pkgs; [
      #  thunderbird
    ];
  };
}
