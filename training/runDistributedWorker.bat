@echo off
REM Using sets inside of ifs annoys windows, this Setlocal fixes that
Setlocal EnableDelayedExpansion

WHERE git
if !errorlevel! neq 0 echo git required, download here: https://git-scm.com/download/win
if !errorlevel! neq 0 pause & exit

if exist !APPDATA!\bakkesmod\ (
    echo Bakkesmod located at !APPDATA!\bakkesmod\ 
    goto :done
    
) else (
    echo \nBakkesmod not found at !APPDATA!\bakkesmod\ 
    echo * If you've already installed it elsewhere, you're fine *
    set /p choice=Download Bakkesmod[y/n]?:
    
    if /I "!choice!" EQU "Y" goto :install
    if /I "!choice!" EQU "N" goto :no_install
)

    :install
    echo Downloading Bakkesmod
    curl.exe -L --output !USERPROFILE!\Downloads\BakkesModSetup.zip --url https://github.com/bakkesmodorg/BakkesModInjectorCpp/releases/latest/download/BakkesModSetup.zip
    tar -xf !USERPROFILE!\Downloads\BakkesModSetup.zip -C !USERPROFILE!\Downloads\
    !USERPROFILE!\Downloads\BakkesModSetup.exe
    
    if !errorlevel! neq 0 echo \n*** Problem with Bakkesmod installation. Manually install and try again ***\n
    if !errorlevel! neq 0 pause & exit /b !errorlevel!
    
    echo Bakkesmod installed!
    goto :done

    :no_install
    goto :done    
    
    :done

python -m venv !LocalAppData!\necto\venv

CALL  !LocalAppData!\necto\venv\Scripts\activate.bat

python -m pip install git+https://github.com/Rolv-Arild/rocket-learn.git
python -m pip install -r requirements.txt -f https://download.pytorch.org/whl/torch_stable.html

if !errorlevel! neq 0 pause & exit /b !errorlevel!

set /p helper_name=Enter name: 
set /p ip=Enter IP address: 
set /p password=Enter password: 

echo.
echo #########################
echo ### Launching Worker! ###
echo #########################
echo.

python worker.py !helper_name! !ip! !password!

pause