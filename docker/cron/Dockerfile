FROM alpine:latest

# Installer `crond`, `kubectl`, `bash` et autres utilitaires
RUN apk add --no-cache bash curl jq openrc \
    && apk add --no-cache docker-cli \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl && mv kubectl /usr/local/bin/ \
    && apk add nodejs
    # && apk add npm \
    # && npm install -g crontab-ui


# Ajouter un fichier crontab de test
COPY crontab /etc/crontabs/root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN /usr/sbin/crond

# Lancer cron en foreground
# CMD ["/usr/sbin/crond", "-f", "-l", "2"]
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
