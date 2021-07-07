# pratyakshm's CleanWin
# This file is a part of the CleanWin software
# Copyright (c) 2021 Pratyaksh Mehrotra <pratyakshm@protonmail.com>
# All rights reserved.

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Function screen {
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
    Clear-Host 
    Write-Host "CleanWin pre-execution environment"
    Start-Sleep 1

    # Check if device is connected.
    Write-Host "Checking if this device is connected..."
	Import-Module BitsTransfer
	Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/File.txt
	if (Test-Path File.txt) {
        $host.UI.RawUI.WindowTitle = "pratyakshm's CleanWin"
		Remove-Item File.txt
        Write-Host "This device is connected."
	}
	elseif (!(Test-Path File.txt)) {
		Write-Host "This device is not connected. CleanWin will now exit."
		exit
	}

    # Check for for pending updates (part of code used here is picked from https://gist.github.com/Grimthorr/44727ea8cf5d3df11cf7).
    Write-Host " "
    Write-Host "Checking for Windows updates..."
    $UpdateSession = New-Object -ComObject Microsoft.Update.Session
    $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
    $Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0 and AutoSelectOnWebSites=1").Updates)
    $Title = $($Updates).Title
    if (!($Title)) {
        Write-Host "This device is updated. "
    }
    else {
        Write-Host "The following updates are pending:"
        $($Updates).Title
        Start-Sleep 1
        Write-Host " "
        Write-Host "Please update your device before running CleanWin."
        exit
    }
    Start-Sleep -Milliseconds 600

    # Check for pending restarts.
    Write-Host " "
    Write-Host "Checking for pending restart..."
    Start-Sleep 1
    param (
        [Parameter(
        Mandatory = $false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        Position=0
        )]
        [string[]]  $ComputerName = $env:COMPUTERNAME
        )
    ForEach ($Computer in $ComputerName) {
        $PendingReboot = $false
        $HKLM = [UInt32] "0x80000002"
        $WMI_Reg = [WMIClass] "\\$Computer\root\default:StdRegProv"
        if ($WMI_Reg) {
            if (($WMI_Reg.EnumKey($HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\")).sNames -contains 'RebootPending') {$PendingReboot = $true}
            if (($WMI_Reg.EnumKey($HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\")).sNames -contains 'RebootRequired') {$PendingReboot = $true}
        
            #Checking for SCCM namespace
            $SCCM_Namespace = Get-WmiObject -Namespace ROOT\CCM\ClientSDK -List -ComputerName $Computer -ErrorAction Ignore
            if ($SCCM_Namespace) {
                if (([WmiClass]"\\$Computer\ROOT\CCM\ClientSDK:CCM_ClientUtilities").DetermineIfRebootPending().RebootPending -eq $true) {$PendingReboot = $true}
            }
        
            if ($PendingReboot -eq $true) {
                Write-Host "A device restart is pending."
                Write-Host "Please restart this device then run CleanWin."
            }
            else {
                Write-Host "No pending restarts detected."
                Start-Sleep 2
                Clear-Host
            }
            #Clearing Variables
            $WMI_Reg        = $null
            $SCCM_Namespace = $null
        }   
    }
    Clear-Host
    Start-Sleep 1
	Write-Host "pratyakshm's CleanWin"
	Start-Sleep -Milliseconds 100
	Write-Host " "
	Write-Host "Copyright (c) Pratyaksh Mehrotra (a.k.a. pratyakshm) and contributors"
	Start-Sleep -Milliseconds 100
    Write-Warning "GUI will freeze while CleanWin is performing a task."
    Write-Host " "
    $CurrentVersionPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
	$CurrentBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
	$BuildBranch = Get-ItemPropertyValue $CurrentVersionPath -Name BuildBranch
	$OSBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
	$DisplayVersion = Get-ItemPropertyValue $CurrentVersionPath -Name DisplayVersion
	if ($CurrentBuild -lt 21996) {
		Write-Host "This PC is running Windows 10."
		Write-Host "Version $DisplayVersion, OS Build $OSBuild in $BuildBranch branch."
	}
	elseif ($CurrentBuild -ge 22000) {
		Write-Host "This PC is running Windows 11."
		Write-Host "Version $DisplayVersion, OS Build $OSBuild in $BuildBranch branch."
		Write-Host "Note that CleanWin's Windows 11 support is experimental and you might face issues."
	}
    Write-Host " "
    Write-Host "Please ensure that no other apps or programs run while CleanWin is working."
    Write-Host " "
}

screen

# Universal stuff.
$CurrentVersionPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$CurrentBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild

### BEGIN GUI ###

$Form = New-Object System.Windows.Forms.Form
$Form.ClientSize = '610,355'
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
$UninstallApps.Text = "Uninstall all apps"
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
$UninstallFeatures.Text = "Uninstall features"
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
$Label4.Location = New-Object System.Drawing.Point(320,10)
$Label4.Font = 'Segoe UI,12,style=Bold' 

$CleanExplorer = New-Object System.Windows.Forms.Button
$CleanExplorer.Text = "Clean Windows Explorer"
$CleanExplorer.Width = 140
$CleanExplorer.Height = 45
$CleanExplorer.Location = New-Object System.Drawing.Point(320,38)
$CleanExplorer.Font = 'Segoe UI,10'

$RevertExplorer = New-Object System.Windows.Forms.Button
$RevertExplorer.Text = "Revert Windows Explorer changes"
$RevertExplorer.Width = 140
$RevertExplorer.Height = 45
$RevertExplorer.Location = New-Object System.Drawing.Point(460,38)
$RevertExplorer.Font = 'Segoe UI,10'

$ShowSeconds = New-Object System.Windows.Forms.Button
$ShowSeconds.Text = "Show seconds in taskbar"
$ShowSeconds.Width = 140
$ShowSeconds.Height = 45
$ShowSeconds.Location = New-Object System.Drawing.Point(320,83)
$ShowSeconds.Font = 'Segoe UI,10'

$UnpinStartTiles = New-Object System.Windows.Forms.Button
$UnpinStartTiles.Text = "Unpin apps in Start menu"
$UnpinStartTiles.Width = 140
$UnpinStartTiles.Height = 45
$UnpinStartTiles.Location = New-Object System.Drawing.Point(460,83)
$UnpinStartTiles.Font = 'Segoe UI,10'

$UnpinTaskbarApps = New-Object System.Windows.Forms.Button
$UnpinTaskbarApps.Text = "Unpin apps from taskbar"
$UnpinTaskbarApps.Width = 140
$UnpinTaskbarApps.Height = 45
$UnpinTaskbarApps.Location = New-Object System.Drawing.Point(320,128)
$UnpinTaskbarApps.Font = 'Segoe UI,10'

$NewsAndInterests = New-Object System.Windows.Forms.Button
$NewsAndInterests.Text = "Turn off News and Interests"
$NewsAndInterests.Width = 140
$NewsAndInterests.Height = 45
$NewsAndInterests.Location = New-Object System.Drawing.Point(460,128)
$NewsAndInterests.Font = 'Segoe UI,10'


############# TASKS & SERVICES ###################

$Label5 = New-Object System.Windows.Forms.Label
$Label5.Text = "             Tasks and Services"
$Label5.AutoSize = $true
$Label5.Width = 25
$Label5.Height = 10
$Label5.Location = New-Object System.Drawing.Point(320,190)
$Label5.Font = 'Segoe UI,12,style=Bold' 

$SetupWindowsUpdate = New-Object System.Windows.Forms.Button
$SetupWindowsUpdate.Text = "Setup Windows Update"
$SetupWindowsUpdate.Width = 140
$SetupWindowsUpdate.Height = 40
$SetupWindowsUpdate.Location = New-Object System.Drawing.Point(320,220)
$SetupWindowsUpdate.Font = 'Segoe UI,10'

$ResetWindowsUpdate = New-Object System.Windows.Forms.Button
$ResetWindowsUpdate.Text = "Reset Windows Update"
$ResetWindowsUpdate.Width = 140
$ResetWindowsUpdate.Height = 40
$ResetWindowsUpdate.Location = New-Object System.Drawing.Point(460,220)
$ResetWindowsUpdate.Font = 'Segoe UI,10'

$DisableTasksServices = New-Object System.Windows.Forms.Button
$DisableTasksServices.Text = "Optimize Tasks and Services"
$DisableTasksServices.Width = 140
$DisableTasksServices.Height = 40
$DisableTasksServices.Location = New-Object System.Drawing.Point(320,260)
$DisableTasksServices.Font = 'Segoe UI,10'

$EnableTasksServices = New-Object System.Windows.Forms.Button
$EnableTasksServices.Text = "Revert Tasks and Services changes"
$EnableTasksServices.Width = 140
$EnableTasksServices.Height = 40
$EnableTasksServices.Location = New-Object System.Drawing.Point(460,260)
$EnableTasksServices.Font = 'Segoe UI,10'

$Label7 = New-Object System.Windows.Forms.Label
$Label7.Text = "https://github.com/pratyakshm/CleanWin"
$Label7.AutoSize = $true
$Label7.Width = 25
$Label7.Height = 10
$Label7.Location = New-Object System.Drawing.Point(340,315)
$Label7.Font = 'Segoe UI,9' 

$Form.controls.AddRange(@( $Label2, $Label3, $Label3, $Label4, $Label5, $Label7, $UninstallApps, 
$UninstallSelectively, $InstallWinGet ,$Winstall, $EnableWSL, $UninstallFeatures, $DisableDataCollection, $DisableTelemetry,
$EnableDataCollection, $EnableTelemetry, $FullBandwidth, $ReserveBandwidth, $CleanExplorer, $RevertExplorer, $UnpinStartTiles, $UnpinTaskbarApps, $NewsAndInterests, $ShowSeconds, 
$SetupWindowsUpdate, $ResetWindowsUpdate, $DisableTasksServices, $EnableTasksServices))

$CWFolder = "C:\CleanWin"
If (Test-Path $CWFolder) {
}
Else {
    New-Item -Path "${CWFolder}" -ItemType Directory | Out-Null 
}

Start-Transcript -OutputDirectory "${CWFolder}" | Out-Null 

Add-Type -AssemblyName System.Windows.Forms

$SetForegroundWindow = @{
    Namespace = "WinAPI"
    Name = "ForegroundWindow"
    Language = "CSharp"
    MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
}

if (-not ("WinAPI.ForegroundWindow" -as [type]))
{
    Add-Type @SetForegroundWindow
}

Get-Process | Where-Object -FilterScript {$_.MainWindowTitle -like "pratyakshm's CleanWin"} | ForEach-Object -Process {
    # Show window if minimized.
    [WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10) | Out-Null

    # Move the console window to the foreground.
    [WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle) | Out-Null
}

#### BUTTONS CODE ###

#### APPS ####
$UninstallSelectively.Add_Click( {

    Add-Type -AssemblyName PresentationCore, PresentationFramework

    #region Variables.
    # ArrayList containing the UWP apps to remove.
    $AppxPackages = New-Object -TypeName System.Collections.ArrayList($null)

    # List of UWP apps that won't be recommended for removal.
    $UncheckedAppxPackages = @(

        # Calculator.
        "Microsoft.WindowsCalculator",
    
        # Microsoft Office.
        "Microsoft.Office.Desktop.OneNote",
        "Microsoft.Office.Desktop.Word",
        "Microsoft.Office.Desktop",
        "Microsoft.Office.Desktop.Outlook",
        "Microsoft.Office.Desktop.Excel",
        "Microsoft.Office.Desktop.Access",
        "Microsoft.Office.Desktop.PowerPoint",
    
        # Microsoft Store.
        "Microsoft.WindowsStore",
    
        # Photos (and Video Editor).
        "Microsoft.Windows.Photos",
        "Microsoft.Photos.MediaEngineDLC",

        # Snip & Sketch.
        "Microsoft.ScreenSketch"

    )

    # UWP apps that won't be shown in the form
    $ExcludedAppxPackages = @(
		# HEVC Video Extensions from Device Manufacturer.
		"Microsoft.HEVCVideoExtension",

		# Microsoft Store and appx dependencies.
		"Microsoft.StorePurchaseApp",
        "Microsoft.DesktopAppInstaller",
    
        # Web Media Extensions.
        "Microsoft.WebMediaExtensions"

        # Media Engine DLC
        "Microsoft.Photos.MediaEngineDLC"

        # Windows Terminal.
        "Microsoft.WindowsTerminal"

        # Web Experience (used for Widgets).
        "MicrosoftWindows.Client.WebExperience"
            
        # Xbox apps.
		"Microsoft.GamingServices",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxGameOverlay"
    )
    #endregion Variables.

    #region XAML Markup.
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
    #endregion XAML Markup.

    $Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
    $Form = [Windows.Markup.XamlReader]::Load($Reader)
    $XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
        Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name) -Scope Global
    }


    #region Functions.
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
            # Exit function, item is not checked.
            return
        }

        # If package checked, add to the array list to uninstall.
        [void]$AppxPackages.Add($AppxName)
    }
    #endregion Functions.

    #region Events Handlers.

    # Window Loaded Event.
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

    # Prevent the console output from freezing by emulating backspace key (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Module/Sophia.psm1#L728-L767).
    # Sleep for 500ms.
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	$SetForegroundWindow = @{
		Namespace = "WinAPI"
		Name = "ForegroundWindow"
		Language = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
	}

	if (-not ("WinAPI.ForegroundWindow" -as [type]))
	{
		Add-Type @SetForegroundWindow
	}

	Get-Process | Where-Object -FilterScript {$_.MainWindowTitle -like "Uninstall apps selectively"} | ForEach-Object -Process {
		# Show window if minimized.
		[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10) | Out-Null

		Start-Sleep -Milliseconds 100

		# Move the console window to the foreground.
		[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle) | Out-Null

		Start-Sleep -Milliseconds 100

		# Emulate Backspace key.
		[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
	}

    # Button Click Event.
    $Button.Add_Click({DeleteButton})
    #endregion Events Handlers.

    if (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cnotmatch ($ExcludedAppxPackages -join "|")})
    {
        # Display the dialog box.
        $Form.ShowDialog() | Out-Null
    }
    else
    {
        Write-Host "Nothing to display."
    }
})

$UninstallApps.Add_Click( { 
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
    Write-Host " "
    
    # Remove Windows inbox apps.
    Write-Host "Uninstalling Windows apps..."
    $InboxApps = @(
        "Microsoft.549981C3F5F10"
        "Microsoft.BingNews"
        "Microsoft.BingWeather"
        "Microsoft.GamingApp"
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
        "Microsoft.Todos"
        "Microsoft.WindowsAlarms"
        "Microsoft.WindowsCamera"
        "Microsoft.WindowsCommunicationsApps" 
        "Microsoft.WindowsFeedbackHub" 
        "Microsoft.WindowsMaps" 
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.XboxApp"
        "Microsoft.YourPhone"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
    )
    ForEach ($InboxApp in $InboxApps) {
        if (Get-AppxPackage $InboxApp) {
            Write-Host "     Uninstalling $InboxApp..."
            Get-AppxPackage -Name $InboxApp| Remove-AppxPackage 
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $InboxApp | Remove-AppxProvisionedPackage -Online | Out-Null
        }
        else {
            # Do nothing.
        }
    }

    # Remove Sponsored apps.
	$SponsoredApps = @(
		"*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
		"*CandyCrush*"
		"*BubbleWitch3Saga*"
		"*Twitter*"
		"*Facebook*"
		"*Spotify*"
		"*Minecraft*"
		"*Dolby*"
	)
	ForEach ($SponsoredApp in $SponsoredApps) {
	    if (Get-AppxPackage $SponsoredApp) {
			Write-Host "     Uninstalling $SponsoredApp.."
			Get-AppxPackage -Name $SponsoredApp| Remove-AppxPackage 
			Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $SponsoredApp | Remove-AppxProvisionedPackage -Online | Out-Null
		}
		else {
			# Do nothing.
		}
    }
    Write-Host "    Uninstalled unnecessary apps."

    # Remove registry keys used to suggest apps.
    Write-Host " "
	Write-Host "    Removing suggested apps references..."
    New-PSDrive HKU -PSProvider Registry -Root HKEY_Users | Out-Null
	Remove-Item -Path "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps"
    Remove-PSDrive -Name HKU
	Write-Host "    Removed suggested apps references."


    # Remove Office webapps shortcuts.
	if (Test-Path "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk") {
		Write-Host "    Removing Office online web-app shortcuts..."
		Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
		Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
		Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
		Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Word.lnk"
		Write-Host "    Removed Office Online web-app shortcuts."
	}

	# Uninstall Connect app.
	if (Get-AppxPackage Microsoft-PPIProjection-Package) {
		Import-Module BitsTransfer
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/install_wim_tweak.exe
		Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/connect.cmd
		./connect.cmd | Out-Null
		Remove-Item install_wim_tweak.exe
		Remove-Item connect.cmd
		Remove-Item Packages.txt
	}
	else {
		# Do nothing.
	}

    # Uninstall Microsoft OneDrive.
	if (Get-Command winget) {
        Write-Host " "
		Write-Host "    Uninstalling Microsoft OneDrive..."

		# Uninstall using WinGet.
		winget uninstall Microsoft.OneDrive | Out-Null

		# Cleanup leftover folders if found.
		Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force
		Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force
		Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force
		Remove-Item "$env:LOCALAPPDATA\OneDrive" -Recurse -Force
		
		Write-Host "    Uninstalled Microsoft OneDrive."
        }
	else {
		Write-Host "    WinGet is not installed. Please install WinGet first before uninstalling Microsoft OneDrive."
	}

    
    # Unpin apps from taskbar (https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html).
    Write-Host " "
    Write-Host "    Unpinning apps from taskbar..."
	$AppNames = @(
		"Mail"
		"Microsoft Edge"
		"Microsoft Store"
		"Microsoft Teams"
		"Office"
		"Xbox"
	)
	ForEach ($AppName in $AppNames) {
		if ( $App = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object { $_.Name -eq $AppName })) {
			$App.Verbs() | Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' } | ForEach-Object { $_.DoIt() } -ErrorAction SilentlyContinue | Out-Null
		}	
	}
	Write-Host "    Unpinned apps from taskbar."
    Write-Host " "
    Write-Host "Uninstalled apps."
})

$InstallWinGet.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
	Write-Host " "
	if (!(Get-Command winget)) {
        Write-Host "Preparing download..."
        # Create new folder and set location.
        if (!(Test-Path CleanWin)) {
            New-Item CleanWin -ItemType Directory | out-Null
            $currentdir = $(Get-Location).Path
            $dir = "$currentdir/CleanWin"
            Set-Location $dir
        }
        else {
            Set-Location CleanWin
        }

        # Download the packages.
        Import-Module BitsTransfer
        $WinGetURL = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
        $VCLibsURL = "https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx"
        Write-Host "Downloading WinGet installation packages..."
        Start-BitsTransfer $WinGetURL.assets.browser_download_url ; Start-BitsTransfer $VCLibsURL 

        # Install WinGet.
        Write-Host "Installing WinGet..."
        Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -DependencyPath Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
                
        # Cleanup installers.
        Set-Location ..
        Remove-Item CleanWin -Recurse -Force

        # Get-Command winget, if it works then print success message.
        if (Get-Command winget) {
            Write-Host "Installed WinGet."
        }
        else {
             Write-Host "WinGet could not be installed."
        }
	}
	else {
		Write-Host "WinGet is already installed on this device."
	}
} )

$Winstall.Add_Click( {
    if ($winstall -like "y") {
        Write-Host " "
        # Check if WinGet is installed, then proceed.
        if (Get-Command winget) {
            # Try Winstall.txt
            if (Test-Path Winstall.txt) {
                Write-Host "Starting Winstall..."
                # Get each line from the text file and use winget install command on it.
                Get-Content 'Winstall.txt' | ForEach-Object {
                    $App = $_.Split('=')
                    Write-Host "    Installing $App..."
                    winget install "$App"
                }
                Write-Host "Winstall has successfully installed the app(s)."
            }
            # Try winstall.txt
            elseif (Test-Path winstall.txt) {
                Write-Host "Starting Winstall..."
                # Get each line from the text file and use winget install command on it.
                Get-Content 'winstall.txt' | ForEach-Object {
                    $App = $_.Split('=')
                    Write-Host "    Installing $App..."
                    winget install "$App"
                }
                Write-Host "Winstall has successfully installed the app(s)."
            }
            else {
                # File picker UI to manually pick the file.
                [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
                Write-Host "Select Winstall text file from File Picker UI"
                $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
                $OpenFileDialog.InitialDirectory = $initialDirectory
                $OpenFileDialog.Filter = "Text file (*.txt)| *.txt"
                $OpenFileDialog.ShowDialog() | Out-Null
                if ($OpenFileDialog.FileName) {
                    Write-Host "Starting Winstall..."
                    Get-Content $OpenFileDialog.FileName | ForEach-Object {
                        $App = $_.Split('=')
                        Write-Host "    Installing $App..."
                        winget install "$App"
                    }
                    Write-Host "Winstall has successfully installed the app(s)."
                }
                elseif (!($OpenFileDialog.FileName)) {
                    Write-Host "Winstall not selected."
                }
                else {
                    # Do nothing.
                }
            }
        }
        # Inform user if WinGet is not installed.
        else {
            Write-Host "WinGet is not installed. Please install WinGet first before using Winstall."
            Start-Process "https://bit.ly/Winstall" 
        }
    }
    else {
        # Do nothing.
    }
})


$EnableWSL.Add_Click( {
$ProgressPreference = 'SilentlyContinue'
    Write-Host " "
    Write-Host "Enabling Windows Subsystem for Linux..."
    Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) {
        Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    }
    else {
        Write-Host "Could not enable optional feature: Hyper-V, since this edition of Windows does not support it. "
    }    Write-Host "Enabled Windows Subsystem for Linux."
})

$UninstallFeatures.Add_Click( {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'

    Write-Host " "
    Write-Host "Removing capabilites and features..."

    # Uninstall capabilities.
    $Capabilities = @(
		"App.StepsRecorder*"
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
        Get-WindowsCapability -Online | Where-Object {$_.Name -like $Capability} | Remove-WindowsCapability -Online | Out-Null
	}
    
    # Prevent the console output from freezing by emulating backspace key (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Module/Sophia.psm1#L728-L767).
    # Sleep for 500ms.
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	$SetForegroundWindow = @{
		Namespace = "WinAPI"
		Name = "ForegroundWindow"
		Language = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
	}

	if (-not ("WinAPI.ForegroundWindow" -as [type]))
	{
		Add-Type @SetForegroundWindow
	}

	Get-Process | Where-Object -FilterScript {$_.MainWindowTitle -like "pratyakshm's CleanWin*"} | ForEach-Object -Process {
		# Show window if minimized.
		[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10) | Out-Null

		Start-Sleep -Milliseconds 100

		# Move the console window to the foreground.
		[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle) | Out-Null

		Start-Sleep -Milliseconds 100

		# Emulate Backspace key.
		[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
	}

    # Print the friendly names list of capabilities uninstalled.
    $CapLists =@(
        "Math Recognizer"
		"Microsoft Paint"
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
        Start-Sleep -Milliseconds 70
        Write-Host "    - Uninstalled $CapList"
    }

    # Uninstall optional features.
    $OptionalFeatures = @(
        "WorkFolders-Client*"
        "Printing-XPSServices-Feature*"
    )
    ForEach ($OptionalFeature in $OptionalFeatures) {
        Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like $OptionalFeature} | Disable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
    }
    # Print the friendly list of optional features uninstalled.
    Write-Host "    - Disabled Work Folders Client."

    Write-Host "Removed capabilities and features."
})


###########################
##### E X P L O R E R #####
###########################

$CleanExplorer.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    Write-Host "Cleaning up Windows Explorer..."
    New-PSDrive HKU -PSProvider Registry -Root HKEY_Users | Out-Null

    # Turn off Sticky keys prompt.
    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

    # Use print screen key to launch Snip overlay.
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1

    # Sets default explorer view to This PC.
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

    # Hide 3D objects in File Explorer.
	if ($CurrentBuild -lt 22000) {
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
        $Hide3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		$Hide3DObjects2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		if (!(Test-Path $Hide3DObjects1)) {
			New-Item -Path $Hide3DObjects1 -Force | Out-Null
			}
		Set-ItemProperty -Path $Hide3DObjects1 -Name "ThisPCPolicy" -Type String -Value "Hide"
		if (!(Test-Path $Hide3DObjects2)) {
			New-Item -Path $Hide3DObjects2 -Force | Out-Null
			}
		Set-ItemProperty -Path $Hide3DObjects2 -Name "ThisPCPolicy" -Type String -Value "Hide"
	}
	else {
		# Do nothing
	}

    # Hide search box/icon in taskbar.
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
    
    # Hide Task view icon in taskbar.
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
    
    # Hide Cortana icon in taskbar.
	if ($CurrentBuild -lt 22000) {
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	}
	else {
		# Do nothing
	}

    # Hide Meet Now icon in taskbar.
	if ($CurrentBuild -lt 22000) {
        $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 1
        Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	}
	else {
		# Do nothing
	}
    
    # Turn off News and interests in taskbar.
	if ($CurrentBuild -lt 22000) {
		$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
		$Feed2 = "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\Feeds"
		Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 2 | Out-Null
		Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 2 | Out-Null
	}
	else {
		# Do nothing
	}

    # Restart explorer.exe to reflect changes immeditately and then provide 2 seconds of breathing time.
    Stop-Process -ProcessName explorer
    Start-Sleep 3

    # Print list of changes done.
    Write-Host "Changelog:"
    Write-Host "    - Bound Print Screen key to launch Snip overlay"
    Write-Host "    - Set default File Explorer View to This PC"
    Write-Host "    - Turned off Sticky keys"
    # Check if News and interests was turned off and inform user.
    $Feed = "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\Feeds"
    $NIValue = Get-ItemPropertyValue -Path $Feed -Name ShellFeedsTaskbarViewMode
    if ($NIValue -eq 2) {
        Write-Host "    - Turned off News and interests in taskbar."
    }
    else {
        # Do nothing.
    }
	if ($CurrentBuild -lt 22000) {
        Write-Host "     - Hid 3D Objects from File Explorer"
        Write-Host "    - Hid Search bar from taskbar"
        Write-Host "     - Hid Cortana from taskbar"
        Write-Host "     - Hid Meet now from taskbar"
	}
	else {
		Write-Host "    - Hid Search icon from taskbar"
	}
    Write-Host "    - Hid Task view from taskbar"

    Remove-PSDrive -Name HKU
    Write-Host "Finished cleaning up Windows Explorer."
       
})

$RevertExplorer.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'

    Write-Host " "
    Write-Host "Reverting to default Windows Explorer settings..."

    New-PSDrive HKU -PSProvider Registry -Root HKEY_Users | Out-Null

    # Enable Sticky keys prompt.
    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"

    # Set Explorer default view to Quick access.
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo"

    # Restore 3D objects in File Explorer.
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		$Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
        $Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
        $Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		if (!(Test-Path $Restore3DObjects1)) {
			New-Item -Path $Restore3DObjects1 | Out-Null
		}
        Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	}
	else {
		# Do nothing
	}
    
    # Show search bar/icon in taskbar.
	if ($CurrentBuild -lt 22000) {
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
	}
	else {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 1
	}    

    # Show Task view icon in taskbar.
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton"
    
    # Show Cortana icon in taskbar.
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1

    # Show Meet now icon in taskbar.
	if ($CurrentBuild -lt 22000) {
        $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 0
        Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	}
	else {
		# Do nothing
	}
    
    # No longer use print screen key to launch Snip overlay.
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0

    # Turn on News and interests in taskbar.
	if ($CurrentBuild -lt 22000) {
		$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
		$Feed2 = "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\Feeds"
		Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 0 | Out-Null
		Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 0 | Out-Null
        Remove-PSDrive -Name HKU
	}
	else {
		# Do nothing
	}

    # Print list of changes done.
    Write-Host "Changelog:"
    Write-Host "    - Unbound Print Screen key to launch Snip overlay"
    Write-Host "    - Set default File Explorer view to Quick Access"
    Write-Host "    - Turned on Sticky keys"
    # Check if News and interests was turned off and inform user.
    $Feed = "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\Feeds"
    $NIValue = Get-ItemPropertyValue -Path $Feed -Name ShellFeedsTaskbarViewMode
    if ($NIValue -eq 0) {
        Write-Host "    - Turned on News and interests in taskbar."
    }
    else {
        # Do nothing.
    }
	if ($CurrentBuild -lt 22000) {
        Write-Host "     - Restored 3D Objects to File Explorer"
        Write-Host "    - Restored Search bar to taskbar"
        Write-Host "     - Restored Cortana to taskbar"
        Write-Host "     - Restored Meet now to taskbar"
	}
	else {
		Write-Host "    - Restored Search icon to taskbar"
	}
    Write-Host "    - Restored Task view to taskbar"

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
    Write-Host "Showed Seconds in taskbar. Changes will take effect on next restart."
})

$UnpinStartTiles.Add_Click( {
	Write-Host " "
	if ($CurrentBuild -lt 22000) {
		Write-Host "Unpinning all tiles from Start Menu..."
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
		If(Test-Path $layoutFile)
		{
			Remove-Item $layoutFile
		}
		# Creates a blank layout file.
		$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
		$regAliases = @("HKLM", "HKCU")
		# Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level.
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
		Stop-Process -name explorer -Force
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
		Stop-Process -name explorer -Force
		# Uncomment the next line to make clean start menu default for all new users.
		Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
		Remove-Item $layoutFile
		Write-Host "Unpinned all tiles from Start Menu."
	}
	elseif ($CurrentBuild -ge 22000) {
		Write-Host "This device is currently on $CurrentBuild"
		Write-Host "CleanWin currently cannot unpin apps from Start Menu in Windows 11."
	}
	else {
		# Do nothing.
	}
})

$UnpinTaskbarApps.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Unpinning apps from taskbar..."
	$AppNames = @(
		"Microsoft Store"
		"Office"
		"Xbox"
		"Mail"
	)
	ForEach ($AppName in $AppNames) {
 		((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object {$_.Name -eq $AppName}).Verbs() | Where-Object {$_.Name.replace('&','') -match 'Unpin from taskbar'} | Where-Object {$_.DoIt()} -ErrorAction SilentlyContinue | Out-Null
	}
	Write-Host "Unpinned apps from taskbar."
})

$NewsAndInterests.Add_Click( {
	if ($CurrentBuild -lt 22000) {
        New-PSDrive HKU -PSProvider Registry -Root HKEY_Users | Out-Null
		Write-Host " "
		Write-Host "Turning off News and interests..."
		$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
		$Feed2 = "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\Feeds"
		Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 2 | Out-Null
		Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 2 | Out-Null
		Write-Host "Turned off News and interests."
        Write-Host "Use 'Revert Windows Explorer changes' to turn it back on."
        Remove-PSDrive -Name HKU
	}
	else {
		Write-Host "This PC is running Windows 11. Windows 11 does not have News and interests."
	}
})



#################
#### PRIVACY ####
#################
$DisableDataCollection.Add_Click( { 
$ErrorActionPreference = 'SilentlyContinue'
    Write-Host " "
    Write-Host "Turning off data collection..."
    
	# Disable suggestions and silent installation of sponsored apps.
	if (!(Test-Path "C:\CleanWin\Suggestions.reg")) {
		reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "C:\CleanWin\Suggestions.reg" | Out-Null
	}
	else {
		reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "C:\CleanWin\SuggestionsThisMustWork.reg" | Out-Null
	}
	$SyncNotification = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	Set-ItemProperty -Path $SyncNotification -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
	Remove-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SystemPaneSuggestionsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SoftLandingEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent"
	Remove-ItemProperty -Path $Suggestions -Name "ContentDeliveryAllowed"
	Remove-ItemProperty -Path $Suggestions -Name "OemPreInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEverEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent*"
	Remove-Item -Path "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps"
    
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

    # Print user friendly messages to list every change.
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
    if ($CurrentBuild -lt 22000) {
        # Get Windows Edition, if its Professional, Education, or Enterprise.
        if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) {
                Write-Host "Setting up Windows Update policies..."

                # Declare registry keys locations.
                $Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
                $Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
                if (!(Test-Path $Update1)) {
                    New-Item -Path $Update1 | Out-Null
                    New-Item -Path $Update2 | Out-Null
                }

                # Write registry values.
                Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
                Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
                Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
                Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
                Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
                Set-ItemProperty -Path $Update2 -Name NoAutoRebootWithLoggedOnUsers -Type Dword -Value 1

                # Print user message; policies applied.
                $WinUpdatePolicies =@(
                    "Turned off automatic updates"
                    "Device will no longer auto restart if users are signed in"
                    "Turned off re-installation of apps after Windows Updates"
                    "Delayed quality updates by 4 days"
                    "Delayed feature updates by 20 days"
                )
                ForEach ($WinUpdatePolicy in $WinUpdatePolicies) {
                    Write-Host "    - $WinUpdatePolicy"
                }
                
                Write-Host "Set up Windows Update policies."

            }

        # Print user message if unsupported edition.
        else {
            Write-Host "You are running an edition of Windows that does not support setting up Windows Update policies."
            Write-Host "Could not set up Windows Update policies."
        }
    }

    elseif ($CurrentBuild -ge 22000) {
        Write-Host "CleanWin currently cannot set up Windows Update policies on Windows 11."
    }

    else {
        # Do nothing.
    }
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
		"SysMain"
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
		"SysMain"
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
