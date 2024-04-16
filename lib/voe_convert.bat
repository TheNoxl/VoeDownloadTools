@echo off
setlocal enabledelayedexpansion

rem Set the path to the folder containing the .ts segment files
set "FolderPath=%CD%\segments"

rem Set the path and name for the combined .ts file
set "OutputFilePath=%CD%\%1.ts"

rem Create a temporary text file with the names of the .ts files
set "ConcatenatedSegmentsFile=%FolderPath%\segments.txt"
if exist "%ConcatenatedSegmentsFile%" del "%ConcatenatedSegmentsFile%"

setlocal enabledelayedexpansion

rem Set the path to the folder containing the .ts segment files
set "FolderPath=%CD%\segments"

rem Set the path and name for the combined .ts file
set "OutputFilePath=%CD%\%1.ts"

rem Create a temporary text file with the names of the .ts files
set "ConcatenatedSegmentsFile=%FolderPath%\segments.txt"
if exist "%ConcatenatedSegmentsFile%" del "%ConcatenatedSegmentsFile%"

rem List all .ts files in the folder and append them to the combined file
for %%i in ("%FolderPath%\*.ts") do (
    echo file '%%i'>>"%ConcatenatedSegmentsFile%"
)


rem Use FFmpeg to concatenate the segment files
%CD%\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe -f concat -safe 0 -i "%ConcatenatedSegmentsFile%" -c copy "%OutputFilePath%"

rem Delete all files in the "segments" folder
del /Q "%FolderPath%\*.*"
