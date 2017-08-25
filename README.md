# rhelcve

**This is a internal/draft tool intended first to learn Symfony framework and riot.js**

This webgui tool fetches security notifications from RedHat database with some filter criteria.

User is able to make decision to accept or decline the errata and motivate it. Result is stored in internal database for further loading.
Issues can be created and (accepted) errata associated to it.

## General

## Development

### Environment setup

#### Requirements

* php7
* nodejs
* gulp
* bower
* mysql

#### Installation
```bash
# install nodejs
apt-get install nodejs
# install php stuff
apt-get install php7-fpm php7-cli php7-zip php7-xml php7-readline php7-opcache
apt-get install php7-mysql php7-mcrypt php7-json php7-curl php7-common
# install gulp
npm install --global gulp-cli
# install gulp modules
npm install -g gulp-bower
npm install -g gulp-concat
npm install -g gulp-if
npm install -g gulp-jshint
npm install -g gulp-less
npm install -g gulp-rename
npm install -g gulp-sass
npm install -g gulp-sourcemaps
npm install -g gulp-uglify
npm install -g gulp-uglifycss
npm install -g jshint
# install bower
npm install --global bower
```

### Database

The simplest way is to use the Symfony console commands dedicated to database domain (handled by Doctrine).
As entities and configuration are already declared in the Symfony project (cf. parameters.yml), Doctrine will be to handle commands accordingly. 

```bash
# declare/create the database
php bin/console doctrine:database:create
# declare/create the tables in the database
php bin/console doctrine:schema:update --force
```
The tables inside are auto-created via Symfony shell commands:
### Run in dev mode

```bash
composer run
```

Ctrl-C to quit.

With your browser, load page: http://localhost:9001

## Production
```bash
# install nginx (or apache2)
apt-get install nginx
# install php-fpm
apt-get install php-fpm
```

TODO