# Locale and timezone
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
}
