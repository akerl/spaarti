spaarti
=========

[![Gem Version](https://img.shields.io/gem/v/spaarti.svg)](https://rubygems.org/gems/spaarti)
[![Dependency Status](https://img.shields.io/gemnasium/akerl/spaarti.svg)](https://gemnasium.com/akerl/spaarti)
[![Code Climate](https://img.shields.io/codeclimate/github/akerl/spaarti.svg)](https://codeclimate.com/github/akerl/spaarti)
[![Coverage Status](https://img.shields.io/coveralls/akerl/spaarti.svg)](https://coveralls.io/r/akerl/spaarti)
[![Build Status](https://img.shields.io/travis/akerl/spaarti.svg)](https://travis-ci.org/akerl/spaarti)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Tool to maintain local clones of repos you have access to on GitHub

## Usage

To clone all your repos to the current directory: `spaarti`

Adding `-p` will remove orphaned repos (repos on disk that don't exist on GitHub, or that you no longer have access to).

Adding `-q` will silence output except errors.

You can override the defaults by defining a config file in YAML:

```
base_path: Defaults to './', this is the root that repos will be cloned to
auth_file: Passed to OctoAuth for storing your GitHub token, the default will use ~/.octoauth.yml
exclude: Array of strings, any repos matching any string won't be cloned (strings are treated as regex)
format: Format string used to determine path. Defaults to "%{full_name}", so "akerl/blog" is cloned at "akerl/blog". Available keys: https://developer.github.com/v3/repos/#get
git_config: Hash of key/value pairs, will be set in .git/config for cloned repos. Useful for setting things like user.name/email
quiet: Boolean, controls verbosity of status output
purge: Boolean, true will remove repos that are on-disk but not accessible by you on GitHub
url_type: Used to determine how to clone, one of: html, clone, git, ssh, svn. Defaults to 'ssh'
```

The default config path is `~/.spaarti.yml`, but you can provide an alternate path with `./spaarti -c /path/to/config`

## Installation

    gem install spaarti

## License

spaarti is released under the MIT License. See the bundled LICENSE file for details.

