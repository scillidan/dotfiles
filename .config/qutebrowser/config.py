import os

userhome = os.environ.get("USERHOME", "")
if userhome and not userhome.endswith(os.sep):
    userhome += os.sep
downloads_dir = os.path.join(userhome, "Downloads")

config.load_autoconfig(False)

c.auto_save.session = True
c.content.cookies.accept = "all"
c.content.cookies.store = True
c.content.javascript.clipboard = "access"
c.downloads.location.directory = downloads_dir
c.downloads.location.remember = False
c.downloads.location.suggestion = "filename"
c.downloads.remove_finished = 0
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_load = False
c.input.insert_mode.plugins = False
c.session.default_name = "default"
c.session.lazy_restore = True
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
}

config.source("themes/city-lights-theme.py")
c.fonts.default_family = "Sarasa Term SC Nerd"
c.scrolling.bar = "never"
c.url.default_page = os.path.join(
    "file:///",
    userhome,
    r"Share/dotfiles/.config/qutebrowser/default-page/qutebrowser-default-bindings.html",
)
c.window.hide_decoration = True
c.zoom.default = "80%"

c.aliases["ob"] = "open -t -- {clipboard}"
c.aliases["ss"] = f"screenshot {downloads_dir}/screenshot-$(date +%s).png"
c.hints.selectors["elements"] = [
    "p",
    "li",
    "blockquote",
    "pre",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "article",
    "section",
    "td",
    "figcaption",
]
config.bind(",gc", "spawn --userscript git-clone")
config.bind(",rr", "spawn --userscript repomix-remote")
config.bind(",ys", "spawn --userscript yank_sel_md")
