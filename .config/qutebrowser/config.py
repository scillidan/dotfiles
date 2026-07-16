import os

userhome = os.environ.get("USERHOME")
downloads_dir = os.path.join(userhome, r"Downloads")

config.load_autoconfig(False)

c.content.cookies.accept = "all"
c.content.cookies.store = True
c.session.default_name = "default"
c.session.lazy_restore = True
c.auto_save.session = True
c.downloads.remove_finished = 0

config.source("themes/city-lights-theme.py")
c.fonts.default_family = "Sarasa Term SC Nerd"
c.window.hide_decoration = True
c.scrolling.bar = "never"
c.zoom.default = "80%"
c.url.default_page = os.path.join("file:///", userhome, r"Share/files/cheatsheets/poster/qutebrowser-default-bindings.png")

c.downloads.location.directory = downloads_dir
c.downloads.location.suggestion = "filename"
c.downloads.location.remember = False

c.aliases["op"] = "open"
c.aliases["ob"] = "open -t -- {clipboard}"
c.aliases["ss"] = f"screenshot {downloads_dir}/screenshot-$(date +%s).png"

config.bind(",gc", "spawn --userscript git-clone")
config.bind(",rr", "spawn --userscript repomix-remote")
