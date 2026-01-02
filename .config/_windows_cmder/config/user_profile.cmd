@echo off

REM Sys
REM .
set "LC_ALL=en_US.utf8"
set "LANG=en_US.utf8"
set "CHANGE_LOG_NAME=User"
set "SYS_ARCH=64"

REM CUDA
REM .
set "NVCC_FLAGS=-allow-unsupported-compiler"
rem set "LD_LIBRARY_PATH=TensorRT\8.5.1.7\lib"
set "_use_new_zipfile_serialization=False"

REM Lib
REM .
set "PYENV=%USERHOME%\.pyenv\pyenv-win"
set "PYENV_ROOT=%USERHOME%\.pyenv\pyenv-win"
set "PYENV_HOME=%USERHOME%\.pyenv\pyenv-win"
set "RUSTUP_DIST_SERVER=https://mirror.sjtu.edu.cn/rust-static"
set "RUSTUP_UPDATE_ROOT=https://mirror.sjtu.edu.cn/rust-static/rustup"
set "RBENV_USE_MIRROR=CN"
set "RBENV_ROOT=%USERHOME%\Usr\Lib\rbenv"
REM Lib for Opt
REM .
set "NODE_OPTIONS=--max_old_space_size=2048"
rem set "NODE_ENV=development node postcss"
rem set "PUPPETEER_SKIP_DOWNLOAD=true"
rem set "PUPPETEER_PRODUCT=firefox npm install"
set "PUPPETEER_EXECUTABLE_PATH=%LocalAppData%\ms-playwright\chromium-1117\chrome-win\chrome.exe"
set "DENO_INSTALL=%LocalAppData%\deno"
set "PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python"
set "RUST_BACKTRACE=full"
set "RUSTFLAGS=--cfg tracing_unstable"
set "CARGO_HTTP_CHECK_REVOKE=false"
set "GOSUMDB=sum.golang.org"
REM set "ANDROID_NDK_HOME=%USERHOME%\Usr\Lib\android-ndk"

REM Bin
REM .
REM forgit
set "FORGIT_CHECKOUT_BRANCH_BRANCH_GIT_OPTS=--sort=-committerdate"

REM Opt
REM .
set "FAST_REFRESH=true"
REM kokoro-tts-cli
set "KOKORO_PATH=%USERHOME%\Usr\OptAud\Kokoro-TTS-Local"

REM clink
REM .
REM clink-terminal
set "CLINK_INPUTRC=%CMDER_ROOT%\config"
set "CLINK_FZF_PREVIEW_SIXELS=0"
SET CLINK_PATH=^
%    =%%USERHOME%\Usr\Source\clink\clink-gizmos;^
%    =%%USERHOME%\Usr\Source\clink\clink-zoxide;^
%    =%%USERHOME%\Usr\Source\clink\clink-terminal\scripts;^
%    =%%CLINK_PATH%

SET PATH=^
%    =%%USERHOME%\Usr\Source\clink\clink-terminal\bin;^
%    =%%PATH%

REM Aliases
for %%f in (
	"%USERHOME%\Usr\Git\dotfiles\.config\alias.yaml"
	"%CMDER_ROOT%\config\.alias.yaml"
) do if exist "%%f" (
	for /f "tokens=1,2 delims==" %%a in ('yq -o props "... comments = """"" --properties-separator="=" "%%f"') do (
		if "%%a" NEQ "" doskey %%a=%%b $*
	)
)

call "refrenv"
