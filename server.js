const express = require('express');
const dgram = require('dgram');
const { exec, execSync } = require('child_process');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = 3000;
const WIZ_IP = '192.168.xx.xx';
const WIZ_PORT = 38899;
const CLEVO_TOOL = 'C:\\ClevoKB\\CLEVO_KeyboardColour.exe';

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

function clearPriorLoops() {
  try {
    execSync('powershell.exe -Command "Get-Process -Name powershell -ErrorAction SilentlyContinue | Where-Object { $_.Id -ne $PID } | Stop-Process -Force -ErrorAction SilentlyContinue"');
  } catch (err) {}
}

function sendWizPayload(payloadObj) {
  return new Promise((resolve, reject) => {
    const message = Buffer.from(JSON.stringify(payloadObj));
    const client = dgram.createSocket('udp4');

    client.send(message, 0, message.length, WIZ_PORT, WIZ_IP, (err) => {
      if (err) {
        client.close();
        return reject(err);
      }
      client.close();
      resolve();
    });
  });
}

function setClevoKB(arg) {
  exec(`"${CLEVO_TOOL}" ${arg} --hide`, { windowsHide: true }, (err) => {
    if (err) console.error('[Clevo Error]', err);
  });
}

// ==========================================
// 1. PRIMARY LIGHTING & PROFILE ROUTE
// ==========================================
app.post('/api/profile', async (req, res) => {
  const { wizPayload, clevoArg, brightness, shutdown } = req.body;

  clearPriorLoops();

  if (wizPayload) {
    try {
      await sendWizPayload(wizPayload);
    } catch (err) {
      console.error('[API Error] Failed to send UDP payload to WiZ lamp');
    }
  }

  if (clevoArg) {
    setClevoKB(clevoArg);
  }

  // Handle display brightness control via native Windows WMI
  if (brightness !== undefined) {
    const psBrightness = `(Get-WmiObject -Namespace root\\WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1, ${brightness})`;
    exec(`powershell -Command "${psBrightness}"`, { windowsHide: true }, (err) => {
      if (err) console.error('[Brightness Error]', err);
    });
  }

  if (shutdown) {
    res.json({ status: 'success', message: 'Initiating laptop shutdown...' });
    setTimeout(() => exec('shutdown /s /f /t 0'), 1000);
    return;
  }

  res.json({ status: 'success' });
});

// ==========================================
// 2. DEDICATED BRIGHTNESS ROUTES (GET & POST)
// ==========================================
app.get('/api/brightness', (req, res) => {
  const psGetBrightness = `
    $brightness = (Get-WmiObject -Namespace root\\WMI -Class WmiMonitorBrightness).CurrentBrightness
    if ($null -eq $brightness) { $brightness = 100 }
    [PSCustomObject]@{ brightness = $brightness } | ConvertTo-Json
  `;

  exec(`powershell -Command "${psGetBrightness}"`, { windowsHide: true }, (err, stdout) => {
    if (err) {
      return res.json({ brightness: 100 });
    }
    try {
      const data = JSON.parse(stdout);
      res.json({ brightness: data.brightness });
    } catch (e) {
      res.json({ brightness: 100 });
    }
  });
});

app.post('/api/brightness', (req, res) => {
  const { brightness } = req.body;
  if (brightness === undefined) {
    return res.status(400).json({ status: 'error', message: 'Missing brightness value' });
  }

  const psBrightness = `(Get-WmiObject -Namespace root\\WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1, ${brightness})`;
  exec(`powershell -Command "${psBrightness}"`, { windowsHide: true }, (err) => {
    if (err) {
      console.error('[Brightness Error]', err);
      return res.status(500).json({ status: 'error', message: 'Failed to set brightness' });
    }
    res.json({ status: 'success', brightness });
  });
});

// ==========================================
// 3. QUICK AUTOMATION ROUTE
// ==========================================
app.post('/api/automate', (req, res) => {
  const { action } = req.body;
  console.log(`[Automation] Triggering -> ${action}`);

  let shellCommand = '';
  let execOptions = { windowsHide: true };

  switch (action) {
    case 'valorant':
      shellCommand = 'start "" "C:\\Riot Games\\Riot Client\\RiotClientServices.exe" --launch-product=valorant --launch-patchline=live';
      break;
    case 'mw4':
      shellCommand = 'powershell.exe -Command "Set-Location -Path \'C:\\Call of Duty Modern Warfare 4\'; Start-Process \'.\\!start_sp26.bat\'"';
      break;
    case 'obs':
      shellCommand = 'cd /d "C:\\Program Files\\obs-studio\\bin\\64bit" && start "" obs64.exe';
      break;
    case 'spotify':
      shellCommand = 'start spotify:';
      break;
    case 'youtube':
      shellCommand = 'start chrome https://www.youtube.com';
      break;
    case 'steam':
      shellCommand = 'start steam://';
      break;
    case 'explorer':
      shellCommand = 'start explorer.exe';
      break;
    case 'discord':
      shellCommand = 'start discord://';
      break;
    case 'mute':
      shellCommand = 'powershell -Command "$w=New-Object -ComObject WScript.Shell; $w.SendKeys([char]173)"';
      break;
    default:
      return res.status(400).json({ status: 'error', message: 'Unknown action' });
  }

  exec(shellCommand, execOptions, (err) => {
    if (err) console.error('[Automation Error]', err);
  });

  res.json({ status: 'success', action });
});

// ==========================================
// 4. KREO APP CONTROL ROUTES
// ==========================================
app.post('/api/kreo-open', (req, res) => {
  const kreoPath = 'C:\\Program Files (x86)\\Kreo Hive 65\\OemDrv.exe';
  console.log('[Kreo] Opening app...');
  
  exec(`start "" "${kreoPath}"`, { windowsHide: true }, (err) => {
    if (err) {
      console.error('[Kreo Open Error]', err);
      return res.status(500).json({ status: 'error', message: 'Failed to open Kreo app' });
    }
    res.json({ status: 'success', action: 'opened' });
  });
});

app.post('/api/kreo-close', (req, res) => {
  console.log('[Kreo] Closing app...');
  
  exec('taskkill /F /IM OemDrv.exe', { windowsHide: true }, (err) => {
    res.json({ status: 'success', action: 'closed' });
  });
});

// ==========================================
// 5. SYSTEM METRICS ROUTE (CPU Load & Status)
// ==========================================
app.get('/api/metrics', (req, res) => {
  const psCommand = `
    $cpu = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
    if (-not $cpu) { $cpu = "0" }
    [PSCustomObject]@{ CpuLoad = "$([math]::Round($cpu, 1))% Load"; GpuStatus = "Active" } | ConvertTo-Json
  `;

  exec(`powershell -Command "${psCommand}"`, { windowsHide: true }, (err, stdout) => {
    if (err) {
      return res.json({ cpu: 'Normal', gpu: 'Active' });
    }
    try {
      const data = JSON.parse(stdout);
      res.json({ cpu: data.CpuLoad, gpu: data.GpuStatus });
    } catch (e) {
      res.json({ cpu: 'Normal', gpu: 'Active' });
    }
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n==================================================`);
  console.log(`  Master Lighting & Automation Server Active`);
  console.log(`  Network Access: http://192.168.xx.xx:${PORT}`);
  console.log(`==================================================\n`);
});
