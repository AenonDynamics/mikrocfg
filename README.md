mikrocfg
=============================

**Manage MikroTik device configurations via ssh from a central repository**

## Features ##

* maintain your device configurations within **git** or any other vcs
* deploy router configuration via ssh (key based)
* multipart config files
* custom deploy tasks via shell script

## Usage ##

### Installation ###

Download the [current release]() and unpack the files in e.g. `/opt/mikrocfg` - that's it.

### Create Workspace ###

A "workspace" is a directory containing multiple target directories. 
Each target directory requires a config file named `.config` and holds all `.rsc`` config files (or symlinks).

Additionally each workspace requires a `dist/` directory where the concatenated configuration files are stored. mikrocfg tool creates a sub-directory for each target within this directory (named exactly like the target).

**Workspace**

```raw
my-config
  |- dist
  |- wifi-ap-site1
  |- wifi-ap-site2
  |    |- .config
  |    |- 20-ap-config.rsc
  |    |- 30-wifi.rsc
  |    |- 50-firewall.rsc
  |
  |- wifi-ap-site3
  |- access-switch-site1
  |- core-router-site5
```

### Config file ###

The `.config` file includes additional variables/functions used for the deployment script

```bash
# deployment - hostname/ip address
CONF_HOST="192.168.88.1"
```

### RSC files ###

Each file can contain any `RouterOS` directive.

Files are only recognized (merged) in case the following conditions are fulfilled:

* The filename requires the extension `.rsc`
* The filename has to be start with a numeric priority value

The priority prefix is necessarry to avoid dependency issues (values/objects not defined).

**valid names**

* `20-wlan.rsc`
* `001-interfaces.rsc`

**invalid names**

* `20-wlan.conf`
* `interfaces.rsc`

## Deployment ##

The configuration deployment is achieved with a custom shell script. Basically you have to upload the configuration into your device and trigger a system reset using the generated configuration as initial device config (`run-after-reset`). It can be easily modified to run bulk upgrades on device groups.

**Example deployment script**

```bash
#!/usr/bin/env bash

# fail on error
set -e

# extract args
ACTION="$1"
DIST_FILE="$2"

#load host config
source $TARGET_DIR/.config

# sftp config
SFTP_KEYFILE=".credentials/mikrotik"
SFTP_KNOWN_HOSTS=".credentials/known_hosts"
SFTP_PORT="22"
SFTP_DSN="admin@$CONF_HOST"

sftp_upload(){

    echo "uploading config to $CONF_HOST"

    # upload files
    {
        echo "cd flash"
        echo "put $DIST_FILE config.rsc"
    } | sftp -b - -i $SFTP_KEYFILE -P $SFTP_PORT -o UserKnownHostsFile=$SFTP_KNOWN_HOSTS -o StrictHostKeyChecking=no $SFTP_DSN && {
        echo "files uploaded"
    } || {
        echo "uploading failed"
        exit 1
    }

    # apply changes ?
    if [ "$ACTION" == "apply" ]; then
        echo "applying new configuration - system reset.."
        ssh -i $SFTP_KEYFILE -p $SFTP_PORT -o UserKnownHostsFile=$SFTP_KNOWN_HOSTS -o StrictHostKeyChecking=no $SFTP_DSN \
            "/system reset-configuration keep-users=yes run-after-reset=flash/config.rsc"
    fi
}

# trigger upload
sftp_upload
```

## Contribution ##

The **.deb** package is automatically generated via a **Continuous Delivery Pipeline** - please do not build packages manually!

## License ##
mikrocfg is OpenSource and licensed under the Terms of [GNU GENERAL PUBLIC LICENSE 2.0](https://opensource.org/licenses/GPL-2.0). You're welcome to [contribute](docs/CONTRIBUTING.md)
