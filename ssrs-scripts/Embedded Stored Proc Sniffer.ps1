# NOTE: Parses .rdls for possible embedded stored procedures. 
# FV: Needs to be parameterized to take in report names to reduce data set. 
# FV: Needs to be modified to query .rdl file and select <CommandText> only.
$files = Get-ChildItem "C:\Rollins\ServSuite\Dev\SSRS\SSRS" -Filter *.rdl
foreach ($file in $files){
    $fileContent = Get-Content $file
    foreach ($line in $fileContent) {
        if ($line -ilike "*select*" -and -not ($line -ilike "*branchname*")) {
            Write-Output $file.name
            Write-Output $line
            Write-Output " "
            break
        }
    }
}