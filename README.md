# PowerDNS-Admin - with native support for IPv6 and TLS
This Project is a fork of https://github.com/PowerDNS-Admin/PowerDNS-Admin/ with some additions regarding support of native IPv6 and TLS / SSL / HTTPS

## What this is all about
Running an IPv6 native application is getting more an more important as IPv4-Adresses are rare already and sometimes there is even a cost penalty. Therefore I had the idea to switch over to IPv6, as I get a whole /64 network for no addtional cost.
However there are some things to consider as IPv6 will give you direct access (end-to-end) and expose the application via unsecured HTTP if you don't do anything about it.

### Switching to IPv6 and provide a fallback for IPv4-clients

Support in Docker for IPv6 is not fully developed yet, but the current status allows to work when a static IPv6-range is available (what is always helpful when talking about DNS anyway). Starting a container with IPv6 enabled is well documented, so I will not get in details about this here. All change required to the startup of PowerDNS-Admin is to set the `BIND_ADDRESS` to `[::]:443` where `[::]` is the IPv6 equivilant of `0.0.0.0` or bind-to-any-ip-available and port 443 is the default port for HTTPS (see below why you should use HTTPS in case of IPv6, if you start out to experiment you might as well use HTTP on port 80 instead).

Using IPv6 natively in Docker enables you to get rid of the need for a reverse-proxy configuration or load-balancer. For most of the use cases I encountered, adding this extra layer is a bit over the top. However you will need such a solution if you want to provide backward compatible IPv4-Access with only a single external IPv4 address available on the host maschine: Keep in mind that most load balancer software is IPv6 aware by now and will basically do a repackaging of incoming IPv4 traffic to IPv6 to contact the application and do the same thing in reverse to deliver the response to an IPv4 client.

### Securing the communication - background
With the default settings PowerDNS only uses HTTP only (bound to port 80) and the most common advice is: "stick it behind a reverse proxy which will take care of HTTPS". While this is true for IPv4 and Docker using a private network, it does not hold true when using IPv6 or when you are already part of an internal network in your company and your docker-network is just a small subnet directly exposed.

PowerDNS-Admin features a login, secured by passwords and optinally an OTP-Token. So it is definitly not advisable to use the application without the use of Transport Layer Security enabled (commonly called HTTPS).
With the help of letsencrypt its no big deal to get certificates today and HTTPS should be used in anything that is not a local development system, therefore: If you choose IPv6, you almost certainly also want to have HTTPS enabled.

### Make use of TLS / HTTPS in PowerDNS-Admin
Getting PowerDNS-Admin to run with TLS support in gunicorn enabled is only a few lines of changes to the entrypoint-script. Keep in mind that it is up to you to keept the Files up to date and you need to somehow provision those to the container, using a volume or bind-mount.

# Below is the original description of PowerDNS-Admin

A PowerDNS web interface with advanced features.

[![CodeQL](https://github.com/PowerDNS-Admin/PowerDNS-Admin/actions/workflows/codeql-analysis.yml/badge.svg?branch=master)](https://github.com/PowerDNS-Admin/PowerDNS-Admin/actions/workflows/codeql-analysis.yml)
[![Docker Image](https://github.com/PowerDNS-Admin/PowerDNS-Admin/actions/workflows/build-and-publish.yml/badge.svg?branch=master)](https://github.com/PowerDNS-Admin/PowerDNS-Admin/actions/workflows/build-and-publish.yml)

#### Features:

- Provides forward and reverse zone management
- Provides zone templating features
- Provides user management with role based access control
- Provides zone specific access control
- Provides activity logging
- Authentication:
  - Local User Support
  - SAML Support
  - LDAP Support: OpenLDAP / Active Directory
  - OAuth Support: Google / GitHub / Azure / OpenID
- Two-factor authentication support (TOTP)
- PDNS Service Configuration & Statistics Monitoring
- DynDNS 2 protocol support
- Easy IPv6 PTR record editing
- Provides an API for zone and record management among other features
- Provides full IDN/Punycode support

## [Project Update - PLEASE READ!!!](https://github.com/PowerDNS-Admin/PowerDNS-Admin/discussions/1708)

## Running PowerDNS-Admin

There are several ways to run PowerDNS-Admin. The quickest way is to use Docker.
If you are looking to install and run PowerDNS-Admin directly onto your system, check out
the [wiki](https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/master/docs/wiki/) for ways to do that.

### Docker

Here are two options to run PowerDNS-Admin using Docker.
To get started as quickly as possible, try option 1. If you want to make modifications to the configuration option 2 may
be cleaner.

#### Option 1: From Docker Hub

To run the application using the latest stable release on Docker Hub, run the following command:

```
$ docker run -d \
    -e SECRET_KEY='a-very-secret-key' \
    -v pda-data:/data \
    -p 9191:80 \
    powerdnsadmin/pda-legacy:latest
```

This creates a volume named `pda-data` to persist the default SQLite database with app configuration.

#### Option 2: Using docker-compose

1. Update the configuration   
   Edit the `docker-compose.yml` file to update the database connection string in `SQLALCHEMY_DATABASE_URI`.
   Other environment variables are mentioned in
   the [AppSettings.defaults](https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/master/powerdnsadmin/lib/settings.py) dictionary.
   To use a Docker-style secrets convention, one may append `_FILE` to the environment variables with a path to a file
   containing the intended value of the variable (e.g. `SQLALCHEMY_DATABASE_URI_FILE=/run/secrets/db_uri`).   
   Make sure to set the environment variable `SECRET_KEY` to a long, random
   string (https://flask.palletsprojects.com/en/1.1.x/config/#SECRET_KEY)

2. Start docker container
   ```
   $ docker-compose up
   ```

You can then access PowerDNS-Admin by pointing your browser to http://localhost:9191.

## Screenshots

![dashboard](docs/screenshots/dashboard.png)

## Support

**Looking for help?** Try taking a look at the project's
[Support Guide](https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/master/.github/SUPPORT.md) or joining
our [Discord Server](https://discord.powerdnsadmin.org).

## Security Policy

Please see our [Security Policy](https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/master/SECURITY.md).

## Contributing

Please see our [Contribution Guide](https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/master/docs/CONTRIBUTING.md).

## Code of Conduct

Please see our [Code of Conduct Policy](https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/master/docs/CODE_OF_CONDUCT.md).

## License

This project is released under the MIT license. For additional
information, [see the full license](https://github.com/PowerDNS-Admin/PowerDNS-Admin/blob/master/LICENSE).

## [Donate](https://www.buymeacoffee.com/AzorianMatt)

Like my work?

<a href="https://www.buymeacoffee.com/AzorianMatt" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

**Want to sponsor me?** Please visit my organization's [sponsorship page](https://github.com/sponsors/AzorianSolutions).
