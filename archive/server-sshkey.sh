#!/usr/bin/env bash

# to generate key
# ssh-keygen -t rsa

# for openssh, we may need to edit /etc/ssh/sshd_config
#     AuthorizedKeysFile    %h/.ssh/authorized_keys
#     PubkeyAcceptedKeyTypes=+ssh-dss


servers=(phall poisson)

for server in ${servers[@]}; do
    ssh $server "
    mkdir -p .ssh
    chmod 700 .ssh
    touch .ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
    cat >> .ssh/authorized_keys" <<< `cat ~/.ssh/id_rsa.pub`
done
