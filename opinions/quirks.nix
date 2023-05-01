{
  # Disable power button from having any effect, as the system cannot suspend,
  # otherwise the device will be unable to resume, at least on kernel 6.3.0
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  services.xserver.desktopManager.gnome3.extraGSettingsOverrides = ''
    [org.gnome.settings-daemon.plugins.power]
    power-button-action='nothing'
  '';
  services.logind.extraConfig = ''
    HandlePowerKey=lock
  '';
}
