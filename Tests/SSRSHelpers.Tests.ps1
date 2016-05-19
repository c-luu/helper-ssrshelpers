# Import-Module $PSScriptRoot\..\SSRSHelpers -Force
Import-Module SSRSHelpers

# NOTE: This is to test private items
InModuleScope SSRSHelpers {
	Describe "Get-DataSetInfo" {
		BeforeEach {
			$TestDataSetInfo = New-Object System.Object
			$TestDataSetInfo | Add-Member -Type NoteProperty -Name ReportName -Value "TestReportName"
			$TestDataSetInfo | Add-Member -Type NoteProperty -Name DataSetName -Value "TestDataSetName"
			$TestDataSetInfo | Add-Member -Type NoteProperty -Name CommandText -Value "TestCommandText"
		}

		AfterEach {

		}

		$TestRdlPath = "TestDrive:\TestReportName.rdl"
		Set-Content $TestRdlPath -Value  '<?xml version="1.0" encoding="UTF-8"?>
<Report xmlns="http://schemas.microsoft.com/sqlserver/reporting/2003/10/reportdefinition" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner">
  <DataSets>
    <DataSet Name="TestDataSetName">
      <Query>
        <CommandText>
		TestCommandText
		</CommandText>
      </Query>
    </DataSet>
  </DataSets>
</Report>'
		
		It "Returns the test DataSetInfo object" {
			Get-DataSetInfo -RdlFilePath "TestDrive:\TestReportName.rdl" -DataSetName "TestDataSetName" | Should Be $TestDataSetInfo
		}
	}
}
