# NOTE: Parses .rdls for embedded stored procedures. 
# TODO: Provide parameter filters and flag to supply custom folder path.
# TODO: Try catching looks funky. Review needed.

function Get-RDLDataSetInfo ([string] $reportName, [string] $dataSetName) {

$files = Get-ChildItem "File Path Here" | Where-Object { $_.Name -like "*$reportName*.rdl" }
$rdlCollection = @()

foreach ($file in $files) {
     Try {
        $rdl = [xml] (Get-Content $file.FullName)
     }
     
     Catch {
        Write-Host "$file ==> $_.Exception.Message"
     }
     
     $DataSets = $rdl.Report.DataSets.DataSet | Where-Object { $_.Name -like "*$dataSetName*" }
     
     
     foreach ($ds in $DataSets) {       
         $rdlObject = New-Object System.Object
         $rdlObject | Add-Member -Type NoteProperty -Name ReportName -Value $file.Name
         $rdlObject | Add-Member -Type NoteProperty -Name DataSetName -Value $ds.Name
         $rdlObject | Add-member -Type NoteProperty -Name CommandText -Value $ds.Query.CommandText
         
         $rdlCollection += $rdlObject
      }    
}

$rdlCollection | Out-GridView

Write-Host "Done"
}
