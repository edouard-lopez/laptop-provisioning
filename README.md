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

1. Create an **insecure file** to hold your vault password:

      ```sh
      touch .secret.txt && chmod u=rw,go= .secret.txt
      $EDITOR .secret.txt # add your vault password
      ```

2. Create a vault to hold your `sudo` password

      ```sh
      ansible-vault encrypt_string \
            --vault-password-file=.secret.txt \
            --stdin-name 'ansible_sudo_pass' \
            --output .secret.yml
      ```

3. Run the playbook

      ```sh
      poetry shell
      # specific tag(s)
      make configure TAGS="foo,bar"

      # Top-level tags for roles
      make configure-<TAB>
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
