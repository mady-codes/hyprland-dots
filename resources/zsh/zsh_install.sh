#!/bin/zsh

# Ensure you define the log file
LOG="$HOME/zsh_install.log"

# Define the list of core Zsh packages
zsh_packages=(
    eza
    zsh
    zsh-completions
    fzf
)

# Function to install packages using pacman
install_package() {
    sudo pacman -S --noconfirm "$1" 2>&1 | tee -a "$LOG"
}

# Installing core Zsh packages
printf "${NOTE} Installing core Zsh packages...${RESET}\n"
for ZSH in "${zsh_packages[@]}"; do
  install_package "$ZSH"
  if [ $? -ne 0 ]; then
     echo -e "\e[1A\e[K${ERROR} - $ZSH package installation failed. Please check the installation logs"
  fi
done

# Check if zsh is installed and proceed with Oh My Zsh installation
if command -v zsh >/dev/null; then
  printf "${NOTE} Installing Oh My Zsh and plugins...\n"
  
  # Install Oh My Zsh if not already installed
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
  else
      echo "Directory .oh-my-zsh already exists. Skipping re-installation." 2>&1 | tee -a "$LOG"
  fi

  # Install zsh-autosuggestions plugin if not already installed
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
      git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
  else
      echo "Directory zsh-autosuggestions already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
  fi

  # Install zsh-syntax-highlighting plugin if not already installed
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
  else
      echo "Directory zsh-syntax-highlighting already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
  fi

else
  echo "Zsh is not installed. Please install Zsh first." | tee -a "$LOG"
fi

# PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[1;32m%}%n%{\e[1;37m%}@%{\e[1;37m%}%{\e[1;31m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[%b%{\e[1;38;5;214m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[38;5;214m%}'%D{"%a %b %d, %I:%M %p"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%}
# %{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B] <$(git_prompt_info)>%{\e[0m%}%b '
# PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '