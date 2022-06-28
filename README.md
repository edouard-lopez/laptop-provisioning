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
      poetry shell
      ansible-playbook localhost.yml --tags "login"  # task-level tag

      # Top-level tags for roles
      ansible-playbook localhost.yml --tags "code-ide"
      ansible-playbook localhost.yml --tags "container"
      ansible-playbook localhost.yml --tags "dotfiles"
      ansible-playbook localhost.yml --tags "git"
      ansible-playbook localhost.yml --tags "infra"
      ansible-playbook localhost.yml --tags "nodejs"
      ansible-playbook localhost.yml --tags "offline"
      ansible-playbook localhost.yml --tags "python"
      ansible-playbook localhost.yml --tags "security"
      ansible-playbook localhost.yml --tags "shell-fish"
      ansible-playbook localhost.yml --tags "shell-zsh"
      ansible-playbook localhost.yml --tags "shells"
      ansible-playbook localhost.yml --tags "terminal"
      ansible-playbook localhost.yml --tags "tmux"
      ```

## Install

You can install everything you need with:

```sh
make  # install requirements, dependencies and dev-dependencies
```

## Debug a Task

Register your task's output with:

```diff
 - name: Foo
       shell: echo bar
+      register: result
```

Then add a debug task after:

```diff
+- name: Print return information from the previous task
+  ansible.builtin.debug:
+    var: result
```

## License

[MIT][MIT]

[MIT]: https://mit-license.org/
