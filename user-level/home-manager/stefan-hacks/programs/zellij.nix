# zellij.nix — Home Manager zellij terminal multiplexer
{ config, lib, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
  };

  # Zellij uses KDL format; home-manager's structured settings don't map well.
  # We place the raw KDL config via xdg.configFile.
  xdg.configFile."zellij/config.kdl".text = ''
keybinds clear-defaults=true {
    locked {
        bind "Ctrl a" { SwitchToMode "normal"; }
    }
    pane {
        bind "left" { MoveFocus "left"; }
        bind "down" { MoveFocus "down"; }
        bind "up" { MoveFocus "up"; }
        bind "right" { MoveFocus "right"; }
        bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
        bind "d" { NewPane "down"; SwitchToMode "locked"; }
        bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "locked"; }
        bind "f" { ToggleFocusFullscreen; SwitchToMode "locked"; }
        bind "h" { MoveFocus "left"; }
        bind "i" { TogglePanePinned; SwitchToMode "locked"; }
        bind "j" { MoveFocus "down"; }
        bind "k" { MoveFocus "up"; }
        bind "l" { MoveFocus "right"; }
        bind "n" { NewPane; SwitchToMode "locked"; }
        bind "p" { SwitchToMode "normal"; }
        bind "r" { NewPane "right"; SwitchToMode "locked"; }
        bind "s" { NewPane "stacked"; SwitchToMode "locked"; }
        bind "w" { ToggleFloatingPanes; SwitchToMode "locked"; }
        bind "x" { CloseFocus; SwitchToMode "locked"; }
        bind "z" { TogglePaneFrames; SwitchToMode "locked"; }
        bind "tab" { SwitchFocus; }
    }
    tab {
        bind "left" { GoToPreviousTab; }
        bind "down" { GoToNextTab; }
        bind "up" { GoToPreviousTab; }
        bind "right" { GoToNextTab; }
        bind "1" { GoToTab 1; SwitchToMode "locked"; }
        bind "2" { GoToTab 2; SwitchToMode "locked"; }
        bind "3" { GoToTab 3; SwitchToMode "locked"; }
        bind "4" { GoToTab 4; SwitchToMode "locked"; }
        bind "5" { GoToTab 5; SwitchToMode "locked"; }
        bind "6" { GoToTab 6; SwitchToMode "locked"; }
        bind "7" { GoToTab 7; SwitchToMode "locked"; }
        bind "8" { GoToTab 8; SwitchToMode "locked"; }
        bind "9" { GoToTab 9; SwitchToMode "locked"; }
        bind "[" { BreakPaneLeft; SwitchToMode "locked"; }
        bind "]" { BreakPaneRight; SwitchToMode "locked"; }
        bind "b" { BreakPane; SwitchToMode "locked"; }
        bind "h" { GoToPreviousTab; }
        bind "j" { GoToNextTab; }
        bind "l" { GoToNextTab; }
        bind "n" { NewTab; SwitchToMode "locked"; }
        bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
        bind "x" { CloseTab; SwitchToMode "locked"; }
        bind "tab" { SwapTab; }
    }
    resize {
        bind "left" { Resize "Decrease"; }
        bind "down" { Resize "Increase"; }
        bind "up" { Resize "Increase"; }
        bind "right" { Resize "Decrease"; }
        bind "=" { Resize "Reset"; SwitchToMode "locked"; }
        bind "r" { SwitchToMode "normal"; }
    }
    move {
        bind "left" { MovePane "left"; }
        bind "down" { MovePane "down"; }
        bind "up" { MovePane "up"; }
        bind "right" { MovePane "right"; }
        bind "m" { SwitchToMode "normal"; }
    }
    scroll {
        bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
        bind "j" { ScrollDown; }
        bind "k" { ScrollUp; }
        bind "d" { HalfPageScrollDown; }
        bind "u" { HalfPageScrollUp; }
        bind "s" { SwitchToMode "normal"; }
    }
    search {
        bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
        bind "j" { ScrollDown; }
        bind "k" { ScrollUp; }
        bind "d" { HalfPageScrollDown; }
        bind "u" { HalfPageScrollUp; }
        bind "n" { Search "down"; }
        bind "N" { Search "up"; }
        bind "s" { SwitchToMode "normal"; }
    }
    session {
        bind "d" { Detach; }
        bind "q" { Quit; }
        bind "r" { SwitchToMode "normal"; }
    }
}

// Default layout
layout {
    pane size=1 borderless=true {
        plugin location="zellij:tab-bar"
    }
    pane
    pane size=2 borderless=true {
        plugin location="zellij:status-bar"
    }
}

theme "default"
  '';
}
