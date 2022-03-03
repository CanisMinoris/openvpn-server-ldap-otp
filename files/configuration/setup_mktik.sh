#!/bin/bash

sshcertificate=/etc/openvpn/mktik-cert

if [ ! -f "$sshcertificate" ]; then
        echo "Generating Certificate"
        ssh-keygen -t rsa -f $sshcertificate
        if [ -f "$sshcertificate" ];then
                echo "Certificate generated"
        else
                echo "Certificate not generated"
        fi 
fi
