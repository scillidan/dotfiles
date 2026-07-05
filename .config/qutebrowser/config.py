import os
userhome = os.environ.get('USERHOME', os.path.expanduser('~'))
downloads_dir = os.path.join(userhome, 'Downloads')

config.load_autoconfig()

config.source("themes/city-lights-theme.py")
c.fonts.default_family = "Sarasa Term SC Nerd"
c.window.hide_decoration = True
c.scrolling.bar = "never"
c.zoom.default = "80%"

c.auto_save.session = True
c.session.lazy_restore = True
c.downloads.location.directory = os.path.join(userhome, '/Downloads')
c.downloads.location.suggestion = 'filename'
c.downloads.location.remember = False

c.aliases['ob'] = 'open -t -- {clipboard}'
c.aliases['ss'] = 'screenshot ~/{downloads_dir}/screenshot-$(date +%s).png'

config.bind(',gc', 'spawn --userscript git-clone')
config.bind(',rr', 'spawn --userscript repomix-remote')
