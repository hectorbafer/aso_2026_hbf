$logsWeb = @"
POST /api/v1/auth/login?session=a8f93j2&token=expired [IP: 192.168.10.45] [Agent: Mozilla/5.0] [ERR-0040-AUTH]
GET /api/v2/products/search?q=laptop&sort=asc [IP: 10.0.2.15] [Agent: Chrome/110.0] [ERR-0200-OK]
DELETE /api/v1/admin/drop_table?confirm=true&force=1 [IP: 172.16.254.88] [Agent: ScriptBot/1.2] [ERR-0500-FATAL]
GET /api/v1/user/profile?id=9921&token=xyz [IP: 192.168.10.102] [Agent: Firefox/109.0] [ERR-0403-FORBIDDEN]
"@

$lineas = $logsWeb.Split("`n")

$separador = $linea -split "["
$peticion = $separador[0]
$ip = $separador[1]
$agente = $separador[2]
$fallo = $separador[3]

# Ignorar el error de OK
if($fallo -eq "OK"){
    continue
}

$agente = $agente.Replace("Agent: ","").Trim()
Write-Host $agente
