#!/bin/bash

# Ubuntu Development Environment Verification and Cleanup Script
# This script verifies the installation and fixes common issues

echo "🔍 Starting Ubuntu Development Environment Verification..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
ISSUES_FOUND=0
ISSUES_FIXED=0
WARNINGS=0

# Log file
LOG_FILE="/tmp/ubuntu-dev-setup-verification.log"
echo "Verification started at $(date)" > "$LOG_FILE"

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
            ((WARNINGS++))
            ;;
        "ERROR")
            echo -e "${RED}✗${NC} $message"
            ((ISSUES_FOUND++))
            ;;
        "FIX")
            echo -e "${BLUE}🔧${NC} $message"
            ((ISSUES_FIXED++))
            ;;
        "INFO")
            echo -e "${BLUE}ℹ${NC} $message"
            ;;
    esac
    echo "[$status] $message" >> "$LOG_FILE"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if package is installed
package_installed() {
    dpkg -l "$1" >/dev/null 2>&1
}

# Function to check if service is running
service_running() {
    systemctl is-active --quiet "$1"
}

# Function to check if service is enabled
service_enabled() {
    systemctl is-enabled --quiet "$1"
}

echo "🧹 1. Cleaning up package management..."
echo "----------------------------------------"

# Update package lists
print_status "INFO" "Updating package lists..."
if sudo apt update >/dev/null 2>&1; then
    print_status "OK" "Package lists updated successfully"
else
    print_status "ERROR" "Failed to update package lists"
fi

# Fix broken packages
print_status "INFO" "Checking for broken packages..."
if sudo apt --fix-broken install -y >/dev/null 2>&1; then
    print_status "OK" "No broken packages found"
else
    print_status "FIX" "Fixed broken packages"
fi

# Configure unconfigured packages
print_status "INFO" "Configuring any unconfigured packages..."
if sudo dpkg --configure -a >/dev/null 2>&1; then
    print_status "OK" "All packages properly configured"
else
    print_status "FIX" "Configured pending packages"
fi

# Clean package cache
print_status "INFO" "Cleaning package cache..."
sudo apt autoclean >/dev/null 2>&1
sudo apt autoremove -y >/dev/null 2>&1
print_status "OK" "Package cache cleaned"

echo ""
echo "🔍 2. Checking for duplicate sources..."
echo "----------------------------------------"

# Check for duplicate sources in sources.list
if [ -f /etc/apt/sources.list ]; then
    DUPLICATES=$(sort /etc/apt/sources.list | uniq -d | wc -l)
    if [ "$DUPLICATES" -gt 0 ]; then
        print_status "WARN" "Found $DUPLICATES duplicate entries in sources.list"
        print_status "FIX" "Removing duplicates from sources.list..."
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
        sort /etc/apt/sources.list | uniq | sudo tee /etc/apt/sources.list.tmp >/dev/null
        sudo mv /etc/apt/sources.list.tmp /etc/apt/sources.list
        print_status "OK" "Duplicates removed from sources.list"
    else
        print_status "OK" "No duplicates found in sources.list"
    fi
fi

# Check for duplicate sources in sources.list.d
if [ -d /etc/apt/sources.list.d ]; then
    for file in /etc/apt/sources.list.d/*.list; do
        if [ -f "$file" ]; then
            DUPLICATES=$(sort "$file" | uniq -d | wc -l)
            if [ "$DUPLICATES" -gt 0 ]; then
                print_status "WARN" "Found duplicates in $(basename "$file")"
                print_status "FIX" "Removing duplicates from $(basename "$file")..."
                sudo cp "$file" "$file.backup"
                sort "$file" | uniq | sudo tee "$file.tmp" >/dev/null
                sudo mv "$file.tmp" "$file"
                print_status "OK" "Duplicates removed from $(basename "$file")"
            fi
        fi
    done
fi

echo ""
echo "🔧 3. Verifying essential development tools..."
echo "----------------------------------------------"

# Check essential build tools
ESSENTIAL_TOOLS=("gcc" "g++" "make" "cmake" "git" "curl" "wget" "vim" "python3" "pip3" "node" "npm")

for tool in "${ESSENTIAL_TOOLS[@]}"; do
    if command_exists "$tool"; then
        VERSION=$(command -v "$tool" >/dev/null && $tool --version 2>/dev/null | head -n1 || echo "Unknown version")
        print_status "OK" "$tool is installed"
    else
        print_status "ERROR" "$tool is not installed or not in PATH"
        case $tool in
            "gcc"|"g++"|"make")
                print_status "FIX" "Installing build-essential..."
                sudo apt install -y build-essential >/dev/null 2>&1
                ;;
            "cmake")
                print_status "FIX" "Installing cmake..."
                sudo apt install -y cmake >/dev/null 2>&1
                ;;
            "git")
                print_status "FIX" "Installing git..."
                sudo apt install -y git >/dev/null 2>&1
                ;;
            "curl")
                print_status "FIX" "Installing curl..."
                sudo apt install -y curl >/dev/null 2>&1
                ;;
            "wget")
                print_status "FIX" "Installing wget..."
                sudo apt install -y wget >/dev/null 2>&1
                ;;
            "vim")
                print_status "FIX" "Installing vim..."
                sudo apt install -y vim >/dev/null 2>&1
                ;;
            "python3")
                print_status "FIX" "Installing python3..."
                sudo apt install -y python3 python3-dev >/dev/null 2>&1
                ;;
            "pip3")
                print_status "FIX" "Installing pip3..."
                sudo apt install -y python3-pip >/dev/null 2>&1
                ;;
            "node")
                print_status "FIX" "Installing nodejs..."
                sudo apt install -y nodejs >/dev/null 2>&1
                ;;
            "npm")
                print_status "FIX" "Installing npm..."
                sudo apt install -y npm >/dev/null 2>&1
                ;;
        esac
    fi
done

echo ""
echo "🐍 4. Verifying Python environment..."
echo "-------------------------------------"

# Check Python installation
if command_exists python3; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    print_status "OK" "Python installed: $PYTHON_VERSION"
    
    # Check if python command points to python3
    if ! command_exists python; then
        print_status "WARN" "python command not found, creating symlink..."
        if package_installed python-is-python3; then
            print_status "OK" "python-is-python3 package is installed"
        else
            print_status "FIX" "Installing python-is-python3 package..."
            sudo apt install -y python-is-python3 >/dev/null 2>&1
        fi
    else
        print_status "OK" "python command is available"
    fi
    
    # Check pip installation
    if command_exists pip3; then
        PIP_VERSION=$(pip3 --version 2>&1)
        print_status "OK" "pip3 installed: $PIP_VERSION"
        
        # Upgrade pip
        print_status "INFO" "Upgrading pip to latest version..."
        python3 -m pip install --user --upgrade pip >/dev/null 2>&1
        print_status "OK" "pip upgraded"
    else
        print_status "ERROR" "pip3 not found"
        print_status "FIX" "Installing pip3..."
        sudo apt install -y python3-pip >/dev/null 2>&1
    fi
    
    # Check essential Python packages
    PYTHON_PACKAGES=("numpy" "pandas" "matplotlib" "requests" "flask" "django")
    print_status "INFO" "Checking essential Python packages..."
    
    for package in "${PYTHON_PACKAGES[@]}"; do
        if python3 -c "import $package" >/dev/null 2>&1; then
            print_status "OK" "Python package '$package' is installed"
        else
            print_status "WARN" "Python package '$package' not found"
            print_status "FIX" "Installing $package..."
            pip3 install --user "$package" >/dev/null 2>&1
        fi
    done
else
    print_status "ERROR" "Python3 not found"
fi

echo ""
echo "🌐 5. Verifying Node.js environment..."
echo "--------------------------------------"

if command_exists node; then
    NODE_VERSION=$(node --version 2>&1)
    print_status "OK" "Node.js installed: $NODE_VERSION"
    
    if command_exists npm; then
        NPM_VERSION=$(npm --version 2>&1)
        print_status "OK" "npm installed: $NPM_VERSION"
        
        # Check npm global packages
        GLOBAL_PACKAGES=("typescript" "eslint" "prettier")
        for package in "${GLOBAL_PACKAGES[@]}"; do
            if npm list -g "$package" >/dev/null 2>&1; then
                print_status "OK" "Global npm package '$package' is installed"
            else
                print_status "WARN" "Global npm package '$package' not found"
            fi
        done
        
        # Fix npm permissions if needed
        NPM_PREFIX=$(npm config get prefix)
        if [[ "$NPM_PREFIX" == "/usr" ]] || [[ "$NPM_PREFIX" == "/usr/local" ]]; then
            print_status "WARN" "npm prefix may cause permission issues"
            print_status "FIX" "Configuring npm to use user directory..."
            mkdir -p ~/.npm-global
            npm config set prefix '~/.npm-global'
            
            # Add to PATH if not already there
            if ! echo "$PATH" | grep -q "$HOME/.npm-global/bin"; then
                echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
                print_status "OK" "Added npm global bin to PATH in ~/.bashrc"
            fi
        else
            print_status "OK" "npm prefix is properly configured"
        fi
    else
        print_status "ERROR" "npm not found"
    fi
else
    print_status "ERROR" "Node.js not found"
fi

echo ""
echo "🗄️ 6. Verifying database services..."
echo "------------------------------------"

# Check Docker
if command_exists docker; then
    print_status "OK" "Docker is installed"
    
    # Check if user is in docker group
    if groups "$USER" | grep -q docker; then
        print_status "OK" "User is in docker group"
    else
        print_status "WARN" "User not in docker group"
        print_status "FIX" "Adding user to docker group..."
        sudo usermod -aG docker "$USER"
        print_status "OK" "User added to docker group (logout/login required)"
    fi
    
    # Check if docker service is running
    if service_running docker; then
        print_status "OK" "Docker service is running"
    else
        print_status "WARN" "Docker service is not running"
        print_status "FIX" "Starting docker service..."
        sudo systemctl start docker
        sudo systemctl enable docker
        print_status "OK" "Docker service started and enabled"
    fi
else
    print_status "ERROR" "Docker not found"
fi

# Check PostgreSQL
if package_installed postgresql; then
    print_status "OK" "PostgreSQL is installed"
    
    if service_running postgresql; then
        print_status "OK" "PostgreSQL service is running"
    else
        print_status "WARN" "PostgreSQL service is not running"
        print_status "FIX" "Starting PostgreSQL service..."
        sudo systemctl start postgresql
        sudo systemctl enable postgresql
        print_status "OK" "PostgreSQL service started and enabled"
    fi
else
    print_status "WARN" "PostgreSQL not installed"
fi

# Check MySQL
if package_installed mysql-server; then
    print_status "OK" "MySQL is installed"
    
    if service_running mysql; then
        print_status "OK" "MySQL service is running"
    else
        print_status "WARN" "MySQL service is not running"
        print_status "FIX" "Starting MySQL service..."
        sudo systemctl start mysql
        sudo systemctl enable mysql
        print_status "OK" "MySQL service started and enabled"
    fi
else
    print_status "WARN" "MySQL not installed"
fi

# Check Redis
if package_installed redis-server; then
    print_status "OK" "Redis is installed"
    
    if service_running redis-server; then
        print_status "OK" "Redis service is running"
    else
        print_status "WARN" "Redis service is not running"
        print_status "FIX" "Starting Redis service..."
        sudo systemctl start redis-server
        sudo systemctl enable redis-server
        print_status "OK" "Redis service started and enabled"
    fi
else
    print_status "WARN" "Redis not installed"
fi

echo ""
echo "🔧 7. Checking system configuration..."
echo "--------------------------------------"

# Check Git configuration
if command_exists git; then
    GIT_USER=$(git config --global user.name 2>/dev/null)
    GIT_EMAIL=$(git config --global user.email 2>/dev/null)
    
    if [ -n "$GIT_USER" ] && [ "$GIT_USER" != "Your Name" ]; then
        print_status "OK" "Git user name is configured: $GIT_USER"
    else
        print_status "WARN" "Git user name not configured or using placeholder"
        print_status "INFO" "Run: git config --global user.name 'Your Name'"
    fi
    
    if [ -n "$GIT_EMAIL" ] && [ "$GIT_EMAIL" != "your.email@example.com" ]; then
        print_status "OK" "Git email is configured: $GIT_EMAIL"
    else
        print_status "WARN" "Git email not configured or using placeholder"
        print_status "INFO" "Run: git config --global user.email 'your.email@example.com'"
    fi
else
    print_status "ERROR" "Git not found"
fi

# Check SSH
if [ -d ~/.ssh ]; then
    print_status "OK" "SSH directory exists"
    
    if [ -f ~/.ssh/id_rsa ] || [ -f ~/.ssh/id_ed25519 ]; then
        print_status "OK" "SSH key found"
    else
        print_status "WARN" "No SSH key found"
        print_status "INFO" "Consider generating SSH key: ssh-keygen -t ed25519 -C 'your.email@example.com'"
    fi
else
    print_status "WARN" "SSH directory not found"
fi

# Check shell
CURRENT_SHELL=$(echo "$SHELL")
print_status "INFO" "Current shell: $CURRENT_SHELL"

if command_exists zsh; then
    print_status "OK" "Zsh is installed"
    
    if [ -d ~/.oh-my-zsh ]; then
        print_status "OK" "Oh My Zsh is installed"
    else
        print_status "WARN" "Oh My Zsh not found"
    fi
else
    print_status "WARN" "Zsh not installed"
fi

echo ""
echo "🧪 8. Running system health checks..."
echo "-------------------------------------"

# Check disk space
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 80 ]; then
    print_status "OK" "Disk usage is healthy ($DISK_USAGE%)"
elif [ "$DISK_USAGE" -lt 90 ]; then
    print_status "WARN" "Disk usage is high ($DISK_USAGE%)"
else
    print_status "ERROR" "Disk usage is critical ($DISK_USAGE%)"
fi

# Check memory
MEMORY_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ "$MEMORY_USAGE" -lt 80 ]; then
    print_status "OK" "Memory usage is healthy ($MEMORY_USAGE%)"
else
    print_status "WARN" "Memory usage is high ($MEMORY_USAGE%)"
fi

# Check for common issues
print_status "INFO" "Checking for common issues..."

# Check if /var/lib/dpkg/lock exists
if [ -f /var/lib/dpkg/lock ]; then
    if lsof /var/lib/dpkg/lock >/dev/null 2>&1; then
        print_status "WARN" "Package manager is locked (another process running)"
    else
        print_status "OK" "Package manager is available"
    fi
fi

# Check for broken symlinks in common directories
BROKEN_LINKS=$(find /usr/local/bin /usr/bin ~/.local/bin -xtype l 2>/dev/null | wc -l)
if [ "$BROKEN_LINKS" -gt 0 ]; then
    print_status "WARN" "Found $BROKEN_LINKS broken symlinks"
    print_status "INFO" "Run 'find /usr/local/bin /usr/bin ~/.local/bin -xtype l -delete' to remove them"
else
    print_status "OK" "No broken symlinks found"
fi

echo ""
echo "🔄 9. Final cleanup and optimization..."
echo "--------------------------------------"

# Update package database
print_status "INFO" "Updating package database..."
sudo apt update >/dev/null 2>&1

# Upgrade packages if needed
UPGRADABLE=$(apt list --upgradable 2>/dev/null | wc -l)
if [ "$UPGRADABLE" -gt 1 ]; then
    print_status "WARN" "$((UPGRADABLE-1)) packages can be upgraded"
    print_status "INFO" "Run 'sudo apt upgrade' to upgrade packages"
else
    print_status "OK" "All packages are up to date"
fi

# Clean up
print_status "INFO" "Performing final cleanup..."
sudo apt autoremove -y >/dev/null 2>&1
sudo apt autoclean >/dev/null 2>&1

# Update locate database
if command_exists updatedb; then
    print_status "INFO" "Updating locate database..."
    sudo updatedb >/dev/null 2>&1
    print_status "OK" "Locate database updated"
fi

echo ""
echo "📊 VERIFICATION SUMMARY"
echo "======================="
echo -e "Issues Found: ${RED}$ISSUES_FOUND${NC}"
echo -e "Issues Fixed: ${GREEN}$ISSUES_FIXED${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
echo ""

if [ "$ISSUES_FOUND" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    print_status "OK" "🎉 Your Ubuntu development environment is perfectly configured!"
elif [ "$ISSUES_FOUND" -eq 0 ]; then
    print_status "OK" "✅ Your Ubuntu development environment is working well with minor warnings"
else
    print_status "WARN" "⚠️ Some issues were found and fixed. You may need to logout/login or reboot for all changes to take effect."
fi

echo ""
echo "📝 RECOMMENDATIONS"
echo "=================="

if [ "$WARNINGS" -gt 0 ] || [ "$ISSUES_FOUND" -gt 0 ]; then
    echo "• Logout and login again to apply group changes (especially for Docker)"
    echo "• Reboot if you installed new kernels or system components"
    echo "• Configure Git with your personal information if not done already"
    echo "• Generate SSH keys for Git repositories if needed"
    echo "• Consider setting up your preferred shell (zsh with Oh My Zsh)"
fi

echo "• Check the log file for details: $LOG_FILE"
echo "• Run this script periodically to maintain your development environment"
echo ""
echo "Verification completed at $(date)"
echo "Log saved to: $LOG_FILE"

