# Justfile

play:
    ansible-playbook -i inventory/hosts playbooks/site.yml

check:
    ansible-playbook -i inventory/hosts playbooks/site.yml --check

lint:
    ansible-lint playbooks/

deps:
    ansible-galaxy install -r requirements.yml