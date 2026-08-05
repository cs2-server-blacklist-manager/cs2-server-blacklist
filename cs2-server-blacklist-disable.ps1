if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}
Get-NetFirewallRule -DisplayName "Counter-Strike 2 Server Blacklist" -ErrorAction SilentlyContinue | Remove-NetFirewallRule
