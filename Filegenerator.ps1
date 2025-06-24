Measure-Command {
    $bigFileName = 'plc_log.txt'
    $plcNames = 'PLC_A','PLC_B','PLC_C','PLC_D'
    $errorTypes = 'Sandextrator overload', 'Conveyor misalignment', 'Valve stuck', 'Temperature warning'
    $statusCodes = 'OK','WARN','ERR'

    $writer = [System.IO.StreamWriter]::new($bigFileName, $false)
    $rnd = [System.Random]::new()

    for ($i = 0; $i -lt 50000; $i++) {
        $timestamp = [DateTime]::Now.AddSeconds(-$i).ToString('yyyy-MM-dd HH:mm:ss')
        $plc = $plcNames[$rnd.Next(0, $plcNames.Length)]
        $operator = $rnd.Next(101,121)
        $batch = $rnd.Next(1000,1101)
        $status = $statusCodes[$rnd.Next(0, $statusCodes.Length)]
        $machineTemp = [math]::Round(($rnd.Next(60,110)) + ($rnd.Next()),2)
        $load = $rnd.Next(0,101)

        (($rnd.Next(1,8)) -eq 4) ? {
            $errorType = $errorTypes[$rnd.Next(0, $errorTypes.Length)]
            ($errorType -eq 'Sandextrator overload') ? {
                $value = $rnd.Next(1,11);
                $writer.WriteLine("ERROR; $timestamp; $plc; $errorType; $value; $status; $operator; $batch; $machineTemp; $load")
            } : {
                $writer.WriteLine("ERROR; $timestamp; $plc; $errorType; ; $status; $operator; $batch; $machineTemp; $load")
            }
        } : {
            $writer.WriteLine("INFO; $timestamp; $plc; System running normally; ; $status; $operator; $batch; $machineTemp; $load")
        }
    }
    $writer.Close();$writer.Dispose();[Console]::WriteLine('PLC log file generated.')
}