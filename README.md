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

## Usage

Sharing files is done using the following steps:

1. The user creates a repository and assigns a title and password
2. A random URL is generated for the repository
3. The URL can be send by email and the password by text message
4. Every person with access to both the URL and password can upload and share files
5. The repository is automatically destroyed after 1 month  
     
## IP authentication
 
One of the principles of SISO is to make it simple to use. Therefore in order to the further need of credentials the authorization of creating new repositories is done using IP addresses. The administrator sets the range of IP addresses which can be used to create repositories. 
   
Setting this to the IP range of the organisations ensures that only employees can create repositories.

## Deploy

### Heroku Deploy
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?env[RAILS_ENV]=heroku)

### Setup

Follow the instructions listed below to setup a working environment. 

1. Install ruby
2. Run setup script `bin/setup`, this will install the GemFiles and create the databases
3. Run server `bin/run`, this will run the server which will be available from port 3000
