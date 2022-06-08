# Restore Laptop with Ansible

## Usage

1. Copy your SSH public key to `roles/deploy_ssh_keys/public_keys/` (_e.g._ `foo.pub`)
1. Deploy the SSH keys:

      ```sh
      make deploy-ssh-key
      ```

1. Check the playbook

      ```sh
      make check-playbook
      ```

1. :warning: Run the playbook

      ```sh
      make configure-container
      make configure-dotfiles
      make configure-git
      make configure-nodejs
      make configure-offline
      make configure-python
      make configure-security
      make configure-shell-fish
      make configure-shell-zsh
      make configure-shells
      make configure-terminal
      make configure-tmux
      ```

## Install

You can install everything you need with:

```sh
make  # install requirements, dependencies and dev-dependencies
```

## License

[MIT][MIT]

[MIT]: https://mit-license.org/
