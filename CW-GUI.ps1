# pratyakshm's CleanWin
# This file is a part of the CleanWin software
# Copyright (c) 2021 PratyakshM <pratyakshm@protonmail.com>
# All rights reserved.


#This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly.

$ErrorActionPreference = 'SilentlyContinue'

$Button = [System.Windows.MessageBoxButton]::YesNoCancel
$ErrorIco = [System.Windows.MessageBoxImage]::Warning
$Ask = "Do you want to elevate CleanWin? This is compulsory to ensure proper usage."

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    $Prompt = [System.Windows.MessageBox]::Show($Ask, "Elevation request", $Button, $ErrorIco) 
    Switch ($Prompt) {
        #This will setup Windows 10
        Yes {
            Write-Host "CleanWin has been elevated. Launching GUI..."
            Start-Sleep 1
            Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
            Exit
         }
        No {
            Break
            }
    }
}

# import library code - located relative to this script
Function dotInclude() {
    Param(
        [Parameter(Mandatory)]
        [string]$includeFile
    )
    # Look for the file in the same directory as this script
    $scriptPath = $PSScriptRoot
    if ( $PSScriptRoot -eq $null -and $psISE) {
        $scriptPath = (Split-Path -Path $psISE.CurrentFile.FullPath)
    }
    if ( test-path $scriptPath\$includeFile ) {
        # import and immediately execute the requested file
        . $scriptPath\$includeFile
    }
}


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Function screen {
    Clear-Host
    Start-Sleep 1
    Write-Host "                                        pratyakshm's CleanWin"
    Write-Warning "The GUI window might freeze for an extended period of time while it's performing a task."
    Write-Host " "
    Write-Host " "
    Write-Host " "
    Write-Host " "
    Write-Host " "
    Write-Host " "
    Write-Host "Checking connetivity to the internet..."
    $result = Test-NetConnection github.com
	if ($result.PingSucceeded ) { 
        Write-Host "This PC is connected."
    }
    else {
        Write-Host "Can't connect to GitHub. Some features that require an internet connection will not work."
    }
    Write-Host " "
    Write-Host "Please ensure that no other apps or programs run while CleanWin is working."
    Write-Host " "
}

screen

### BEGIN GUI ###

$Form = New-Object System.Windows.Forms.Form
$Form.ClientSize = '610,380'
$Form.Text = "pratyakshm's CleanWin"
$Form.TopMost = $false;
$Form.MaximizeBox = $false


############### APPS AND FEATURES ############################

$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "               Apps and Features"
$Label2.AutoSize = $true
$Label2.Width = 25
$Label2.Height = 15
$Label2.Location = New-Object System.Drawing.Point(10, 10)
$Label2.Font = 'Segoe UI,12,style=Bold'

$UninstallApps = New-Object System.Windows.Forms.Button
$UninstallApps.Text = "Uninstall all bloat apps"
$UninstallApps.Width = 140
$UninstallApps.Height = 45
$UninstallApps.Location = New-Object System.Drawing.Point(10, 38)
$UninstallApps.Font = 'Segoe UI,10'

$UninstallSelectively = New-Object System.Windows.Forms.Button
$UninstallSelectively.Text = "Uninstall apps selectively"
$UninstallSelectively.Width = 140
$UninstallSelectively.Height = 45
$UninstallSelectively.Location = New-Object System.Drawing.Point(150, 38)
$UninstallSelectively.Font = 'Segoe UI,10'

$InstallWinGet = New-Object System.Windows.Forms.Button
$InstallWinGet.Text = "Install WinGet"
$InstallWinGet.Width = 140
$InstallWinGet.Height = 45
$InstallWinGet.Location = New-Object System.Drawing.Point(10,83)
$InstallWinGet.Font = 'Segoe UI,10'

$Winstall = New-Object System.Windows.Forms.Button
$Winstall.Text = "Winstall"
$Winstall.Width = 140
$Winstall.Height = 45
$Winstall.Location = New-Object System.Drawing.Point(150, 83)
$Winstall.Font = 'Segoe UI,10'

$EnableWSL = New-Object System.Windows.Forms.Button
$EnableWSL.Text = "Enable WSL"
$EnableWSL.Width = 140
$EnableWSL.Height = 45
$EnableWSL.Location = New-Object System.Drawing.Point(150,128)
$EnableWSL.Font = 'Segoe UI,10'

$UninstallFeatures = New-Object System.Windows.Forms.Button
$UninstallFeatures.Text = "Uninstall bloat features"
$UninstallFeatures.Width = 140
$UninstallFeatures.Height = 45
$UninstallFeatures.Location = New-Object System.Drawing.Point(10,128)
$UninstallFeatures.Font = 'Segoe UI,10'

####################### PRIVACY & SECURITY ##########################

$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text = "                        Privacy"
$Label3.AutoSize = $true
$Label3.Width = 25
$Label3.Height = 10
$Label3.Location = New-Object System.Drawing.Point(10,190)
$Label3.Font = 'Segoe UI,12,style=Bold'

$DisableDataCollection = New-Object System.Windows.Forms.Button
$DisableDataCollection.Text = "Disable Data collection"
$DisableDataCollection.Width = 140
$DisableDataCollection.Height = 40
$DisableDataCollection.Location = New-Object System.Drawing.Point(10,220)
$DisableDataCollection.Font = 'Segoe UI,10'

$EnableDataCollection = New-Object System.Windows.Forms.Button
$EnableDataCollection.Text = "Enable Data collection"
$EnableDataCollection.Width = 140
$EnableDataCollection.Height = 40
$EnableDataCollection.Location = New-Object System.Drawing.Point(150,220)
$EnableDataCollection.Font = 'Segoe UI,10'

$DisableTelemetry = New-Object System.Windows.Forms.Button 
$DisableTelemetry.Text = "Disable Telemetry"
$DisableTelemetry.Width = 140
$DisableTelemetry.Height = 40
$DisableTelemetry.Location = New-Object System.Drawing.Point(10, 260)
$DisableTelemetry.Font = 'Segoe UI,10'

$EnableTelemetry = New-Object System.Windows.Forms.Button 
$EnableTelemetry.Text = "Enable Telemetry"
$EnableTelemetry.Width = 140
$EnableTelemetry.Height = 40
$EnableTelemetry.Location = New-Object System.Drawing.Point(150, 260)
$EnableTelemetry.Font = 'Segoe UI,10'

$FullBandwidth = New-Object System.Windows.Forms.Button 
$FullBandwidth.Text = "Release Bandwidth"
$FullBandwidth.Width = 140
$FullBandwidth.Height = 40
$FullBandwidth.Location = New-Object System.Drawing.Point(10, 300)
$FullBandwidth.Font = 'Segoe UI,10'

$ReserveBandwidth = New-Object System.Windows.Forms.Button 
$ReserveBandwidth.Text = "Reserve Bandwidth"
$ReserveBandwidth.Width = 140
$ReserveBandwidth.Height = 40
$ReserveBandwidth.Location = New-Object System.Drawing.Point(150, 300)
$ReserveBandwidth.Font = 'Segoe UI,10'



############## WINDOWS EXPLORER #################

$Label4 = New-Object System.Windows.Forms.Label
$Label4.Text = "                Windows Explorer"
$Label4.AutoSize = $true
$Label4.Width = 25
$Label4.Height = 10
$Label4.Location = New-Object System.Drawing.Point(320,8)
$Label4.Font = 'Segoe UI,12,style=Bold' 

$CleanExplorer = New-Object System.Windows.Forms.Button
$CleanExplorer.Text = "Clean Windows Explorer"
$CleanExplorer.Width = 140
$CleanExplorer.Height = 43
$CleanExplorer.Location = New-Object System.Drawing.Point(320,35)
$CleanExplorer.Font = 'Segoe UI,10'

$RevertExplorer = New-Object System.Windows.Forms.Button
$RevertExplorer.Text = "Revert Windows Explorer tweaks"
$RevertExplorer.Width = 140
$RevertExplorer.Height = 43
$RevertExplorer.Location = New-Object System.Drawing.Point(460,35)
$RevertExplorer.Font = 'Segoe UI,10'

$ShowSeconds = New-Object System.Windows.Forms.Button
$ShowSeconds.Text = "Show seconds in Taskbar"
$ShowSeconds.Width = 140
$ShowSeconds.Height = 43
$ShowSeconds.Location = New-Object System.Drawing.Point(320,78)
$ShowSeconds.Font = 'Segoe UI,10'

$UnpinStartTiles = New-Object System.Windows.Forms.Button
$UnpinStartTiles.Text = "Unpin tiles in Start menu"
$UnpinStartTiles.Width = 140
$UnpinStartTiles.Height = 43
$UnpinStartTiles.Location = New-Object System.Drawing.Point(460,78)
$UnpinStartTiles.Font = 'Segoe UI,10'

$UnpinTaskbarApps = New-Object System.Windows.Forms.Button
$UnpinTaskbarApps.Text = "Unpin apps from Taskbar"
$UnpinTaskbarApps.Width = 140
$UnpinTaskbarApps.Height = 43
$UnpinTaskbarApps.Location = New-Object System.Drawing.Point(320,121)
$UnpinTaskbarApps.Font = 'Segoe UI,10'


############# TASKS & SERVICES ###################

$Label5 = New-Object System.Windows.Forms.Label
$Label5.Text = "             Tasks and Services"
$Label5.AutoSize = $true
$Label5.Width = 25
$Label5.Height = 10
$Label5.Location = New-Object System.Drawing.Point(320,218)
$Label5.Font = 'Segoe UI,12,style=Bold' 

$SetupWindowsUpdate = New-Object System.Windows.Forms.Button
$SetupWindowsUpdate.Text = "Setup Windows Update"
$SetupWindowsUpdate.Width = 140
$SetupWindowsUpdate.Height = 40
$SetupWindowsUpdate.Location = New-Object System.Drawing.Point(320,245)
$SetupWindowsUpdate.Font = 'Segoe UI,10'

$ResetWindowsUpdate = New-Object System.Windows.Forms.Button
$ResetWindowsUpdate.Text = "Reset Windows Update"
$ResetWindowsUpdate.Width = 140
$ResetWindowsUpdate.Height = 40
$ResetWindowsUpdate.Location = New-Object System.Drawing.Point(460,245)
$ResetWindowsUpdate.Font = 'Segoe UI,10'

$DisableTasksServices = New-Object System.Windows.Forms.Button
$DisableTasksServices.Text = "Optimize Tasks and Services"
$DisableTasksServices.Width = 140
$DisableTasksServices.Height = 40
$DisableTasksServices.Location = New-Object System.Drawing.Point(320,285)
$DisableTasksServices.Font = 'Segoe UI,10'

$EnableTasksServices = New-Object System.Windows.Forms.Button
$EnableTasksServices.Text = "Revert Tasks and Services changes"
$EnableTasksServices.Width = 140
$EnableTasksServices.Height = 40
$EnableTasksServices.Location = New-Object System.Drawing.Point(460,285)
$EnableTasksServices.Font = 'Segoe UI,10'

$Label7 = New-Object System.Windows.Forms.Label
$Label7.Text = "CleanWin is FOSS, and shall only be downloaded from https://github.com/pratyakshm/CleanWin"
$Label7.AutoSize = $true
$Label7.Width = 25
$Label7.Height = 10
$Label7.Location = New-Object System.Drawing.Point(10,360)
$Label7.Font = 'Segoe UI,6,style=Monospace' 

$Form.controls.AddRange(@( $Label2, $Label3, $Label3, $Label4, $Label5, $Label7, $UninstallApps, 
$UninstallSelectively, $InstallWinGet ,$Winstall, $EnableWSL, $UninstallFeatures, $DisableDataCollection, $DisableTelemetry,
$EnableDataCollection, $EnableTelemetry, $FullBandwidth, $ReserveBandwidth, $CleanExplorer, $RevertExplorer, $UnpinStartTiles, $UnpinTaskbarApps, $ShowSeconds, 
$SetupWindowsUpdate, $ResetWindowsUpdate, $DisableTasksServices, $EnableTasksServices))

$CWFolder = "C:\CleanWin"
If (Test-Path $CWFolder) {
}
Else {
    New-Item -Path "${CWFolder}" -ItemType Directory | Out-Null 
}

Start-Transcript -OutputDirectory "${CWFolder}" | Out-Null 

#### BUTTONS CODE ###

#### APPS ####
$UninstallSelectively.Add_Click( {

    Add-Type -AssemblyName PresentationCore, PresentationFramework

    #region Variables
    # ArrayList containing the UWP apps to remove
    $AppxPackages = New-Object -TypeName System.Collections.ArrayList($null)

    # List of UWP apps that won't be recommended for removal
    $UncheckedAppxPackages = @(

        # Calculator
        "Microsoft.WindowsCalculator",
    
        # Microsoft Office
        "Microsoft.Office.Desktop.OneNote",
        "Microsoft.Office.Desktop.Word",
        "Microsoft.Office.Desktop",
        "Microsoft.Office.Desktop.Outlook",
        "Microsoft.Office.Desktop.Excel",
        "Microsoft.Office.Desktop.Access",
        "Microsoft.Office.Desktop.PowerPoint",
    
        # Microsoft Store
        "Microsoft.WindowsStore",
    
        # Photos (and Video Editor)
        "Microsoft.Windows.Photos",
        "Microsoft.Photos.MediaEngineDLC",
    
        # Xbox apps
		"Microsoft.GamingServices",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxGameOverlay"
    )

    # UWP apps that won't be shown in the form
    $ExcludedAppxPackages = @(
		# HEVC Video Extensions from Device Manufacturer
		"Microsoft.HEVCVideoExtension",

		# Microsoft Store and appx dependencies
		"Microsoft.StorePurchaseApp",
        "Microsoft.DesktopAppInstaller",
    
        # Web Media Extensions
        "Microsoft.WebMediaExtensions"

        # Windows Terminal
        "Microsoft.WindowsTerminal"
    )
    #endregion Variables

    #region XAML Markup
    [xml]$XAML = '
    <Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Name="Window"
    MinHeight="450" MinWidth="400"
    SizeToContent="Width" WindowStartupLocation="CenterScreen"
    TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
    FontFamily="Segoe UI" FontSize="12" ShowInTaskbar="False">
    <Window.Resources>
    <Style TargetType="StackPanel">
                <Setter Property="Orientation" Value="Horizontal"/>
            </Style>
            <Style TargetType="CheckBox">
                <Setter Property="Margin" Value="10, 10, 5, 10"/>
                <Setter Property="IsChecked" Value="True"/>
            </Style>
            <Style TargetType="TextBlock">
                <Setter Property="Margin" Value="5, 10, 10, 10"/>
            </Style>
            <Style TargetType="Button">
                <Setter Property="Margin" Value="20"/>
                <Setter Property="Padding" Value="10"/>
            </Style>
        </Window.Resources>
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Grid.Column="1" Orientation="Horizontal">
                    <CheckBox Name="CheckboxRemoveAll" IsChecked="False"/>
                    <TextBlock Name="TextblockRemoveAll"/>
                </StackPanel>
            </Grid>
            <ScrollViewer Name="Scroll" Grid.Row="1"
                HorizontalScrollBarVisibility="Disabled"
                VerticalScrollBarVisibility="Auto">
                <StackPanel Name="PanelContainer" Orientation="Vertical"/>
            </ScrollViewer>
            <Button Name="Button" Grid.Row="2"/>
        </Grid>
</Window>
    '
    #endregion XAML Markup

    $Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
    $Form = [Windows.Markup.XamlReader]::Load($Reader)
    $XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
        Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name) -Scope Global
    }


    #region Functions
    function Get-CheckboxClicked
    {
        [CmdletBinding()]
        param
        (
            [Parameter(
                Mandatory = $true,
                ValueFromPipeline = $true
            )]
            [ValidateNotNull()]
            $CheckBox
        )

        $AppxName = $CheckBox.Parent.Children[1].Text
        if ($CheckBox.IsChecked)
        {
            [void]$AppxPackages.Add($AppxName)
        }
        else
        {
            [void]$AppxPackages.Remove($AppxName)
        }
        if ($AppxPackages.Count -gt 0)
        {
            $Button.IsEnabled = $true
        }
        else
        {
            $Button.IsEnabled = $false
        }
    }

    function DeleteButton
    {
        [void]$Window.Close()
        $OFS = "|"
        if ($CheckboxRemoveAll.IsChecked)
        {   
            Write-Host "Uninstalling selected apps..."
            Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage -AllUsers
            Write-Host "Done."
        }
        else
        {  
            Write-Host "Uninstalling selected apps..."
            Get-AppxPackage -PackageTypeFilter Bundle | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage
            Write-Host "Done."
        }
        $OFS = " "
    }

    function Add-AppxControl
    {
        [CmdletBinding()]
        param
        (
            [Parameter(
                Mandatory = $true,
                ValueFromPipeline = $true
            )]
            [ValidateNotNull()]
            [string]
            $AppxName
        )

        $CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
        $CheckBox.Add_Click({Get-CheckboxClicked -CheckBox $_.Source})

        $TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock
        $TextBlock.Text = $AppxName

        $StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
        [void]$StackPanel.Children.Add($CheckBox)
        [void]$StackPanel.Children.Add($TextBlock)

        [void]$PanelContainer.Children.Add($StackPanel)

        if ($UncheckedAppxPackages.Contains($AppxName))
        {
            $CheckBox.IsChecked = $false
            # Exit function, item is not checked
            return
        }

        # If package checked, add to the array list to uninstall
        [void]$AppxPackages.Add($AppxName)
    }
    #endregion Functions

    #region Events Handlers

    # Window Loaded Event
    $Window.Add_Loaded({
        $OFS = "|"
        (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cnotmatch $ExcludedAppxPackages}).Name | ForEach-Object -Process {
            Add-AppxControl -AppxName $_
        }
        $OFS = " "

        $TextblockRemoveAll.Text = "Remove for all users"
        $Window.Title = "Uninstall apps selectively"
        $Button.Content = "Uninstall"
    })

    # Button Click Event
    $Button.Add_Click({DeleteButton})
    #endregion Events Handlers

    if (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cnotmatch ($ExcludedAppxPackages -join "|")})
    {
        # Display the dialog box
        $Form.ShowDialog() | Out-Null
    }
    else
    {
        Write-Host "Nothing to display."
    }
})

$UninstallApps.Add_Click( { 
$ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    
    # Inbox UWP Apps
    Write-Host "    Uninstalling unnecessary UWP apps..."
    $Bloatware = @(
    "Microsoft.549981C3F5F10"
    "Microsoft.BingNews"
    "Microsoft.BingWeather"
    "Microsoft.GamingApp"
    "Microsoft.GamingServices" 
    "Microsoft.GetHelp" 
    "Microsoft.Getstarted" 
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer" 
    "Microsoft.MicrosoftStickyNotes"  
    "Microsoft.MSPaint"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.Office.OneNote"
    "Microsoft.MixedReality.Portal"
    "Microsoft.MicrosoftSolitaireCollection" 
    "Microsoft.NetworkSpeedTest" 
    "Microsoft.News" 
    "Microsoft.Office.Sway" 
    "Microsoft.OneConnect"
    "Microsoft.People" 
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.Print3D" 
    "Microsoft.SkypeApp"
    "Microsoft.ScreenSketch"
    "Microsoft.StorePurchaseApp" 
    "Microsoft.Todos"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCamera"
    "Microsoft.WindowsCommunicationsApps" 
    "Microsoft.WindowsFeedbackHub" 
    "Microsoft.WindowsMaps" 
    "Microsoft.WindowsSoundRecorder" 
    "Microsoft.XboxApp"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"

    # Sponsored Apps
    "*EclipseManager*"
    "*ActiproSoftwareLLC*"
    "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
    "*Duolingo-LearnLanguagesforFree*"
    "*PandoraMediaInc*"
    "*CandyCrush*"
    "*BubbleWitch3Saga*"
    "*Wunderlist*"
    "*Flipboard*"
    "*Twitter*"
    "*Facebook*"
    "*Spotify*"
    "*Minecraft*"
    "*Royal Revolt*"
    "*Sway*"
    "*Speed Test*"
    "*Dolby*"
    )
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage 
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online | Out-Null
    }
    Write-Host "    Uninstalled unnecessary UWP apps."

    # Remove Office webapps shortcuts
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Word.lnk"
    Write-Host "    Removed Office Online web-app shortcuts."

    # Uninstall Connect App
	Import-Module BitsTransfer
	Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/install_wim_tweak.exe
	Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/connect.cmd
	./connect.cmd | Out-Null
	Remove-Item install_wim_tweak.exe
	Remove-Item connect.cmd
	Remove-Item Packages.txt

    Write-Host "    Deleting unnecessary registry keys..."
    $Keys = @(
        New-PSDrive HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        # Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
                
        # Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                
        # Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
                
        # Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
                
        # Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
                
        # Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        )
        
    # Delete the keys
    ForEach ($Key in $Keys) {
        Remove-Item $Key -Recurse 
    }
    Write-Host "    Deleted unnecessary registry keys."    

    # Uninstall Microsoft OneDrive
    Write-Host "    Uninstalling Microsoft OneDrive..."
	$OneDriveKey = 'HKLM:Software\Policies\Microsoft\Windows\OneDrive'
	If (!(Test-Path $OneDriveKey)) {
		mkdir $OneDriveKey | Out-Null
		Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
	}
	Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
	New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
	$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
	$ExplorerReg1 = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
	$ExplorerReg2 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
	Stop-Process -Name "OneDrive*"
	Start-Sleep 2
	If (!(Test-Path $onedrive)) {
		$onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
	}
	Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
	If (Test-Path "$env:USERPROFILE\OneDrive") {
		Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	}
	If (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive") {
		Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	}
	If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive") {
		Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	}
	If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
		Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
	}
	If (!(Test-Path $ExplorerReg1)) {
		New-Item $ExplorerReg1 | Out-Null
	}
	Set-ItemProperty $ExplorerReg1 System.IsPinnedToNameSpaceTree -Value 0 
	If (!(Test-Path $ExplorerReg2)) {
		New-Item $ExplorerReg2 | Out-Null
	}
	Set-ItemProperty $ExplorerReg2 System.IsPinnedToNameSpaceTree -Value 0
	Start-Process explorer.exe -NoNewWindow
	Remove-Item env:OneDrive

	# Uninstall Microsoft OneDrive 64-bit (in preview)
	Remove-Item "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
	Remove-Item "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json.backup" -ErrorAction SilentlyContinue
	Start-BitsTransfer -Source "https://raw.githubusercontent.com/CleanWin/Files/main/settings.json" -Destination "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
	winget uninstall OneDriveSetup.exe | Out-Null
	Remove-Item env:OneDrive
    Write-Host "    Uninstalled Microsoft OneDrive."

    # Unpin apps from Taskbar (https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html)
	Write-Host "Unpinning apps from Taskbar..."
	$AppNames = @(
		"Microsoft Store"
		"Office"
		"Xbox"
		"Mail"
	)
	ForEach ($AppName in $AppNames) {
		if ( $App = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object { $_.Name -eq $AppName })) {
			$App.Verbs() | Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' } | ForEach-Object { $_.DoIt(); $exec = $true } -ErrorAction SilentlyContinue | Out-Null
		}	
	}
	Write-Host "Unpinned apps from Taskbar."

    Write-Host "Removed all bloatware."
})

$InstallWinGet.Add_Click( {
    $ErrorActionPreference = "Stop"
	Write-Host " "
	# Check if WinGet is already installed.
    try {if(Get-Command winget) {
		# Inform user and skip ahead if installed.
        Write-Host "WinGet is already installed on this device."
        }}
	# Install WinGet if not installed.
    catch {
		# Import BitsTransfer module, ping GitHub - if success, proceed with installation, else print no connection message.
		Import-Module BitsTransfer
		$result = Test-NetConnection github.com 	
		if( $result.PingSucceeded ) {
			Write-Host "Downloading WinGet installation packages..."
			Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
			Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
			# Hash the files, if hashes match, begin installation or write warning.
			$filehash1 =(Get-FileHash "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle" -Algorithm SHA256).Hash
			$filehash2 = (Get-FileHash "Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx" -Algorithm SHA256).Hash
				if ( ($filehash1 -eq "CEE94DB96EB0995BA36FAA3D6417CA908C368A2829D4F24791D96D83BDE6F724") -and ($filehash2 -eq "6602159C341BAFEA747D0EDF15669AC72DF8817299FBFAA90469909E06794256") ) {
					Write-Host "Successfully verified package hashes."
					Write-Host "Installing WinGet..."
					Add-AppxPackage -Path .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -DependencyPath .\Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
					Remove-Item Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
					Remove-Item Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
					Write-Host "Installed Windows Package Manager (WinGet)."
				}
				else {
					write-host "Package hashes mismatch. WinGet won't be installed."
				}
		}
		else {
			Write-Host "Could not connect to the internet. WinGet won't be installed."
		}
	}
} )

$Winstall.Add_Click( {
    Write-Host " "
	Write-Host "Finding Winstall.txt..."
	If (Test-Path Winstall.txt) {
		Write-Host "Found Winstall.txt! Beginning Winstall..."
        Get-Content 'Winstall.txt' | Foreach-Object {
            $App = $_.Split('=')
            Write-Host "Installing $App..."
            winget install $App
        }
        Write-Host "Winstall has successfully installed the package(s)."
    }
    else {
        Write-Host "Could not find 'Winstall.txt'. Learn more at bit.ly/Winstall."
    }
})


$EnableWSL.Add_Click( {
    Write-Host " "
    # Import BitsTransfer module, ping github - if success, enable WSL, else print no connection message.
    Import-Module BitsTransfer 
	$result = Test-NetConnection github.com
	if( $result.PingSucceeded ) {
        Write-Host "Enabling Windows Subsystem for Linux..."
        Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart -WarningAction Ignore | Out-Null
        Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart -WarningAction Ignore | Out-Null
        Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -Online -All -NoRestart -WarningAction Ignore | Out-Null
        Write-Host "Enabled Windows Subsystem for Linux."
    } 
    else {
        Write-Host "Could not connect to the internet. WSL won't be enabled."
    }
})

$UninstallFeatures.Add_Click( {
    Write-Host " "
    Write-Host "Disabling and uninstalling unnecessary features..."

    # Uninstall capabilities.
    $Capabilities = @(
		"App.StepsRecorder*"
		"App.Support.QuickAssist*"
        "Hello.Face*"
        "MathRecognizer*"
		"Media.WindowsMediaPlayer*"
		"Microsoft-Windows-SnippingTool*"
		"Microsoft.Windows.MSPaint*" 
		"Microsoft.Windows.PowerShell.ISE*"
		"Microsoft.Windows.WordPad*"
		"Print.Fax.Scan*"
		"XPS.Viewer*"
    )
    ForEach ($Capability in $Capabilities) {
		Remove-WindowsCapability -Name $Capability -Online | Out-Null
	}
    # Print the friendly names list of capabilities uninstalled.
    $CapLists =@(
        "Math Recognizer"
		"Microsoft Paint"
		"Quick Assist"
        "Steps Recorder"
		"Snipping Tool"
        "Windows Fax & Scan"
        "Windows Media Player"
        "Windows Hello Face"
		"Windows PowerShell ISE"
		"Windows XPS Features"
		"WordPad"
    )
    ForEach ($CapList in $CapLists) {
        Write-Host "    - Uninstalled $CapList"
    }

    # Uninstall optional features.
    $OptionalFeatures = @(
        "WorkFolders-Client*"
        "Printing-XPSServices-Feature*"
    )
    ForEach ($OptionalFeature in $OptionalFeatures) {
        Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq $OptionalFeature } | Disable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
    }
    # Print the friendly list of optional features uninstalled.
    Write-Host "    - Disabled Work Folders Client."

    Write-Host "Finished disabling and uninstalling unnecessary features."
})


###########################
##### E X P L O R E R #####
###########################

$CleanExplorer.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    Write-Host "Cleaning up Windows Explorer..."

    # Turn off Sticky keys prompt.
    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

    # Use print screen key to launch Snip overlay.
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1

    # Sets default explorer view to This PC.
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

    # Hide 3D objects in File Explorer.
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
    $Hide3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
    $Hide3DObjects2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
    If (!(Test-Path $Hide3DObjects1)) {
        New-Item -Path $Hide3DObjects1 -Force | Out-Null
        }
    Set-ItemProperty -Path $Hide3DObjects1 -Name "ThisPCPolicy" -Type String -Value "Hide"
    If (!(Test-Path $Hide3DObjects2)) {
        New-Item -Path $Hide3DObjects2 -Force | Out-Null
        }
    Set-ItemProperty -Path $Hide3DObjects2 -Name "ThisPCPolicy" -Type String -Value "Hide"
    
    # Expand Ribbon in File Explorer.
    $ExpandRibbonInExplorer = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon"
	New-Item -Path $ExpandRibbonInExplorer -Force | Out-Null
	New-ItemProperty -Path $ExpandRibbonInExplorer -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 0 -Force

    # Hide search bar in Taskbar.
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
    
    # Hide Task view icon in Taskbar.
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
    
    # Hide Cortana icon in Taskbar.
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0

    # Hide Meet Now icon in Taskbar.
	$Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	$Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 1 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1

    # Turn off News and interests in Taskbar.
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name ShellFeedsTaskbarViewMode -Type DWord -Value 2

    # Restart explorer.exe to reflect changes immeditately and then provide 2 seconds of breathing time.
    Stop-Process -ProcessName explorer
    Start-Sleep 2

    # Print list of changes done.
    Write-Host "Changelog:"
    Write-Host "    - Bound Print Screen key to launch Snip overlay"
    Write-Host "    - Set default File Explorer View to This PC instead of Quick Access"
    Write-Host "    - Expanded Ribbon in File Explorer"
    Write-Host "    - Turned off Sticky keys popup"
    Write-Host "    - Turned off News and interests"
    $Hides =@(
        "3D Objects from File Explorer"
        "Search bar in Taskbar"
        "Task View in Taskbar"
        "Cortana in Taskbar"
        "Meet Now in Taskbar"
    )
    ForEach ($Hide in $Hides) {
        Write-Host "    - Hid $Hide."
    }

    Write-Host "Finished cleaning up Windows Explorer."
       
})

$RevertExplorer.Add_Click( {
    Write-Host " "
    $ErrorActionPreference = 'SilentlyContinue'

    Write-Host "Reverting to default Windows Explorer settings..."

    # Enable Sticky keys prompt.
    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"

    # Set Explorer default view to Quick access.
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo"

    # Restore 3D objects in File Explorer.
    $Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    $Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
    $Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
    If (!(Test-Path $Restore3DObjects1)) {
        New-Item -Path $Restore3DObjects1 | Out-Null
        }
    Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy"
    Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy"
    
    # Minimize Ribbon in File Explorer.
	$MinimizeRibbonInExplorer = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon"
	New-Item -Path $MinimizeRibbonInExplorer -Force | Out-Null
	New-ItemProperty -Path $MinimizeRibbonInExplorer -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 1 -Force

    # Show search bar icon in Taskbar.
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
    
    # Show taskview icon in Taskbar.
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton"
    
    # Show Cortana icon in Taskbar.
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1

    # Show Meet now icon in Taskbar.
	$Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	$Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 0
    Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 0
    
    # No longer use print screen key to launch Snip overlay.
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0

    # Turn on News and interests in Taskbar.
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name ShellFeedsTaskbarViewMode -Type DWord -Value 0

    # Restart explorer.exe to reflect changes immeditately and then provide 2 seconds of breathing time.
    Stop-Process -ProcessName explorer
    Start-Sleep 2

    Write-Host "Reverted to default Windows Explorer settings."
})

$ShowSeconds.Add_Click( {
    Write-Host " "
    $ErrorActionPreference = 'SilentlyContinue'
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
    Stop-Process -ProcessName explorer
    Write-Host "Showed Seconds in Taskbar. Changes will take effect on next restart."
})

$UnpinStartTiles.Add_Click( {
    Write-Host " "
	Write-Host "Unpinning all tiles in start menu..."
	Set-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -Value '<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '  <LayoutOptions StartTileGroupCellWidth="6" />'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '  <DefaultLayoutOverride>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    <StartLayoutCollection>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '      <defaultlayout:StartLayout GroupCellWidth="6" />'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    </StartLayoutCollection>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '  </DefaultLayoutOverride>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    <CustomTaskbarLayoutCollection>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '      <defaultlayout:TaskbarLayout>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '        <taskbar:TaskbarPinList>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '          <taskbar:UWA AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" />'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '          <taskbar:DesktopApp DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '        </taskbar:TaskbarPinList>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '      </defaultlayout:TaskbarLayout>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    </CustomTaskbarLayoutCollection>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '</LayoutModificationTemplate>'
	$START_MENU_LAYOUT = @"
	<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
		<LayoutOptions StartTileGroupCellWidth="6" />
		<DefaultLayoutOverride>
			<StartLayoutCollection>
				<defaultlayout:StartLayout GroupCellWidth="6" />
			</StartLayoutCollection>
		</DefaultLayoutOverride>
	</LayoutModificationTemplate>
"@
	$layoutFile="C:\Windows\StartMenuLayout.xml"
	# Delete layout file if it already exists.
	If(Test-Path $layoutFile) {
		Remove-Item $layoutFile
	}
	# Create a blank layout file.
	$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
	$regAliases = @("HKLM", "HKCU")
	# Assign start layout and force it to apply with "LockedStartLayout" at both the machine and user level.
	foreach ($regAlias in $regAliases){
		$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
		$keyPath = $basePath + "\Explorer" 
		IF(!(Test-Path -Path $keyPath)) { 
			New-Item -Path $basePath -Name "Explorer" | Out-Null
		}
		Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
		Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
	}
	# Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process.
	Stop-Process -name explorer
	Start-Sleep -s 5
	$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
	Start-Sleep -s 5
	
	# Enable the ability to pin items again by disabling "LockedStartLayout".
	foreach ($regAlias in $regAliases){
		$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
		$keyPath = $basePath + "\Explorer" 
		Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
	}
	# Restart Explorer and delete the layout file.
	Stop-Process -name explorer
	# Uncomment the next line to make clean start menu default for all new users.
	Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
	Remove-Item $layoutFile
	Write-Host "Unpinned all tiles in Start Menu."
})

$UnpinTaskbarApps.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Unpinning apps from Taskbar..."
	$AppNames = @(
		"Microsoft Store"
		"Office"
		"Xbox"
		"Mail"
	)
	ForEach ($AppName in $AppNames) {
 		((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $AppName}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true} -ErrorAction SilentlyContinue | Out-Null
	}
	Write-Host "Unpinned apps from Taskbar."
})


#################
#### PRIVACY ####
#################
$DisableDataCollection.Add_Click( { 
$ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    Write-Host "Turning off data collection..."
    
	# Disable suggestions and silent installation of sponsored apps.
	$Suggestions = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	Set-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SoftLandingEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "ContentDeliveryAllowed" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-310093Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-314559Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-338393Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-353694Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-353696Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
    
    # Disable Tailored experiences.
	$CloudContent = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	If (!(Test-Path $CloudContent )) {
		New-Item $CloudContent -Force | Out-Null
		}
	Set-ItemProperty -Path $CloudContent -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

	# Disable Telemetry.
	$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$DataCollection2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$DataCollection3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $DataCollection1 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $DataCollection2 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $DataCollection3 -Name "AllowTelemetry" -Type DWord -Value 0

	# Stop and disable Telemetry services.
	Stop-Service DiagTrack | Set-Service -StartupType Disabled
	Stop-Service dmwappushservice | Set-Service -StartupType Disabled

    # Turn off Activity History.
    $ActivityFeed = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    Set-ItemProperty -Path $ActivityFeed -Name "EnableActivityFeed" -Type DWord -Value 0
    Set-ItemProperty -Path $ActivityFeed -Name "PublishUserActivities" -Type DWord -Value 0
    Set-ItemProperty -Path $ActivityFeed -Name "UploadUserActivities" -Type DWord -Value 0	
    
    # Turn off Advertising ID.
    $AdvertisingID = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
    If (!(Test-Path $AdvertisingID)) {
        New-Item -Path $AdvertisingID | Out-Null
    }
    Set-ItemProperty -Path $AdvertisingID -Name "DisabledByGroupPolicy" -Type DWord -Value 1
    
    # Turn off Feedback notifications.
    $Feedback1 = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
    $Feedback2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    $Feedback3 = "Microsoft\Windows\Feedback\Siuf\DmClient"
    $Feedback4 = "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    If (!(Test-Path $Feedback1)) {
        New-Item -Path $Feedback1 -Force | Out-Null
    }
    Set-ItemProperty -Path $Feedback1 -Name "NumberOfSIUFInPeriod" -Type DWord -Value 1
    If (!(Test-Path $Feedback2)) {
        New-Item -Path $Feedback2 -Force | Out-Null
    }
    Set-ItemProperty -Path $Feedback2 -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
    Disable-ScheduledTask -TaskName $Feedback3 -ErrorAction SilentlyContinue | Out-Null
    Disable-ScheduledTask -TaskName $Feedback4 -ErrorAction SilentlyContinue | Out-Null
    
    # Turn off Background apps (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Sophia.psm1#L8988-L9033).
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
			Remove-ItemProperty -Path $_.PsPath -Name * -Force
		}
	$ExcludedApps = @(
		"Microsoft.LockApp",
		"Microsoft.Windows.ContentDeliveryManager",
		"Microsoft.Windows.Cortana",
		"Microsoft.549981C3F5F10",
		"Microsoft.Windows.Search",
		"Microsoft.Windows.SecHealthUI",
		"Microsoft.Windows.ShellExperienceHost",
		"Microsoft.Windows.StartMenuExperienceHost",
		"Microsoft.WindowsStore"
		)
		$OFS = "|"
		Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | Where-Object -FilterScript {$_.PSChildName -notmatch "^$($ExcludedApps.ForEach({[regex]::Escape($_)}))"} | ForEach-Object -Process {
			New-ItemProperty -Path $_.PsPath -Name Disabled -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path $_.PsPath -Name DisabledByUser -PropertyType DWord -Value 1 -Force
		}
		$OFS = " "
    
    # Turn off Location permission.
    $Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
    $Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
    If (!(Test-Path $Location1)) {
        New-Item -Path $Location1 -Force | Out-Null
    }
    Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Deny"
    Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 0
    
    # Turn off Inking & typing personalization.
	$Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	If (!(Test-Path $Ink1)) {
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 1 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 0
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0

    # Turn off "Let websites provide locally relevant content by accessing my language list".
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Remove-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut"
	New-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 1
    
    # Turn off automatic Maps updates.
    Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0

	$Tasks = @(
		"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"Microsoft\Windows\Application Experience\ProgramDataUpdater"
		"Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
		"Microsoft\Windows\Autochk\Proxy"
		"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
		"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
		"Microsoft\Windows\Windows Error Reporting\QueueReporting" 
		"Microsoft\Windows\Feedback\Siuf\DmClient"
		"Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    )
    ForEach ($Task in $Tasks) {
		Disable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		Write-Host "Disabled scheduled task: $Task."
	}

    # Print user messages to list every change
    $PrivacySettings =@(
        "Activity History"
        "Advertising ID"
        "App suggestions"
        "Feedback"
        "Inking personalization"
        "Location tracking"
        "Maps updates"
        "Online speech recognition"
        "Tailored Experiences"
        "Tasks related to data collection"
        "Telemetry"
        "Websites access to language list to provide locally relevant content"
    )
    Write-Host "Turned off:"
    ForEach ($PrivacySetting in $PrivacySettings) {
        Write-Host "    - $PrivacySetting"
    }

    Write-Host "Data collection was turned off."
})


$EnableDataCollection.Add_Click( { 
    $ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    Write-Host "Turning on data collection..."

	# Turn on Advertising ID.
    $Advertising = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
    Remove-ItemProperty -Path $Advertising -Name "DisabledByGroupPolicy"

	# Turn on Activity History.
    $ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
    Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
    Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	
	# Turn on Feedback notifications.
    $Feedback = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
    If (!(Test-Path $Feedback )) {
        New-Item $Feedback -Force | Out-Null
    }
    Remove-ItemProperty -Path $Feedback -Name "NumberOfSIUFInPeriod"

    # Turn on Background apps.
    Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
	    Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
    
    # Turn on "Let websites provide locally relevant content by accessing my language list".
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Remove-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut"
	New-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
        
	# Turn on location permission.
    $Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
    $Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
    If (!(Test-Path $Location1)) {
        New-Item -Path $Location1 -Force | Out-Null
    }
    Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Allow"
    Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 1
    
    # Turn on Inking & typing personalization.
    $Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	If (!(Test-Path $Ink1)) {
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 0 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 1
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 1

	# Turn on Maps updates.
    Remove-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled"

	# Turn on suggestions and silent installation of sponsored apps.
    $Suggestions1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    $Suggestions2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Remove-ItemProperty -Path $Suggestions1 -Name "SilentInstalledAppsEnabled"
    Remove-ItemProperty -Path $Suggestions1 -Name "SystemPaneSuggestionsEnabled"
    Remove-ItemProperty -Path $Suggestions2 -Name "ShowSyncProviderNotifications"
    Remove-ItemProperty -Path $Suggestions1 -Name "SoftLandingEnabled"
    Remove-ItemProperty -Path $Suggestions1 -Name "SubscribedContent"
	
	# Turn on Tailored Experiences.
    $TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    $TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
    $TailoredExp3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    Remove-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData"
    Remove-ItemProperty -Path $TailoredExp2 -Name "Disabled"
    Remove-ItemProperty -Path $TailoredExp3 -Name "DoNotShowFeedbackNotifications"
	
	# Turn on telemetry.
    $Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    $Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    $Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    Set-ItemProperty -Path $Telemetry1  -Name "AllowTelemetry" -Type DWord -Value 3
    Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 3
    Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 3
	
	# Start telemetry services
    Start-Service DiagTrack | Set-Service -StartupType Automatic
    Start-Service dmwappushservice | Set-Service -StartupType Automatic

    # Print user messages to list everything enabled.
    $PrivacySettings =@(
        "Activity History"
        "Advertising ID"
        "App suggestions"
        "Feedback"
        "Inking personalization"
        "Location tracking"
        "Maps updates"
        "Online speech recognition"
        "Tailored Experiences"
        "Telemetry"
        "Websites access to language list to provide locally relevant content"
    )
    Write-Host "Turned on:"
    ForEach ($PrivacySetting in $PrivacySettings) {
        Write-Host "    - $PrivacySetting"
    }
  
    Write-Host "Data collection has been turned on."
})

$DisableTelemetry.Add_Click( {
    $ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    $Telemetry = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    Set-ItemProperty -Path $Telemetry -Name "AllowCommericalDataPipeline" -Type DWord -Value 1
    Set-ItemProperty -Path $Telemetry -Name "AllowDeviceNameInTelemetry" -Type DWord -Value 0
    Set-ItemProperty -Path $Telemetry -Name "AllowTelemetry" -Type DWord -Value 0
    Set-ItemProperty -Path $Telemetry -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
    Set-ItemProperty -Path $Telemetry -Name "LimitEnhancedDiagnosticDataWindowsAnalytics" -Type DWord -Value 0
    Write-Host "Telemetry / Diagnostic Data collection has been turned off."
})

$EnableTelemetry.Add_Click( {
    $ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    $Telemetry = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    Remove-ItemProperty -Path $Telemetry -Name "AllowTelemetry"
    Remove-ItemProperty -Path $Telemetry -Name "AllowCommericalDataPipeline"
    Remove-ItemProperty -Path $Telemetry -Name "DoNotShowFeedbackNotifications"
    Remove-ItemProperty -Path $Telemetry -Name "LimitEnhancedDiagnosticDataWindowsAnalytics"
    Remove-ItemProperty -Path $Telemetry -Name "AllowDeviceNameInTelemetry"
    Write-Host "Telemetry / Diagnostic Data collection has been turned on."
})

$FullBandwidth.Add_Click( {
    $ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    $Bandwidth = "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
    New-Item -Path $Bandwidth -ItemType Directory -Force
    Set-ItemProperty -Path $Bandwidth -Name "NonBestEffortLimit" -Type DWord -Value 0
    Write-Host "Released full bandwidth to user."
})

$ReserveBandwidth.Add_Click({
    $ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    $Bandwidth = "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
    Remove-ItemProperty -Path $Bandwidth -Name "NonBestEffortLimit"
    Write-Host "Implemented default setting of reserving 20% internet bandwidth to OS."
})


############################################
#####  T A S K S & S E R V I C E S ########
###########################################

$SetupWindowsUpdate.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
    Write-Host "Checking Windows OS update channel..."
    $channel = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name DisplayVersion
    if ($channel -match "Dev") {
        Write-Host "Device detected to be flighting in Windows Insider Dev channel."
        Write-Host "Update policies will be configured in accordance with Insider Dev channel."
    }
    else {
        Write-Host "Device was not detected to be in Dev channel."
        Write-Host "General update policies will be configured."
    }

    Write-Host " "
	Write-Host "Configuring Windows Update with the following policies..."
    $WinUpdatePolicies =@(
        "Turn off automatic updates"
        "Do not auto restart PC if users are signed in"
        "Turn off re-installation of bloatware after Windows Updates"
		"Delay quality updates by 4 days"
    )
    ForEach ($WinUpdatePolicy in $WinUpdatePolicies) {
    	Write-Host "    - $WinUpdatePolicy"
    }

	$Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
        If (!(Test-Path $Update1)) {
          New-Item -Path $Update1 | Out-Null
          New-Item -Path $Update2 | Out-Null
          }
	Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
    Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
    Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
	$channel = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name DisplayVersion
	if ($channel -match "Dev") {
		Write-Host "    - Delay weekly flights by 2 days"
  		Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 2
	}
	else {
		Write-Host "    - Delay feature updates by 20 days"
  		Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
	}
    Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
	Set-ItemProperty -Path $Update2 -Name NoAutoRebootWithLoggedOnUsers -Type Dword -Value 1
    Write-Host "Windows Update policies have been configured."
    Write-Host "Note: These policies will have no effect effect on Windows Core editions."
})

$ResetWindowsUpdate.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
    Write-Host "All Windows Update policies were reset."
})


$DisableTasksServices.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    Write-Host "Disabling unnecessary tasks & services..."
    $Services = @(
		"DiagTrack"
		"dmwapppushservice"
		"SysMain"
		"RetailDemo"
		"diagnosticshub.standardcollector.service"
		"MapsBroker"
		"NetTcpPortSharing"
		"RemoteRegistry"
		"SharedAccess"
		"TrkWks"
    )
    ForEach ($Service in $Services) {
		Stop-Service $Service | Out-Null
		Set-Service $Service -StartupType Disabled
		Write-Host "    Stopped service: $Service."
	}

	$Tasks = @(
		"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"Microsoft\Windows\Application Experience\ProgramDataUpdater"
		"Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
		"Microsoft\Windows\Autochk\Proxy"
		"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
		"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
		"Microsoft\Windows\Windows Error Reporting\QueueReporting" 
		"Microsoft\Windows\Feedback\Siuf\DmClient"
		"Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    )
    ForEach ($Task in $Tasks) {
		Disable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		Write-Host "    Turned off task: $Task."
	}

    Write-Host "Optimized tasks and services."
})

$EnableTasksServices.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    Write-Host "Reverting changes made to tasks & services..."

    $Services = @(
		"DiagTrack"
		"dmwapppushservice"
		"SysMain"
		"RetailDemo"
		"diagnosticshub.standardcollector.service"
		"MapsBroker"
		"NetTcpPortSharing"
		"RemoteRegistry"
		"SharedAccess"
		"TrkWks"
    )
    ForEach ($Service in $Services) {
		Start-Service $Service | Out-Null
		Set-Service $Service -StartupType Automatic
		Write-Host "    Started service: $Service."
	}

	$Tasks = @(
		"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"Microsoft\Windows\Application Experience\ProgramDataUpdater"
		"Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
		"Microsoft\Windows\Autochk\Proxy"
		"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
		"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
		"Microsoft\Windows\Windows Error Reporting\QueueReporting" 
		"Microsoft\Windows\Feedback\Siuf\DmClient"
		"Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    )
    ForEach ($Task in $Tasks) {
		Enable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		Write-Host "    Turned on task: $Task."
	}
    Write-Host "Undid tasks and services changes."
})

[void]$Form.ShowDialog()
