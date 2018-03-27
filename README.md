# Table of Contents


## Supported tags

Current branch: latest

*  `7.8.1.1`,
*  `7.7.1.1`,
*  `7.3.8.1`,
*  `7.2.3.4`,`7.2.3.3`,`7.2.3.2`,`7.2.3.1`
*  `7.2.2.4`,`7.2.2.3`,`7.2.2.2`,`7.2.2.1`
*  `7.1.9.1`

For previous versions or newest releases see other branches.

## Introduction


Dockerfiles to build [Jira](https://www.atlassian.com/software/jira)


### Version
* Version: `7.8.1.1` - Latest: Upgrade - 7.7.1 -> 7.8.1;
* Version: `7.7.1.1` - Upgrade - 7.3.8 -> 7.7.1; Upgraded java to 8u161
* Version: `7.3.8.1` - Upgrade - 7.2.3 -> 7.3.8; Upgraded java to 8u131
* Version: `7.2.3.4` - Fix on java cacerts pointing
* Version: `7.2.3.3` - Fix Startup Script
* Version: `7.2.3.2` - Upgraded java to 111 build 14
* Version: `7.2.3.1` - Upgraded to Jira 7.2.3
* Version: `7.2.2.4` - Added feature to copy the content of the conf dir after startup (to share the dir)
* Version: `7.2.2.3` - Some small fixes on the startup scripts
* Version: `7.2.2.2` - Jira 7.2.2
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

Just create a volume or share a host directory for /opt/jira-home and (optionaly) for the configuration dir
jira uses.

You can also use the pre_run_cmd variable to determine commands to be pre-runned


## Configuration

### Data Store

This image doesn't use data volumes by default but you should configure /opt/jira-home to point to a data volume or to point to a folder in the local disk

### User

No special users

### Ports

Next ports are exposed

* `8080/tcp` - default port


### Entrypoint

We use puppet as the default entry point to manage the environment

*Jira is launched in background. Which means that is possible to restart jira without restarting the container.*

### Hostname

It is recommended to specify `hostname` for this image, so if you will recreate bamboo instance you will keep the same hostname.

### SSL certs
The image is configured to use /etc/pki/tls/certs as the base ssl cert configuration. Java will use /etc/pki/tls/certs/java/cacerts as it's keychain.

If you want to add more certs to it ou can mount this file.

### Basic configuration using Environment Variables

> Some basic configurations are allowed to configure the system and make it easier to change at docker command line

* JAVA_HOME "/opt/java_home" - Java install dir
* JIRA_VERSION "7.1.9" - Version of jira
* JIRA_INSTALLDIR "/opt/jira"
* JIRA_HOME "/opt/jira-home"
* JVM_MINIMUM_MEMORY 512m - Java memory parameter, changing this is needed for larger installs
* ENV JVM_MAXIMUM_MEMORY 4096m - Java memory parameter, changing this is needed for larger installs
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
