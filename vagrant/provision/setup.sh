#!/bin/bash

application_name="earthlings"
postgres_password="CHOOSE A SECURE DB PASSWORD"
safeuser_username="safeuser"
safeuser_password="CHOOSE A SECURE USER PASSWORD"
source_dir="/home/$safeuser_username/$application_name"

pwd

echo "Provisioning virtual machine..."
sudo apt-get update -y > /dev/null

# Create a safe user with a home director
echo "Add safe user"
useradd -s /bin/bash -m -d /home/$safeuser_username -c "safe user" $safeuser_username
echo "$safeuser_username:$safeuser_password" | chpasswd # give the user the specified password
usermod -aG sudo $safeuser_username # Add safe user to the sudo group

# Git
echo "Installing Git and Curl"
sudo apt-get install git curl -y > /dev/null


# Nginx
echo "Installing Nginx"
sudo apt-get install nginx -y > /dev/null


# Node
echo "Installing Node"
# Add the official node repo
curl -sL https://deb.nodesource.com/setup | sudo bash - > /dev/null
sudo apt-get install nodejs -y > /dev/null


# Dependent global npm installs
echo "Installing pm2"
sudo npm install -g pm2


# Postgres 9.3
echo "Installing Postgres"
# Add the official postgres repo
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - > /dev/null
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" \
	>> /etc/apt/sources.list.d/postgresql.list'
sudo apt-get update -y > /dev/null

# Get the packages
sudo apt-get install postgresql-9.3 libpq-dev postgresql-server-dev-9.3 -y > /dev/null


# Postgres Configuration
echo "Configuring Postgres"
# Set the password to the config value
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password '$postgres_password';" > /dev/null

# All access the postgresql DB from remote sources
sudo sed -i "s/127.0.0.1\\/32/0.0.0.0\\/0/g" /etc/postgresql/9.3/main/pg_hba.conf
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.3/main/postgresql.conf

# Restart after changes
sudo service postgresql restart > /dev/null


# Nginx Configuration
echo "Configuring Nginx"
sudo cp /vagrant/provision/config/demo.conf /etc/nginx/sites-available/demo.conf > /dev/null
sudo ln -s /etc/nginx/sites-available/demo.conf /etc/nginx/sites-enabled/
sudo rm -rf /etc/nginx/sites-available/default

# Restart Nginx for the config to take effect
sudo service nginx restart > /dev/null


# Checkout the code to this machine.
git clone git@github.com:jthoms1/techtalk-2014-dec.git $source_dir


# Node App Configuration
echo "Configuring and starting Node app."
sudo -H -u $safeuser_username bash -c 'pm2 start $source_dir/app/server.js --name "$application_name" -i 0'
sudo pm2 startup ubuntu -u $safeuser_username
sudo -H -u $safeuser_username bash -c 'pm2 save'

echo "Finished provisioning."

