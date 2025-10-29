Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Get screen dimensions
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$screenWidth = $screen.Bounds.Width
$screenHeight = $screen.Bounds.Height

# Random number generator for positioning
$random = New-Object System.Random

# Delay between pop-ups (in milliseconds)
$delay = 1

# Maximum number of pop-ups to prevent system overload
$maxPopups = 100

# Array to store popup forms for cleanup
$forms = @()

# Create a control form to handle the exit mechanism
$controlForm = New-Object System.Windows.Forms.Form
$controlForm.Opacity = 0  # Make it invisible
$controlForm.ShowInTaskbar = $false
$controlForm.FormBorderStyle = 'None'
$controlForm.Size = New-Object System.Drawing.Size(1, 1)

# Add KeyDown event to exit on Esc
$controlForm.Add_KeyDown({
    if ($_.KeyCode -eq "Escape") {
        # Close all popup forms
        foreach ($form in $forms) {
            if (-not $form.IsDisposed) {
                $form.Close()
            }
        }
        $controlForm.Close()
    }
})

# Show the control form
$controlForm.Show()

# Counter for pop-ups
$i = 0

# Create pop-up forms in a loop
while ($i -lt $maxPopups -and -not $controlForm.IsDisposed) {
    $i++
    
    # Create a new form for the error pop-up
    $form = New-Object System.Windows.Forms.Form
    $form.Width = 100
    $form.Height = 200
    $form.FormBorderStyle = 'FixedDialog'
    $form.Text = "Error $i"
    $form.TopMost = $true
    $form.StartPosition = 'Manual'
    $form.Location = New-Object System.Drawing.Point($random.Next(0, $screenWidth - 200), $random.Next(0, $screenHeight - 100))
    $form.BackColor = [System.Drawing.Color]::FromArgb(0, 0, 170)  # Blue like BSOD
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    # Add error message label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "ERROR: your pc is ratted! (Message $i)\lol"
    $label.ForeColor = [System.Drawing.Color]::White
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $form.Controls.Add($label)

    # Add the form to the array
    $forms += $form

    # Show the form
    $form.Show()

    # Delay to prevent immediate overload
    Start-Sleep -Milliseconds $delay
}

# Keep the script running until the control form is closed
while (-not $controlForm.IsDisposed) {
    [System.Windows.Forms.Application]::DoEvents()
}