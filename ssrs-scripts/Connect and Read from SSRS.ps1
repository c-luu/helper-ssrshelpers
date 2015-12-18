$reportServerUri = "insert Uri Here"

# NOTE: By specifying -Namespace "SSRS" we place all generated types from wsdl into .NET namespace called SSRS:
$rs = New-WebServiceProxy -Uri $reportServerUri -UseDefaultCredential -Namespace "SSRS"

<#
$replicatedReports = $rs.Listchildren("/", $true) | Where-Object { $_.Path -like "/Reports/Replicated/*" }
$replicatedReports 
#>

# List everything on the Report Server, recursively.
$catalogItems = $rs.ListChildren("/", $true)
# $catalog

# List all Linked Reports, together w/ the path of the Report it refers to:
$linkedReports = $rs.ListChildren("/", $true)  | Where-Object { $_.TypeName -eq "LinkedReport" }
Write-Output $linkedReports
 $results = $linkedReports | ForEach-Object {
    $linkPath = $rs.GetItemLink($_.Path)
    $result = New-Object PSObject -Property @{ LinkName = $_.Name; LinkPath = $_.Path; ReportPath = $linkPath }
    $result
} 


# Write-Output $results

# List all Linked Reports that refer to reports in a specific folder:
$results | Where-Object { $_.ReportPath -like "/Reports/Replicated/*" }

