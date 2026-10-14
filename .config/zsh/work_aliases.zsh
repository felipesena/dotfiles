#JAVA
alias use-jdk8="sdk use java 8.0.412-zulu"
alias use-jdk11="sdk use java 11.0.32-tem"
alias use-jdk17="sdk use java 17.0.20-tem"
alias use-jdk21="sdk use java 21-tem"
alias use-jdk25="sdk use java 25.0.4-tem"

alias use-graalvm="sdk use java 22.1.0.r17-grl"

#Sops
alias sops-staging="AWS_SDK_LOAD_CONFIG=1 sops -i"
alias sops-prod="AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=vulcano sops -i"

# Database token
alias marketplace-db-token="hotctl vault database --address https://vault.vulcano.hotmart.com --engine mysql --name marketplace --role read"
alias hotpay-db-token="hotctl vault database --address https://vault.hp.hotmart.com --engine mysql --name hotpay --role read"
alias payment-db-token="hotctl vault database --address https://vault.hp.hotmart.com --engine mysql --name payments-micro-services --role read"
alias subscription-db-token="hotctl vault database --address https://vault.hp.hotmart.com --engine mysql --name subscription --role read"

#WildFly Configuration
alias use-staging-database="cp ~/wildfly-9.0.2.Final/standalone/configuration/standalone.xml.staging ~/wildfly-9.0.2.Final/standalone/configuration/standalone.xml"
alias use-local-database="cp ~/wildfly-9.0.2.Final/standalone/configuration/standalone.xml.local ~/wildfly-9.0.2.Final/standalone/configuration/standalone.xml"

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
