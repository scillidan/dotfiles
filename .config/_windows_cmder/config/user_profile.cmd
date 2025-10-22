@echo off

set "LC_ALL=en_US.utf8"
set "LANG=en_US.utf8"
set "CHANGE_LOG_NAME=User"
set "SYS_ARCH=64"

rem Lib
set "PYENV=%USERPROFILE%\.pyenv\pyenv-win"
set "PYENV_ROOT=%USERPROFILE%\.pyenv\pyenv-win"
set "PYENV_HOME=%USERPROFILE%\.pyenv\pyenv-win"
set "RUSTUP_DIST_SERVER=https://mirror.sjtu.edu.cn/rust-static"
set "RUSTUP_UPDATE_ROOT=https://mirror.sjtu.edu.cn/rust-static/rustup"
set "RBENV_USE_MIRROR=CN"
set "RBENV_ROOT=%USERPROFILE%\Usr\Lib\rbenv"

rem Lib for Opt
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

rem Bin
:: clink-terminal
set "CLINK_FZF_PREVIEW_SIXELS=1"

rem Opt
set "FAST_REFRESH=true"

rem OptWeb
:: kokoro-tts-cli
set "KOKORO_PATH=%USERPROFILE%\Usr\OptWeb\Kokoro-TTS-Local"

:: alass-cli
set "ALASS_FFMPEG_PATH=%SCOOP_HOME%\apps\ffmpeg\current\bin\ffmpeg.exe"
set "ALASS_FFPROBE_PATH=%SCOOP_HOME%\apps\ffmpeg\current\bin\ffprobe.exe"

:: espeak-ng
set "PHONEMIZER_ESPEAK_LIBRARY=%SCOOP_HOME%\apps\espeak-ng\current\eSpeak NG\libespeak-ng.dll"
set "PHONEMIZER_ESPEAK_PATH=%USERPROFILE%\Git\cli\espeak-ng.bat"

call "%CMDER_ROOT%\vendor\setpath.bat"
call "%USERPROFILE%\Usr\Shell\RefrEnv\refrenv.bat"
