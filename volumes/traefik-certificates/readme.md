Traefik certificates are stored in this volume. This volume is mounted to the Traefik container at `/certificates`.

An "acme.json" file is stored in this volume. This file contains the ACME certificates that Traefik has obtained from Let's Encrypt. This file is used to persist the certificates across container restarts.

Warning permissions on acme.json must be set to 600. This is because the file contains sensitive information such as private keys. If the permissions are not set correctly, Traefik will not start.

