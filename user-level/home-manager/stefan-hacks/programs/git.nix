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

    settings = {
      user.name = "stefan-hacks";
      user.email = "stefanmrobertson@gmail.com";

      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;
      fetch.prune = true;
      log.date = "iso";

      # ── Power-programmer aliases ──
      alias = {
        # ── Basics ──
        s = "status -sb";
        st = "status";
        ss = "status --short";

        # ── Staging ──
        a = "add";
        aa = "add -A";
        ap = "add -p";
        unstage = "restore --staged";
        "unstage-all" = "restore --staged :";
        co = "checkout";
        cob = "checkout -b";

        # ── Committing ──
        ci = "commit";
        cm = "commit -m";
        amend = "commit --amend";
        amendn = "commit --amend --no-edit";
        undo = "reset --soft HEAD~1";
        "undo-hard" = "reset --hard HEAD~1";
        wip = "!git add -A && git commit -m 'wip: save point'";

        # ── Branching ──
        br = "branch";
        brv = "branch -vv";
        brd = "branch -d";
        brD = "branch -D";
        sw = "switch";
        swc = "switch -c";
        rename = "branch -m";
        current = "rev-parse --abbrev-ref HEAD";

        # ── Diff ──
        d = "diff";
        ds = "diff --staged";
        dw = "diff --word-diff";
        last = "diff HEAD~1";

        # ── Log / History ──
        l = "log --oneline --graph --decorate --all -20";
        lg = "log --oneline --graph --decorate --all";
        lga = "log --oneline --graph --decorate --all --branches";
        hist = "log --pretty=format:'%C(yellow)%h%Creset %C(cyan)%ad%Creset %C(blue)%an%Creset %s' --date=short --graph";
        who = "log -p -M --follow --stat --";
        contributors = "shortlog -sne";

        # ── Remote / Sync ──
        p = "push";
        pf = "push --force-with-lease";
        pl = "pull";
        f = "fetch --all --prune";
        fa = "fetch --all";
        pt = "push --tags";

        # ── Stash ──
        stash = "stash";
        stp = "stash pop";
        sta = "stash apply";
        sts = "stash show -p";
        stl = "stash list";

        # ── Cherry-pick / Rebase ──
        cp = "cherry-pick";
        cpnc = "cherry-pick --no-commit";
        rb = "rebase";
        rbi = "rebase -i";
        rba = "rebase --abort";
        rbc = "rebase --continue";

        # ── Cleanup ──
        cleanup = "!git fetch --all --prune && git branch -vv | grep ': gone]' | awk '{print \$1}' | xargs -r git branch -D";
        nuke = "!git reset --hard HEAD && git clean -fd";

        # ── Lazy auto-commit ──
        lazy = "!${gitLazy}/bin/git-lazy";
      };
    };
  };
}
