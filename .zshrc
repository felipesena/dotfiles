# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git 
    kubectl
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='vim'

# POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
# POWERLEVEL9K_STATUS_SHOW_PIPESTATUS=true
# POWERLEVEL9K_STATUS_HIDE_SIGNAME=true
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status root_indicator background_jobs time virtualenv dir virtualenv vcs terraform anaconda)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
# POWERLEVEL9K_SHORTEN_DELIMITER=""
# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
# POWERLEVEL9K_INSTANT_PROMPT=off

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

#JAVA
alias use-jdk8="sdk use java 8.0.412-zulu"
alias use-jdk11="sdk use java 11.0.23-tem"
alias use-jdk17="sdk use java 17.0.7-tem"
alias use-jdk21="sdk use java 21-tem"
alias use-jdk24="sdk use java 24.0.2-tem"
alias use-jdk25="sdk use java 25.0.1-tem"

alias use-graalvm="sdk use java 22.1.0.r17-grl"

#Sops
alias sops-staging="AWS_SDK_LOAD_CONFIG=1 sops -i"
alias sops-prod="AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=vulcano sops -i"

# Database token
alias marketplace-db-token="hotctl vault database --address https://vault.vulcano.hotmart.com --engine mysql --name marketplace --role read"
alias hotpay-db-token="hotctl vault database --address https://vault.hp.hotmart.com --engine mysql --name hotpay --role read"
alias payment-db-token="hotctl vault database --address https://vault.hp.hotmart.com --engine mysql --name payments-micro-services --role read"
alias subscription-db-token="hotctl vault database --address https://vault.hp.hotmart.com --engine mysql --name subscription --role read"

#Liquibase execution
alias marketplace-liquibase="mvn clean install -DskipTests -U && mvn liquibase:update -Dliquibase.datasource.url='jdbc:mysql://localhost/marketplace?useSSL=false' -Dliquibase.datasource.user=root -Dliquibase.datasource.password=admin -Dliquibase.contexts=staging"
alias hotpay-liquibase="mvn clean install -DskipTests -U && mvn liquibase:update -Dliquibase.datasource.url='jdbc:mysql://localhost/hotpay?useSSL=false' -Dliquibase.datasource.user=root -Dliquibase.datasource.password=admin -Dliquibase.contexts=staging"
alias subscription-liquibase="mvn clean install -DskipTests -U && mvn liquibase:update -Dliquibase.datasource.url='jdbc:mysql://localhost/subscription?useSSL=false' -Dliquibase.datasource.user=root -Dliquibase.datasource.password=admin -Dliquibase.contexts=staging"

#WildFly Configuration
alias use-staging-database="cp ~/wildfly-9.0.2.Final/standalone/configuration/standalone.xml.staging ~/wildfly-9.0.2.Final/standalone/configuration/standalone.xml"
alias use-local-database="cp ~/wildfly-9.0.2.Final/standalone/configuration/standalone.xml.local ~/wildfly-9.0.2.Final/standalone/configuration/standalone.xml"

alias reset-db="docker exec -i mysql-container mysql -u root -padmin < ~/Documents/Hotmart/hotpay/hotpay-tests/hotpay-tests-api/src/main/resources/reset-db.sql"

#Hotctl
alias codeartifact-token="hotctl codeartifact token --profile buildstaging --role Developers"
alias getAWSCredentials="~/Developer/Hotmart/scripts/get_aws_credentials.sh"
alias daily-updates="~/Developer/Hotmart/scripts/daily_updates.sh"

#Kubernetes context
alias use-hotpay-context="hotctl eks context --profile hotpay"
alias use-vulcano-context="hotctl eks context --profile vulcano -r Vulcano-Devops"
alias use-staging-context="hotctl eks context --profile buildstaging -r Developers"
alias use-saas-context="hotctl eks context --profile saas-solutions -r Hotpro-DevOPS"
alias use-analytics-context="hotctl eks context --profile analytics -r Analytics-DataDelivery"

alias pmd="~/pmd-bin-6.50.0/bin/run.sh pmd"
alias decrypt='f() { echo $(aws kms decrypt --region us-east-1 --profile analytics --ciphertext-blob $1 | jq ".Plaintext" | tr -d "\"" | base64 --decode) };f'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/felipe.sena/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export PATH="/Users/felipe.sena/Developer/Hotmart/reports/api-report-vulcano:$PATH"

# Kiro CLI post block. Keep at the bottom of this file.
# [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# [[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# --- Yazi Setup ---
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# --- Eza Setup ---
alias ls="eza --color always --icons always --git -l --no-time --no-user --no-permissions --no-filesize -a"
