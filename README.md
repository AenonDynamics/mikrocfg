mikrocfg - MikroTik cli configuration utility
=============================

**Manage MikroTik device configurations via ssh from a central repository**

## Features ##

* maintain your device configurations within **git** or any other vcs
* deploy router configuration via ssh (key based)
* multipart (`.d` style) config files
* custom deploy tasks via shell script hooks
* multidevice mode to deploy same config (overrides optional) to multiple devices
* optimized config size by removing comments and flatten multiline directives
* execute pre-defined scripts on targets and device groups via ssh

## Usage ##

```
Usage: mikrocfg [options...] <command> [args...]
manage MikroTik device configurations via ssh from a central repository

Options:
    -h,--help                       Displays this help
    -v,--version                    Displays version

Commands:
    init <hostname>                 run init script with default credentials on device (e.g. setup ssh keys; default 192.168.88.1)
    reboot <target>                 reboot targets/subtargets
    exec <target> <cmd>             execute command file/snipped on target

    build <target>                  build (merge) target config
    deploy <target>                 deploy a already build target config using custom deploy script within working dir
    apply <target>                  build, deploy and apply target configuration (system reset)

    workspace init                  initialize a new workspace/project (create structure within cwd)
    
```

### Installation ###

1. Download the current release and unpack the files in e.g. `/opt/mikrocfg` - that's it.
2. Optionally create a symlink `ln -s /opt/mikrocfg/mikrocfg /usr/local/bin/mikrocfg`
3. Setup a workspace
4. Create your config files
5. Deploy them

### Create Workspace ###

A "workspace" is a directory containing multiple target directories. 
Each target directory requires a config file named `.config` and holds all `.rsc` config files (or symlinks).

Additionally each workspace requires a `dist/` directory where the concatenated configuration files are stored. mikrocfg tool creates a sub-directory for each target within this directory (named exactly like the target).

**Workspace**

```raw
my-mikrotik-configs
  |- .hooks (optional)
  |- .credentials (optional)
  |- .config (optional, project config)
  |
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

### Target config file ###

The `.config` file includes additional variables/functions used for the deployment script

```bash
# deployment - hostname/ip address
CONF_HOST="192.168.88.1"
```

### Project config file ###

The `config` file includes additional variables/functions used for the default deployment script

```bash
# sftp config
SFTP_KEYFILE=".credentials/deployment"
SFTP_KNOWN_HOSTS=".credentials/known_hosts"
SFTP_PORT="22"
SFTP_USER="admin"

# enable/disable optimization
OPTIMIZE="no"
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

### Config execution wrapper ###

All directives (from your config files) are wrapped into a scope with beep signals before/after the config has been applied. Delays are added as workaround to wait until all network devices have been initialized.

Both (header + footer) parts can be overridden by adding the files to the project.

File: `header.rsc`

```
# ----------------------------------------------
# PROJECT:   $TARGET_NAME
# BUILD:     $BUILD_DATE
# GENERATOR: mikrocfg
# ----------------------------------------------
{
# startup delay 15s (to initialize interfaces...weak workaround..)
:delay 15

# outputbeep signal - 3 short tones
:beep frequency=3000 length=100ms;:delay 150ms; :beep frequency=3000 length=100ms;:delay 150ms; :beep frequency=3000 length=100ms;:delay 150ms
```

File: `footer.rsc`

```
# outputbeep signal - 1 long tone
:beep frequency=3000 length=700ms;

# delay 2s
:delay 2000ms;
```

### Default directory ###

All files within the `.defaults/` directory of the workspace are added to **each** configuration (merged). It can be used to apply global defaults or override the header/footer scripts globally

## Deployment ##

The configuration deployment is achieved with a custom shell script. Basically it uploads the configuration to the device and triggers a system reset using the generated configuration as initial device config (`run-after-reset`).

It can be easily modified to run bulk upgrades on device groups.

**Standard deployment script**

A default deployment script is located in `.hooks/deploy` which is configured per target or within the project config.

Custom deployment scripts can be used by creating a hook script `.hooks/deploy` within the working directory.

## Device initialization ##

Initializing new devices can be time consuming (adding users, ssh keys, ...).

To simplify the process the `mikrocfg init` command uploads all files within the `.init` directory of the workspace to a mikrotik device using the default user `admin` without password.

Optionally a custom  configuration `.init/defconf.rsc` is applied (system reset) to create an initial state. Otherwise the package default `defconf.rsc` is used.

The existence of a persistent `flash/` for legacy devices is automatically checked.

## Comannd execution ##

Pre-defined command snippets within the `.cmd` directory can be executed via ssh directly on the device (or group).

**Example**

File: `.cmd/rm-certs`

```
# remove all certificates
/certificate remove [ find ]
```

**Execute**

`$ mikrocfg exec mytargetGroup rm-certs`

## Usage notes ##

This tool is mostly designed for **stateless devices** where a full restore can be achieved via a single config file!

In case you're using auto generated certificates or other features which are creating persistent changes on the devices each update will **remove these files/configs**. Therefore you have to take care of the specific use-case.

## Contribution ##

The **.deb** package is automatically generated via a **Continuous Delivery Pipeline** - please do not build packages manually!

## Commercial support ##

[Aenon Dynamics](https://aenon-dynamics.com) is offering commercial support for this tool. Just [contact us](https://aenon-dynamics.com/kontakt.html) if you need assitance with your deployment structure.

It's also possible to implement client specific features/functions on request.

## License ##
mikrocfg is OpenSource and licensed under the Terms of [GNU GENERAL PUBLIC LICENSE 2.0](https://opensource.org/licenses/GPL-2.0). You're welcome to [contribute](docs/CONTRIBUTING.md)
