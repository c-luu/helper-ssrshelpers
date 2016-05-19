# Import-Module Variables

function Get-RDLDataSetInfo ([string] $reportName, [string] $dataSetName) {

$files = Get-ChildItem $varRDLFolderPath | Where-Object { $_.Name -like "*$reportName*.rdl" }
$rdlCollection = @()

foreach ($file in $files) {
     Try {
        $rdl = [xml] (Get-Content $file.FullName)
         $DataSets = $rdl.Report.DataSets.DataSet | Where-Object { $_.Name -like "*$dataSetName*" }
     
     #$rdlCollection = Get-RDLObjectCollection $DataSets, $file.Name

     foreach ($ds in $DataSets) {       
         $rdlObject = New-Object System.Object
         $rdlObject | Add-Member -Type NoteProperty -Name ReportName -Value $file.Name
         $rdlObject | Add-Member -Type NoteProperty -Name DataSetName -Value $ds.Name
         $rdlObject | Add-member -Type NoteProperty -Name CommandText -Value $ds.Query.CommandText
         
         $rdlCollection += $rdlObject
      }    
     }
     
     Catch {
        Write-Host "$file ==> $_.Exception.Message"
     }  
}

$rdlCollection | Out-GridView

Write-Host "Done"
}





