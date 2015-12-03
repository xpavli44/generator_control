param([string]$UserCount = "10", $FilePath = "C:\CUGen\WDtest\", $FileName = "config.properties", $TimeToRunMins = "50")

#change configuration files
(Get-Content ($FilePath + $FileName)) | Foreach-Object {$_ -replace '^concurrentUsersCount=.+$', ("concurrentUsersCount=" + $UserCount)} | Set-Content  ($Filepath + $FileName)

(Get-Content ($FilePath + $FileName)) | Foreach-Object {$_ -replace '^userQueueLentght=.+$', ("userQueueLentght=" + $UserCount)} | Set-Content  ($Filepath + $FileName)
(Get-Content ($FilePath + $FileName)) | Foreach-Object {$_ -replace '^timeToRunMins=.+$', ("timeToRunMins=" + $TimeToRunMins)} | Set-Content  ($Filepath + $FileName)