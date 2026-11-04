# --- EJERCICIOS BLOQUE 1 ---

# - Ejercicio 1
$recurso = 8080
Write-Host $recurso.GetType()
$recurso = "Puerto HTTP"
Write-Host $recurso.GetType()

# - Ejercicio 2
[int]$maxConexiones = 100
Write-Host $maxConexiones.GetType()
$maxConexiones = "Cien"

# - Ejercicio 3
[long]$tamanoBackup = 2199023255552
Write-Host $tamanoBackup.GetType()

$costeLicencia = 149.95d
$iva = 31.49d

$totalFactura = $costeLicencia + $iva
Write-Host "Resultado: $totalFactura"

# - Ejercicio 4
$fechaActual = Get-Date

Write-Host "Es el año " + $fechaActual.Year
Write-Host "La contraseña caducará en " + $fechaActual.AddDays(45)

$inicio = Get-Date
Start-Sleep -Seconds 3
$fin = Get-Date
[timespan]$tiempoTotal = $fin - $inicio
Write-Host $tiempoTotal