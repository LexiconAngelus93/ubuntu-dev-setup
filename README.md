# Ubuntu Development Environment Setup

🚀 **One-command setup for a complete Ubuntu development environment**

This repository contains a comprehensive script to set up a complete development environment on Ubuntu Linux, including extensive Python tools, programming languages, databases, DevOps tools, and commonly used applications.

## 🎯 Quick Start

### Option 1: Direct Download and Run
```bash
curl -fsSL https://raw.githubusercontent.com/LexiconAngelus93/ubuntu-dev-setup/main/setup.sh | bash
```

### Option 2: Clone and Run
```bash
git clone https://github.com/LexiconAngelus93/ubuntu-dev-setup.git
cd ubuntu-dev-setup
chmod +x setup.sh
./setup.sh
```

### Option 3: Essential One-Liner
For a minimal setup with just the essentials:
```bash
sudo apt update && sudo apt install -y build-essential cmake gcc g++ gdb clang git python3 python3-pip python3-dev python3-venv nodejs npm default-jdk golang-go rustc ruby php curl wget jq docker.io postgresql mysql-server redis-server sqlite3 nginx htop tmux vim neovim code && pip3 install --user jupyter pandas numpy matplotlib seaborn scikit-learn tensorflow torch flask django fastapi requests beautifulsoup4 selenium black pytest
```

### Option 4: Verify Installation
After running the setup, verify everything is working correctly:
```bash
curl -fsSL https://raw.githubusercontent.com/LexiconAngelus93/ubuntu-dev-setup/main/verify-setup.sh | bash
```

## 📦 What's Included

### 🐍 Python Ecosystem (200+ packages)
- **Data Science & ML**: NumPy, Pandas, Matplotlib, Seaborn, Plotly, Bokeh, Altair
- **Machine Learning**: Scikit-learn, TensorFlow, PyTorch, XGBoost, LightGBM, CatBoost
- **Computer Vision**: OpenCV, Pillow, scikit-image, ImageIO
- **NLP & AI**: NLTK, SpaCy, Transformers, LangChain, OpenAI, Anthropic
- **Web Frameworks**: Flask, Django, FastAPI, Streamlit, Dash, Gradio
- **Development Tools**: Black, Flake8, Pylint, MyPy, Pytest, Pre-commit
- **Documentation**: Sphinx, MkDocs
- **Performance**: Numba, Cython, Dask, Ray
- **Utilities**: Rich, Typer, Click, Pydantic, Requests, BeautifulSoup, Selenium

### 💻 Programming Languages & Runtimes
- **Python** 3.x with extensive package ecosystem
- **Node.js** with npm, yarn, pnpm
- **Java** (OpenJDK 8, 11, 17)
- **Go** with popular tools
- **Rust** with Cargo ecosystem
- **Ruby** with development tools
- **PHP** with CLI and extensions
- **R** for statistical computing
- **Scala** for JVM development
- **Lua** scripting language

### 🗄️ Databases & Data Storage
- **MySQL** server and client
- **PostgreSQL** with contrib packages
- **Redis** server and tools
- **MongoDB** and clients
- **SQLite** for lightweight databases

### ☁️ Cloud & DevOps Tools
- **Container Tools**: Docker, Docker Compose, Podman
- **Kubernetes**: kubectl, Helm
- **Cloud CLIs**: AWS CLI, Google Cloud SDK, Azure CLI
- **Infrastructure**: Terraform, Vagrant
- **Virtualization**: VirtualBox, QEMU/KVM

### 🛠️ Development Tools & IDEs
- **Text Editors**: Vim, Neovim, Emacs, Nano, Gedit
- **IDEs**: VS Code, Sublime Text, Atom, PyCharm Community, IntelliJ IDEA Community
- **Version Control**: Git, Git LFS, Git Flow, SVN, Mercurial
- **Terminal Tools**: Zsh with Oh My Zsh, Fish, Tmux, Screen
- **Modern CLI**: ripgrep, fd, bat, exa, fzf, and more

### 🌐 Web Development
- **Web Servers**: Nginx, Apache2
- **SSL/TLS**: Certbot for Let's Encrypt
- **API Testing**: Postman, Insomnia, HTTPie
- **Frontend Tools**: Complete Node.js ecosystem with React, Vue, Angular tools

### 🎨 Media & Graphics
- **Image Editing**: GIMP, Inkscape, Krita
- **3D Graphics**: Blender
- **Video**: FFmpeg, VLC, MPV, OBS Studio
- **Audio**: Audacity
- **Diagrams**: GraphViz, PlantUML, Mermaid

### 💬 Communication & Productivity
- **Communication**: Discord, Slack, Telegram, Zoom, Teams, Signal
- **Browsers**: Firefox, Chromium
- **Office Suite**: LibreOffice
- **Email**: Thunderbird
- **File Management**: FileZilla, file managers
- **Security**: KeePassXC password manager

### 🔧 System Tools & Utilities
- **Monitoring**: htop, btop, glances, iotop, iftop
- **Network**: nmap, netcat, tcpdump, Wireshark
- **File Tools**: Advanced find, compression tools, sync utilities
- **System Maintenance**: Cleaning tools, package managers

## 🚀 Features

- ✅ **Comprehensive**: 500+ packages and tools installed
- ✅ **Modern**: Latest versions of all tools and languages
- ✅ **Production Ready**: Includes databases, web servers, and deployment tools
- ✅ **Developer Friendly**: Code formatters, linters, debuggers, and IDEs
- ✅ **Data Science Ready**: Complete ML/AI toolkit with Jupyter, TensorFlow, PyTorch
- ✅ **Cloud Native**: Docker, Kubernetes, and cloud CLI tools
- ✅ **Cross-Platform**: Works on Ubuntu 20.04, 22.04, and newer
- ✅ **Safe**: Uses official repositories and trusted sources
- ✅ **Configurable**: Easy to modify for specific needs
- ✅ **Verified**: Includes verification script to check installation and fix issues

## 📋 Prerequisites

- Ubuntu 20.04 LTS or newer
- Internet connection
- Sudo privileges
- At least 10GB free disk space

## ⚙️ Post-Installation

After running the script:

1. **Logout and login** again for group changes (Docker, etc.) to take effect
2. **Update Git configuration** with your details:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
3. **Set database passwords** for MySQL and PostgreSQL if needed
4. **Configure SSH keys** for Git repositories
5. **Install additional IDEs** like IntelliJ IDEA Ultimate, PyCharm Professional if needed

## 🛠️ Customization

The script is modular and easy to customize. You can:

- Comment out sections you don't need
- Add additional packages to any section
- Modify Python package lists
- Change default configurations

## 🔧 Troubleshooting

### Verification Script

The verification script (`verify-setup.sh`) is a comprehensive tool that checks your Ubuntu development environment installation and automatically fixes common issues. It's recommended to run this script after the initial setup or periodically to maintain your development environment.

#### 🚀 How to Run

**Option 1: Direct Download and Run (Recommended)**
```bash
curl -fsSL https://raw.githubusercontent.com/LexiconAngelus93/ubuntu-dev-setup/main/verify-setup.sh | bash
```

**Option 2: Clone Repository and Run Locally**
```bash
git clone https://github.com/LexiconAngelus93/ubuntu-dev-setup.git
cd ubuntu-dev-setup
chmod +x verify-setup.sh
./verify-setup.sh
```

**Option 3: Download Script Only**
```bash
wget https://raw.githubusercontent.com/LexiconAngelus93/ubuntu-dev-setup/main/verify-setup.sh
chmod +x verify-setup.sh
./verify-setup.sh
```

#### 🔍 What the Verification Script Does

**1. Package Management Cleanup**
- Updates package lists and repositories
- Fixes broken or partially installed packages
- Configures any unconfigured packages
- Cleans package cache and removes unnecessary packages
- Removes orphaned packages

**2. Duplicate Source Detection & Removal**
- Scans `/etc/apt/sources.list` for duplicate entries
- Checks all repository files in `/etc/apt/sources.list.d/`
- Automatically removes duplicates while creating backups
- Prevents repository conflicts and update issues

**3. Essential Development Tools Verification**
- Checks for: gcc, g++, make, cmake, git, curl, wget, vim
- Verifies Python 3, pip3, Node.js, npm installations
- Automatically installs missing essential development tools
- Validates tool versions and functionality

**4. Python Environment Comprehensive Check**
- Validates Python 3 installation and version
- Ensures `python` command points to `python3`
- Upgrades pip to the latest version
- Checks essential Python packages: numpy, pandas, matplotlib, requests, flask, django
- Installs missing Python packages automatically
- Verifies virtual environment capabilities

**5. Node.js Environment Validation**
- Verifies Node.js and npm installations and versions
- Checks global npm packages: TypeScript, ESLint, Prettier
- Fixes npm permission issues and configuration
- Configures proper npm prefix to avoid sudo requirements
- Updates PATH for global npm packages

**6. Database Services Health Check**
- Verifies Docker installation and user permissions
- Checks PostgreSQL, MySQL, Redis installations
- Starts and enables database services automatically
- Adds user to docker group for container access
- Validates service configurations

**7. System Configuration Validation**
- Checks Git global configuration (user.name, user.email)
- Verifies SSH directory and key setup
- Validates shell configuration (bash, zsh, Oh My Zsh)
- Provides personalized configuration recommendations

**8. System Health Monitoring**
- Monitors disk usage and memory consumption
- Detects and reports broken symlinks
- Checks for package manager locks
- Validates system performance metrics
- Provides optimization suggestions

#### 📊 Script Output Features

- **🎨 Colored Output**: Easy-to-read status indicators
  - ✅ Green: Success/OK
  - ⚠️ Yellow: Warnings
  - ❌ Red: Errors found
  - 🔧 Blue: Fixes applied
  - ℹ️ Blue: Information

- **📝 Detailed Logging**: Complete log saved to `/tmp/ubuntu-dev-setup-verification.log`
- **📈 Progress Tracking**: Real-time counters for issues found/fixed/warnings
- **📋 Summary Report**: Comprehensive final status report
- **💡 Actionable Recommendations**: Specific next steps and improvements

#### 🕐 When to Run the Verification Script

**Recommended Times:**
- ✅ **After initial setup**: Verify everything installed correctly
- ✅ **Weekly maintenance**: Keep your environment optimized
- ✅ **Before important projects**: Ensure everything is working
- ✅ **After system updates**: Check for any broken dependencies
- ✅ **When experiencing issues**: Diagnose and fix problems automatically
- ✅ **After installing new software**: Verify no conflicts occurred

#### 🛡️ Safety Features

- **🔒 Safe Operations**: All fixes include automatic backups
- **👀 Non-Destructive**: Only fixes known safe issues
- **📋 Detailed Logging**: Complete audit trail of all actions
- **🚫 No Data Loss**: Preserves user configurations and data
- **⚡ Reversible Changes**: Backup files allow manual rollback if needed

#### 📈 Expected Results

After running the verification script, you should see:
- ✅ All essential development tools installed and working
- ✅ Clean package management with no duplicates or conflicts
- ✅ Properly configured Python and Node.js environments
- ✅ Running database services (if installed)
- ✅ Optimized system performance
- ✅ Clear recommendations for any remaining manual steps

#### 🔧 Troubleshooting the Verification Script

If the verification script encounters issues:

1. **Run with verbose output**:
   ```bash
   bash -x verify-setup.sh
   ```

2. **Check the detailed log**:
   ```bash
   cat /tmp/ubuntu-dev-setup-verification.log
   ```

3. **Run specific sections manually** if needed:
   ```bash
   # Fix package issues
   sudo apt update && sudo apt --fix-broken install -y
   
   # Clean duplicates manually
   sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
   sort /etc/apt/sources.list | uniq | sudo tee /etc/apt/sources.list.tmp
   sudo mv /etc/apt/sources.list.tmp /etc/apt/sources.list
   ```

4. **Reboot and retry** if services fail to start:
   ```bash
   sudo reboot
   # Then run verification script again
   ```

### Common Issues

**Permission denied for Docker:**
```bash
sudo usermod -aG docker $USER
# Then logout and login again
```

**Python packages not found:**
```bash
# Ensure pip is up to date
pip3 install --upgrade pip
```

**Node.js packages permission issues:**
```bash
# Configure npm to use a different directory
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## 📝 What Gets Installed

### Package Managers
- apt (system packages)
- pip3 (Python packages)
- npm/yarn/pnpm (Node.js packages)
- cargo (Rust packages)
- go install (Go packages)
- snap (Universal packages)
- flatpak (Desktop applications)

### Services Enabled
- Docker daemon
- PostgreSQL server
- MySQL server
- Redis server
- SSH server

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. Some ideas:

- Add support for other Linux distributions
- Include additional programming languages
- Add more development tools
- Improve error handling
- Add configuration options

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Star History

If this script helped you set up your development environment, please consider giving it a star!

## 🙏 Acknowledgments

- Ubuntu community for excellent package management
- All the open-source projects included in this setup
- Contributors who help improve this script

---

**Made with ❤️ for developers who want to get coding quickly!**

