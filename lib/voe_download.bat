@echo off
setlocal enabledelayedexpansion

set /p movie_name="Please enter the name of the film (a-Z [0-9]): "

set /p playlist_url="Please enter the link to the playlist: (index-v1-a1.m3u8) "

REM Extracting the base URL from the playlist link.
for /f "tokens=1,* delims=?" %%a in ("%playlist_url%") do (
    set "base_url=%%a"
)

REM Removing the part "index-v1-a1.m3u8" from the base URL.
set "base_url=!base_url:index-v1-a1.m3u8=!"

REM Downloading the playlist into the current directory.
echo Downloading playlist...
curl -o playlist.m3u8 "%playlist_url%" || (
    echo Error: The playlist could not be downloaded.
    exit /b
)

REM Creating the output directory if it doesn't exist.
set "output_folder=%CD%\segments"
if not exist "%output_folder%" (
    mkdir "%output_folder%" || (
        echo Error: The target directory could not be created.
        exit /b
    )
)

@echo off
REM Downloading the files from the playlist.
setlocal enabledelayedexpansion
set "counter=1"
for /f "tokens=* delims=" %%a in ('type "playlist.m3u8" ^| find "seg-"') do (
    set "line=%%a"
    if "!line:~0,1!"=="#" (
        rem This line is a comment line, so we'll skip it.
        continue
    )
    set "filename=00000000!counter!.ts"
    set "filename=!filename:~-9!"
    set /a counter+=1
    set "url=!line!"
    set "complete_url=!base_url!!url!"
    echo Herunterladen: !filename!
    curl -o "%output_folder%\!filename!" "!complete_url!" || (
        echo Error: Downloading !filename! failed.
    )
)

REM Deleting the downloaded playlist.
del playlist.m3u8

REM CALLING THE CONVERTER SCRIPT
%CD%\lib\voe_convert.bat !movie_name!
