param([string]$UserCount = "10", $FilePath = "C:\CUGen\WDtest\Reports\", $FileName1 = "report_" + $env:computername + "_0.csv", $FileName2 = "report_" + $env:computername + "_GlogalReport.csv", $Part = "")
#full path to originals
$OriginalFile1 = $FilePath + $FileName1
$OriginalFile2 = $FilePath + $FileName2

#create filnames for copies
If ($Part -eq $null){
$CopyFileName1 = "report_" + $env:computername + "_" + $UserCount + "_users.csv"
$CopyFileName2 = "report_" + $env:computername + "_GlobalReport_" + $UserCount + "_users.csv"
}
Else{
$CopyFileName1 = "report_" + $env:computername + "_" + $UserCount + "_users_part_" + $Part + ".csv"
$CopyFileName2 = "report_" + $env:computername + "_GlobalReport_" + $UserCount + "_users_part_" + $Part + ".csv"
}

#full path for copied files
$CopyFile1 = $FilePath + $CopyFileName1
$CopyFile2 = $FilePath + $CopyFileName2

#actual copy command
Copy-Item $OriginalFile1 $CopyFile1
Copy-Item $OriginalFile2 $CopyFile2