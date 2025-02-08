# Utilisez une image de base légère
FROM debian:bullseye-slim

# Installez les dépendances nécessaires
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Installez code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# host name
ENV HOSTNAME code-server

# give a name to the container
ENV NAME code-server



# create a new user for code-server
RUN useradd -ms /bin/bash code-server

# change the owner of the home directory to code-server
RUN chown -R code-server:code-server /home/code-server


RUN mkdir /code-server
RUN chmod -R 700 /code-server
RUN chown -R code-server:code-server /code-server

# set user shell
# RUN chsh -s /bin/false code-server


WORKDIR /code-server
USER code-server

EXPOSE 7780

# CMD ["code-server", "/code-server", "--auth", "none", "--port", "7780", "--host", "0.0.0.0"]
CMD ["code-server", "/var/www/html", "--port", "7780", "--host", "0.0.0.0"]


# build: docker build -t code-server .
# run: docker run -it --rm -p 8080:8080 code-server