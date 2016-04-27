Import-Module Variables

function Send-RDLToReportServer (
    [string] $reportName,
    [string] $folderName
)
{
   
    $rssPath = $varRSSPath
    $reportServerURL = $varReportServerURL
    $reportFolder = "reportFolder='/" + $folderName + "'"
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

