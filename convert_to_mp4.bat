@echo off
set /p input="Please enter the file path of the input file: "
set /p output="Please enter the file path for the output file (including filename and extension): "

.\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe -i "%input%" -c:v libx264 "%output%"

pause
