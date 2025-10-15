;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
;= l=ls --show-control-chars -CFGNhp --color --ignore={"NTUSER.DAT*","ntuser.dat*"} $*
;= ls=ls --show-control-chars -F --color $*
e.=explorer .
pwd=cd
clr=clear
ipi=ipconfig | findstr /i "ipv4"

;= rem OS
_bash=%SCOOP_HOME%\shims\bash.exe $*
_ssh=%SCOOP_HOME%\apps\git\current\usr\bin\ssh.exe $*
gunzip=gzip

;= Rem Lib
;= :: python
py310=%SCOOP_HOME%\apps\python310\current\python.exe $*
pv310=%SCOOP_HOME%\apps\python310\current\python.exe -m venv .venv && .venv\Scripts\activate.bat
pi310=%SCOOP_HOME%\apps\python310\current\python.exe -m pip install $*
pu310=%SCOOP_HOME%\apps\python310\current\python.exe -m pip uninstall $*
py311=%SCOOP_HOME%\apps\python311\current\python.exe $*
pv311=%SCOOP_HOME%\apps\python311\current\python.exe -m venv .venv && .venv\Scripts\activate.bat
py312=%SCOOP_HOME%\apps\python312\current\python.exe $*
pv312=%SCOOP_HOME%\apps\python312\current\python.exe -m venv .venv && .venv\Scripts\activate.bat
pva=.venv\Scripts\activate.bat
ps=pip_search $*

;= :: pipx
xpi=pipx install $*
xpu=pipx uninstall $*

;= :: uv
uv310=uv venv --python 3.10 && .venv\Scripts\activate.bat
uva=.venv\Scripts\activate.bat
uvv=uv venv $1 --python 3.10 && $1\Scripts\activate.bat
uvi=uv pip install $*

;= :: npm
ns=npms search $*

;= :: pnpm
xni=%SCOOP_HOME%\shims\pnpm.exe add -g $*
xnu=%SCOOP_HOME%\shims\pnpm.exe remove -g $*
xnl=%SCOOP_HOME%\shims\pnpm.exe ls -g

;= :: cargo
cgi=cargo install --force $*
cgu=cargo uninstall $*
cgs=cargo search $* --registry crates-io

;= :: CUDA
cuda11=set "CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8"
cuda12=set "CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.3"

;= rem Opt
e=explorer $CD$\$*
d=dopus "%CD%\$*"

;= rem Shell
rfe=%USERPROFILE%\Usr\Shell\RefrEnv\refrenv.bat
git-sync=_bash %USERPROFILE%\Usr\Shell\git-sync\git-sync $*
mgit=_bash %USERPROFILE%\Usr\Shell\multi-git-status\mgitstatus
ugit=_bash %USERPROFILE%\Usr\Shell\ugit\ugit
pdf2jpg=_bash C:\Users\User\Usr\Git\Shell\_arch\pdf2jpg.sh $*

;= rem Bin
mlbin=mklink %USERPROFILE%\.local\bin\$1 %CD%\$1

;= :: scoop
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

;= :: choco
ch=choco info $*
cs=choco search $*
ci=gsudo choco install -y $*
cu=gsudo choco uninstall $*
cup=gsudo choco upgrade $*
cua=gsudo choco upgrade all -y
cl=choco list

;= :: gh extensions
ghtd=gh tidy
gcorg=gh clone-org $*
ghdl=gh download $*

;= :: alass
alas=alass $1.$2 $1.$3 $1.alass.$3

;= :: doggo
dga=doggo A $* @1.1.1.1
dgg=doggo A $* @8.8.8.8

;= :: erd
et=erd --color auto --hidden --follow --human --sort name --dir-order first --layout inverted $*

;= :: eza
ls=eza $*
l=eza --git-ignore $*
ll=eza --all --header --long $*
llm=eza --all --header --long --sort=modified $*
la=eza -lbhHigUmuSa
lx=eza -lbhHigUmuSa@
lt=eza --tree $*
tree=eza --tree $*

;= :: gopencc
t2c=gopencc -c t2s -i $*
c2t=gopencc -c s2t -i $*

;= :: jq
jqp=jq ".scripts" package.json
