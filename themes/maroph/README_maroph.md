# Pelican Theme maroph
The maroph theme is based on the Pelican theme 
[gum](https://github.com/getpelican/pelican-themes/tree/master/gum)


The following standard Pelican settings are honored:

* DISPLAY_CATEGORIES_ON_MENU
* DISPLAY_PAGES_ON_MENU
* DEFAULT_LANG
* LINKS
* SOCIAL


## Changes
### Added
#### Variable
The following variable was added to the sidebar

* LINKS

#### External Links in Sidebar
Add 

```
target="_blank" rel="noreferrer nofollow"
```

to the a tag.

### Removed

#### Variables
The following gym variables are no longer supported:

* FACEBOOK_URL
* GOOGLE_ANALYTICS_ID
* GOOGLE_ANALYTICS_SITENAME
* GOOGLEPLUS_URL
* JUVIA_ID
* JUVIA_URL
* PIWIK_URL
* PIWIK_ID
* SITESUBTITLE

#### External Font Loading
File static/gumby.css: usage of external font "Open Sans" commented out.

