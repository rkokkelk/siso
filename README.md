# SISO

SISO is a simple and secure file transfer system. It aims to provide functionality to send confidential files over the internet. It originated from the problem that people have with sending confidential files securely using email.  

[![Build Status](https://travis-ci.org/rkokkelk/siso.svg?branch=master)](https://travis-ci.org/rkokkelk/siso) [![security](https://hakiri.io/github/rkokkelk/siso/master.svg)](https://hakiri.io/github/rkokkelk/siso/master) [![Code Climate](https://codeclimate.com/github/rkokkelk/siso/badges/gpa.svg)](https://codeclimate.com/github/rkokkelk/siso) [![Test Coverage](https://codeclimate.com/github/rkokkelk/siso/badges/coverage.svg)](https://codeclimate.com/github/rkokkelk/siso/coverage)

## Functionality

- All confidential information (file content, file names) encrypted in memory
- AES-256-GCM encryption
- Bcrypt password storage
- PBDKDF with 20000 iterations
- Audit logs
- Language support (NL,EN)
- Automatic removal of old repositories
- Easy to use

## Deployement

### Heroku Deploy
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?env[RAILS_ENV]=heroku)

### Docker

A docker image is available [here](https://hub.docker.com/r/rkokkelk/siso/).

or use `docker pull rkokkelk/siso`

## Documentation

Further documentation about configuration, installation and other features can be found at the [Wiki](https://github.com/rkokkelk/siso/wiki).
