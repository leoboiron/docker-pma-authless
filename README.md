# pma-aesauth - PHPMyAdmin With Automatic SSH Connection (AES-Encrypted)

## ⚠️ Security Warning
Do not deploy this image on a publicly accessible infrastructure without additional protection.
This configuration removes all authentication, meaning anyone can access your server and databases. **Use at your own risk.**

## Description
pma-aesauth is a Docker image based on PHPMyAdmin, modified to allow automatic connection to a database via SSH. Credentials are encrypted using AES encryption and Base64 encoding.
- Docker Hub: [leoboiron/pma-aesauth](https://hub.docker.com/r/leoboiron/pma-aesauth)
- GitHub: [leoboiron/docker-pma-aesauth](https://github.com/leoboiron/docker-pma-aesauth)

**Security Measures:**
- The AES key used for encrypting passwords and SSH keys must be **Base64-encoded** before being provided.
- PHPMyAdmin and SSH passwords, as well as the SSH key, must be **encrypted using this AES key** and then **Base64-encoded** before being supplied.


## Installation & Configuration

### Docker Pull Command
```bash
docker pull leoboiron/pma-aesauth:5
```

### Environment Variables
The image requires the following environment variables:

| Variable         | Description |
|-----------------|-------------|
| `AES_KEY`       | AES key used to decrypt passwords and SSH keys, **Base64-encoded**. |
| `PMA_HOST`      | MySQL server address. |
| `PMA_PORT`      | MySQL server port. |
| `PMA_USER`      | MySQL username. |
| `PMA_PASSWORD`  | MySQL password, **encrypted with AES_KEY and then Base64-encoded**. |
| `SSH_HOST`      | Remote SSH server address. |
| `SSH_PORT`      | SSH server port. |
| `SSH_USER`      | SSH username. |
| `SSH_PASSWORD`  | (Option 1) SSH password, **encrypted with AES_KEY and then Base64-encoded**. |
| `SSH_KEY`       | (Option 2) SSH private key, **encrypted with AES_KEY and then Base64-encoded**. |

Either `SSH_PASSWORD` or `SSH_KEY` is required, but not both.

### Encoding Passwords, SSH Keys, and AES Key
Before adding `AES_KEY`, `PMA_PASSWORD`, `SSH_PASSWORD`, or `SSH_KEY` to environment variables, you must:

1. **Generate a secure AES key**.
2. **Base64-encode the AES key** before supplying it to `AES_KEY`.
3. **Encrypt passwords and the SSH key using this AES key**.
4. **Base64-encode the result** before supplying it to `PMA_PASSWORD`, `SSH_PASSWORD`, or `SSH_KEY`.

⚠️ **Do not provide plaintext passwords, SSH keys, or the AES key.**

### Docker Run Command
Example of running the container with an SSH password:

```bash
docker run -d --name phpmyadmin \
  -e AES_KEY="aes_key_base64" \
  -e PMA_HOST="127.0.0.1" \
  -e PMA_PORT="3306" \
  -e PMA_USER="user" \
  -e PMA_PASSWORD="encrypted_password_base64" \
  -e SSH_HOST="192.168.1.1" \
  -e SSH_PORT="22" \
  -e SSH_USER="user" \
  -e SSH_PASSWORD="encrypted_ssh_password_base64" \
  -p 8085:80 \
  leoboiron/pma-aesauth:5
  ```
  If using an SSH key:
  ```bash
  docker run -d --name phpmyadmin \
  -e AES_KEY="aes_key_base64" \
  -e PMA_HOST="127.0.0.1" \
  -e PMA_PORT="3306" \
  -e PMA_USER="user" \
  -e PMA_PASSWORD="encrypted_password_base64" \
  -e SSH_HOST="192.168.1.1" \
  -e SSH_PORT="22" \
  -e SSH_USER="user" \
  -e SSH_KEY="encrypted_ssh_key_base64" \
  -p 8085:80 \
  leoboiron/pma-aesauth:5
```
## License

This project is licensed under the GNU GPL v3.

## Contact

For any questions or improvements, feel free to open an issue or submit a pull request.
