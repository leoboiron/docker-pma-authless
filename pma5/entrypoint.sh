#!/bin/bash

echo "# Decoding AES key..."
echo $AES_KEY | base64 -d > /keys/aes.bin

echo "# Decoding PMA_PASSWORD..."
PMA_PASSWORD=$(echo "$PMA_PASSWORD" | base64 -d | openssl enc -aes-256-cbc -d -pass file:/keys/aes.bin)

if [ ! -z "$SSH_PASSWORD" ] && [ -z "$SSH_KEY" ]; then
    echo "# SSH tunnel with password detected"
    echo "# Decoding SSH password..."
    SSH_PASSWORD=$(echo "$SSH_PASSWORD" | base64 -d | openssl enc -aes-256-cbc -d -pass file:/keys/aes.bin)
    echo "# Removing AES key..."
    rm -f /keys/aes.bin
    echo "# Connecting to SSH..."
    sshpass -p "$SSH_PASSWORD" ssh -4 -L 3306:"$PMA_HOST":"$PMA_PORT" "$SSH_USER@$SSH_HOST" -p "$SSH_PORT" -N -o StrictHostKeyChecking=no &
    echo "# Removing SSH password..."
    unset SSH_PASSWORD
elif [ -z "$SSH_PASSWORD" ] && [ ! -z "$SSH_KEY" ]; then
    echo "# SSH tunnel with key detected"
    echo "# Decoding SSH key..."
    echo "$SSH_KEY" | base64 -d | openssl enc -aes-256-cbc -d -out /keys/private_key -pass file:/keys/aes.bin
    chmod 600 /keys/private_key
    echo "# Connecting with SSH tunnel..."
    ssh -4 -L 3306:"$PMA_HOST":"$PMA_PORT" -i /keys/private_key "$SSH_USER@$SSH_HOST" -p "$SSH_PORT" -N -o StrictHostKeyChecking=no &
    while ! netstat -tunlp 2>/dev/null | grep -q ":3306"; do sleep 1; done
    echo "# Removing SSH key..."
    rm -f /keys/private_key
fi

echo "# Removing AES key..."
rm -f /keys/aes.bin

echo "# Executing original entrypoint..."
exec /docker-entrypoint.sh "$@"
