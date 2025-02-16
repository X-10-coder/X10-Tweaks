# PowerShell GUI Tweaker
Add-Type -AssemblyName 'System.Windows.Forms'

# Function to Show GUI
function Show-TweakerGUI {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'PC Performance Tweaker'
    $form.Size = New-Object System.Drawing.Size(400, 400)
    $form.StartPosition = 'CenterScreen'

    # Create Checkboxes
    $chkDisableServices = New-Object System.Windows.Forms.CheckBox
    $chkDisableServices.Text = 'Disable Unnecessary Services'
    $chkDisableServices.Location = New-Object System.Drawing.Point(20, 20)
    $form.Controls.Add($chkDisableServices)

    $chkVisualEffects = New-Object System.Windows.Forms.CheckBox
    $chkVisualEffects.Text = 'Disable Visual Effects'
    $chkVisualEffects.Location = New-Object System.Drawing.Point(20, 50)
    $form.Controls.Add($chkVisualEffects)

    $chkNetwork = New-Object System.Windows.Forms.CheckBox
    $chkNetwork.Text = 'Optimize Network'
    $chkNetwork.Location = New-Object System.Drawing.Point(20, 80)
    $form.Controls.Add($chkNetwork)

    $chkCleanTemp = New-Object System.Windows.Forms.CheckBox
    $chkCleanTemp.Text = 'Clean Temporary Files'
    $chkCleanTemp.Location = New-Object System.Drawing.Point(20, 110)
    $form.Controls.Add($chkCleanTemp)

    $chkPowerPlan = New-Object System.Windows.Forms.CheckBox
    $chkPowerPlan.Text = 'Set High-Performance Mode'
    $chkPowerPlan.Location = New-Object System.Drawing.Point(20, 140)
    $form.Controls.Add($chkPowerPlan)

    # Apply Button
    $btnApply = New-Object System.Windows.Forms.Button
    $btnApply.Text = 'Apply Tweaks'
    $btnApply.Location = New-Object System.Drawing.Point(20, 180)
    $btnApply.Add_Click({
        if ($chkDisableServices.Checked) {
            $services = @("DiagTrack", "SysMain", "RetailDemo", "XblGameSave", "XboxNetApiSvc", "dmwappushservice", "WSearch", "wisvc", "MapsBroker", "lfsvc")
            foreach ($service in $services) {
                Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
                Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
            }
        }
        if ($chkVisualEffects.Checked) {
            Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value 0
            Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'MinAnimate' -Value 0
        }
        if ($chkNetwork.Checked) {
            Set-NetTCPSetting -SettingName InternetCustom -CongestionProvider DCTCP
            Set-NetTCPSetting -SettingName InternetCustom -MaxSynRetransmissions 2
        }
        if ($chkCleanTemp.Checked) {
            Remove-Item -Path 'C:\Windows\Temp\*' -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
        if ($chkPowerPlan.Checked) {
            powercfg -setactive SCHEME_MIN
        }
        [System.Windows.Forms.MessageBox]::Show('Tweaks Applied! Restart Recommended.', 'Success')
    })
    $form.Controls.Add($btnApply)

    # Show Form
    $form.ShowDialog()
}

# Download and Run via One-Liner
if ($MyInvocation.MyCommand.Path -eq $null) {
    iex (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/X-10-coder/X10-Tweaks/refs/heads/main/Tweaker.ps1').Content
} else {
    Show-TweakerGUI
}
