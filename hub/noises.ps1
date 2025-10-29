# Set path to Windows Media folder
$mediaPath = "$env:windir\Media"

# Get all .wav files
$soundFiles = Get-ChildItem -Path $mediaPath -Filter *.wav

# Play each sound in parallel
foreach ($sound in $soundFiles) {
    Start-Job {
        param($file)
        $player = New-Object System.Media.SoundPlayer
        $player.SoundLocation = $file
        $player.Load()
        $player.PlaySync()
    } -ArgumentList $sound.FullName
}

# Optional: Wait for all jobs to complete before closing
Get-Job | Wait-Job
