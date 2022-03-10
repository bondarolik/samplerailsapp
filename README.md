# README

## Install Node & Yarn

```
# Adding Node.js repository
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

# Adding Yarn repository
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo add-apt-repository ppa:chris-lea/redis-server

# Refresh our packages list with the new repositories
sudo apt-get update

# Install our dependencies for compiiling Ruby along with Node.js and Yarn
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev dirmngr gnupg apt-transport-https ca-certificates redis-server redis-tools nodejs yarn
```

## Add Rbenv to VPS

```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

echo 'eval "$(rbenv init -)"' >> ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars

exec $SHELL
```

## Install Nginx & Passenger

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main > /etc/apt/sources.list.d/passenger.list'

sudo apt-get update

sudo apt-get install -y nginx-extras libnginx-mod-http-passenger

if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi

sudo ls /etc/nginx/conf.d/mod-http-passenger.conf

sudo nano /etc/nginx/conf.d/mod-http-passenger.conf

# Paste ruby path 
passenger_ruby /home/deploy/.rbenv/shims/ruby;

# Start Nginx
sudo service nginx start
```

### Prepare virtual host

```
# Remove default conf for all hosts
sudo rm /etc/nginx/sites-enabled/default

# Add your own
sudo nano /etc/nginx/sites-enabled/sampleapp
```

Virtual host contents:

```
server {
  listen 80;

  server_name 64.227.102.88;
  root /home/deploy/sampleapp/current/public;

  passenger_enabled on;
  passenger_app_env production;

  location /cable {
    passenger_app_group_name myapp_websocket;
    passenger_force_max_concurrent_requests_per_process 0;
  }

  # Allow uploads up to 100MB in size
  client_max_body_size 100m;

  location ~ ^/(assets|packs) {
    expires max;
    gzip_static on;
  }
}
```

Reload updated Nginx hosts:

```
sudo service nginx reload
```

## Create PostgreSQL Database

```
sudo apt-get install postgresql postgresql-contrib libpq-dev

sudo su - postgres

createuser --pwprompt deploy

createdb -O deploy sampleapp_db

exit
```
