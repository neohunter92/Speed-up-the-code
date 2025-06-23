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
 
$logLines = [System.Collections.Generic.List[psobject]]::new(50000)
$rnd = [System.Random]::new()
 
for ($i=0; $i -lt 50000; $i++) {
    $timestamp = [DateTime]::Now.AddSeconds(-$i).ToString("yyyy-MM-dd HH:mm:ss")
    $plc = $plcNames[$rnd.Next(0, $plcNames.Count)]
    $operator = $rnd.Next(101,121)
    $batch = $rnd.Next( 1000,1101)
    $status = $statusCodes[$rnd.Next(0, $statusCodes.Count)]
    $machineTemp = [math]::Round(($rnd.Next(60,110)) + ($rnd.Next()),2)
    $load = $rnd.Next(0, 101)
 
    if (($rnd.Next( 1, 8)) -eq 4) {
        $errorType =  $errorTypes[$rnd.Next(0, $errorTypes.Count)]
        if ($errorType -eq 'Sandextrator overload') {
            $value = $rnd.Next( 1 ,11)
            $msg = "ERROR; $timestamp; $plc; $errorType; $value; $status; $operator; $batch; $machineTemp; $load"
        } else {
            $msg = "ERROR; $timestamp; $plc; $errorType; ; $status; $operator; $batch; $machineTemp; $load"
        }
    } else {
        $msg = "INFO; $timestamp; $plc; System running normally; ; $status; $operator; $batch; $machineTemp; $load"
    }
 
    $logLines.Add($msg)
}
 
$null = [System.IO.File]::WriteAllLines($bigFileName, $logLines)
$null = [Console]::WriteLine("PLC log file generated.")
}