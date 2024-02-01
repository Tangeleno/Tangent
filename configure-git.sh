#!/bin/bash

# Wait until the SSH key file is available
while [ ! -f /root/.ssh/id_ed25519 ]; do
    sleep 1
done

# Set proper permissions for the RSA key
chmod 600 /root/.ssh/id_ed25519

#ssh-add /root/.ssh/id_rsa

# Configure Git to use the RSA key
git config --global core.sshCommand "ssh -i /root/.ssh/id_ed25519"

# Run the main command passed to the Docker container
exec "$@"
