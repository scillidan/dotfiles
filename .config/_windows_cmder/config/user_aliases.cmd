;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here

_bash=%SCOOP_HOME%\shims\bash.exe $*
_ssh=%SCOOP_HOME%\apps\git\current\usr\bin\ssh.exe $*
e.=explorer .
pwd=cd
clr=clear
rfe=%USERPROFILE%\Usr\Shell\RefrEnv\refrenv.bat
ipi=ipconfig | findstr /i "ipv4"
e=explorer $CD$\$*
d=dopus "%CD%\$*"
open=open-cli $*
es.=es -path . $*
;= l=ls --show-control-chars -CFGNhp --color --ignore={"NTUSER.DAT*","ntuser.dat*"} $*
;= ls=ls --show-control-chars -F --color $*
ls=eza $*
l=eza --git-ignore $*
ll=eza --all --header --long $*
llm=eza --all --header --long --sort=modified $*
la=eza -lbhHigUmuSa
lx=eza -lbhHigUmuSa@
lt=eza --tree $*
tree=eza --tree $*
gunzip=gzip
ugit=bash %USERPROFILE%\Usr\Shell\ugit\ugit
git-sync=_bash %USERPROFILE%\Usr\Shell\git-sync\git-sync $*
mgit=_bash %USERPROFILE%\Usr\Shell\multi-git-status\mgitstatus
ghtd=gh tidy
gcorg=gh clone-org $*
ghdl=gh download $*
gwe=gowl edit
gwg=gowl get

ss=scoop search $*
si=scoop install $*
su=scoop uninstall $*
sh=scoop home $*
sl=scoop list
sst=scoop status
sup=scoop update $*
sua=scoop update -a -k
scca=scoop cache rm *
scua=scoop cleanup *
ch=choco info $*
cs=choco search $*
ci=gsudo choco install -y $*
cu=gsudo choco uninstall $*
cup=gsudo choco upgrade $*
cua=gsudo choco upgrade all -y
cl=choco list
gc1=git clone --depth 1 $*
;= gxy=git config --global http.proxy "socks5://127.0.0.1:$*"
;= ungxy=git config --global --unset http.proxy
;= nxy=npm config set proxy http:///127.0.0.1:$1 && npm config set https-proxy http:///127.0.0.1:$1 && npm config get proxy && npm config get https-proxy
;= unnxy=npm config delete proxy && npm config delete https-proxy && npm config get proxy && npm config get https-proxy
sslt=git config --global http.sslVerify true
sslf=git config --global http.sslVerify false
;= ghi=gh extension install $*
;= ghu=gh extension remove $*
py310=%SCOOP_HOME%\apps\python310\current\python.exe $*
pv310=%SCOOP_HOME%\apps\python310\current\python.exe -m venv .venv && .venv\Scripts\activate.bat
pi310=%SCOOP_HOME%\apps\python310\current\python.exe -m pip install $*
pu310=%SCOOP_HOME%\apps\python310\current\python.exe -m pip uninstall $*
py311=%SCOOP_HOME%\apps\python311\current\python.exe $*
pv311=%SCOOP_HOME%\apps\python311\current\python.exe -m venv .venv && .venv\Scripts\activate.bat
py312=%SCOOP_HOME%\apps\python312\current\python.exe $*
pv312=%SCOOP_HOME%\apps\python312\current\python.exe -m venv .venv && .venv\Scripts\activate.bat
pva=.venv\Scripts\activate.bat
;= pixy=pip install -e . --index-url https://pypi.org/simple
pipc=pip cache purge
ps=pip_search $*
uv310=uv venv --python 3.10 && .venv\Scripts\activate.bat
uva=.venv\Scripts\activate.bat
uvv=uv venv $1 --python 3.10 && $1\Scripts\activate.bat
uvi=uv pip install $*
xpi=pipx install $*
xpu=pipx uninstall $*
ns=npms search $*
xni=pnpm add -g $*
xnu=pnpm remove -g $*
xnl=pnpm ls -g
;= yi=yarn add $*
;= yu=yarn remove $*
;= yc=yarn cache clean
;= yarn=corepack yarn $*
;= yarnpkg=corepack yarnpkg $*
;= fni=fnm install v$*
;= fnu=fnm use v$*
cgi=cargo install $*
cgu=cargo uninstall $*
cgs=cargo search $* --registry crates-io
cgbi=cargo-binstall install $*
;= vcs=vcpkg search $*
;= vci=vcpkg install $*
;= vcu=vcpkg remove $*
;= vcup=C:\dev\vcpkg && git pull
;= dsi=datasette install $*
;= dsu=datasette uninstall $*

cuda11=set "CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8"
cuda12=set "CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.3"
alas=alass $1.$2 $1.$3 $1.alass.$3
rec=powersession rec $1.cast
play=powersession play $1.cast
cast=autocast $1.yaml $1.cast
repo2prompt=code2prompt --remote $1

t2c=gopencc -c t2s -i $*
c2t=gopencc -c s2t -i $*
et=erd --color --hidden --follow --human --disk-usage line --sort name --dir-order first --layout inverted $*
jqp=jq ".scripts" package.json
scan=clamscan -v -a --max-filesize=1000M --max-scansize=1000M --alert-exceeds-max=yes $1
abbr=abbreviate original $*
