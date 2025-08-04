#!/bin/bash

# Enhanced Ubuntu Development Environment Setup Script
# This script installs essential packages for a complete development environment
# Including extensive Python tools and commonly used applications

echo "Starting Enhanced Ubuntu Development Environment Setup..."

# Update package lists and upgrade system
sudo apt update && sudo apt upgrade -y

# Install essential development tools and libraries
sudo apt install -y \
    build-essential \
    cmake \
    make \
    gcc \
    g++ \
    gdb \
    clang \
    clang-format \
    clang-tidy \
    lldb \
    valgrind \
    pkg-config \
    autoconf \
    automake \
    libtool \
    m4 \
    gettext \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    zlib1g-dev \
    liblzma-dev \
    libcurl4-openssl-dev

# Version control systems
sudo apt install -y \
    git \
    git-lfs \
    git-flow \
    subversion \
    mercurial \
    bzr

# Text editors and IDEs
sudo apt install -y \
    vim \
    neovim \
    emacs \
    nano \
    gedit \
    kate \
    geany

# Programming languages and runtimes
sudo apt install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    python3-setuptools \
    python3-wheel \
    python3-tk \
    python3-distutils \
    python-is-python3 \
    nodejs \
    npm \
    default-jdk \
    default-jre \
    openjdk-11-jdk \
    openjdk-17-jdk \
    golang-go \
    rustc \
    cargo \
    ruby \
    ruby-dev \
    php \
    php-cli \
    php-dev \
    php-curl \
    php-xml \
    php-mbstring \
    lua5.3 \
    perl \
    r-base \
    scala

# Databases and data tools
sudo apt install -y \
    sqlite3 \
    mysql-client \
    mysql-server \
    postgresql \
    postgresql-client \
    postgresql-contrib \
    redis-server \
    redis-tools \
    mongodb \
    mongodb-clients

# Web development tools
sudo apt install -y \
    curl \
    wget \
    httpie \
    jq \
    yq \
    xmlstarlet \
    nginx \
    apache2 \
    apache2-utils \
    certbot \
    python3-certbot-nginx

# Container and virtualization tools
sudo apt install -y \
    docker.io \
    docker-compose \
    podman \
    virtualbox \
    vagrant \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils

# Network and system tools
sudo apt install -y \
    net-tools \
    nmap \
    netcat \
    tcpdump \
    wireshark \
    iftop \
    iotop \
    htop \
    btop \
    glances \
    tree \
    fd-find \
    ripgrep \
    fzf \
    bat \
    exa \
    unzip \
    zip \
    p7zip-full \
    rar \
    unrar \
    rsync \
    rclone \
    ssh \
    openssh-server \
    tmux \
    screen \
    byobu \
    zsh \
    fish \
    neofetch \
    lolcat \
    figlet

# Media and graphics libraries
sudo apt install -y \
    imagemagick \
    ffmpeg \
    vlc \
    mpv \
    gimp \
    inkscape \
    blender \
    krita \
    graphviz \
    plantuml \
    mermaid-cli \
    audacity \
    obs-studio

# Documentation and markup tools
sudo apt install -y \
    pandoc \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    markdown \
    grip \
    hugo \
    jekyll

# Communication and productivity tools
sudo apt install -y \
    thunderbird \
    chromium-browser \
    firefox \
    libreoffice \
    calibre \
    okular \
    evince \
    filezilla \
    transmission \
    keepassxc \
    timeshift

# System monitoring and maintenance
sudo apt install -y \
    gparted \
    bleachbit \
    stacer \
    synaptic \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install snap packages
sudo apt install -y snapd

# Popular snap packages for development and productivity
sudo snap install --classic \
    code \
    sublime-text \
    atom \
    pycharm-community \
    intellij-idea-community \
    android-studio \
    flutter \
    dart \
    kotlin \
    go \
    node \
    ruby \
    dotnet-sdk

# Communication and productivity snaps
sudo snap install \
    discord \
    slack \
    telegram-desktop \
    zoom-client \
    teams \
    skype \
    notion-snap \
    obsidian \
    postman \
    insomnia \
    dbeaver-ce

# Install flatpak and applications
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Popular flatpak applications
sudo flatpak install -y flathub \
    org.signal.Signal \
    com.spotify.Client \
    org.videolan.VLC \
    org.gimp.GIMP \
    org.inkscape.Inkscape \
    org.blender.Blender \
    com.github.johnfactotum.Foliate \
    org.gnome.Calculator \
    org.gnome.Calendar

# Add user to important groups
sudo usermod -aG docker $USER
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

# Install Oh My Zsh (optional but popular)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install extensive Python packages
pip3 install --user --upgrade \
    pip \
    setuptools \
    wheel \
    virtualenv \
    virtualenvwrapper \
    pipenv \
    poetry \
    conda \
    jupyter \
    jupyterlab \
    notebook \
    ipython \
    ipykernel \
    ipywidgets \
    requests \
    urllib3 \
    beautifulsoup4 \
    scrapy \
    selenium \
    flask \
    django \
    fastapi \
    uvicorn \
    gunicorn \
    celery \
    redis \
    sqlalchemy \
    alembic \
    psycopg2-binary \
    pymongo \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    plotly \
    bokeh \
    altair \
    scipy \
    scikit-learn \
    scikit-image \
    opencv-python \
    pillow \
    imageio \
    tensorflow \
    torch \
    torchvision \
    keras \
    xgboost \
    lightgbm \
    catboost \
    statsmodels \
    sympy \
    networkx \
    nltk \
    spacy \
    gensim \
    transformers \
    datasets \
    huggingface-hub \
    openai \
    anthropic \
    langchain \
    streamlit \
    gradio \
    dash \
    voila \
    black \
    flake8 \
    pylint \
    mypy \
    pytest \
    pytest-cov \
    coverage \
    tox \
    pre-commit \
    bandit \
    safety \
    isort \
    autopep8 \
    yapf \
    docstring-parser \
    sphinx \
    mkdocs \
    pydantic \
    typer \
    click \
    rich \
    textual \
    tqdm \
    python-dotenv \
    configparser \
    pyyaml \
    toml \
    jsonschema \
    marshmallow \
    cerberus \
    schedule \
    apscheduler \
    paramiko \
    fabric \
    invoke \
    watchdog \
    psutil \
    py-cpuinfo \
    memory-profiler \
    line-profiler \
    pyinstrument \
    cython \
    numba \
    dask \
    ray \
    joblib \
    multiprocessing-logging \
    python-magic \
    python-dateutil \
    pytz \
    arrow \
    pendulum \
    faker \
    factory-boy \
    hypothesis \
    freezegun

# Install Node.js packages globally
sudo npm install -g \
    yarn \
    pnpm \
    typescript \
    ts-node \
    @types/node \
    @angular/cli \
    @vue/cli \
    create-react-app \
    next \
    nuxt \
    svelte \
    express \
    express-generator \
    koa \
    fastify \
    nest \
    nodemon \
    pm2 \
    forever \
    concurrently \
    cross-env \
    dotenv-cli \
    eslint \
    prettier \
    jshint \
    stylelint \
    sass \
    less \
    postcss-cli \
    autoprefixer \
    webpack \
    webpack-cli \
    parcel \
    rollup \
    vite \
    gulp \
    grunt \
    bower \
    browserify \
    babel-cli \
    mocha \
    jest \
    cypress \
    playwright \
    puppeteer \
    cheerio \
    axios \
    lodash \
    moment \
    dayjs \
    uuid \
    chalk \
    commander \
    inquirer \
    ora \
    boxen \
    figlet \
    cowsay \
    lolcatjs

# Install Rust packages
cargo install \
    ripgrep \
    fd-find \
    bat \
    exa \
    tokei \
    hyperfine \
    bandwhich \
    bottom \
    dust \
    procs \
    sd \
    tealdeer \
    zoxide \
    starship \
    gitui \
    delta \
    cargo-edit \
    cargo-watch \
    cargo-expand \
    cargo-outdated \
    cargo-audit \
    cargo-tree \
    cargo-bloat

# Install Go packages
go install github.com/golang/protobuf/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install github.com/cosmtrek/air@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/cmd/godoc@latest
go install golang.org/x/lint/golint@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Install additional useful tools via wget/curl
# Install Docker Compose (latest version)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Install Google Cloud SDK
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update && sudo apt install google-cloud-cli

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Configure Git (user should update with their info)
echo "Configuring Git with placeholder values (please update with your information):"
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
git config --global core.editor "vim"

# Enable and start important services
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl enable mysql
sudo systemctl start mysql
sudo systemctl enable redis-server
sudo systemctl start redis-server

# Clean up
sudo apt autoremove -y
sudo apt autoclean

echo "Enhanced Development Environment Setup Complete!"
echo ""
echo "IMPORTANT NOTES:"
echo "1. You need to logout and login again for group changes (Docker, etc.) to take effect"
echo "2. Update Git configuration with your actual name and email:"
echo "   git config --global user.name 'Your Actual Name'"
echo "   git config --global user.email 'your.actual.email@example.com'"
echo "3. Consider installing additional IDEs manually:"
echo "   - IntelliJ IDEA Ultimate"
echo "   - PyCharm Professional"
echo "   - WebStorm"
echo "   - DataGrip"
echo "4. Database passwords may need to be set for MySQL and PostgreSQL"
echo "5. Consider setting up SSH keys for Git repositories"
echo ""
echo "Installed tools include:"
echo "- Complete development toolchain (gcc, clang, make, cmake, etc.)"
echo "- Multiple programming languages (Python, Node.js, Java, Go, Rust, Ruby, PHP, R, Scala)"
echo "- Extensive Python data science and ML libraries"
echo "- Web development frameworks and tools"
echo "- Database systems (MySQL, PostgreSQL, Redis, MongoDB)"
echo "- Container tools (Docker, Podman)"
echo "- Cloud CLI tools (AWS, GCP, Azure)"
echo "- DevOps tools (Kubernetes, Helm, Terraform)"
echo "- Text editors and IDEs"
echo "- Media and graphics tools"
echo "- Communication and productivity applications"
echo "- System monitoring and maintenance tools"

