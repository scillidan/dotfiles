config.load_autoconfig()

config.source("themes/city-lights-theme.py")
c.fonts.default_family = "Sarasa Term SC Nerd"
c.scrolling.bar = "never"
c.zoom.default = "80%"

c.auto_save.session = True
c.session.lazy_restore = True
c.downloads.location.directory = "~/Downloads"

c.aliases['ob'] = 'open -t -- {clipboard}'
c.aliases['ss'] = 'screenshot ~/Downloads/screenshot-$(date +%s).png'

config.bind(',gc', 'spawn --userscript git-clone')
config.bind(',rr', 'spawn --userscript repomix-remote')
