{
  inputs,
  pkgs,
  ...
}:

{
  # ── Shell / system utilities ──────────────────────────
  environment.systemPackages = with pkgs; [
    # Custom: `rip` from flake input
    inputs.rip.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Encryption (secrets management)
    age

    # Bitwarden CLI bridge (vault stays in the Bitwarden apps; rbw is the
    # programmatic layer used by pi's security extension). pinentry-curses
    # handles the `rbw unlock` master-password prompt in the terminal.
    rbw
    pinentry-curses

    # browser thing for agents
    playwright

    # System essentials
    # Pi coding agent — from the upstream flake input (`inputs.pi`), bumped with
    # `nix flake update pi`. Nix builds it from source, so a bump costs a
    # ~1–2 min local build; nothing is substituted from a binary cache.
    inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Codex CLI — OpenAI's terminal agent. Plain nixpkgs here: it comes from
    # the binary cache and nixos-unstable tracks it within a release of
    # upstream (0.171.0 against rust-v0.172.0 on 2026-11-27), so it does not
    # need the pi treatment. Bump with `nix flake update nixpkgs`. Its
    # config and credentials live in ~/.codex, out of band like pi's.
    codex
    gh
    ntfs3g
    lsof
    corefonts
    ffmpeg
    btop-cuda
    git
    git-lfs
    curl
    openssl
    tmux
    zellij
    file
    dig
    iw
    wakeonlan
    tree
    neovim
    glow
    bat
    jq
    ddcutil
    fd
    eza
    pandoc
  ];

  # ── Shell aliases (apply system-wide) ─────────────────
  environment.shellAliases = {
    vi = "nvim";
    ls = "eza";
    ll = "eza -lbF --git";
    la = "eza -lbhHigUmuSa --git";
    lt = "eza --tree --level=2";
  };

  # ── Session variables ─────────────────────────────────
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    NIXOS_OZONE_WL = "1";
  };
}
