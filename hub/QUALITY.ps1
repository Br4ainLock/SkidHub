# Ultimate-Display-Chaos.ps1
# The mother of all weird display pranks — extreme distortion, flicker, resolution madness, cursor insanity, wallpaper spam, and more.

Write-Host "🚨 WARNING: Starting ultimate display chaos! Hold on! 🚨"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Helper: Get screen resolution dynamically
function Get-ScreenResolution {
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    return @{Width = $screen.Width; Height = $screen.Height}
}

# Helper: Set Screen Resolution (requires admin, may fail silently)
function Set-ScreenResolution($width, $height) {
    Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Disp {
    [StructLayout(LayoutKind.Sequential)]
    public struct DEVMODE {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmDeviceName;
        public short  dmSpecVersion;
        public short  dmDriverVersion;
        public short  dmSize;
        public short  dmDriverExtra;
        public int    dmFields;

        public int    dmPositionX;
        public int    dmPositionY;
        public int    dmDisplayOrientation;
        public int    dmDisplayFixedOutput;

        public short  dmColor;
        public short  dmDuplex;
        public short  dmYResolution;
        public short  dmTTOption;
        public short  dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmFormName;
        public short  dmLogPixels;
        public int    dmBitsPerPel;
        public int    dmPelsWidth;
        public int    dmPelsHeight;
        public int    dmDisplayFlags;
        public int    dmDisplayFrequency;
        public int    dmICMMethod;
        public int    dmICMIntent;
        public int    dmMediaType;
        public int    dmDitherType;
        public int    dmReserved1;
        public int    dmReserved2;
        public int    dmPanningWidth;
        public int    dmPanningHeight;
    };

    [DllImport("user32.dll")]
    public static extern int EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE devMode);

    [DllImport("user32.dll")]
    public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);

    public const int ENUM_CURRENT_SETTINGS = -1;
    public const int CDS_UPDATEREGISTRY = 0x01;
    public const int CDS_TEST = 0x02;
    public const int DISP_CHANGE_SUCCESSFUL = 0;
    public const int DISP_CHANGE_RESTART = 1;
}
"@

    $devmode = New-Object Disp+DEVMODE
    $devmode.dmSize = [Runtime.InteropServices.Marshal]::SizeOf($devmode)

    # Get current settings
    if ([Disp]::EnumDisplaySettings($null, [Disp]::ENUM_CURRENT_SETTINGS, [ref]$devmode) -eq 0) {
        Write-Host "Failed to get current display settings"
        return
    }

    # Set desired width and height, randomize bits per pixel and refresh rate too!
    $devmode.dmPelsWidth = $width
    $devmode.dmPelsHeight = $height
    $devmode.dmBitsPerPel = @(16, 24, 32) | Get-Random
    $devmode.dmDisplayFrequency = @(60, 75, 85, 120) | Get-Random
    $devmode.dmFields = 0x180000

    $result = [Disp]::ChangeDisplaySettings([ref]$devmode, [Disp]::CDS_UPDATEREGISTRY)

    switch ($result) {
        0 { Write-Host "Resolution changed to $width x $height successfully" }
        1 { Write-Host "Resolution change requires restart" }
        default { Write-Host "Failed to change resolution" }
    }
}

# --- Start chaos loop ---
$screen = Get-ScreenResolution
Write-Host "Current resolution detected: $($screen.Width)x$($screen.Height)"

# Prepare wallpaper spam (download a bunch of memes)
$wallpapersFolder = "$env:TEMP\memes_chaos"
if (-Not (Test-Path $wallpapersFolder)) { New-Item -Path $wallpapersFolder -ItemType Directory | Out-Null }

$memes = @(
    "https://i.imgflip.com/4/1bij.jpg",
    "https://i.imgflip.com/26am.jpg",
    "https://i.imgflip.com/3si4.jpg",
    "https://i.imgflip.com/39t1o.jpg",
    "https://i.imgflip.com/2hgfw.jpg"
)

for ($i=0; $i -lt $memes.Count; $i++) {
    $file = Join-Path $wallpapersFolder "meme$i.jpg"
    if (-Not (Test-Path $file)) {
        try {
            Invoke-WebRequest -Uri $memes[$i] -OutFile $file -ErrorAction Stop
        }
        catch {
            Write-Host "Failed to download meme $i"
        }
    }
}

# Load user32 functions for messaging and beep
Add-Type -Namespace WinAPI -Name User32 -MemberDefinition @"
    [DllImport("user32.dll")]
    public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);

    [DllImport("user32.dll")]
    public static extern bool FlashWindow(IntPtr hwnd, bool bInvert);

    [DllImport("kernel32.dll")]
    public static extern bool Beep(uint dwFreq, uint dwDuration);
"@

$HWND_BROADCAST = [IntPtr]0xffff
$WM_SETTINGCHANGE = 0x001A
$SMTO_ABORTIFHUNG = 0x0002

# Function to refresh system settings (accessibility, color profile, etc)
function Refresh-Settings {
    $null = [WinAPI.User32]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [UIntPtr]::Zero, "Accessibility", $SMTO_ABORTIFHUNG, 1000, [ref]([UIntPtr]::Zero))
}

# Function to flash the screen colors (invert colors repeatedly)
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class DisplayUtils {
    [DllImport("user32.dll")]
    public static extern IntPtr GetDC(IntPtr hWnd);
    
    [DllImport("gdi32.dll")]
    public static extern uint SetROP2(IntPtr hdc, int fnDrawMode);
    
    [DllImport("gdi32.dll")]
    public static extern bool PatBlt(IntPtr hdc, int x, int y, int w, int h, int rop);
    
    [DllImport("user32.dll")]
    public static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC);

    public const int R2_NOT = 6;
    public const int PATINVERT = 0x005A0049;

    public static void InvertScreen(int width, int height) {
        IntPtr hdc = GetDC(IntPtr.Zero);
        SetROP2(hdc, R2_NOT);
        PatBlt(hdc, 0, 0, width, height, PATINVERT);
        ReleaseDC(IntPtr.Zero, hdc);
    }
}
"@

function Flicker-Invert {
    param($width, $height, $times)
    for ($i = 0; $i -lt $times; $i++) {
        [DisplayUtils]::InvertScreen($width, $height)
        Start-Sleep -Milliseconds (Get-Random -Minimum 100 -Maximum 300)
    }
}

# Function to shake the active window by moving it rapidly
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class WindowUtils {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);

    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT {
        public int Left; public int Top; public int Right; public int Bottom;
    }
}
"@

function Shake-ActiveWindow {
    $hwnd = [WindowUtils]::GetForegroundWindow()
    if ($hwnd -eq [IntPtr]::Zero) { return }
    $rect = New-Object WindowUtils+RECT
    if (-not [WindowUtils]::GetWindowRect($hwnd, [ref]$rect)) { return }
    $width = $rect.Right - $rect.Left
    $height = $rect.Bottom - $rect.Top

    for ($i=0; $i -lt 15; $i++) {
        $offsetX = Get-Random -Minimum -15 -Maximum 15
        $offsetY = Get-Random -Minimum -15 -Maximum 15
        [WindowUtils]::MoveWindow($hwnd, $rect.Left + $offsetX, $rect.Top + $offsetY, $width, $height, $true)
        Start-Sleep -Milliseconds 50
    }

    # Return to original position
    [WindowUtils]::MoveWindow($hwnd, $rect.Left, $rect.Top, $width, $height, $true)
}

# Function to spam notification balloon (using Toast notifications in Windows 10+)
function Show-RandomToast {
    param([string]$text)

    $toastXml = @"
<toast>
  <visual>
    <binding template='ToastGeneric'>
      <text>Display Madness</text>
      <text>$text</text>
    </binding>
  </visual>
</toast>
"@

    $xmlDoc = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xmlDoc.LoadXml($toastXml)

    $toast = [Windows.UI.Notifications.ToastNotification]::new($xmlDoc)
    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("DisplayChaos")
    $notifier.Show($toast)
}

# Load Windows.UI.Notifications types for toast notifications
Add-Type -AssemblyName Windows.UI

# Loop chaos for ~3 minutes (180 iterations * ~1 sec delay)
for ($i = 0; $i -lt 180; $i++) {

    # 1. Flicker screen colors randomly 3-7 times
    Flicker-Invert $screen.Width $screen.Height (Get-Random -Minimum 3 -Maximum 7)

    # 2. Change resolution randomly (including weird values)
    $newWidth = @(800, 1024, 1280, 1440, 1600, 1920, 2560) | Get-Random
    $newHeight = @(600, 768, 900, 1024, 1080, 1440) | Get-Random
    Set-ScreenResolution $newWidth $newHeight

    # 3. Shake the active window
    Shake-ActiveWindow

    # 4. Spam cursor size to max + random cursor (busy + crosshair + help)
    $CursorPath = "HKCU:\Control Panel\Cursors"
    $cursorFiles = @(
        "$env:SystemRoot\Cursors\wait.cur",
        "$env:SystemRoot\Cursors\cross_r.cur",
        "$env:SystemRoot\Cursors\help.cur"
    )
    Set-ItemProperty -Path $CursorPath -Name "CursorSize" -Value 99 -Force

    $randomCursor = $cursorFiles | Get-Random
    Get-ItemProperty -Path $CursorPath | ForEach-Object {
        Set-ItemProperty -Path $CursorPath -Name $_.PSChildName -Value $randomCursor -Force
    }

    # 5. Random wallpaper from memes folder
    $memeFiles = Get-ChildItem -Path $wallpapersFolder -Filter *.jpg
    if ($memeFiles.Count -gt 0) {
        $randomWallpaper = $memeFiles | Get-Random
        Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
        # SPI_SETDESKWALLPAPER = 20, SPIF_UPDATEINIFILE = 1, SPIF_SENDCHANGE = 2
        [Wallpaper]::SystemParametersInfo(20, 0, $randomWallpaper.FullName, 1 -bor 2) | Out-Null
    }

    # 6. Flash window taskbar icon (simulate attention grab)
    try {
        $hwnd = [WindowUtils]::GetForegroundWindow()
        if ($hwnd -ne [IntPtr]::Zero) {
            [WinAPI.User32]::FlashWindow($hwnd, $true) | Out-Null
        }
    }
    catch {}

    # 7. Show a random toast notification (mute exceptions)
    try {
        $texts = @(
            "Your display has been hacked!",
            "Did you see that?",
            "Chaos is fun!",
            "Why is your screen so weird?",
            "Press Ctrl+Alt+Del if you can't handle it"
        )
        Show-RandomToast -text ($texts | Get-Random)
    }
    catch {}

    # 8. Play a beep at random frequency/duration
    try {
        $freq = Get-Random -Minimum 300 -Maximum 1200
        $dur = Get-Random -Minimum 100 -Maximum 500
        [WinAPI.User32]::Beep($freq, $dur) | Out-Null
    }
    catch {}

    # 9. Refresh system settings so Windows notices registry changes
    Refresh-Settings

    # Sleep a bit before next loop
    Start-Sleep -Milliseconds (Get-Random -Minimum 600 -Maximum 1200)
}

Write-Host "Display chaos complete! You might want to reboot now."

