# ── Prism Launcher, wired for Minecraft 26.3 + Iris on NVIDIA/Wayland ─
# nixpkgs' prismlauncher, with the EGL environment the 26.3 renderer needs.
#
# Minecraft 26.3 replaced GLFW with SDL3 and creates its OpenGL backend
# through EGL. On an NVIDIA host under Wayland the display the client asks
# for is not the one glvnd picks by default, so `eglChooseConfig` comes back
# EGL_BAD_DISPLAY, the client aborts `Failed to create backend OpenGL` and
# falls back to Vulkan — where Sodium and Iris do not work. The symptoms are
# a client that runs fine vanilla and dies instantly with Iris installed.
#
# Isolated 2026-11-25 on the RTX 5070 (595.112.07, GNOME Wayland):
#   EGL_PLATFORM=wayland alone             -> EGL_BAD_DISPLAY
#   __GLX_VENDOR_LIBRARY_NAME=nvidia alone -> EGL_BAD_DISPLAY
#   both, plus GBM_BACKEND=nvidia-drm      -> OpenGL 3.3 NVIDIA, Iris renders
#
# The variables are set on the launcher, so every instance and every game
# process it starts inherits them; no per-instance setup to remember.
{
  prismlauncher,
  makeWrapper,
  symlinkJoin,
}:

symlinkJoin {
  name = "prismlauncher-mc-${prismlauncher.version}";
  paths = [ prismlauncher ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/prismlauncher \
      --set EGL_PLATFORM wayland \
      --set __GLX_VENDOR_LIBRARY_NAME nvidia \
      --set GBM_BACKEND nvidia-drm \
      --set __GL_THREADED_OPTIMIZATIONS 0
  '';
}
