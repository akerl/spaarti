spaarti
=========

[![Gem Version](https://img.shields.io/gem/v/spaarti.svg)](https://rubygems.org/gems/spaarti)
[![Build Status](https://img.shields.io/circleci/project/akerl/spaarti/master.svg)](https://circleci.com/gh/akerl/spaarti)
[![Coverage Status](https://img.shields.io/codecov/c/github/akerl/spaarti.svg)](https://codecov.io/github/akerl/spaarti)
[![Code Quality](https://img.shields.io/codacy/65bacb9d92d948f6ae637ce63ade3557.svg)](https://www.codacy.com/app/akerl/spaarti)
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
exclude: Hash where keys are attributes of a repo (https://developer.github.com/v3/repos/#get) and values are array of regex pattern strings, with any repo whose attribute matches any pattern not being pulled
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

