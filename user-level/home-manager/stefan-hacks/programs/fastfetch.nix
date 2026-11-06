# fastfetch.nix — Home Manager fastfetch system info
# GNOME Adwaita dark color palette
_: {
  programs.fastfetch = {
    enable = true;
  };

  # fastfetch uses JSONC; home-manager's structured settings don't map well.
  # We place the raw JSONC config via xdg.configFile.
  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
        "display": {
            "color": {
                "keys": ""
            },
            "separator": " \uf061\u001b[2C",
            "constants": [
                "\u001b[s",
                "\u001b[u\u001b[14C",
                "\u001b[38;2;224;27;36m",
                "\u001b[38;2;255;120;0m",
                "\u001b[38;2;246;211;45m",
                "\u001b[38;2;51;209;122m",
                "\u001b[38;2;53;132;228m",
                "\u001b[38;2;26;95;180m",
                "\u001b[38;2;192;97;203m",
                "\u001b[38;2;145;65;172m",
                "\u001b[38;2;94;92;100m",
                "\u001b[38;2;119;118;123m",
                "\u001b[38;2;255;255;255m",
                "\u001b[38;2;246;245;244m",
                "\u001b[38;2;222;221;218m"
            ],
            "brightColor": false
        },
        "modules": [
            { "type": "break" },
            {
                "type": "version",
                "key": " ",
                "format": "\uD83D\uDE80\u001b[1m {$3}{1} - {2} "
            },
            {
                "type": "title",
                "keyIcon": "\uf007",
                "key": "{$4}├─ {icon}  {$1}Login{$2}"
            },
            {
                "type": "os",
                "key": "{$4}├─ {icon}  {$1}{sysname}{$2}"
            },
            {
                "type": "de",
                "key": "{$4}├─ {icon}  {$1}DE {$2}"
            },
            {
                "type": "shell",
                "key": "{$4}├─ {icon}  {$1}Shell{$2}"
            },
            {
                "type": "terminal",
                "key": "{$4}├─ {icon}  {$1}Terminal{$2}"
            },
            {
                "type": "packages",
                "key": "{$4}├─ {icon}  {$1}Packages{$2}"
            },
            {
                "type": "break"
            },
            {
                "type": "custom",
                "key": " ",
                "format": "\uD83D\uDD27\uFE0F {$5}Hardware "
            },
            {
                "type": "host",
                "key": "{$6}├─ {icon}  {$1}Chassis{$2}"
            },
            {
                "type": "cpu",
                "key": "{$6}├─ {icon}  {$1}CPU{$2}",
                "keyIcon": "\uf4bc"
            },
            {
                "type": "gpu",
                "key": "{$6}├─ {icon}  {$1}GPU{$2}",
                "keyIcon": "\uf4ca"
            },
            {
                "type": "display",
                "key": "{$6}├─ {icon}  {$1}Display{$2}"
            },
            {
                "type": "memory",
                "key": "{$6}├─ {icon}  {$1}RAM{$2}",
                "format": "{percentage-bar} {used} \/ {total}",
                "percent": { "type": ["bar"] }
            },
            {
                "type": "disk",
                "key": "{$6}\u2570\u2500 {icon}  {$1}Disk{$2}",
                "keyIcon": "\udb80\ude49",
                "format": "{size-percentage-bar} {size-used} \/ {size-total} [{filesystem}] ({mountpoint})",
                "percent": { "type": ["bar"] }
            },
            { "type": "break" },
            {
                "type": "custom",
                "key": " ",
                "format": "\uD83C\uDF0D {$7}Network "
            },
            {
                "type": "wifi",
                "key": "{$8}├─ {icon}  {$1}Wifi{$2}"
            },
            {
                "type": "localip",
                "key": "{$8}├─ {icon}  {$1}IP Addr{$2}",
                "keyIcon": "\uDB82\ude60",
                "format": "[{4}] {1}"
            },
            {
                "type": "publicip",
                "key": "{$8}├─ {icon}  {$1}Public IP{$2}",
                "keyIcon": "\uDB82\ude60"
            },
            {
                "type": "dns",
                "key": "{$8}\u2570\u2500 {icon}  {$1}DNS{$2}",
                "keyIcon": "\uDB80\uddd6"
            },
            { "type": "break" },
            {
                "type": "custom",
                "key": " ",
                "format": "\uD83D\uDD0B\uFE0F {$9}Peripherals "
            },
            {
                "type": "bluetooth",
                "key": "{$10}├─ {icon}  {$1}Bluetooth{$2}"
            },
            {
                "type": "poweradapter",
                "key": "{$10}├─ {icon}  {$1}Power Adapter{$2}"
            },
            {
                "type": "battery",
                "key": "{$10}\u2570\u2500 {icon}  {$1}Battery{$2}"
            },
            { "type": "break" },
            {
                "type": "custom",
                "key": " ",
                "format": "\uD83C\uDFA7 {$11}Media "
            },
            {
                "type": "media",
                "key": "{$12}├─ {icon}  {$1}Now Playing{$2}",
                "format": "{1:30}"
            },
            {
                "type": "player",
                "key": "{$12}\u2570\u2500 {icon}  {$1}Player{$2}"
            },
            { "type": "break" },
            {
                "type": "custom",
                "key": " ",
                "format": "\uD83D\uDD54 {$13}Date/Time "
            },
            {
                "type": "datetime",
                "key": "{$14}├─ {icon}  {$1}Date/Time{$2}",
                "format": "{day-pretty}-{month-name-short}-{year} / {hour-pretty}:{minute-pretty}:{second-pretty} {timezone-name}"
            },
            {
                "type": "uptime",
                "key": "{$14}\u2570\u2500 {icon}  {$1}Uptime{$2}"
            },
            { "type": "break" },
            {
                "type": "colors",
                "key": " "
            }
        ]
    }
  '';
}
