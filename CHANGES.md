Changelog
====================================

### 1.1.0 ###

* Added: default sftp deploy hook
* Added: project based configuration file `$WORKINGDIR/.config` loaded on startup (optional)
* Added: device initialization example
* Changed: init directory changed from `_init` to `.init`
* Changed: `bash-functions` updated to `v0.1.0` (MPL-2.0)
* Bugfix: `init` command doesn't honor hostname (default used instead)

### 1.0.0 ###

* Added: multiline flattening
* Added: whitespace+comment removal
* Bugfix: resolving basepath using symlinks failed