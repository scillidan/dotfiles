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

;= rem choco
ch=choco info $*
cs=choco search $*
ci=gsudo choco install -y $*
cu=gsudo choco uninstall $*
cup=gsudo choco upgrade $*
cua=gsudo choco upgrade all -y
cl=choco list

;= rem scoop
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
sib=scoop install %USERHOME%\Usr\GitFork\scoop-bucket\bucket\$*.json
rsib=scoop uninstall $1 && scoop install %USERHOME%\Usr\GitFork\scoop-bucket\bucket\$1.json
fccc=formatjson $1 && checkver $1

;= rem gh extensions
ghtd=gh tidy
gcorg=gh clone-org $*
ghdl=gh download $*

;= rem alass
alas=alass $1.$2 $1.$3 $1.alass.$3

;= rem doggo
dga=doggo A $* @1.1.1.1
dgg=doggo A $* @8.8.8.8

;= rem erd
etree=erd --color auto --hidden --follow --human --sort name --dir-order first --layout inverted $*

;= rem eza
ls=eza $*
l=eza --git-ignore $*
ll=eza --all --header --long $*
llm=eza --all --header --long --sort=modified $*
la=eza -lbhHigUmuSa
lx=eza -lbhHigUmuSa@
lt=eza --tree $*
tree=eza --tree $*

;= rem gopencc
t2c=gopencc -c t2s -i $*
c2t=gopencc -c s2t -i $*

;= rem jq
jqp=jq ".scripts" package.json

;= rem lstr
tree=lstr

;= rem ltts
lttso=ltts $2 -v af_bella -o $1.mp3

;= rem sgpt
comment=cat $* | sgpt --code "Generate comments for each line"
explain=sgpt --model ollama/mistral:7b-instruct --role explain $*
optimize=sgpt --model ollama/mistral:7b-instruct --role optimize $*
summarize=sgpt --model ollama/mistral:7b-instruct --role summarize $*
adcopy=sgpt --model ollama/llama3.1:8b --role adcopy $*

;= rem Lib
;= rem cargo
cgi=cargo install --force $*
cgu=cargo uninstall $*
cgs=cargo search $* --registry crates-io

;= rem npm
ns=npms search $*
;= rem pnpm
xni=%SCOOP%\shims\pnpm.exe add -g $*
xnu=%SCOOP%\shims\pnpm.exe remove -g $*
xnl=%SCOOP%\shims\pnpm.exe ls -g

;= rem python
py310=%SCOOP%\apps\python310\current\python.exe $*
pv310=%SCOOP%\apps\python310\current\python.exe -m venv .venv && .venv\Scripts\activate.bat
pi310=%SCOOP%\apps\python310\current\python.exe -m pip install $*
pu310=%SCOOP%\apps\python310\current\python.exe -m pip uninstall $*
py311=%SCOOP%\apps\python311\current\python.exe $*
pv311=%SCOOP%\apps\python311\current\python.exe -m venv .venv && .venv\Scripts\activate.bat
py312=%SCOOP%\apps\python312\current\python.exe $*
pv312=%SCOOP%\apps\python312\current\python.exe -m venv .venv && .venv\Scripts\activate.bat
pva=.venv\Scripts\activate.bat
ps=pip_search $*
;= rem pipx
xpi=pipx install $*
xpu=pipx uninstall $*
;= rem uv
uv310=uv venv --python 3.10 && .venv\Scripts\activate.bat
uva=.venv\Scripts\activate.bat
uvv=uv venv $1 --python 3.10 && $1\Scripts\activate.bat
uvi=uv pip install $*

;= rem Opt
;= rem CUDA
cuda11=set "CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8"
cuda12=set "CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.3"

;= rem Other
do=dopus "%CD%\$*"
e=explorer $CD$\$*
