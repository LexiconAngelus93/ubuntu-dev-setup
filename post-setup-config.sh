#!/bin/bash

# Ubuntu Development Environment Post-Setup Configuration Script
# This script handles advanced configuration and user-specific setup tasks
# Run this after the main setup.sh and verify-setup.sh scripts

echo "🔧 Starting Ubuntu Development Environment Post-Setup Configuration..."
echo "====================================================================="

# Check if running in a pipe (non-interactive mode)
if [ ! -t 0 ]; then
    echo "⚠️  NOTICE: Script detected non-interactive mode (piped from curl)"
    echo "📥 For full interactive experience, please download and run locally:"
    echo "   wget https://raw.githubusercontent.com/LexiconAngelus93/ubuntu-dev-setup/main/post-setup-config.sh"
    echo "   chmod +x post-setup-config.sh"
    echo "   ./post-setup-config.sh"
    echo ""
    echo "🤖 Running in automatic mode with sensible defaults..."
    echo "⏱️  Waiting 5 seconds before starting (Ctrl+C to cancel)..."
    sleep 5
    INTERACTIVE_MODE=false
else
    INTERACTIVE_MODE=true
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration tracking
CONFIGS_COMPLETED=0
CONFIGS_SKIPPED=0
MANUAL_STEPS=0

# Log file
LOG_FILE="/tmp/ubuntu-dev-post-setup.log"
echo "Post-setup configuration started at $(date)" > "$LOG_FILE"

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "OK")
            echo -e "${GREEN}✓${NC} $message"
            ;;
        "WARN")
            echo -e "${YELLOW}⚠${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}✗${NC} $message"
            ;;
        "CONFIG")
            echo -e "${BLUE}🔧${NC} $message"
            ((CONFIGS_COMPLETED++))
            ;;
        "SKIP")
            echo -e "${CYAN}⏭${NC} $message"
            ((CONFIGS_SKIPPED++))
            ;;
        "MANUAL")
            echo -e "${PURPLE}👤${NC} $message"
            ((MANUAL_STEPS++))
            ;;
        "INFO")
            echo -e "${BLUE}ℹ${NC} $message"
            ;;
        "STEP")
            echo -e "${PURPLE}📋${NC} $message"
            ;;
    esac
    echo "[$status] $message" >> "$LOG_FILE"
}

# Function to ask yes/no questions
ask_yes_no() {
    local question=$1
    local default=${2:-"n"}
    local response
    
    if [ "$INTERACTIVE_MODE" = false ]; then
        # In non-interactive mode, use defaults
        echo -e "${CYAN}$question [Auto: $default]${NC}"
        case $default in
            [Yy]|[Yy][Ee][Ss]) return 0 ;;
            *) return 1 ;;
        esac
    fi
    
    if [ "$default" = "y" ]; then
        echo -e "${CYAN}$question [Y/n]:${NC} "
    else
        echo -e "${CYAN}$question [y/N]:${NC} "
    fi
    
    read -r response </dev/tty 2>/dev/null || {
        # Fallback if /dev/tty is not available
        echo -e "${YELLOW}⚠️  Cannot read input, using default: $default${NC}"
        response=$default
    }
    
    response=${response:-$default}
    
    case $response in
        [Yy]|[Yy][Ee][Ss]) return 0 ;;
        *) return 1 ;;
    esac
}

# Function to wait for user input before continuing
wait_for_user() {
    local message=${1:-"Press Enter to continue to the next section..."}
    
    if [ "$INTERACTIVE_MODE" = false ]; then
        echo -e "${PURPLE}📋 $message [Auto-continuing in 2 seconds...]${NC}"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${PURPLE}📋 $message${NC}"
    read -r </dev/tty 2>/dev/null || {
        echo -e "${YELLOW}⚠️  Cannot read input, auto-continuing...${NC}"
        sleep 1
    }
}

# Function to get user input
get_user_input() {
    local prompt=$1
    local default=$2
    local response
    
    if [ "$INTERACTIVE_MODE" = false ]; then
        echo -e "${CYAN}$prompt [Auto: $default]${NC}"
        echo "$default"
        return
    fi
    
    if [ -n "$default" ]; then
        echo -e "${CYAN}$prompt [$default]:${NC} "
    else
        echo -e "${CYAN}$prompt:${NC} "
    fi
    
    read -r response </dev/tty 2>/dev/null || {
        echo -e "${YELLOW}⚠️  Cannot read input, using default: $default${NC}"
        response=$default
    }
    
    echo "${response:-$default}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo ""
echo "🔍 1. Analyzing verification results..."
echo "--------------------------------------"

# Check if verification log exists
if [ -f "/tmp/ubuntu-dev-setup-verification.log" ]; then
    print_status "OK" "Found verification log, analyzing results..."
    
    # Count issues from verification log
    VERIFICATION_ERRORS=$(grep -c "\[ERROR\]" /tmp/ubuntu-dev-setup-verification.log 2>/dev/null || echo "0")
    VERIFICATION_WARNINGS=$(grep -c "\[WARN\]" /tmp/ubuntu-dev-setup-verification.log 2>/dev/null || echo "0")
    
    print_status "INFO" "Verification found $VERIFICATION_ERRORS errors and $VERIFICATION_WARNINGS warnings"
    
    if [ "$VERIFICATION_ERRORS" -gt 0 ] || [ "$VERIFICATION_WARNINGS" -gt 0 ]; then
        print_status "INFO" "This script will help you resolve remaining issues and complete your setup"
    fi
else
    print_status "WARN" "Verification log not found. Run verify-setup.sh first for best results."
    if ask_yes_no "Would you like to run the verification script now?"; then
        if [ -f "./verify-setup.sh" ]; then
            print_status "CONFIG" "Running verification script..."
            ./verify-setup.sh
        else
            print_status "INFO" "Downloading and running verification script..."
            curl -fsSL https://raw.githubusercontent.com/LexiconAngelus93/ubuntu-dev-setup/main/verify-setup.sh | bash
        fi
    fi
fi

wait_for_user "Ready to proceed with Git configuration?"

echo ""
echo "👤 2. Git Configuration Setup..."
echo "--------------------------------"

if command_exists git; then
    GIT_USER=$(git config --global user.name 2>/dev/null)
    GIT_EMAIL=$(git config --global user.email 2>/dev/null)
    
    if [ -z "$GIT_USER" ] || [ "$GIT_USER" = "Your Name" ] || [ "$GIT_USER" = "Ubuntu Dev Setup" ]; then
        print_status "MANUAL" "Git user name needs configuration"
        
        if ask_yes_no "Would you like to configure Git now?" "y"; then
            USER_NAME=$(get_user_input "Enter your full name" "Developer")
            if [ -n "$USER_NAME" ]; then
                git config --global user.name "$USER_NAME"
                print_status "CONFIG" "Git user name set to: $USER_NAME"
            fi
        else
            print_status "SKIP" "Git user name configuration skipped"
        fi
    else
        print_status "OK" "Git user name already configured: $GIT_USER"
    fi
    
    if [ -z "$GIT_EMAIL" ] || [ "$GIT_EMAIL" = "your.email@example.com" ] || [ "$GIT_EMAIL" = "dev@ubuntu-setup.com" ]; then
        print_status "MANUAL" "Git email needs configuration"
        
        if ask_yes_no "Would you like to configure Git email now?" "y"; then
            USER_EMAIL=$(get_user_input "Enter your email address" "developer@example.com")
            if [ -n "$USER_EMAIL" ]; then
                git config --global user.email "$USER_EMAIL"
                print_status "CONFIG" "Git email set to: $USER_EMAIL"
            fi
        else
            print_status "SKIP" "Git email configuration skipped"
        fi
    else
        print_status "OK" "Git email already configured: $GIT_EMAIL"
    fi
    
    # Configure additional Git settings
    if ask_yes_no "Would you like to configure additional Git settings?" "y"; then
        print_status "CONFIG" "Configuring additional Git settings..."
        
        # Set default branch to main
        git config --global init.defaultBranch main
        
        # Set default editor
        if command_exists code; then
            git config --global core.editor "code --wait"
            print_status "CONFIG" "Set VS Code as default Git editor"
        elif command_exists vim; then
            git config --global core.editor "vim"
            print_status "CONFIG" "Set Vim as default Git editor"
        fi
        
        # Configure merge and pull strategies
        git config --global pull.rebase false
        git config --global merge.tool vimdiff
        
        # Configure useful aliases
        git config --global alias.st status
        git config --global alias.co checkout
        git config --global alias.br branch
        git config --global alias.ci commit
        git config --global alias.unstage 'reset HEAD --'
        git config --global alias.last 'log -1 HEAD'
        git config --global alias.visual '!gitk'
        
        print_status "CONFIG" "Configured Git aliases and settings"
    fi
else
    print_status "ERROR" "Git not found. Please install Git first."
fi

wait_for_user "Git configuration completed. Ready to proceed with SSH key setup?"

echo ""
echo "🔐 3. SSH Key Setup..."
echo "----------------------"

SSH_DIR="$HOME/.ssh"
if [ ! -d "$SSH_DIR" ]; then
    print_status "MANUAL" "SSH directory doesn't exist"
    if ask_yes_no "Would you like to create SSH directory and generate SSH keys?"; then
        mkdir -p "$SSH_DIR"
        chmod 700 "$SSH_DIR"
        print_status "CONFIG" "Created SSH directory"
    else
        print_status "SKIP" "SSH setup skipped"
    fi
fi

if [ -d "$SSH_DIR" ]; then
    # Check for existing SSH keys
    SSH_KEYS_FOUND=false
    for key_type in rsa ed25519 ecdsa; do
        if [ -f "$SSH_DIR/id_$key_type" ]; then
            print_status "OK" "Found existing SSH key: id_$key_type"
            SSH_KEYS_FOUND=true
        fi
    done
    
    if [ "$SSH_KEYS_FOUND" = false ]; then
        print_status "MANUAL" "No SSH keys found"
        
        if ask_yes_no "Would you like to generate a new SSH key?" "y"; then
            KEY_EMAIL=$(get_user_input "Enter email for SSH key" "${GIT_EMAIL:-developer@example.com}")
            KEY_TYPE=$(get_user_input "Choose key type (ed25519/rsa)" "ed25519")
            
            case $KEY_TYPE in
                "rsa")
                    ssh-keygen -t rsa -b 4096 -C "$KEY_EMAIL" -f "$SSH_DIR/id_rsa"
                    ;;
                *)
                    ssh-keygen -t ed25519 -C "$KEY_EMAIL" -f "$SSH_DIR/id_ed25519"
                    ;;
            esac
            
            print_status "CONFIG" "Generated SSH key"
            
            # Start SSH agent and add key
            if command_exists ssh-agent; then
                eval "$(ssh-agent -s)" >/dev/null 2>&1
                if [ -f "$SSH_DIR/id_ed25519" ]; then
                    ssh-add "$SSH_DIR/id_ed25519" >/dev/null 2>&1
                elif [ -f "$SSH_DIR/id_rsa" ]; then
                    ssh-add "$SSH_DIR/id_rsa" >/dev/null 2>&1
                fi
                print_status "CONFIG" "Added SSH key to agent"
            fi
            
            # Display public key
            echo ""
            print_status "STEP" "Your SSH public key (copy this to GitHub/GitLab):"
            echo "----------------------------------------"
            if [ -f "$SSH_DIR/id_ed25519.pub" ]; then
                cat "$SSH_DIR/id_ed25519.pub"
            elif [ -f "$SSH_DIR/id_rsa.pub" ]; then
                cat "$SSH_DIR/id_rsa.pub"
            fi
            echo "----------------------------------------"
            echo ""
            
            print_status "MANUAL" "Add this key to your Git hosting service:"
            echo "  • GitHub: Settings → SSH and GPG keys → New SSH key"
            echo "  • GitLab: Preferences → SSH Keys → Add key"
            echo "  • Bitbucket: Personal settings → SSH keys → Add key"
            
            if ask_yes_no "Press Enter when you've added the key to continue..." "y"; then
                print_status "OK" "SSH key setup completed"
            fi
        else
            print_status "SKIP" "SSH key generation skipped"
        fi
    fi
    
    # Configure SSH config file
    SSH_CONFIG="$SSH_DIR/config"
    if [ ! -f "$SSH_CONFIG" ]; then
        if ask_yes_no "Would you like to create an SSH config file with common settings?"; then
            cat > "$SSH_CONFIG" << 'EOF'
# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes

# GitLab
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes

# Default settings
Host *
    AddKeysToAgent yes
    UseKeychain yes
    ServerAliveInterval 60
    ServerAliveCountMax 30
EOF
            chmod 600 "$SSH_CONFIG"
            print_status "CONFIG" "Created SSH config file"
        fi
    else
        print_status "OK" "SSH config file already exists"
    fi
fi

wait_for_user "SSH configuration completed. Ready to proceed with shell optimization?"

echo ""
echo "🐚 4. Shell Configuration..."
echo "----------------------------"

CURRENT_SHELL=$(basename "$SHELL")
print_status "INFO" "Current shell: $CURRENT_SHELL"

if [ "$CURRENT_SHELL" != "zsh" ]; then
    if command_exists zsh; then
        if ask_yes_no "Would you like to switch to Zsh as your default shell?"; then
            chsh -s "$(which zsh)"
            print_status "CONFIG" "Changed default shell to Zsh (logout/login required)"
        else
            print_status "SKIP" "Shell change skipped"
        fi
    else
        if ask_yes_no "Zsh not found. Would you like to install it?"; then
            sudo apt update && sudo apt install -y zsh
            print_status "CONFIG" "Installed Zsh"
            
            if ask_yes_no "Would you like to set Zsh as your default shell?"; then
                chsh -s "$(which zsh)"
                print_status "CONFIG" "Changed default shell to Zsh"
            fi
        fi
    fi
fi

# Oh My Zsh setup
if command_exists zsh && [ ! -d "$HOME/.oh-my-zsh" ]; then
    if ask_yes_no "Would you like to install Oh My Zsh?"; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_status "CONFIG" "Installed Oh My Zsh"
        
        # Configure Oh My Zsh theme and plugins
        if [ -f "$HOME/.zshrc" ]; then
            # Set theme
            sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' "$HOME/.zshrc"
            
            # Add useful plugins
            sed -i 's/plugins=(git)/plugins=(git docker docker-compose npm node python pip virtualenv sudo history-substring-search zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
            
            print_status "CONFIG" "Configured Oh My Zsh theme and plugins"
        fi
        
        # Install additional plugins
        ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
        
        # zsh-autosuggestions
        if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" >/dev/null 2>&1
            print_status "CONFIG" "Installed zsh-autosuggestions plugin"
        fi
        
        # zsh-syntax-highlighting
        if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" >/dev/null 2>&1
            print_status "CONFIG" "Installed zsh-syntax-highlighting plugin"
        fi
    else
        print_status "SKIP" "Oh My Zsh installation skipped"
    fi
fi

wait_for_user "Shell configuration completed. Ready to proceed with Python environment optimization?"

echo ""
echo "🐍 5. Python Environment Optimization..."
echo "----------------------------------------"

if command_exists python3; then
    # Set up Python virtual environment tools
    if ! python3 -c "import venv" >/dev/null 2>&1; then
        if ask_yes_no "Python venv module not found. Install python3-venv?"; then
            sudo apt install -y python3-venv
            print_status "CONFIG" "Installed python3-venv"
        fi
    fi
    
    # Configure pip
    PIP_CONF_DIR="$HOME/.config/pip"
    PIP_CONF_FILE="$PIP_CONF_DIR/pip.conf"
    
    if [ ! -f "$PIP_CONF_FILE" ]; then
        if ask_yes_no "Would you like to configure pip with optimized settings?"; then
            mkdir -p "$PIP_CONF_DIR"
            cat > "$PIP_CONF_FILE" << 'EOF'
[global]
timeout = 60
index-url = https://pypi.org/simple/
trusted-host = pypi.org
               pypi.python.org
               files.pythonhosted.org

[install]
user = true
upgrade = true
EOF
            print_status "CONFIG" "Created pip configuration file"
        fi
    fi
    
    # Set up common Python development directories
    if ask_yes_no "Would you like to create Python development directories?"; then
        mkdir -p "$HOME/Development/Python/projects"
        mkdir -p "$HOME/Development/Python/venvs"
        print_status "CONFIG" "Created Python development directories"
    fi
    
    # Install/upgrade essential Python packages
    if ask_yes_no "Would you like to install/upgrade essential Python development packages?"; then
        print_status "CONFIG" "Installing essential Python packages..."
        pip3 install --user --upgrade \
            pip setuptools wheel \
            virtualenv virtualenvwrapper \
            ipython jupyter \
            black flake8 pylint mypy \
            pytest pytest-cov \
            requests beautifulsoup4 \
            numpy pandas matplotlib \
            >/dev/null 2>&1
        print_status "CONFIG" "Installed essential Python packages"
    fi
else
    print_status "ERROR" "Python3 not found"
fi

wait_for_user "Python environment optimization completed. Ready to proceed with Node.js environment optimization?"

echo ""
echo "🌐 6. Node.js Environment Optimization..."
echo "-----------------------------------------"

if command_exists node && command_exists npm; then
    # Configure npm
    NPM_PREFIX="$HOME/.npm-global"
    if [ ! -d "$NPM_PREFIX" ]; then
        if ask_yes_no "Would you like to configure npm for global packages without sudo?"; then
            mkdir -p "$NPM_PREFIX"
            npm config set prefix "$NPM_PREFIX"
            
            # Add to PATH in shell config
            SHELL_CONFIG=""
            if [ -f "$HOME/.zshrc" ]; then
                SHELL_CONFIG="$HOME/.zshrc"
            elif [ -f "$HOME/.bashrc" ]; then
                SHELL_CONFIG="$HOME/.bashrc"
            fi
            
            if [ -n "$SHELL_CONFIG" ]; then
                if ! grep -q "npm-global/bin" "$SHELL_CONFIG"; then
                    echo 'export PATH=~/.npm-global/bin:$PATH' >> "$SHELL_CONFIG"
                    print_status "CONFIG" "Added npm global bin to PATH"
                fi
            fi
            
            print_status "CONFIG" "Configured npm global directory"
        fi
    fi
    
    # Install essential global packages
    if ask_yes_no "Would you like to install essential Node.js global packages?"; then
        print_status "CONFIG" "Installing essential Node.js packages..."
        npm install -g \
            typescript \
            @types/node \
            eslint \
            prettier \
            nodemon \
            pm2 \
            http-server \
            create-react-app \
            @vue/cli \
            @angular/cli \
            >/dev/null 2>&1
        print_status "CONFIG" "Installed essential Node.js packages"
    fi
    
    # Set up Node.js development directories
    if ask_yes_no "Would you like to create Node.js development directories?"; then
        mkdir -p "$HOME/Development/Node/projects"
        print_status "CONFIG" "Created Node.js development directories"
    fi
else
    print_status "WARN" "Node.js or npm not found"
fi

wait_for_user "Node.js environment optimization completed. Ready to proceed with database configuration?"

echo ""
echo "🗄️ 7. Database Configuration..."
echo "-------------------------------"

# Docker setup
if command_exists docker; then
    if ! groups "$USER" | grep -q docker; then
        print_status "MANUAL" "User not in docker group"
        if ask_yes_no "Add user to docker group? (requires logout/login)"; then
            sudo usermod -aG docker "$USER"
            print_status "CONFIG" "Added user to docker group"
        fi
    else
        print_status "OK" "User already in docker group"
    fi
    
    # Docker Compose setup
    if ! command_exists docker-compose; then
        if ask_yes_no "Docker Compose not found. Install it?"; then
            sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            print_status "CONFIG" "Installed Docker Compose"
        fi
    fi
fi

# PostgreSQL setup
if command_exists psql; then
    if ask_yes_no "Would you like to configure PostgreSQL?"; then
        print_status "MANUAL" "PostgreSQL configuration:"
        echo "  1. Set password for postgres user: sudo -u postgres psql -c \"ALTER USER postgres PASSWORD 'your_password';\""
        echo "  2. Create your user database: sudo -u postgres createdb $USER"
        echo "  3. Grant privileges: sudo -u postgres psql -c \"GRANT ALL PRIVILEGES ON DATABASE $USER TO postgres;\""
        
        if ask_yes_no "Would you like to run these commands now?"; then
            DB_PASSWORD=$(get_user_input "Enter password for postgres user" "postgres")
            sudo -u postgres psql -c "ALTER USER postgres PASSWORD '$DB_PASSWORD';" >/dev/null 2>&1
            sudo -u postgres createdb "$USER" >/dev/null 2>&1
            sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $USER TO postgres;" >/dev/null 2>&1
            print_status "CONFIG" "Configured PostgreSQL"
        fi
    fi
fi

# MySQL setup
if command_exists mysql; then
    if ask_yes_no "Would you like to run MySQL secure installation?"; then
        print_status "MANUAL" "Running MySQL secure installation..."
        sudo mysql_secure_installation
        print_status "CONFIG" "MySQL secure installation completed"
    fi
fi

wait_for_user "Database configuration completed. Ready to proceed with development tools configuration?"

echo ""
echo "🔧 8. Development Tools Configuration..."
echo "---------------------------------------"

# VS Code extensions
if command_exists code; then
    if ask_yes_no "Would you like to install recommended VS Code extensions?"; then
        print_status "CONFIG" "Installing VS Code extensions..."
        
        # Essential extensions
        EXTENSIONS=(
            "ms-python.python"
            "ms-vscode.vscode-typescript-next"
            "bradlc.vscode-tailwindcss"
            "esbenp.prettier-vscode"
            "ms-vscode.vscode-eslint"
            "ms-vscode.vscode-json"
            "redhat.vscode-yaml"
            "ms-vscode.vscode-docker"
            "ms-vscode.vscode-git"
            "eamodio.gitlens"
            "ms-vscode.vscode-markdown"
            "yzhang.markdown-all-in-one"
            "ms-vscode.vscode-theme-github"
            "pkief.material-icon-theme"
        )
        
        for ext in "${EXTENSIONS[@]}"; do
            code --install-extension "$ext" >/dev/null 2>&1
        done
        
        print_status "CONFIG" "Installed VS Code extensions"
    fi
fi

# Create development workspace
if ask_yes_no "Would you like to create a development workspace structure?"; then
    mkdir -p "$HOME/Development"/{Python,Node,Go,Rust,Java,Web,Mobile,DevOps,Scripts}
    mkdir -p "$HOME/Development/Repositories"
    mkdir -p "$HOME/Development/Learning"
    mkdir -p "$HOME/Development/Playground"
    print_status "CONFIG" "Created development workspace structure"
fi

wait_for_user "Development tools configuration completed. Ready to proceed with system optimizations?"

echo ""
echo "⚙️ 9. System Optimizations..."
echo "-----------------------------"

# Configure Git LFS
if command_exists git && command_exists git-lfs; then
    if ask_yes_no "Would you like to configure Git LFS?"; then
        git lfs install
        print_status "CONFIG" "Configured Git LFS"
    fi
fi

# Configure system limits for development
if ask_yes_no "Would you like to optimize system limits for development?"; then
    # Increase file watch limits for development tools
    echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf >/dev/null
    sudo sysctl -p >/dev/null 2>&1
    print_status "CONFIG" "Increased file watch limits"
fi

# Set up useful aliases
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ] && ask_yes_no "Would you like to add useful development aliases?"; then
    cat >> "$SHELL_CONFIG" << 'EOF'

# Development aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Python aliases
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Node.js aliases
alias ni='npm install'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# System aliases
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias search='apt search'
alias ports='netstat -tuln'
alias myip='curl ifconfig.me'
EOF
    print_status "CONFIG" "Added development aliases"
fi

wait_for_user "System optimizations completed. Ready to proceed with final steps?"

echo ""
echo "🔄 10. Final Steps and Recommendations..."
echo "----------------------------------------"

# Create a development environment info file
DEV_INFO_FILE="$HOME/Development/environment-info.md"
if ask_yes_no "Would you like to create a development environment info file?"; then
    cat > "$DEV_INFO_FILE" << EOF
# Development Environment Information

Generated on: $(date)

## System Information
- OS: $(lsb_release -d | cut -f2)
- Kernel: $(uname -r)
- Architecture: $(uname -m)

## Installed Tools
$(command_exists python3 && echo "- Python: $(python3 --version)")
$(command_exists node && echo "- Node.js: $(node --version)")
$(command_exists npm && echo "- npm: $(npm --version)")
$(command_exists git && echo "- Git: $(git --version)")
$(command_exists docker && echo "- Docker: $(docker --version)")
$(command_exists code && echo "- VS Code: $(code --version | head -n1)")

## Configuration Files
- Git config: ~/.gitconfig
- SSH config: ~/.ssh/config
- Shell config: $SHELL_CONFIG
- Python pip config: ~/.config/pip/pip.conf

## Development Directories
- Main workspace: ~/Development/
- Python projects: ~/Development/Python/
- Node.js projects: ~/Development/Node/
- Repositories: ~/Development/Repositories/

## Useful Commands
- Update system: \`update\`
- Git status: \`gs\`
- Python virtual env: \`venv myproject && cd myproject && activate\`
- Docker compose: \`dc up -d\`

## Next Steps
1. Restart your terminal or logout/login for all changes to take effect
2. Test SSH key with: \`ssh -T git@github.com\`
3. Clone your first repository: \`git clone git@github.com:username/repo.git\`
4. Create your first Python project: \`cd ~/Development/Python && python3 -m venv myproject\`

EOF
    print_status "CONFIG" "Created development environment info file"
fi

wait_for_user "All configurations completed. Ready to view the final summary?"

echo ""
echo "📊 POST-SETUP CONFIGURATION SUMMARY"
echo "===================================="
echo -e "Configurations Completed: ${GREEN}$CONFIGS_COMPLETED${NC}"
echo -e "Configurations Skipped: ${CYAN}$CONFIGS_SKIPPED${NC}"
echo -e "Manual Steps Required: ${PURPLE}$MANUAL_STEPS${NC}"
echo ""

if [ "$MANUAL_STEPS" -gt 0 ]; then
    print_status "MANUAL" "Some manual steps are required:"
    echo "  • Logout and login again for group changes to take effect"
    echo "  • Restart your terminal for shell changes"
    echo "  • Test SSH key connection to your Git hosting service"
    echo "  • Review and customize your shell configuration"
fi

print_status "STEP" "🎉 Post-setup configuration completed!"
echo ""

if [ "$INTERACTIVE_MODE" = false ]; then
    echo "🤖 AUTOMATIC MODE COMPLETED"
    echo "============================"
    echo "The script ran in automatic mode with default settings."
    echo "For full customization, download and run interactively:"
    echo ""
    echo "  wget https://raw.githubusercontent.com/LexiconAngelus93/ubuntu-dev-setup/main/post-setup-config.sh"
    echo "  chmod +x post-setup-config.sh"
    echo "  ./post-setup-config.sh"
    echo ""
fi
echo "📝 FINAL RECOMMENDATIONS"
echo "========================"
echo "1. 🔄 Restart your terminal or logout/login for all changes to take effect"
echo "2. 🔑 Test your SSH key: ssh -T git@github.com"
echo "3. 📁 Your development workspace is ready at: ~/Development/"
echo "4. 📖 Check your environment info: cat ~/Development/environment-info.md"
echo "5. 🚀 Start coding! Your Ubuntu development environment is fully configured."
echo ""
echo "Log file saved to: $LOG_FILE"
echo "Configuration completed at $(date)"

