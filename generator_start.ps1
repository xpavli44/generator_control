param([string]$FilePath = "C:\CUGen\WDtest\", $FileName = "run.bat")
cd $FilePath
#start generator
#Start-Process -FilePath java.exe -ArgumentList ("-jar", $p, "-classpath $ENV:CLASSPATH", "-NoNewWindow")
#Start-Process -File $p
& .\$FileName