function Get-DataSetInfo {
	[cmdletbinding()]
	param(
		[string] $RdlFilePath,
		[string] $DataSetName
	)

	$Rdl = [xml] (Get-Content $RdlFilePath.FullName)
	$DataSet = $Rdl.Report.DataSets.DataSet | Where-Object { $_.Name -eq $DataSetName }
	$DataSetInfo = New-Object System.Object

	$DataSetInfo | Add-Member -Type NoteProperty -Name ReportName -Value $RdlFilePath.Name
	$DataSetInfo | Add-Member -Type NoteProperty -Name DataSetName -Value $DataSet.Name
	$DataSetInfo | Add-Member -Type NoteProperty -Name CommandText -Value $DataSet.Query.CommandText

	return $DataSetInfo
}
