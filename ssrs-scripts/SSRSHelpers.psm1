# NOTE: Parses .rdls for embedded stored procedures. 
# TODO: Finish abstracting/ renaming Get-RDLObjectCollection func
# TODO: Provide parameter filters and flag to supply custom folder path.
# TODO: Try catching looks funky. Review needed.



function Get-RDLDataSetInfo ([string] $reportName, [string] $dataSetName) {

. Get-ScriptDirectory + "\Variables.ps1"

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

<#function Get-RDLObjectCollection ($dataSets, [string] $fileName) {
    $rdlCollection = @()
    foreach ($ds in $dataSets) {       
         $rdlObject = New-Object System.Object
         $rdlObject | Add-Member -Type NoteProperty -Name ReportName -Value $fileName
         $rdlObject | Add-Member -Type NoteProperty -Name DataSetName -Value $ds.Name
         $rdlObject | Add-member -Type NoteProperty -Name CommandText -Value $ds.Query.CommandText
         
         $rdlCollection += $rdlObject
      }
      
      return $rdlCollection    
}#>


# NOTE: Deploy-RDLToReplicated deploys reports to the Replicated path on SSRS and Live if the flag is set.
# TODO: Secure sensitive parameter values. Have try catching. Be able to choose Replicated And/Or Live folders.

function Deploy-RDLToReplicated (
    [string] $reportName,
    [switch] $goLive
)
{
    . Get-ScriptDirectory + "\Variables.ps1"
    
    $rssPath = $varRSSPath
    $reportServerURL = $varReportServerURL
    $reportFolder = $varReportFolder
    $reportShare = $varReportShare + $reportName + ".rdl'" 
    $reportName = "reportName='" + $reportName + "'"
    $dataSourceName = $varDataSourceName
    $dataSourceFullPath = $varDataSourceFullPath
    $reportHidden = $varReportHidden
    $oneLine = "rs.exe -i $rssPath -s $reportServerURL -v $reportFolder -v $reportShare -v $reportName -v $dataSourceName -v $dataSourceFullPath -v $reportHidden"
    
    if (!$goLive) {
        Invoke-Expression $oneLine
    }
    
    else {
        Invoke-Expression $oneLine
        
        $reportFolder = $varLiveReportFolder
        $dataSourceName = $varLiveDataSourceName
        $dataSourceFullPath = $varLiveDataSourceFullPath
        $oneLine = "rs.exe -i $rssPath -s $reportServerURL -v $reportFolder -v $reportShare -v $reportName -v $dataSourceName -v $dataSourceFullPath -v $reportHidden"
        
        Invoke-Expression $oneLine
    }
}

function Get-ScriptDirectory {
    return $MyDir = Split-Path $MyInvocation.MyCommand.Definition
}
