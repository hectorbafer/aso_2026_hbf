$logsWeb = @"
POST /api/v1/auth/login?session=a8f93j2&token=expired [IP: 192.168.10.45] [Agent: Mozilla/5.0] [ERR-0040-AUTH]
GET /api/v2/products/search?q=laptop&sort=asc [IP: 10.0.2.15] [Agent: Chrome/110.0] [ERR-0200-OK]
DELETE /api/v1/admin/drop_table?confirm=true&force=1 [IP: 172.16.254.88] [Agent: ScriptBot/1.2] [ERR-0500-FATAL]
GET /api/v1/user/profile?id=9921&token=xyz [IP: 192.168.10.102] [Agent: Firefox/109.0] [ERR-0403-FORBIDDEN]
"@

$lineas = $logsWeb.Split("`n")

$resultados = foreach($linea in $lineas){
    $lineaLimpia = $linea.Trim()
    if ($lineaLimpia.Length -eq 0) {
        continue
    }

    $bloques = $lineaLimpia -split " \["
    $peticion = $bloques[0]
    $ipBloque = $bloques[1]
    $agentBloque = $bloques[2]
    $errBloque = $bloques[3]

    Write-Host "Procesando codigo de error..."
    $errorTexto = $errBloque.Replace("]", "").Trim()

    if($errorTexto -eq "ERR-0200-OK"){
        continue
    }

    $partesError = $errorTexto.Split("-")
    $codigoError = $partesError[1]
    Write-Host "Codigo aislado: $codigoError"

    Write-Host "Procesando peticion HTTP..."
    $partesPeticion = $peticion.Split(" ")
    $metodo = $partesPeticion[0]
    $urlCompleta = $partesPeticion[1]

    if($urlCompleta.Contains("?")){
        $indiceInterrogacion = $urlCompleta.IndexOf("?")
        $rutaLimpia = $urlCompleta.Substring(0, $indiceInterrogacion)
    } else {
        $rutaLimpia = $urlCompleta
    }
    Write-Host "Metodo: $metodo | Ruta: $rutaLimpia"

    Write-Host "Procesando direccion IP..."
    $ipCruda = $ipBloque.Replace("IP:", "").Replace("]", "").Trim()
    
    $ultimoPunto = $ipCruda.LastIndexOf(".")
    $ipEnmascarada = $ipCruda.Substring(0, $ultimoPunto + 1) + "***"
    Write-Host "IP Enmascarada: $ipEnmascarada"

    $agente = $agentBloque.Replace("Agent:", "").Replace("]", "").Trim()

    [PSCustomObject]@{
        Metodo      = $metodo
        Ruta        = $rutaLimpia
        IP          = $ipEnmascarada
        Agente      = $agente
        CodigoError = $codigoError
    }
}

$resultados | Export-Csv -Path "auditoria_web.csv" -NoTypeInformation -Encoding UTF8