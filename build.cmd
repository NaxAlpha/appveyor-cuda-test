@echo off

echo "Checking Cache"
mkdir "cache"
if NOT EXIST "cache/cuda.exe" (
    echo "Cache Not Found..."
    echo "Downloading CUDA toolkit 8"
    appveyor DownloadFile  https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_win10-exe -FileName cuda.exe
    move "cuda.exe" "cache/cuda.exe"
)

echo "Installing CUDA toolkit 8"
cache\cuda.exe -s compiler_8.0 ^
                  cublas_8.0 ^
                  cublas_dev_8.0 ^
                  cudart_8.0 ^
                  curand_8.0 ^
                  curand_dev_8.0

if NOT EXIST "cudnn" (
    echo "Downloading cuDNN"
    appveyor DownloadFile https://www.dropbox.com/s/1kkjlwrpvylemp6/cudnn-8.0-windows10-x64-v7.zip?dl=1 -FileName cudnn.zip
    7z x cudnn.zip -o cudnn
)

echo "Installation Test:.............."

dir cudnn
dir cudnn\cuda\bin
dir cudnn\cuda\lib 
dir cudnn\cuda\include 

dir .

dir "%ProgramFiles%"
dir "C:\Program Files"
dir "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA"
dir "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v8.0"
dir "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v8.0\bin"

if NOT EXIST "%ProgramFiles%\NVIDIA GPU Computing Toolkit\CUDA\v8.0\bin\cudart64_80.dll" ( 
echo "Failed to install CUDA"
exit /B 1
)

set PATH=%ProgramFiles%\NVIDIA GPU Computing Toolkit\CUDA\v8.0\bin;%ProgramFiles%\NVIDIA GPU Computing Toolkit\CUDA\v8.0\libnvvp;%PATH%

nvcc -V
