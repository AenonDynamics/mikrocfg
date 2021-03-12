Changelog
====================================

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