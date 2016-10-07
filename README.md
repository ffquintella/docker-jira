# Table of Contents


## Supported tags

Current branch: latest

*  `7.2.2.2`,`7.2.2.1`, `7.1.9.1`, `latest`

For previous versions or newest releases see other branches.

## Introduction


Dockerfiles to build [Jira](https://www.atlassian.com/software/jira)


### Version
* Version: `7.2.2.2` - Latest: Some fixes on the code
* Version: `7.1.9.2` - 7.1.9
* Version: `7.1.9.1` - First version


## Installation

Pull the image from docker hub.

```bash
docker pull ffquintella/docker-jira
```

Alternately you can build the image locally.

```bash
git clone https://github.com/ffquintella/docker-jira.git
cd docker-jira
./build.sh
```

## Quick Start

Not written yet


## Configuration

### Data Store

This image doesn't use data volumes by default but you should configure /opt/jira-home to point to a data volume or to point to a folder in the local disk

### User

No special users

### Ports

Next ports are exposed

* `8085/tcp` - Bamboo default web interface
* `54663/tcp` - Bamboo broker


### Entrypoint

We use puppet as the default entry point to manage the environment

*Bamboo is launched in background. Which means that is possible to restart bamboo without restarting the container.*

### Hostname

It is recommended to specify `hostname` for this image, so if you will recreate bamboo instance you will keep the same hostname.

### Basic configuration using Environment Variables

> Some basic configurations are allowed to configure the system and make it easier to change at docker command line

* JAVA_HOME "/opt/java_home" - Java install dir
* JIRA_VERSION "7.1.9" - Version of jira
* JIRA_INSTALLDIR "/opt/jira"
* JIRA_HOME "/opt/jira-home"
* FACTER_PRE_RUN_CMD "" - Command to be executed just before starting bamboo
* FACTER_EXTRA_PACKS "" - Packages to be installed at runtime (must be centos7 packages on the defaul repos or epel)


## Upgrade from previous version

Basically stop your running container;

Docker pull latest version

Start a new instance with the new image (backup your data dir)

## Credits

My thanks to the following

- Every one who worked building docker
- Github for the dvcs support
- Puppet guys for the great tool
- The guys at Voxpupuli for the [great puppet module](https://github.com/voxpupuli/puppet-jira) witch made this image so easier to create
