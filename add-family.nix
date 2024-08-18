{
  config,
  pkgs,
  ...
}: {
  users.users.family = {
    isNormalUser = true;
    description = "Family";
    initialHashedPassword = "$y$j9T$xU9DxXq2GEjYoaoVW8znj/$TLvcORihk3kF2s6JnnD8WSLbh8Me2e0SQaBoqKTFCB7";
    packages = with pkgs; [
      #  thunderbird
    ];
  };
}
