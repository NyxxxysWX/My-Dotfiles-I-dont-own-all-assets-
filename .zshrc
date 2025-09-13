# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dst"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
pacman() {
  if [[ "$1" == "-F" && -n "$2" ]]; then
    pkg="$2"

    if pacman --noconfirm -S "$pkg" 2>/dev/null; then
      echo "Installed with pacman"
      return
    fi

    if choco search "$pkg" --exact | grep -q "^$pkg "; then
      choco install -y "$pkg"
      echo "Installed with Chocolatey"
      return
    fi

    if scoop search "$pkg" | grep -q "^$pkg"; then
      scoop install "$pkg"
      echo "Installed with Scoop"
      return
    fi

    if cargo search "$pkg" | grep -q "^$pkg ="; then
      if cargo install "$pkg"; then
        echo "Installed with Cargo"
        return
      else
        echo "Cargo failed to install package '$pkg'."
      fi
    fi

    if command -v npackdcli >/dev/null 2>&1; then
      if npackdcli search "$pkg" | grep -q "$pkg"; then
        if npackdcli install "$pkg" --accept-eula --accept-license; then
          echo "Installed with Npackd"
          return
        else
          echo "Npackd failed to install package '$pkg'."
        fi
      fi
    fi

    if command -v nuget >/dev/null 2>&1; then
      if nuget list "$pkg" | grep -q "^$pkg "; then
        if nuget install "$pkg" -OutputDirectory ./nuget-packages; then
          echo "Installed with NuGet (to ./nuget-packages)"
          return
        else
          echo "NuGet failed to install package '$pkg'."
        fi
      fi
    fi

    if command -v yarn >/dev/null 2>&1; then
      if yarn info "$pkg" >/dev/null 2>&1; then
        if yarn global add "$pkg"; then
          echo "Installed with Yarn"
          return
        else
          echo "Yarn failed to install package '$pkg'."
        fi
      fi
    fi

    if command -v eget >/dev/null 2>&1; then
      # Try to install the package using eget
      if eget "$pkg"; then
        echo "Installed with eget (GitHub binary)"
        return
      else
        echo "eget failed to install package '$pkg'."
      fi
    fi

    echo "Package '$pkg' not found in any package manager."
  else
    command pacman "$@"
  fi
}




