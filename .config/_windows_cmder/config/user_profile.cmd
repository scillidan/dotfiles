@echo off

set "LC_ALL=en_US.utf8"
set "LANG=en_US.utf8"
set "CHANGE_LOG_NAME=User"
set "SYS_ARCH=64"

rem Lib
set "NVM_HOME=%USERPROFILE%\Scoop\apps\nvm\current"
set "NVM_SYMLINK=%USERPROFILE%\Scoop\persist\nvm\nodejs\nodejs"
set "PNPM_HOME=%USERPROFILE%\.pnpm"
set "PIPX_HOME=%USERPROFILE%\.pipx"
set "PYENV=%USERPROFILE%\.pyenv\pyenv-win"
set "PYENV_ROOT=%USERPROFILE%\.pyenv\pyenv-win"
set "PYENV_HOME=%USERPROFILE%\.pyenv\pyenv-win"
set "CARGO_HOME=%USERPROFILE%\.cargo"
set "CARGO_TARGET_DIR=%USERPROFILE%\.cargo\tmp"
set "RUSTUP_DIST_SERVER=https://mirror.sjtu.edu.cn/rust-static"
set "RUSTUP_UPDATE_ROOT=https://mirror.sjtu.edu.cn/rust-static/rustup"
set "GOPATH=%USERPROFILE%\.go"
set "GOROOT=%USERPROFILE%\Scoop\apps\go\current"
:: set "GOROOT=%USERPROFILE%\Usr\Lib\go1.20.1"
set "LUA_PATH_5_3=%USERPROFILE%\Lib\lua53\x64"
set "LUA_CPATH_5_3=%USERPROFILE%\Lib\lua53\x64"
set "RBENV_USE_MIRROR=CN"
set "RBENV_ROOT=%USERPROFILE%\Usr\Lib\rbenv"

rem Lib opt
set "NODE_OPTIONS=--max_old_space_size=2048"
:: set "NODE_ENV=development node postcss"
:: set "PUPPETEER_SKIP_DOWNLOAD=true"
:: set "PUPPETEER_PRODUCT=firefox npm install"
set "PUPPETEER_EXECUTABLE_PATH=%LocalAppData%\ms-playwright\chromium-1117\chrome-win\chrome.exe"
set "DENO_INSTALL=%LocalAppData%\deno"
set "PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python"
set "RUST_BACKTRACE=full"
set "RUSTFLAGS=--cfg tracing_unstable"
set "CARGO_HTTP_CHECK_REVOKE=false"
set "GOSUMDB=sum.golang.org"
:: set "ANDROID_NDK_HOME=%USERPROFILE%\Usr\Lib\android-ndk"

rem CUDA
:: set "CUDNN=%CUDNN%"
set "HF_MODEL_ROOT=C:\huggingface\model"
set "HF_DATASET_ROOT=C:\huggingface\dataset"
set "HF_MIRROR=https://hf-mirror.com"
:: set "HF_MIRROR=https://huggingface.co"
:: set "HF_ENDPOINT=https://hf-mirror.com"
set "HF_HUB_ENABLE_HF_TRANSFER=1"
set "NVCC_FLAGS=-allow-unsupported-compiler"
:: set "LD_LIBRARY_PATH=TensorRT\8.5.1.7\lib"
set "_use_new_zipfile_serialization=False"

rem Opt
set "FAST_REFRESH=true"

:: alass-cli
set "ALASS_FFMPEG_PATH=%USERPROFILE%\Scoop\apps\ffmpeg\current\bin\ffmpeg.exe"
set "ALASS_FFPROBE_PATH=%USERPROFILE%\Scoop\apps\ffmpeg\current\bin\ffprobe.exe"

:: espeak-ng
set "PHONEMIZER_ESPEAK_LIBRARY=%USERPROFILE%\Scoop\apps\espeak-ng\current\eSpeak NG\libespeak-ng.dll"
set "PHONEMIZER_ESPEAK_PATH=%USERPROFILE%\Git\cli\espeak-ng.bat"

:: kokoro-tts-cli
:: set "KOKORO_PATH=%USERPROFILE%\Usr\OptWeb\Kokoro-TTS-Local"

:: aeneas
:: set "AENEAS_FORCE_CEW=True"
:: set "AENEAS_FORCE_CFW=True"

:: dedoc
:: set "DEDOC_HOME=%USERPROFILE%\Data\dedoc"

:: gh
:: set "GH_CONFIG_DIR=%USERPROFILE%\.config\gh"

:: lunarvim
:: set "XDG_DATA_HOME=%APPDATA%"
:: set "XDG_CONFIG_HOME=%HOME%\AppData\Local"
:: set "XDG_CACHE_HOME=%LocalAppData%\Temp"
:: set "XDG_RUNTIME_DIR=%LocalAppData%\Temp"
:: set "LUNARVIM_BASE_DIR=%APPDATA%\lunarvim\lvim"
:: set "LUNARVIM_CACHE_DIR=%LocalAppData%\Temp\lvim"
:: set "LUNARVIM_CONFIG_DIR=%LocalAppData%\lvim"
:: set "LUNARVIM_RUNTIME_DIR=%APPDATA%\lunarvim"

:: nvim
:: set "VISUAL=subl"

:: pm2
:: set "PM2_HOME=C:\ProgramData\pm2\home"
:: set "PM2_INSTALL_DIRECTORY=C:\ProgramData\npm\npm\node_modules\pm2"
:: set "PM2_SERVICE_DIRECTORY=C:\ProgramData\pm2\service"

:: rename
:: set "RENAME_EDITOR=subl -w"

:: rime-ls
:: set "LIBRIME_LIB_DIR=%USERPROFILE%\Usr\Lib\rime\dist\lib"
:: set "LIBRIME_INCLUDE_DIR=%USERPROFILE%\Usr\Lib\rime\dist\include"
:: set "LIB=%USERPROFILE%\Usr\Lib\rime\dist\lib"

:: rsync
:: set "CWRSYNCHOME="

:: wim
:: set "PYTHONHOME=%LocalAppData%\Programs\Python\Python310"
:: set "PYTHONPATH=%LocalAppData%\Programs\Python\Python310\python.exe"
:: set "PYTHONIOENCODING=UTF-8"
:: set "DYNAMIC_PYTHON3_DLL=%LocalAppData%\Programs\Python\Python310\python310.dll"

call "%CMDER_ROOT%\vendor\setpath.bat"
call "%USERPROFILE%\Usr\Shell\RefrEnv\refrenv.bat"
