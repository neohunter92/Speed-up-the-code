Measure-Command{
$bigFileName = "plc_log.txt"
$plcNames = 'PLC_A','PLC_B','PLC_C','PLC_D'
$errorTypes = @(
    'Sandextrator overload',
    'Conveyor misalignment',
    'Valve stuck',
    'Temperature warning'
)
$statusCodes = 'OK','WARN','ERR'
 
# $logLines = @()
$logLines = [System.Collections.Generic.List[psobject]]::new()
$rnd = [System.Random]::new()
 
for ($i=0; $i -lt 50000; $i++) {
    $timestamp = (Get-Date).AddSeconds(-$i).ToString("yyyy-MM-dd HH:mm:ss")
    # $plc = Get-Random -InputObject $plcNames
    $plc = Get-Random -InputObject $plcNames
    $operator = $rnd.Next(101,121)
    $batch = $rnd.Next( 1000,1101)
    $status = Get-Random -InputObject $statusCodes
    $machineTemp = [math]::Round(($rnd.Next(60,110)) + ($rnd.Next()),2)
    # $machineTemp = [math]::Round((Get-Random -Minimum 60 -Maximum 110) + (Get-Random),2)
    $load = $rnd.Next(0, 101)
 
    if (($rnd.Next( 1, 8)) -eq 4) {
        $errorType =  Get-Random -InputObject $errorTypes
        if ($errorType -eq 'Sandextrator overload') {
            $value = $rnd.Next( 1 ,11)
            $msg = "ERROR; $timestamp; $plc; $errorType; $value; $status; $operator; $batch; $machineTemp; $load"
        } else {
            $msg = "ERROR; $timestamp; $plc; $errorType; ; $status; $operator; $batch; $machineTemp; $load"
        }
    } else {
        $msg = "INFO; $timestamp; $plc; System running normally; ; $status; $operator; $batch; $machineTemp; $load"
    }
 
    # $logLines += $msg
    $logLines.Add($msg)
}
 
$null = Set-Content -Path $bigFileName -Value $logLines
$null = Write-Output "PLC log file generated."
}