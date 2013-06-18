---
layout: post
title: Python Package Management with Virtualenv on OS X Mountain Lion 10.8
---

# Preface

I had worked with both Ruby's RVM and rbenv a little, and setting up something similar for Python version and package management seemed a little undocumented, ambiguous, and generally quirky to me. Maybe doing this should not require a blog post, though the following was the simplest way for me to accomplish this.

Also, [this post](http://hackercodex.com/guide/python-virtualenv-on-mac-osx-mountain-lion-10.8/) on the same topic was very helpful.

# Python

I choose to leave OS X's stock Python install alone, which was a slightly out-of-date version 2.7.2 for the system executable at /usr/bin/python. Also, the Python package manager easy_install comes with 10.8, but it's [deprecated](https://github.com/mxcl/homebrew/wiki/Gems,-Eggs-and-Perl-Modules#with-a-brewed-python--you-dont-need-sudo).

So, I wanted to start with a base Python version that was more recent than the OS X stock Python. I did this using Homebrew:

    brew install python

This installed version 2.7.5. Note that the Homebrew install of Python also includes Pip (the preferred Python package manager these days) as well as Distribute (a lower-level package management piece [that Pip builds upon](http://stackoverflow.com/a/8550546/33096)).

# Global Packages

At this point, if I use Pip to install a package, it will be installed globally. In general, I want to only install packages into specific environments and leave the global package store alone. However, I still need a global package for virtualenv itself:

    pip install virtualenv

I may have to install other global packages in the future, but the only package I've installed explicitly for now is virtualenv.

# Setting Up Virtualenv

I created a `~/.virtualenvs` folder where I will create all or most of my environments:

    mkdir ~/.virtualenvs

For example, I can create a global environment for Python 2.7 packages, and a global environment for Python 3 packages. Note that I can also create project-specific environments if I want.

Then, I added the following default settings to my `.bashrc` file:

    # virtualenv settings
    export PIP_REQUIRE_VIRTUALENV=true # pip should only run if there is a virtualenv currently activated
    export PIP_RESPECT_VIRTUALENV=true # tell pip to install packages into the active virtualenv environment
    export VIRTUALENV_DISTRIBUTE=true  # tell virtualenv to use Distribute instead of legacy setuptools

The first setting is the most important. It tells pip to only run if inside a virtual environment. This keeps global packages untouched and stable, and it prevents a package from accidentally being installed globally when you mean to install it in a particular virtual environment. However, if global packages need to be installed/uninstalled/upgraded later, I'll need to temporarily comment out and disable this setting.

Also note the `VIRTUALENV_DISTRIBUTE` option. This tells virtualenv to use the newer Distribute supporting library. From the official Python package page [here](https://pypi.python.org/pypi/distribute): *Distribute is a fork of the Setuptools project. Distribute is intended to replace Setuptools as the standard method for working with Python module distributions.*

Now, we can create an environment and activate it:

    cd ~/.virtualenvs
    virtualenv default
    . ~/.virtualenvs/default/bin/activate

With this environment active, any calls to the Python, Pip, etc. executables will pass through it, and packages will be installed to this environment.

# Listing and Uninstalling Environments

Since I plan to create most environments in `~/.virtualenvs`, I can just check that directory to see all installed environments. Likewise, to remove an environment, I can just remove the corresponding directory there.

# Creating a Default Environment

To activate a default environment on login, I also added this to my `.bashrc` file:

    # set a default virtualenv
    . ~/.virtualenvs/default/bin/activate

# Final Thoughts

## Virtualenvwrapper

Virtualenvwrapper claims to ease several of the pain points and manual steps I described above, but I wanted to see if I could use virtualenv directly without adding another layer of tooling to learn.

## Modifying the Shell

When you activate an environment, virtualenv modifies your prompt to indicate which environment you're using. If this is undesirable, you can add the following line to your `.bashrc` file:

    export VIRTUAL_ENV_DISABLE_PROMPT=true # tell virtualenv not to modify my prompt

If you disable this indicator in your prompt, you can check which environment you're currently using by echoing the `$VIRTUAL_ENV` variable.

## An Environment's Bindings to a Python Executable 

When a new environment is created, it is bound to the current system Python executable by default (whatever `which python` points to). In my case, this will be the Python 2 executable installed by Homebrew. You can, however, bind a new virtual environment to a particular Python executable by using the `-p` flag. For example, you could do `virtualenv -p python3 foo-py3` to create a Python 3 environment or even `virtualenv -p /usr/bin/python2.6 foo-py2.6` to call out a specific path to a Python executable.
