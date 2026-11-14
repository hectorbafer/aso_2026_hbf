$logsWeb = @"
POST /api/v1/auth/login?session=a8f93j2&token=expired [IP: 192.168.10.45] [Agent: Mozilla/5.0] [ERR-0040-AUTH]
GET /api/v2/products/search?q=laptop&sort=asc [IP: 10.0.2.15] [Agent: Chrome/110.0] [ERR-0200-OK]
DELETE /api/v1/admin/drop_table?confirm=true&force=1 [IP: 172.16.254.88] [Agent: ScriptBot/1.2] [ERR-0500-FATAL]
GET /api/v1/user/profile?id=9921&token=xyz [IP: 192.168.10.102] [Agent: Firefox/109.0] [ERR-0403-FORBIDDEN]
"@

$lineas = $logsWeb.Split("`n")

$parametros=foreach($linea in $lineas){
    if($linea.Contains("[ERR-0200-OK]")){
        continue
    }

    # Extrayendo metodo
    $espacio = $linea.IndexOf(" ")
    $metodo = $linea.Substring(0,"$espacio")
    $linea = $linea.Substring($espacio).Trim()

    # Extrayendo url
    $espacio = $linea.IndexOf(" ")
    $url = $linea.Substring(0,$espacio)
    $url = $url.Split("?")[0]
    $linea = $linea.Substring($espacio).Trim()

    # Extrayendo IP
    $lista = $linea -Split "] \["
    $ip = $lista[0]
    $agente = $lista[1]
    $err = $lista[2]
    
    $ip = $ip.Replace("[IP: ", "")

    # Sustituir octeto
    $ip = $ip.Split(".")
    $octeto1 = $ip[0]
    $octeto2 = $ip[1]
    $octeto3 = $ip[2]
    $octeto4 = $ip[3]
    $octeto4 = "***"
    $ip = $octeto1+"."+$octeto2+"."+$octeto3+"."+$octeto4
    
    # Extrayendo error
    $err = $err.Replace("]", "").Trim()
    $errPartes = $err.Split("-")
    $codigo = $errPartes[1]
    Write-Host $codigo

    # Extrayendo agente
    $agente = $agente.Replace("Agent: ", "").Replace("]", "").Trim()
    $agentelimpio = $agente
    Write-Host $agentelimpio

    [PSCustomObject]@{
        Method = $metodo
        CleanPath = $url
        Maskedip = $ip
        ErrorCode = $codigo
        Agente = $agentelimpio
    }
}

$parametros | Export-Csv -Path "auditoria_web.csv" -Encoding UTF8 -NoTypeInformation
