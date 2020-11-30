# Script gets all monitors with an specific interal.
Import-Module OperationsManager

$table = @()

$monitors = Get-SCOMMonitor #| foreach-object {$_.Configuration}
Foreach ($monitor in $monitors) { 
    if ($monitor.Configuration -match "<IntervalSeconds>(?<content>.*)</IntervalSeconds>") {
        $intervalSeconds = [int]$matches['content']
        if ($intervalSeconds -le 60) {
            Write-Host $intervalSeconds -ForegroundColor Red
        } elseif ($intervalSeconds -gt 60 -and $intervalSeconds -le 600) {
            Write-Host $intervalSeconds -ForegroundColor Yellow
        } elseif ($intervalSeconds -gt 600) {
            Write-Host $intervalSeconds -ForegroundColor Green
        }
        Write-Host "Workflow:" $monitor.DisplayName
        Write-Host "MP:" ($monitor.GetManagementPack()).DisplayName

        $hash = @{
            ManagementPack = $monitor.GetManagementPack().DisplayName
            Interval = $intervalSeconds
            MonitorWorkflow = $monitor.DisplayName
        }
        $object = New-Object psobject -Property $hash
        $table += $object
        "-"*30
    }
}  

$table | Out-GridView