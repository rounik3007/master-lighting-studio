# ==============================================================================
# Master Lighting CLI Control Panel (Colored Fonts Menu Edition)
# Devices: Philips WiZ Lamp (192.168.29.35:38899) & Gigabyte G6 KF Keyboard
# ==============================================================================

$WizIP     = '192.168.29.35'
$WizPort   = 38899
$ClevoTool = 'C:\ClevoKB\CLEVO_KeyboardColour.exe'

function Set-WiZState ($payload) {
    try {
        $u = [System.Net.Sockets.UdpClient]::new()
        $u.Connect($WizIP, $WizPort)
        $b = [System.Text.Encoding]::ASCII.GetBytes($payload)
        [void]$u.Send($b, $b.Length)
        $u.Close()
    } catch {
        Write-Host " [!] WiZ Lamp unreachable" -ForegroundColor Red
    }
}

function Set-ClevoKB ($arg) {
    if (Test-Path $ClevoTool) {
        Start-Process -FilePath $ClevoTool -ArgumentList "$arg --hide" -WorkingDirectory "C:\ClevoKB\" -WindowStyle Hidden
    } else {
        Write-Host " [!] Clevo executable not found at C:\ClevoKB\" -ForegroundColor Red
    }
}

function Clear-PriorLoops {
    Get-Process -Name "powershell" -ErrorAction SilentlyContinue | 
        Where-Object { $_.Id -ne $PID } | 
        Stop-Process -Force -ErrorAction SilentlyContinue
}

function Show-Menu {
    Clear-Host
    Write-Host "========================================================================================" -ForegroundColor Cyan
    Write-Host "                       MASTER LIGHTING CONTROL DASHBOARD                                " -ForegroundColor Yellow
    Write-Host "========================================================================================" -ForegroundColor Cyan
    
    # Row 1
    Write-Host " [1] Overdrive Red          " -ForegroundColor Red -NoNewline
    Write-Host "[10] Deep Ocean Blue    " -ForegroundColor Blue -NoNewline
    Write-Host "[19] Golden Hour        " -ForegroundColor Yellow -NoNewline
    Write-Host "[28] Tokyo Drift" -ForegroundColor Magenta
    
    # Row 2
    Write-Host " [2] Sakura Pink            " -ForegroundColor Magenta -NoNewline
    Write-Host "[11] Pure White Focus   " -ForegroundColor White -NoNewline
    Write-Host "[20] Iceberg Cool       " -ForegroundColor Cyan -NoNewline
    Write-Host "[29] Northern Lights" -ForegroundColor Green
    
    # Row 3
    Write-Host " [3] Warm Amber             " -ForegroundColor Yellow -NoNewline
    Write-Host "[12] Midnight Crimson   " -ForegroundColor DarkRed -NoNewline
    Write-Host "[21] Valorant Red/Blue  " -ForegroundColor Red -NoNewline
    Write-Host "[30] Electric Sunset" -ForegroundColor DarkYellow
    
    # Row 4
    Write-Host " [4] Spectrum Wave          " -ForegroundColor Cyan -NoNewline
    Write-Host "[13] Vaporwave Dual     " -ForegroundColor Magenta -NoNewline
    Write-Host "[22] Stealth Black      " -ForegroundColor DarkGray -NoNewline
    Write-Host "[31] Deep Cosmos" -ForegroundColor DarkBlue
    
    # Row 5
    Write-Host " [5] Cyber Neon             " -ForegroundColor DarkCyan -NoNewline
    Write-Host "[14] Solar Flare        " -ForegroundColor Red -NoNewline
    Write-Host "[23] Soft Lavender      " -ForegroundColor DarkMagenta -NoNewline
    Write-Host "[32] Golden Eclipse" -ForegroundColor DarkYellow
    
    # Row 6
    Write-Host " [6] Deep Purple Night      " -ForegroundColor DarkMagenta -NoNewline
    Write-Host "[15] Breathing Amber    " -ForegroundColor Yellow -NoNewline
    Write-Host "[24] Mint Green         " -ForegroundColor Green -NoNewline
    Write-Host "[33] Cyberpunk 2077" -ForegroundColor Yellow
    
    # Row 7
    Write-Host " [7] Emerald Matrix         " -ForegroundColor Green -NoNewline
    Write-Host "[16] Emergency Strobe   " -ForegroundColor Red -NoNewline
    Write-Host "[25] Twilight Indigo    " -ForegroundColor DarkBlue -NoNewline
    Write-Host "[34] Fresh Air" -ForegroundColor Cyan
    
    # Row 8
    Write-Host " [8] Cozy Candlelight       " -ForegroundColor DarkYellow -NoNewline
    Write-Host "[17] Arctic Cyan        " -ForegroundColor Cyan -NoNewline
    Write-Host "[26] Bedtime Timer      " -ForegroundColor Yellow -NoNewline
    Write-Host "[35] Sleep & Shutdown" -ForegroundColor Red
    
    # Row 9
    Write-Host " [9] Sunset Gold            " -ForegroundColor Yellow -NoNewline
    Write-Host "[18] Acid Lime          " -ForegroundColor Green -NoNewline
    Write-Host "[27] Miami Vice         " -ForegroundColor Magenta -NoNewline
    Write-Host "[0]  Blackout (All Off)" -ForegroundColor DarkGray
    
    Write-Host "========================================================================================" -ForegroundColor Cyan
}

do {
    Show-Menu
    $choice = Read-Host " Select Profile [0-35 or Q]"
    
    switch ($choice) {
        '1'  { Clear-PriorLoops; Write-Host " Activating Overdrive Red..." -ForegroundColor Red; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":0,"b":0,"dimming":100}}'; Set-ClevoKB "colour ff0000"; Start-Sleep -Seconds 1 }
        '2'  { Clear-PriorLoops; Write-Host " Activating Sakura Pink..." -ForegroundColor Magenta; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":110,"b":168,"dimming":100}}'; Set-ClevoKB "colour ff6ea8"; Start-Sleep -Seconds 1 }
        '3'  { Clear-PriorLoops; Write-Host " Activating Warm Amber..." -ForegroundColor Yellow; Set-WiZState '{"method":"setPilot","params":{"temp":2700,"dimming":100}}'; Set-ClevoKB "colour ff5500"; Start-Sleep -Seconds 1 }
        '4'  { Clear-PriorLoops; Write-Host " Activating Spectrum Wave..." -ForegroundColor Cyan; Set-WiZState '{"method":"setPilot","params":{"sceneId":4,"dimming":100}}'; Set-ClevoKB "theme colourtransform"; Start-Sleep -Seconds 1 }
        '5'  { Clear-PriorLoops; Write-Host " Activating Cyber Neon..." -ForegroundColor DarkCyan; Set-WiZState '{"method":"setPilot","params":{"r":0,"g":255,"b":255,"dimming":100}}'; Set-ClevoKB "colour 00ffff"; Start-Sleep -Seconds 1 }
        '6'  { Clear-PriorLoops; Write-Host " Activating Deep Purple Night..." -ForegroundColor DarkMagenta; Set-WiZState '{"method":"setPilot","params":{"r":136,"g":0,"b":255,"dimming":80}}'; Set-ClevoKB "colour 8800ff"; Start-Sleep -Seconds 1 }
        '7'  { Clear-PriorLoops; Write-Host " Activating Emerald Matrix..." -ForegroundColor Green; Set-WiZState '{"method":"setPilot","params":{"r":0,"g":255,"b":68,"dimming":100}}'; Set-ClevoKB "colour 00ff44"; Start-Sleep -Seconds 1 }
        '8'  { Clear-PriorLoops; Write-Host " Activating Cozy Candlelight..." -ForegroundColor DarkYellow; Set-WiZState '{"method":"setPilot","params":{"temp":2200,"dimming":60}}'; Set-ClevoKB "colour ffaa00"; Start-Sleep -Seconds 1 }
        '9'  { Clear-PriorLoops; Write-Host " Activating Sunset Gold..." -ForegroundColor Yellow; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":136,"b":0,"dimming":100}}'; Set-ClevoKB "colour ff8800"; Start-Sleep -Seconds 1 }
        '10' { Clear-PriorLoops; Write-Host " Activating Deep Ocean Blue..." -ForegroundColor Blue; Set-WiZState '{"method":"setPilot","params":{"r":0,"g":68,"b":255,"dimming":90}}'; Set-ClevoKB "colour 0044ff"; Start-Sleep -Seconds 1 }
        '11' { Clear-PriorLoops; Write-Host " Activating Pure White Focus..." -ForegroundColor White; Set-WiZState '{"method":"setPilot","params":{"temp":5000,"dimming":100}}'; Set-ClevoKB "colour ffffff"; Start-Sleep -Seconds 1 }
        '12' { Clear-PriorLoops; Write-Host " Activating Midnight Crimson..." -ForegroundColor DarkRed; Set-WiZState '{"method":"setPilot","params":{"r":136,"g":0,"b":0,"dimming":40}}'; Set-ClevoKB "colour 880000"; Start-Sleep -Seconds 1 }
        '13' { Clear-PriorLoops; Write-Host " Activating Vaporwave Dual..." -ForegroundColor Magenta; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":0,"b":255,"dimming":100}}'; Set-ClevoKB "colour 00ffff"; Start-Sleep -Seconds 1 }
        '14' { Clear-PriorLoops; Write-Host " Activating Solar Flare..." -ForegroundColor Red; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":60,"b":0,"dimming":100}}'; Set-ClevoKB "colour ff0000"; Start-Sleep -Seconds 1 }
        '15' { Clear-PriorLoops; Write-Host " Activating Breathing Amber..." -ForegroundColor Yellow; Set-WiZState '{"method":"setPilot","params":{"temp":2700,"dimming":100}}'; Set-ClevoKB "theme tempo"; Start-Sleep -Seconds 1 }
        '16' { Clear-PriorLoops; Write-Host " Activating Emergency Strobe..." -ForegroundColor Red; Set-WiZState '{"method":"setPilot","params":{"sceneId":1,"dimming":100}}'; Set-ClevoKB "theme flash"; Start-Sleep -Seconds 1 }
        '17' { Clear-PriorLoops; Write-Host " Activating Arctic Cyan..." -ForegroundColor Cyan; Set-WiZState '{"method":"setPilot","params":{"temp":6500,"dimming":100}}'; Set-ClevoKB "colour 00e5ff"; Start-Sleep -Seconds 1 }
        '18' { Clear-PriorLoops; Write-Host " Activating Acid Lime..." -ForegroundColor Green; Set-WiZState '{"method":"setPilot","params":{"r":191,"g":255,"b":0,"dimming":100}}'; Set-ClevoKB "colour bfff00"; Start-Sleep -Seconds 1 }
        '19' { Clear-PriorLoops; Write-Host " Activating Golden Hour..." -ForegroundColor Yellow; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":180,"b":50,"dimming":90}}'; Set-ClevoKB "colour ff6a00"; Start-Sleep -Seconds 1 }
        '20' { Clear-PriorLoops; Write-Host " Activating Iceberg Cool..." -ForegroundColor Cyan; Set-WiZState '{"method":"setPilot","params":{"r":180,"g":235,"b":255,"dimming":80}}'; Set-ClevoKB "colour 80d8ff"; Start-Sleep -Seconds 1 }
        '21' { Clear-PriorLoops; Write-Host " Activating Valorant Dual..." -ForegroundColor Red; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":70,"b":85,"dimming":100}}'; Set-ClevoKB "colour 00d2ff"; Start-Sleep -Seconds 1 }
        '22' { Clear-PriorLoops; Write-Host " Activating Stealth Mode..." -ForegroundColor DarkGray; Set-WiZState '{"method":"setPilot","params":{"temp":2700,"dimming":20}}'; Set-ClevoKB "colour 000000"; Start-Sleep -Seconds 1 }
        '23' { Clear-PriorLoops; Write-Host " Activating Soft Lavender..." -ForegroundColor DarkMagenta; Set-WiZState '{"method":"setPilot","params":{"r":216,"g":191,"b":216,"dimming":85}}'; Set-ClevoKB "colour e6e6fa"; Start-Sleep -Seconds 1 }
        '24' { Clear-PriorLoops; Write-Host " Activating Mint Green..." -ForegroundColor Green; Set-WiZState '{"method":"setPilot","params":{"r":152,"g":251,"b":152,"dimming":90}}'; Set-ClevoKB "colour 98ff98"; Start-Sleep -Seconds 1 }
        '25' { Clear-PriorLoops; Write-Host " Activating Twilight Indigo..." -ForegroundColor DarkBlue; Set-WiZState '{"method":"setPilot","params":{"r":75,"g":0,"b":130,"dimming":75}}'; Set-ClevoKB "colour 4b0082"; Start-Sleep -Seconds 1 }
        '26' { 
            Clear-PriorLoops; Write-Host " Starting 30-Min Bedtime Timer..." -ForegroundColor Yellow
            Set-WiZState '{"method":"setPilot","params":{"temp":2200,"dimming":30}}'
            Set-ClevoKB "colour 000000"
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"Start-Sleep -Seconds 1800; `$u=[System.Net.Sockets.UdpClient]::new(); `$u.Connect('$WizIP', $WizPort); `$b=[System.Text.Encoding]::ASCII.GetBytes('{\`"method\`":\`"setState\`",\`"params\`":{\`"state\`":false}}'); [void]`$u.Send(`$b,`$b.Length); `$u.Close()`"" -WindowStyle Hidden
            Start-Sleep -Seconds 1 
        }
        '27' { Clear-PriorLoops; Write-Host " Activating Miami Vice..." -ForegroundColor Magenta; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":0,"b":128,"dimming":100}}'; Set-ClevoKB "colour 00ffff"; Start-Sleep -Seconds 1 }
        '28' { Clear-PriorLoops; Write-Host " Activating Tokyo Drift..." -ForegroundColor Magenta; Set-WiZState '{"method":"setPilot","params":{"r":180,"g":0,"b":255,"dimming":100}}'; Set-ClevoKB "colour ff0055"; Start-Sleep -Seconds 1 }
        '29' { Clear-PriorLoops; Write-Host " Activating Northern Lights..." -ForegroundColor Green; Set-WiZState '{"method":"setPilot","params":{"r":0,"g":255,"b":150,"dimming":90}}'; Set-ClevoKB "colour 8800ff"; Start-Sleep -Seconds 1 }
        '30' { Clear-PriorLoops; Write-Host " Activating Electric Sunset..." -ForegroundColor DarkYellow; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":90,"b":0,"dimming":100}}'; Set-ClevoKB "colour ff0088"; Start-Sleep -Seconds 1 }
        '31' { Clear-PriorLoops; Write-Host " Activating Deep Cosmos..." -ForegroundColor DarkBlue; Set-WiZState '{"method":"setPilot","params":{"r":20,"g":0,"b":60,"dimming":50}}'; Set-ClevoKB "colour 0044ff"; Start-Sleep -Seconds 1 }
        '32' { Clear-PriorLoops; Write-Host " Activating Golden Eclipse..." -ForegroundColor DarkYellow; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":215,"b":0,"dimming":100}}'; Set-ClevoKB "colour 330000"; Start-Sleep -Seconds 1 }
        '33' { Clear-PriorLoops; Write-Host " Activating Cyberpunk 2077..." -ForegroundColor Yellow; Set-WiZState '{"method":"setPilot","params":{"r":255,"g":240,"b":0,"dimming":100}}'; Set-ClevoKB "colour 00ffff"; Start-Sleep -Seconds 1 }
        '34' { Clear-PriorLoops; Write-Host " Activating Fresh Air..." -ForegroundColor Cyan; Set-WiZState '{"method":"setPilot","params":{"temp":4500,"dimming":80}}'; Set-ClevoKB "colour 00ffaa"; Start-Sleep -Seconds 1 }
        '35' {
            Clear-PriorLoops
            Write-Host " Dimming lights to 30% Warm & Initiating Shutdown..." -ForegroundColor Red
            Set-WiZState '{"method":"setPilot","params":{"temp":2200,"dimming":30}}'
            Set-ClevoKB "colour 000000"
            Stop-Computer -Force
        }
        '0'  { Clear-PriorLoops; Write-Host " Turning Off System Lights..." -ForegroundColor DarkGray; Set-WiZState '{"method":"setState","params":{"state":false}}'; Set-ClevoKB "colour 000000"; Start-Sleep -Seconds 1 }
        'Q'  { Write-Host " Exiting..." -ForegroundColor Gray }
        'q'  { Write-Host " Exiting..." -ForegroundColor Gray }
        Default { Write-Host " Invalid option selected!" -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} while ($choice -notmatch '^[Qq]$')