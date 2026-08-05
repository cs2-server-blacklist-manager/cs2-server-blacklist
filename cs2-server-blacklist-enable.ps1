if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}
try {
    $res = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/cs2-server-blacklist-manager/cs2-server-blacklist/refs/heads/main/blacklist.txt" -ErrorAction Stop -UseBasicParsing
    Get-NetFirewallRule -DisplayName "Counter-Strike 2 Server Blacklist" -ErrorAction SilentlyContinue | Remove-NetFirewallRule
    $res.Content -split "\r?\n" | Where-Object {$_ -match "\S"} | ForEach-Object {
        Write-Host Blacklisted $_
        New-NetFirewallRule -DisplayName "Counter-Strike 2 Server Blacklist" -Direction Outbound -Action Block -RemoteAddress $_ | Out-Null
    }
} catch {
    Write-Warning "Downloading blacklist failed with status code $($_.Exception.Response.StatusCode.Value__)"
}
