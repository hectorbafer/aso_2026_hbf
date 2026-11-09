$logCrudo = @"
[INFO] ID:8842 :: 2023/11/01_10:00 :: User:admin_01 :: Action:Login_Success
[ERROR] ID:9921 :: 2023/11/01_10:05 :: User:guest_user :: Action:Auth_Fail (Pass)
[WARN] ID:8843 :: 2023-11-01 10:15 :: User:dev_team :: Action:Upload_Limit_Exceeded
[CRITICAL] ID:1001 :: 01-11-2023_10:20 :: User:ROOT :: Action:Service_Stop
"@

$lineas = $logCrudo.Split("`n")

foreach($linea in $lineas){
    if($linea.Substring(1,4) -eq "INFO"){
        continue
    }
    $separador = $linea -split " :: "
    $id = $separador[0]
    $fecha = $separador[1]
    $user = $separador[2]
    $accion = $separador[3]

    # [ERROR] ID:9921
    Write-Host "Procesando $id..."

    $id = $id.Replace("[","").Replace("]","").Replace("ID:","")
    $fallo = $id.Split(" ")[0].Trim()
    $identificador = $id.Split(" ")[1].Trim()

    Write-Host $identificador

    # 2023/11/01_10:00
    Write-Host "Procesando $fecha..."

    $fecha_hora = $fecha.Replace("_"," ").Replace("/","-").Trim()
    $fecha_list = $fecha.Split(" ")
    $fecha = $fecha_list[0]
    $hora = $fecha_list[1]

    $horas = $hora.Split(":")[0]
    $minutos = $hora.Split(":")[1]

    if($fecha[2] -eq "-"){
        $dia = $fecha.Split("-")[0]
        $mes = $fecha.Split("-")[1]
        $anio = $fecha.Split("-")[2]
    }
    else{
        $dia = $fecha.Split("-")[2]
        $mes = $fecha.Split("-")[1]
        $anio = $fecha.Split("-")[0]
    }

    $fecha_limpia = Get-Date -Year $anio -Month $mes -Day $dia -Hour $horas -Minute $minutos

    Write-Host $fecha_limpia

    # User:admin_01
    Write-Host "Procesando $user..."

    $user = $user.ToLower().Replace("User:","").Trim()

    if($user -eq "ROOT"){
        $user = $user.Replace("ROOT","administrador")
    }
    Write-Host $user

    # Action:Login_Success
    Write-Host "Procesando $accion..."

    $accion = $accion.Replace("Action:","").Trim()
    Write-Host $accion

    [PSCustomObject]@{
        TimeStamp = $fecha_limpia
        Severity = $fallo
        User = $user
        EventID = $identificador
        Action = $accion 
    }
}

$reportes = Export-Csv "reporte_seguridad.csv"