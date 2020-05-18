#!/bin/bash
umask 077

echo "installing Postfix" 
apt-get update && apt-get install postfix libsasl2-modules -y
echo "End installation of postfix"
sleep 1
apt-get update 
sleep 2
echo "step 4"
sed -i 's/default_transport = error/# default_transport = error/g' /etc/postfix/main.cf
sed -i 's/relay_transport = error/# relay_transport = error/g' /etc/postfix/main.cf

cat << EOF >> /etc/postfix/main.cf
relayhost = [smtp.sendgrid.net]:2525
smtp_tls_security_level = encrypt
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
header_size_limit = 4096000
smtp_sasl_security_options = noanonymous
EOF

echo "step 5" 
sleep 1 
#Paste your API key after the API=
API=
echo [smtp.sendgrid.net]:2525 apikey:$API >> /etc/postfix/sasl_passwd

postmap /etc/postfix/sasl_passwd

echo "step 9"
ls -l /etc/postfix/sasl_passwd*
 
echo "step 10"
rm /etc/postfix/sasl_passwd

echo "step 11" 
chmod 600 /etc/postfix/sasl_passwd.db
ls -la /etc/postfix/sasl_passwd.db

echo "step 12 reloading postfix"
/etc/init.d/postfix restart

echo "Installing mailutils or mailx package"

apt-get install mailutils -y

