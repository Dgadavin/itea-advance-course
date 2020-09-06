# Ansible

## Install Ansible with python
```bash
easy_install pip
pip install ansible
```

## Setup inventory file

```bash
touch ansible_examples/hosts
Put such content
[stage]
<ip-of-ansible-test-machine>
[local]
localhost
```

##Ad-hoc commands

```bash
ansible --key-file /home/ec2-user/<key-name> stage -m ping -u ec2-user -i hosts
ansible --key-file /home/ec2-user/<key-name> stage -m setup -u ec2-user -i hosts
ansible --key-file /home/ec2-user/<key-name> stage -m shell -a 'uname -a' -u ec2-user -i hosts
ansible --key-file /home/ec2-user/<key-name> stage -m copy -a 'src=/etc/motd dest=/tmp/' -u ec2-user -i hosts
```

## Setup ssh keys

```bash
ansible-playbook playbook.yaml -i hosts --private-key /home/ec2-user/<key-name> -u ec2-user --check -t ssh --diff # Check and shows diif wthout actuall setup
ansible-playbook playbook.yaml -i hosts --private-key /home/ec2-user/<key-name> -u ec2-user -t ssh # Setup keys
```

## Use ansible galaxy to install haproxy

```bash
cd devopsology-base-course/ansibe_examples
ansible-galaxy install geerlingguy.haproxy --roles-path roles/
ansible-playbook haproxy.yml -i hosts --private-key /home/ec2-user/<key-name> -u ec2-user
```

## Use ansible vault

```bash
ansible-vault create new_secret.yml # create vault file with secret content
ansible-vault edit new_secret.yml # edit secret file
ansible-playbook playbook.yaml -i hosts --private-key /home/ec2-user/<key-name> -u ec2-user --ask-vault-pass -t configs --diff
```
