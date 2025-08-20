Title: Config
Date: 25-08-20 14:18
Status: hidden

## Introduction
My idea of is to create a simple blog that I want to host as GitHub Pages.

I want to write my text in Markdown, so I need some software to
create the web site data.

The static site generator [Pelican](https://getpelican.com/) seems to
be just what I need - lets give it a try.

All the Pelican project data are located in the branch _main_ of my GitHub repository
[maro/nosense_pelican](https://github.com/maroph/nosense_pelican).

The created site data are stored in the branch _gh-pages_, to be served
as GitHub Pages. I use the Python module 
[ghp-import](https://github.com/c-w/ghp-import)
to copy the data to this branch.

## Installation
The following Python modules are needed:

* [PyPi:pelican](https://pypi.org/project/pelican/)
* [PyPi:ghp-import](https://pypi.org/project/ghp-import/)

```bash
python3 -m venv --prompt pelican --without-pip ./venv
chmod 700 ./venv || exit 1
source ./venv/bin/activate || exit 1
#
python -m pip install --upgrade pip
python -m pip install --upgrade setuptools
python -m pip install --upgrade wheel
#
python -m pip install --upgrade "pelican[markdown]"
python -m pip install --upgrade ghp-import
```

To keep things simple, I use an own virtual environment for the installation.

## Documentation

* [PelicanDocumentation](https://docs.getpelican.com/)
* [ghp-import Sources/Documentation](https://github.com/c-w/ghp-import)

## Themes

* [Themes Preview](https://pelicanthemes.com/)
* [Themes Sources](https://github.com/getpelican/pelican-themes)

## Plugins

* [Pluguins](https://github.com/pelican-plugins)
* [Legacy Plugins](https://github.com/getpelican/pelican-plugins)

## Create the Pelican Project
You need an empty directory to create a Pelican skeleton project.

```bash
mkdir nosense-pelican
cd nosense_pelican
#
pelican-quickstart
#
mkdir content/images
mkdir content/pages
```

### Quick Start
TODO

```
(pelican) $ pelican-quickstart
Welcome to pelican-quickstart v4.11.0.

This script will help you create a new Pelican-based website.

Please answer the following questions so this script can generate the files
needed by Pelican.


> Where do you want to create your new web site? [.] .
> What will be the title of this web site? No Sense
> Who will be the author of this web site? maroph
> What will be the default language of this web site? [en] en
> Do you want to specify a URL prefix? e.g., https://example.com   (Y/n) Y
> What is your URL prefix? (see above example; no trailing slash) https://maroph.github.io/nosense_pelican
> Do you want to enable article pagination? (Y/n) Y
> How many articles per page do you want? [10] 10
> What is your time zone? [Europe/Rome] Europe/Berlin
> Do you want to generate a tasks.py/Makefile to automate generation and publishing? (Y/n) y
> Do you want to upload your website using FTP? (y/N) n
> Do you want to upload your website using SSH? (y/N) n
> Do you want to upload your website using Dropbox? (y/N) n
> Do you want to upload your website using S3? (y/N) n
> Do you want to upload your website using Rackspace Cloud Files? (y/N) n
> Do you want to upload your website using GitHub Pages? (y/N) y
> Is this your personal page (username.github.io)? (y/N) y
Done. Your new project is available at .../nosense_pelican
```

#### File pelicanconf.py
TODO

```
cat pelicanconf.py
AUTHOR = 'maroph'
SITENAME = 'No Sense'
SITEURL = ""

PATH = "content"

TIMEZONE = 'Europe/Berlin'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (
    ("Pelican", "https://getpelican.com/"),
    ("Python.org", "https://www.python.org/"),
    ("Jinja2", "https://palletsprojects.com/p/jinja/"),
    ("You can modify those links in your config file", "#"),
)

# Social widget
SOCIAL = (
    ("You can add links in your config file", "#"),
    ("Another social link", "#"),
)

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True
```

#### File publishconf.py
TODO

```
cat publishconf.py
# This file is only used if you use `make publish` or
# explicitly specify it as your config file.

import os
import sys

sys.path.append(os.curdir)
from pelicanconf import *

# If your site is available via HTTPS, make sure SITEURL begins with https://
SITEURL = "https://maroph.github.io/nosense_pelican"
RELATIVE_URLS = False

FEED_ALL_ATOM = "feeds/all.atom.xml"
CATEGORY_FEED_ATOM = "feeds/{slug}.atom.xml"

DELETE_OUTPUT_DIRECTORY = True

# Following items are often useful when publishing

# DISQUS_SITENAME = ""
# GOOGLE_ANALYTICS = ""
```

## Adapt the Pelican Project
### File pelicanconf.py
TODO

```
cat pelicanconf.py
AUTHOR = 'maroph'
SITENAME = 'No Sense'
SITEURL = ""

PATH = "content"

TIMEZONE = 'Europe/Berlin'

DEFAULT_LANG = 'en'

FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

USE_FOLDER_AS_CATEGORY = False
DISPLAY_CATEGORIES_ON_MENU = False
DISPLAY_PAGES_ON_MENU = True

LINKS = (
    ("GitHub", "https://github.com/maroph"),
    ("CC-BY-4.0", "https://creativecommons.org/licenses/by/4.0/legalcode")
)

SOCIAL = ()

DEFAULT_PAGINATION = 10
```

### File publishconf.py
TODO

```
cat publishconf.py
import os
import sys

sys.path.append(os.curdir)
from pelicanconf import *

SITEURL = "https://maroph.github.io/nosense_pelican"
RELATIVE_URLS = False

FEED_ALL_ATOM = "feeds/all.atom.xml"

DELETE_OUTPUT_DIRECTORY = True
```

## Build/Test Commands
### Build the Local Site
```bash
pelican
```

### Run the Local Site
```bash
pelican --autoreload --listen
```

The local site is available at <http://127.0.0.1:8000>

### Deploy the Site
```bash
pelican -s ./publishconf.py
ghp-import --no-jekyll --push --no-history ./output
```

