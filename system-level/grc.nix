# grc.nix — Generic Colouriser (grc) for all users.
# Provides colorised terminal output for supported system commands.
# Aliases are generated for every command that has a matching conf.* file
# in the grc share directory.
{pkgs, ...}: {
  environment.systemPackages = [pkgs.grc];

  # Enable grc aliases for all users via a system-wide profile script.
  environment.etc."profile.d/grc-aliases.sh".text = ''
    # Generic Colouriser (grc) aliases — applied to all users
    if [ -n "''${TERM:-}" ] && [ "$TERM" != "dumb" ] && [ -t 1 ]; then
      GRC="${pkgs.grc}/bin/grc"
      if [ -x "$GRC" ]; then
        alias colourify="$GRC -es --colour=auto"

        # ── core system ──
        alias ant='colourify ant'
        alias blkid='colourify blkid'
        alias configure='colourify ./configure'
        alias curl='colourify curl'
        alias cvs='colourify cvs'
        alias df='colourify df'
        alias diff='colourify diff'
        alias dig='colourify dig'
        alias dnf='colourify dnf'
        alias du='colourify du'
        alias env='colourify env'
        alias fdisk='colourify fdisk'
        alias findmnt='colourify findmnt'
        alias free='colourify free'
        alias gcc='colourify gcc'
        alias getfacl='colourify getfacl'
        alias getsebool='colourify getsebool'
        alias go-test='colourify go-test'
        alias head='colourify head'
        alias id='colourify id'
        alias ifconfig='colourify ifconfig'
        alias ip='colourify ip'
        alias ipaddr='colourify ipaddr'
        alias ipneighbor='colourify ipneighbor'
        alias iproute='colourify iproute'
        alias iptables='colourify iptables'
        alias irclog='colourify irclog'
        alias iwconfig='colourify iwconfig'
        alias jobs='colourify jobs'
        alias journalctl='colourify journalctl'
        alias kubectl='colourify kubectl'
        alias last='colourify last'
        alias ldap='colourify ldap'
        alias log='colourify log'
        alias ls='colourify ls'
        alias lsattr='colourify lsattr'
        alias lsblk='colourify lsblk'
        alias lsmod='colourify lsmod'
        alias lsof='colourify lsof'
        alias lspci='colourify lspci'
        alias make='colourify make'
        alias mount='colourify mount'
        alias mtr='colourify mtr'
        alias mvn='colourify mvn'
        alias netstat='colourify netstat'
        alias nmap='colourify nmap'
        alias ntpdate='colourify ntpdate'
        alias php='colourify php'
        alias ping='colourify ping'
        alias ps='colourify ps'
        alias pv='colourify pv'
        alias semanageboolean='colourify semanageboolean'
        alias semanagefcontext='colourify semanagefcontext'
        alias semanageuser='colourify semanageuser'
        alias sensors='colourify sensors'
        alias showmount='colourify showmount'
        alias sockstat='colourify sockstat'
        alias sql='colourify sql'
        alias ss='colourify ss'
        alias stat='colourify stat'
        alias sysctl='colourify sysctl'
        alias systemctl='colourify systemctl'
        alias tail='colourify tail'
        alias tcpdump='colourify tcpdump'
        alias traceroute='colourify traceroute'
        alias tune2fs='colourify tune2fs'
        alias ulimit='colourify ulimit'
        alias uptime='colourify uptime'
        alias vmstat='colourify vmstat'
        alias wdiff='colourify wdiff'
        alias whois='colourify whois'
        alias yaml='colourify yaml'

        # ── docker subcommands ──
        alias dockerimages='colourify dockerimages'
        alias dockerinfo='colourify dockerinfo'
        alias docker-machinels='colourify docker-machinels'
        alias dockernetwork='colourify dockernetwork'
        alias dockerps='colourify dockerps'
        alias dockerpull='colourify dockerpull'
        alias dockersearch='colourify dockersearch'
        alias dockerversion='colourify dockerversion'
      fi
    fi
  '';
}
