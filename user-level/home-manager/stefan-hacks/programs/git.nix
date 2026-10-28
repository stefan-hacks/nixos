# git.nix — Home Manager git configuration
# All git aliases live here (not in bash.nix) so git provides tab-completion.
{pkgs, ...}: let
  # Complex shell-based alias: auto-commit with human-readable summary
  gitLazy = pkgs.writeShellScriptBin "git-lazy" ''
    set -e
    git add -A
    status=$(git status --porcelain)
    if [ -z "$status" ]; then
      echo "No changes to commit."
      exit 0
    fi

    added_mods=""
    deletions=""
    while IFS= read -r line; do
      state=$(echo "$line" | cut -c1-2)
      file=$(echo "$line" | cut -c4-)
      if echo "$state" | grep -q '[AMR]'; then
        added_mods="$added_mods\n  - $file"
      elif echo "$state" | grep -q 'D'; then
        deletions="$deletions\n  - $file"
      fi
    done <<< "$status"

    msg="Auto-commit summary:"
    if [ -n "$added_mods" ]; then
      msg="$msg\n\n[Added/Modified]:$added_mods"
    fi
    if [ -n "$deletions" ]; then
      msg="$msg\n\n[Deleted]:$deletions"
    fi

    echo -e "$msg"
    git commit -m "$(echo -e "$msg")"
    git push
  '';
in {
  programs.git = {
    enable = true;

    userName = "stefan-hacks";
    userEmail = "stefanmrobertson@gmail.com";

    extraConfig = {
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;
      fetch.prune = true;
      log.date = "iso";
    };

    # ── Power-programmer aliases ──
    # Simple aliases: git <alias> maps to git <command>
    aliases = {
      # ── Basics ──
      s = "status -sb"; # short status with branch
      st = "status"; # full status
      ss = "status --short"; # minimal status

      # ── Staging ──
      a = "add"; # stage file
      aa = "add -A"; # stage all
      ap = "add -p"; # stage patch interactively
      unstage = "restore --staged"; # unstage file
      unstage-all = "restore --staged :"; # unstage everything
      co = "checkout"; # checkout file/branch
      cob = "checkout -b"; # create and switch to branch

      # ── Committing ──
      ci = "commit"; # commit
      cm = "commit -m"; # commit with message
      amend = "commit --amend"; # amend last commit
      amendn = "commit --amend --no-edit"; # amend without editing message
      undo = "reset --soft HEAD~1"; # undo last commit (keep changes)
      undo-hard = "reset --hard HEAD~1"; # undo last commit (discard)
      wip = "!git add -A && git commit -m 'wip: save point'"; # quick save

      # ── Branching ──
      br = "branch"; # list branches
      brv = "branch -vv"; # verbose branch list
      brd = "branch -d"; # delete branch
      brD = "branch -D"; # force delete branch
      sw = "switch"; # switch branch
      swc = "switch -c"; # create and switch
      rename = "branch -m"; # rename current branch
      current = "rev-parse --abbrev-ref HEAD"; # show current branch name

      # ── Diff ──
      d = "diff"; # diff unstaged
      ds = "diff --staged"; # diff staged
      dw = "diff --word-diff"; # word-level diff
      last = "diff HEAD~1"; # diff last commit

      # ── Log / History ──
      l = "log --oneline --graph --decorate --all -20"; # compact log
      lg = "log --oneline --graph --decorate --all"; # full compact log
      lga = "log --oneline --graph --decorate --all --branches"; # all branches
      hist = "log --pretty=format:'%C(yellow)%h%Creset %C(cyan)%ad%Creset %C(blue)%an%Creset %s' --date=short --graph"; # detailed log
      who = "log -p -M --follow --stat --"; # who changed this file
      contributors = "shortlog -sne"; # contributor stats

      # ── Remote / Sync ──
      p = "push"; # push current branch
      pf = "push --force-with-lease"; # safer force push
      pl = "pull"; # pull
      f = "fetch --all --prune"; # fetch all remotes, prune stale
      fa = "fetch --all"; # fetch all remotes
      pt = "push --tags"; # push tags

      # ── Stash ──
      stash = "stash"; # stash changes
      stp = "stash pop"; # pop stash
      sta = "stash apply"; # apply stash (keep in list)
      sts = "stash show -p"; # show stash diff
      stl = "stash list"; # list stashes

      # ── Cherry-pick / Rebase ──
      cp = "cherry-pick"; # cherry-pick commit
      cpnc = "cherry-pick --no-commit"; # cherry-pick without commit
      rb = "rebase"; # rebase
      rbi = "rebase -i"; # interactive rebase
      rba = "rebase --abort"; # abort rebase
      rbc = "rebase --continue"; # continue rebase

      # ── Cleanup ──
      cleanup = "!git fetch --all --prune && git branch -vv | grep ': gone]' | awk '{print \\$1}' | xargs -r git branch -D"; # remove merged branches
      nuke = "!git reset --hard HEAD && git clean -fd"; # discard ALL changes

      # ── Lazy auto-commit ──
      lazy = "!${gitLazy}/bin/git-lazy";
    };
  };
}
