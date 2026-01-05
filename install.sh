#!/usr/bin/env bash
#
# Dotfiles installer
# Usage:
#   ./install.sh                     # install everything
#   FILTER="nvim mise zsh" ./install.sh  # install only specific packages
#   curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh | bash
#
set -e

# ============================================================================
# CONFIG
# ============================================================================
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
FILTER="${FILTER:-}"

# ============================================================================
# HELPERS
# ============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}::${NC} $1"; }
ok() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err() { echo -e "${RED}✗${NC} $1"; }

# Detect platform
OS="$(uname -s)"
case "$OS" in
    Darwin) PLATFORM="macos" ;;
    Linux)  PLATFORM="linux" ;;
    *)      err "Unsupported: $OS"; exit 1 ;;
esac

# Detect Linux distro package manager
if [ "$PLATFORM" = "linux" ]; then
    if command -v apt &>/dev/null; then
        LINUX_PKG_MGR="apt"
    elif command -v dnf &>/dev/null; then
        LINUX_PKG_MGR="dnf"
    elif command -v pacman &>/dev/null; then
        LINUX_PKG_MGR="pacman"
    else
        LINUX_PKG_MGR=""
    fi
fi

# Symlink helper
mklink() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    rm -rf "$dest"
    ln -sf "$src" "$dest"
    ok "linked $dest"
}

# Install command - handles platform differences
# Usage: install_pkg <macos_pkg> <apt_pkg> <dnf_pkg> <pacman_pkg>
#        install_pkg neovim neovim neovim neovim
#        install_pkg "neovim --HEAD" neovim neovim neovim
install_pkg() {
    local macos="$1" apt="$2" dnf="$3" pacman="$4"
    
    if [ "$PLATFORM" = "macos" ]; then
        if command -v brew &>/dev/null; then
            brew install $macos 2>/dev/null || true
        else
            warn "brew not installed, skipping $macos"
        fi
    else
        case "$LINUX_PKG_MGR" in
            apt)    [ -n "$apt" ] && sudo apt install -y $apt ;;
            dnf)    [ -n "$dnf" ] && sudo dnf install -y $dnf ;;
            pacman) [ -n "$pacman" ] && sudo pacman -S --noconfirm $pacman ;;
            *)      warn "no package manager found" ;;
        esac
    fi
}

# Dependency tracking
INSTALLED=()

depends_on() {
    for dep in "$@"; do
        if [[ ! " ${INSTALLED[*]} " =~ " ${dep} " ]]; then
            run_pkg "$dep"
        fi
    done
}

# Check if package should run (based on FILTER)
should_run() {
    local pkg="$1"
    [ -z "$FILTER" ] && return 0
    [[ " $FILTER " =~ " $pkg " ]] && return 0
    return 1
}

# Run a package installer
run_pkg() {
    local pkg="$1"
    
    # Skip if already installed
    [[ " ${INSTALLED[*]} " =~ " ${pkg} " ]] && return 0
    
    # Check if function exists
    if ! declare -f "pkg_$pkg" &>/dev/null; then
        err "unknown package: $pkg"
        return 1
    fi
    
    info "installing $pkg..."
    "pkg_$pkg"
    INSTALLED+=("$pkg")
    ok "$pkg done"
}

# ============================================================================
# PACKAGES
# ============================================================================

pkg_git() {
    if command -v git &>/dev/null; then
        ok "git already installed"
        return
    fi
    
    if [ "$PLATFORM" = "macos" ]; then
        # xcode-select installs git
        xcode-select --install 2>/dev/null || true
    else
        install_pkg "" git git git
    fi
}

pkg_brew() {
    [ "$PLATFORM" != "macos" ] && return 0
    
    if command -v brew &>/dev/null; then
        ok "brew already installed"
        return
    fi
    
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
}

pkg_mise() {
    if command -v mise &>/dev/null; then
        ok "mise already installed"
    else
        curl https://mise.run | sh
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    mklink "$DOTFILES/mise.toml" "$HOME/.config/mise/config.toml"
    
    # Install tools defined in mise.toml
    if [ -f "$DOTFILES/mise.toml" ]; then
        mise trust "$DOTFILES/mise.toml" 2>/dev/null || true
        mise install
    fi
}

pkg_zsh() {
    # Install zsh if not present
    if ! command -v zsh &>/dev/null; then
        install_pkg zsh zsh zsh zsh
    fi
    
    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    
    # Plugins
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    
    # Links
    mklink "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
    mklink "$DOTFILES/zsh/zsh_profile" "$HOME/.zsh_profile"
    mklink "$DOTFILES/zsh/zsh_alias" "$HOME/.zsh_alias"
    [ -f "$DOTFILES/zsh/.env" ] && mklink "$DOTFILES/zsh/.env" "$HOME/.env"
}

pkg_nvim() {
    depends_on git
    
    install_pkg neovim neovim neovim neovim
    mklink "$DOTFILES/nvim" "$HOME/.config/nvim"
    mkdir -p "$HOME/.local/share/nvim"
}

pkg_tmux() {
    depends_on git
    
    install_pkg tmux tmux tmux tmux
    
    # TPM
    [ ! -d "$HOME/.tmux/plugins/tpm" ] && \
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    
    mklink "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
    mklink "$DOTFILES/tmux/global-sessionizer-defaults.sh" "$HOME/.tmux-sessionizer"
}

pkg_lazygit() {
    depends_on git
    
    if [ "$PLATFORM" = "macos" ]; then
        install_pkg lazygit "" "" ""
    else
        # lazygit isn't in default repos, use go or binary
        if command -v go &>/dev/null; then
            go install github.com/jesseduffield/lazygit@latest
        else
            warn "install go first or install lazygit manually"
        fi
    fi
    
    mklink "$DOTFILES/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
}

pkg_kitty() {
    if [ "$PLATFORM" = "macos" ]; then
        install_pkg "kitty --cask" "" "" ""
    else
        install_pkg "" kitty kitty kitty
    fi
    
    mklink "$DOTFILES/kitty" "$HOME/.config/kitty"
}

pkg_ghostty() {
    [ "$PLATFORM" != "macos" ] && return 0
    
    depends_on brew
    brew install --cask ghostty 2>/dev/null || true
    mklink "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"
}

pkg_alacritty() {
    if [ "$PLATFORM" = "macos" ]; then
        install_pkg "alacritty --cask" "" "" ""
    else
        install_pkg "" alacritty alacritty alacritty
    fi
    
    mklink "$DOTFILES/alacritty" "$HOME/.config/alacritty"
}

pkg_wezterm() {
    if [ "$PLATFORM" = "macos" ]; then
        install_pkg "wezterm --cask" "" "" ""
    else
        # wezterm has its own repo for linux
        warn "install wezterm manually from https://wezfurlong.org/wezterm/"
    fi
    
    mklink "$DOTFILES/wezterm" "$HOME/.config/wezterm"
}

pkg_fzf() {
    install_pkg fzf fzf fzf fzf
}

pkg_ripgrep() {
    install_pkg ripgrep ripgrep ripgrep ripgrep
}

pkg_bat() {
    install_pkg bat bat bat bat
}

pkg_jq() {
    install_pkg jq jq jq jq
}

pkg_htop() {
    install_pkg htop htop htop htop
}

pkg_bun() {
    if command -v bun &>/dev/null; then
        ok "bun already installed"
        return
    fi
    
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
}

pkg_opencode() {
    if command -v opencode &>/dev/null; then
        ok "opencode already installed"
    else
        if [ "$PLATFORM" = "macos" ]; then
            depends_on brew
            brew tap sst/tap && brew install opencode
        else
            curl -fsSL https://opencode.ai/install | bash
        fi
    fi
    
    mklink "$DOTFILES/opencode" "$HOME/.config/opencode"
}

pkg_oh_my_opencode() {
    depends_on bun opencode
    
    # Run the interactive installer
    # Use --no-tui for non-interactive, configure flags as needed
    if command -v bunx &>/dev/null; then
        bunx oh-my-opencode install
    else
        npx oh-my-opencode install
    fi
}

pkg_aerospace() {
    [ "$PLATFORM" != "macos" ] && return 0
    
    depends_on brew
    brew install --cask nikitabobko/tap/aerospace 2>/dev/null || true
    mklink "$DOTFILES/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
}

pkg_yabai() {
    [ "$PLATFORM" != "macos" ] && return 0
    
    depends_on brew
    brew tap koekeishiya/formulae
    brew install yabai
    mklink "$DOTFILES/yabai/yabairc" "$HOME/.config/yabai/yabairc"
}

pkg_skhd() {
    [ "$PLATFORM" != "macos" ] && return 0
    
    depends_on brew
    brew tap koekeishiya/formulae
    brew install skhd
    mklink "$DOTFILES/skhd/aerospace_skhdrc" "$HOME/.config/skhd/skhdrc"
}

pkg_sketchybar() {
    [ "$PLATFORM" != "macos" ] && return 0
    
    depends_on brew
    brew tap FelixKratz/formulae
    brew install sketchybar
    mklink "$DOTFILES/sketchybar" "$HOME/.config/sketchybar"
}

pkg_i3() {
    [ "$PLATFORM" != "linux" ] && return 0
    
    install_pkg "" i3 i3 i3
    mklink "$DOTFILES/i3" "$HOME/.config/i3"
}

pkg_autorandr() {
    [ "$PLATFORM" != "linux" ] && return 0
    
    install_pkg "" autorandr autorandr autorandr
    mklink "$DOTFILES/autorandr" "$HOME/.config/autorandr"
}

pkg_scripts() {
    mkdir -p "$HOME/.local/bin"
    for script in "$DOTFILES/scripts/"*; do
        [ -f "$script" ] && mklink "$script" "$HOME/.local/bin/$(basename "$script")"
    done
}

pkg_screen() {
    install_pkg screen screen screen screen
    mklink "$DOTFILES/screen/screenrc" "$HOME/.screenrc"
}

pkg_hyper() {
    mklink "$DOTFILES/hyper/hyper.js" "$HOME/.hyper.js"
}

pkg_barik() {
    [ "$PLATFORM" != "macos" ] && return 0
    mklink "$DOTFILES/barik/barik-config.toml" "$HOME/.barik-config.toml"
}

# macOS defaults (not really a package, but fits the pattern)
pkg_macos_defaults() {
    [ "$PLATFORM" != "macos" ] && return 0
    
    # Dock
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -int 0
    defaults write com.apple.Dock showhidden -bool TRUE
    
    # Screenshots
    defaults write com.apple.screencapture type jpg
    
    killall Dock 2>/dev/null || true
}

# ============================================================================
# MAIN
# ============================================================================

# All available packages (order matters for defaults)
ALL_PACKAGES=(
    git
    brew
    mise
    bun
    zsh
    nvim
    tmux
    lazygit
    kitty
    ghostty
    alacritty
    wezterm
    fzf
    ripgrep
    bat
    jq
    htop
    opencode
    oh_my_opencode
    aerospace
    yabai
    skhd
    sketchybar
    i3
    autorandr
    scripts
    screen
    hyper
    barik
    macos_defaults
)

main() {
    echo ""
    echo "┌─────────────────────────────────────┐"
    echo "│         dotfiles installer          │"
    echo "└─────────────────────────────────────┘"
    echo ""
    info "platform: $PLATFORM"
    [ -n "$FILTER" ] && info "filter: $FILTER"
    echo ""
    
    # Clone dotfiles if needed
    if [ ! -d "$DOTFILES" ]; then
        info "cloning dotfiles..."
        git clone https://github.com/YOUR_USERNAME/dotfiles.git "$DOTFILES"
    fi
    cd "$DOTFILES"
    
    # Run packages
    if [ -n "$FILTER" ]; then
        # Run only filtered packages
        for pkg in $FILTER; do
            run_pkg "$pkg"
        done
    else
        # Run all packages
        for pkg in "${ALL_PACKAGES[@]}"; do
            should_run "$pkg" && run_pkg "$pkg"
        done
    fi
    
    echo ""
    echo "┌─────────────────────────────────────┐"
    echo "│            done! 🎉                 │"
    echo "└─────────────────────────────────────┘"
    echo ""
    echo "next steps:"
    echo "  • restart terminal or: source ~/.zshrc"
    echo "  • tmux plugins: prefix + I"
    echo "  • nvim plugins: just open nvim"
    echo ""
}

main "$@"
