Changelog
====================================

### 2.1.1 ###

* Changed: auto negotiation enabled for `ether1` and `ether2` in defonf
* Bugfix: RouterOS `v7.15` compatibility - added `2s` delay between upload and reset

### 2.1.0 ###

* Added: `workspace init` command to create default workspace structure
* Added: default `defconf.rsc` script
* Added: random password generation to `defconf.rsc`
* Added: header/footer wrapper to `defconf` generator
* Added: symlink check to throw an error on invalid links
* Changed: disabled ssh key verification for `init` command (full system rest)
* Bugfix: in case `SFTP_KNOWN_HOSTS` is not set within config, `/dev/null` is used for the `init` command

### 2.0.1 ###

* Bugfix: added linebreak after each file to avoid errors when joining the footer

### 2.0.0 ###

* Added: multidevice builds (subtargets)
* Added: default sftp deploy hook
* Added: project based configuration file `$WORKINGDIR/.config` loaded on startup (optional)
* Added: device initialization example
* Added: `reboot` command
* Added: `exec` command
* Added: config option `OPTIMIZE` to disable output "optimization"
* Added: option to use custom header/footer/post_build hooks
* Added: wrapper files `header.rsc` and `footer.rsc` can be overridden
* Changed: default files (head)
* Changed: init directory changed from `_init` to `.init`
* Changed: `bash-functions` updated to `v0.2.0` (MPL-2.0)
* Bugfix: `init` command doesn't honor hostname (default used instead)

### 1.0.0 ###

* Added: multiline flattening
* Added: whitespace+comment removal
* Bugfix: resolving basepath using symlinks failed