#!/bin/bash

postgres_password="REJ#%*OfdaklJ*O4t5eH"

echo "Provisioning virtual machine..."
sudo apt-get update -y > /dev/null

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


# Postgres 9.3
echo "Installing Postgres"
# Add the official postgres repo
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - > /dev/null
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" \
	>> /etc/apt/sources.list.d/postgresql.list'
sudo apt-get update -y > /dev/null

# Get the packages
sudo apt-get install postgresql-9.3 libpq-dev postgresql-server-dev-9.3 -y > /dev/null

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

echo "Finished provisioning."

