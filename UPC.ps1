Add-Type -AssemblyName PresentationFramework

# Define the list of apps to remove and their PowerShell commands
$apps = @{
    '3D Builder' = '*3dbuilder*'
    'Alarms & Clock' = '*windowsalarms*'
    'Calculator' = '*windowscalculator*'
    'Calendar & Mail' = '*windowscommunicationsapps*'
    'Camera' = '*windowscamera*'
    'Feedback Hub' = '*feedbackhub*'
    'Get Help' = '*gethelp*'
    'Groove Music' = '*zunemusic*'
    'Maps' = '*windowsmaps*'
    'Microsoft News' = '*bingnews*'
    'Microsoft Solitaire Collection' = '*solitairecollection*'
    'Movies & TV' = '*zunevideo*'
    'OneNote' = '*onenote*'
    'Paint 3D' = '*paint3d*'
    'People' = '*people*'
    'Photos' = '*photos*'
    'Print 3D' = '*print3d*'
    'Skype' = '*skype*'
    'Snip & Sketch' = '*snipandsketch*'
    'Sticky Notes' = '*stickynotes*'
    'Tips' = '*getstarted*'
    'Voice Recorder' = '*soundrecorder*'
    'Weather' = '*bingweather*'
    'Xbox' = '*xbox*'
    'Your Phone' = '*yourphone*'
}

# Define the function to remove apps
function Remove-Apps {
    $selectedApps = Get-SelectedApps
    foreach ($app in $selectedApps) {
        if ($apps[$app] -ne $null) {
            Get-AppxPackage -AllUsers | Where-Object {$_.Name -like $apps[$app]} | Remove-AppxPackage -ErrorAction SilentlyContinue
        }
    }
    [System.Windows.MessageBox]::Show('Apps removed successfully.', 'Success')
}

# Define the function to reinstall apps
function Reinstall-Apps {
    foreach ($app in $apps.Keys) {
        if ($apps[$app] -ne $null) {
            Add-AppxPackage -Path "C:\Windows\SystemApps\$($app)\appxmanifest.xml" -ErrorAction SilentlyContinue
        }
    }
    [System.Windows.MessageBox]::Show('Apps reinstalled successfully.', 'Success')
}

# Define the function to show the settings
function Show-Settings {
    [System.Windows.MessageBox]::Show('No settings to show yet.', 'Settings')
}

# Define the function to get the selected apps
function Get-SelectedApps {
    $selectedApps = @()
    foreach ($child in $appsPanel.Children) {
        if ($child.GetType().Name -eq 'CheckBox') {
            $checkBox = [System.Windows.Controls.CheckBox]$child
            if ($checkBox.IsChecked) {
                $selectedApps += $checkBox.Content
            }
        }
    }
    return $selectedApps
}

# Create the WPF window
$window = New-Object System.Windows.Window
$window.Title = 'Windows 10 App Remover'
$window.SizeToContent = 'Height'
$window.Width = 500
$window.ResizeMode = 'CanMinimize'
$window.WindowStartupLocation = 'CenterScreen'

# Create the main stack panel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Margin = '10'
$stackPanel.HorizontalAlignment = 'Left'

# Create the title label
$titleLabel = New-Object System.Windows.Controls.Label
$titleLabel.Content = 'Select the apps to remove:'
$titleLabel.FontSize = '16'
$titleLabel.Margin = '0 0 0 10'
$stackPanel.Children.Add($titleLabel)

# Create the scroll viewer
$scrollViewer = New-Object System.Windows.Controls.ScrollViewer
$scrollViewer.VerticalScrollBarVisibility = 'Auto'
$scrollViewer.HorizontalScrollBarVisibility = 'Disabled'
$scrollViewer.Margin = '0 5 0 5'
$scrollViewer.MaxHeight = 250
$scrollViewer.Content = $appsPanel
$stackPanel.Children.Add($scrollViewer)

# Create the apps panel
$appsPanel = New-Object System.Windows.Controls.StackPanel
$appsPanel.HorizontalAlignment = 'Left'

# Create the checkboxes
foreach ($app in $apps.Keys) {
    $checkBox = New-Object System.Windows.Controls.CheckBox
    $checkBox.Content = $app
    $checkBox.Margin = '0 0 0 5'
    $appsPanel.Children.Add($checkBox)
}

$scrollViewer.Content = $appsPanel

# Create the button panel
$buttonPanel = New-Object System.Windows.Controls.StackPanel
$buttonPanel.Orientation = 'Horizontal'
$buttonPanel.HorizontalAlignment = 'Right'
$buttonPanel.Margin = '0 10 0 0'

# Create the Remove button
$removeButton = New-Object System.Windows.Controls.Button
$removeButton.Content = 'Remove'
$removeButton.Margin = '0 0 5 0'
$removeButton.Add_Click({
    Remove-Apps
})
$buttonPanel.Children.Add($removeButton)

# Create the Reinstall button
$reinstallButton = New-Object System.Windows.Controls.Button
$reinstallButton.Content = 'Reinstall'
$reinstallButton.Margin = '0 0 5 0'
$reinstallButton.Add_Click({
    Reinstall-Apps
})
$buttonPanel.Children.Add($reinstallButton)

# Create the Settings button
$settingsButton = New-Object System.Windows.Controls.Button
$settingsButton.Content = 'Settings'
$settingsButton.Add_Click({
    Show-Settings
})
$buttonPanel.Children.Add($settingsButton)

$stackPanel.Children.Add($buttonPanel)

# Add the stack panel to the window and show it
$window.Content = $stackPanel
$window.ShowDialog() | Out-Null