Add-Type -AssemblyName System.Windows.Forms

# Check if script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    exit
}

# Get list of programs that start on boot-up
$autostartApps = Get-CimInstance -Query "SELECT * FROM Win32_StartupCommand"

# Get list of programs from registry
$runKeys = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$runApps = foreach ($key in $runKeys) {
    Get-ItemProperty $key | ForEach-Object { $_.PSChildName }
}

# Combine the lists and remove duplicates
$allApps = $autostartApps | Select-Object -Property Name, Command, Location, User | Group-Object -Property Name | ForEach-Object { $_.Group[0] } | Sort-Object -Property Name | Select-Object -ExpandProperty Name
$allApps += $runApps | Sort-Object -Unique

# Create GUI
$form = New-Object System.Windows.Forms.Form
$form.Text = "Disable Programs on Boot"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.ControlBox = $false
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# Create a list view to display the programs
$listView = New-Object System.Windows.Forms.ListView
$listView.Location = New-Object System.Drawing.Point(10, 35)
$listView.Size = New-Object System.Drawing.Size(580, 250)
$listView.CheckBoxes = $true
$listView.View = [System.Windows.Forms.View]::Details
$listView.FullRowSelect = $true
$listView.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.Controls.Add($listView)

# Add columns to the list view
$columnHeader1 = New-Object System.Windows.Forms.ColumnHeader
$columnHeader1.Text = "Name"
$columnHeader1.Width = 150
$listView.Columns.Add($columnHeader1)

$columnHeader2 = New-Object System.Windows.Forms.ColumnHeader
$columnHeader2.Text = "Command"
$columnHeader2.Width = 250
$listView.Columns.Add($columnHeader2)

$columnHeader3 = New-Object System.Windows.Forms.ColumnHeader
$columnHeader3.Text = "Location"
$columnHeader3.Width = 100
$listView.Columns.Add($columnHeader3)

$columnHeader4 = New-Object System.Windows.Forms.ColumnHeader
$columnHeader4.Text = "User"
$columnHeader4.Width = 70
$listView.Columns.Add($columnHeader4)

# Add items to the list view
foreach ($app in $allApps) {
    $item = New-Object System.Windows.Forms.ListViewItem
    $item.Text = (Split-Path -Leaf $app)
    
    $autostartApp = $autostartApps | Where-Object { $_.Name -eq $app }
    if ($autostartApp) {
        $item.SubItems.Add($autostartApp.Command)
        $item.SubItems.Add($autostartApp.Location)
        $item.SubItems.Add($autostartApp.User)
    }
    else {
        $item.SubItems.Add("")
        $item.SubItems.Add("")
        $item.SubItems.Add("")
    }
    
    $listView.Items.Add($item)
}

# Add "Disable Selected" button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10, 320)
$button.Size = New-Object System.Drawing.Size(120, 30)
$button.Text = "Disable Selected"
$button.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$button.Add_Click({
    foreach ($item in $listView.CheckedItems) {
        $command = $allApps | Where-Object { $_ -match [Regex]::Escape($item.Text) }
        Set-CimInstance -Query "SELECT * FROM Win32_StartupCommand WHERE Command='$command'" -PropertyType Properties -Values @{Disabled=$true}
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name $item.Text -Value ""
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name $item.Text -Value ""
    }
    $form.Close()
})
$form.Controls.Add($button)

# Add "Disable All" button
$button2 = New-Object System.Windows.Forms.Button
$button2.Location = New-Object System.Drawing.Point(140, 320)
$button2.Size = New-Object System.Drawing.Size(120, 30)
$button2.Text = "Disable All"
$button2.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$button2.Add_Click({
    foreach ($app in $autostartApps) {
        Set-CimInstance -Query "SELECT * FROM Win32_StartupCommand WHERE Command='$($app.Command)'" -PropertyType Properties -Values @{Disabled=$true}
    }
    foreach ($app in $runApps) {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name $app -Value ""
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name $app -Value ""
    }
    $form.Close()
})
$form.Controls.Add($button2)

# Add "Cancel" button
$button3 = New-Object System.Windows.Forms.Button
$button3.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$button3.Location = New-Object System.Drawing.Point(480, 320)
$button3.Size = New-Object System.Drawing.Size(110, 30)
$button3.Text = "Cancel"
$button3.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.Controls.Add($button3)

# Display GUI
[void]$form.ShowDialog()