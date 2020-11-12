#This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly.

$ErrorActionPreference = 'SilentlyContinue'

$Button = [System.Windows.MessageBoxButton]::YesNoCancel
$ErrorIco = [System.Windows.MessageBoxImage]::Error
$Ask = "Do you want to elevate CleanWin?

        Select 'Yes' to elevate

        Select 'No' if you don't want to elevate
        
        Select 'Cancel' to stop run."

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    $Prompt = [System.Windows.MessageBox]::Show($Ask, "Run as an Administrator or not?", $Button, $ErrorIco) 
    Switch ($Prompt) {
        #This will setup Windows 10
        Yes {
            Write-Host "You didn't run this script as an as administrator. It'll self elevate and continue."
            Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
            Exit
         }
        No {
            Break
            }
    }
}

#Unnecessary Windows 10 AppX apps that will be removed by the blacklist.
$global:Bloatware = @(
    "Microsoft.549981C3F5F10"
    "Microsoft.BingNews"
    "Microsoft.BingWeather" 
    "Microsoft.GetHelp" 
    "Microsoft.Getstarted" 
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer" 
    "Microsoft.MicsoftStickyNotes"  
    "Microsoft.MSPaint"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.Office.OneNote"
    "Microsoft.MicrosoftSolitaireCollection" 
    "Microsoft.NetworkSpeedTest" 
    "Microsoft.News" 
    "Microsoft.Office.Sway" 
    "Microsoft.OneConnect"
    "Microsoft.People" 
    "Microsoft.Print3D" 
    "Microsoft.StorePurchaseApp" 
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCommunicationsApps" 
    "Microsoft.WindowsFeedbackHub" 
    "Microsoft.WindowsMaps" 
    "Microsoft.Windows.Photos"
    "Microsoft.WindowsSoundRecorder" 
    "Microsoft.XboxApp"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.ZuneVideo"

    #Sponsored Windows 10 AppX Apps
    #Add sponsored/featured apps to remove in the "*AppName*" format
    "EclipseManager"
    "ActiproSoftwareLLC"
    "AdobeSystemsIncorporated.AdobePhotoshopExpress"
    "Duolingo-LearnLanguagesforFree"
    "PandoraMediaInc"
    "CandyCrush"
    "BubbleWitch3Saga"
    "Wunderlist"
    "Flipboard"
    "Twitter"
    "Facebook"
    "Spotify"                                          
    "Minecraft"
    "Royal Revolt"
    "Sway"                                             
    "Dolby"                                             
)

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

# Override built-in blacklist/whitelist with user defined lists
dotInclude 'CleanWin-CustomLists.ps1'

#convert to regular expression to allow for the super-useful -match operator
$global:BloatwareRegex = $global:Bloatware -join '|'


# This form was created using POSHGUI.com  a free online gui designer for PowerShell
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

### BEGIN GUI ###

$Form = New-Object System.Windows.Forms.Form
$Form.ClientSize = '800,500'
$Form.Text = "The CleanWin Project - version 0.7.1"
$Form.TopMost = $false

############### C L E A N U P ############################
$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "                        Cleanup"
$Label2.AutoSize = $true
$Label2.Width = 25
$Label2.Height = 10
$Label2.Location = New-Object System.Drawing.Point(10, 10)
$Label2.Font = 'Microsoft Sans Serif,12,style=Bold'

$RemoveAllBloatware = New-Object System.Windows.Forms.Button
$RemoveAllBloatware.Text = "Remove all bloatware"
$RemoveAllBloatware.Width = 140
$RemoveAllBloatware.Height = 40
$RemoveAllBloatware.Location = New-Object System.Drawing.Point(10, 35)
$RemoveAllBloatware.Font = 'Microsoft Sans Serif,10'

$RemoveBloatRegkeys = New-Object System.Windows.Forms.Button
$RemoveBloatRegkeys.Text = "Remove bloatware regkeys"
$RemoveBloatRegkeys.Width = 140
$RemoveBloatRegkeys.Height = 40
$RemoveBloatRegkeys.Location = New-Object System.Drawing.Point(150, 35)
$RemoveBloatRegkeys.Font = 'Microsoft Sans Serif,10'

$CustomizeBlacklists = New-Object System.Windows.Forms.Button
$CustomizeBlacklists.Text = "Customize blacklist"
$CustomizeBlacklists.Width = 140
$CustomizeBlacklists.Height = 40
$CustomizeBlacklists.Location = New-Object System.Drawing.Point(10, 75)
$CustomizeBlacklists.Font = 'Microsoft Sans Serif,10'

$RemoveBlacklist = New-Object System.Windows.Forms.Button
$RemoveBlacklist.Text = "Remove bloatware from blacklist"
$RemoveBlacklist.Width = 140
$RemoveBlacklist.Height = 40
$RemoveBlacklist.Location = New-Object System.Drawing.Point(150, 75)
$RemoveBlacklist.Font = 'Microsoft Sans Serif,10'

############# O P T I O N A L  F E A T U R E S ################
$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text = '                Optional Features'
$Label3.AutoSize = $true
$Label3.Width = 25
$Label3.Height = 10
$Label3.Location = New-Object System.Drawing.Point(10,130)
$Label3.Font = 'Microsoft Sans Serif,12,style=Bold'

$InstallNet35 = New-Object System.Windows.Forms.Button
$InstallNet35.Text = "Install dotNET 3.5"
$InstallNet35.Width = 140
$InstallNet35.Height = 40
$InstallNet35.Location = New-Object System.Drawing.Point(10,155)
$InstallNet35.Font = 'Microsoft Sans Serif,10'

$InstallWSL = New-Object System.Windows.Forms.Button
$InstallWSL.Text = "Install WSL"
$InstallWSL.Width = 140
$InstallWSL.Height = 40
$InstallWSL.Location = New-Object System.Drawing.Point(10,195)
$InstallWSL.Font = 'Microsoft Sans Serif,10'

$UninstallBloatFeatures = New-Object System.Windows.Forms.Button
$UninstallBloatFeatures.Text = "Uninstall bloat features"
$UninstallBloatFeatures.Width = 140
$UninstallBloatFeatures.Height = 40 
$UninstallBloatFeatures.Location = New-Object System.Drawing.Point(150,155)
$UninstallBloatFeatures.Font = 'Microsoft Sans Serif,10'

####################### P R I V A C Y ##########################
$Label4 = New-Object System.Windows.Forms.Label
$Label4.Text = "                        Privacy"
$Label4.AutoSize = $true
$Label4.Width = 25
$Label4.Height = 10
$Label4.Location = New-Object System.Drawing.Point(10,250)
$Label4.Font = 'Microsoft Sans Serif,12,style=Bold'

$OOShutup10 = New-Object System.Windows.Forms.Button
$OOShutup10.Text = 'Apply O&OShutup10 config'
$OOShutup10.Width = 140
$OOShutup10.Height = 40
$OOShutup10.Location = New-Object System.Drawing.Point(10, 275)
$OOShutup10.Font = 'Microsoft Sans Serif,10'

$HostsTelemetry = New-Object System.Windows.Forms.Button
$HostsTelemetry.Text = 'Block telemetry using hosts'
$HostsTelemetry.Width = 140
$HostsTelemetry.Height = 40
$HostsTelemetry.Location = New-Object System.Drawing.Point(150, 275)
$HostsTelemetry.Font = 'Microsoft Sans Serif,10'

$DisableDataCollection = New-Object System.Windows.Forms.Button
$DisableDataCollection.Text = "Disable Data collection"
$DisableDataCollection.Width = 140
$DisableDataCollection.Height = 40
$DisableDataCollection.Location = New-Object System.Drawing.Point(10,315)
$DisableDataCollection.Font = 'Microsoft Sans Serif,10'

$EnableDataCollection = New-Object System.Windows.Forms.Button
$EnableDataCollection.Text = "Enable Data collection"
$EnableDataCollection.Width = 140
$EnableDataCollection.Height = 40
$EnableDataCollection.Location = New-Object System.Drawing.Point(150,315)
$EnableDataCollection.Font = 'Microsoft Sans Serif,10'

$DisableTelemetry = New-Object System.Windows.Forms.Button 
$DisableTelemetry.Text = "Disable Telemetry"
$DisableTelemetry.Width = 140
$DisableTelemetry.Height = 40
$DisableTelemetry.Location = New-Object System.Drawing.Point(10, 355)
$DisableTelemetry.Font = 'Microsoft Sans Serif,10'

$EnableTelemetry = New-Object System.Windows.Forms.Button 
$EnableTelemetry.Text = "Enable Telemetry"
$EnableTelemetry.Width = 140
$EnableTelemetry.Height = 40
$EnableTelemetry.Location = New-Object System.Drawing.Point(150, 355)
$EnableTelemetry.Font = 'Microsoft Sans Serif,10'

############## W I N D O W S  E X P L O R E R #################

$Label5 = New-Object System.Windows.Forms.Label
$Label5.Text = "                Windows Explorer"
$Label5.AutoSize = $true
$Label5.Width = 25
$Label5.Height = 10
$Label5.Location = New-Object System.Drawing.Point(320,10)
$Label5.Font = 'Microsoft Sans Serif,12,style=Bold' 

$CleanExplorer = New-Object System.Windows.Forms.Button
$CleanExplorer.Text = "Clean Windows Explorer"
$CleanExplorer.Width = 140
$CleanExplorer.Height = 40
$CleanExplorer.Location = New-Object System.Drawing.Point(320,35)
$CleanExplorer.Font = 'Microsoft Sans Serif,10'

$UndoCleanExplorer = New-Object System.Windows.Forms.Button
$UndoCleanExplorer.Text = "Revert Clean Windows Explorer"
$UndoCleanExplorer.Width = 140
$UndoCleanExplorer.Height = 40 
$UndoCleanExplorer.Location = New-Object System.Drawing.Point(460,35)
$UndoCleanExplorer.Font = 'Microsoft Sans Serif,10'

$DisableStickyKeys = New-Object System.Windows.Forms.Button
$DisableStickyKeys.Text = "Disable Sticky keys"
$DisableStickyKeys.Width = 140
$DisableStickyKeys.Height = 40
$DisableStickyKeys.Location = New-Object System.Drawing.Point(320,75)
$DisableStickyKeys.Font = 'Microsoft Sans Serif,10'

$EnableStickyKeys = New-Object System.Windows.Forms.Button
$EnableStickyKeys.Text = "Enable Sticky keys"
$EnableStickyKeys.Width = 140
$EnableStickyKeys.Height = 40
$EnableStickyKeys.Location = New-Object System.Drawing.Point(460,75)
$EnableStickyKeys.Font = 'Microsoft Sans Serif,10'

$EnablePrtScrForSnip = New-Object System.Windows.Forms.Button
$EnablePrtScrForSnip.Text = "Use PrtScr to open Screen Snip"
$EnablePrtScrForSnip.Width = 140
$EnablePrtScrForSnip.Height = 40
$EnablePrtScrForSnip.Location = New-Object System.Drawing.Point(320,115)
$EnablePrtScrForSnip.Font = 'Microsoft Sans Serif,10'

$DisablePrtScrForSnip = New-Object System.Windows.Forms.Button
$DisablePrtScrForSnip.Text = "Don't use PrtScr to open Screen snip"
$DisablePrtScrForSnip.Width = 140
$DisablePrtScrForSnip.Height = 40
$DisablePrtScrForSnip.Location = New-Object System.Drawing.Point(460,115)
$DisablePrtScrForSnip.Font = 'Microsoft Sans Serif,10'

$Hide3DObjects = New-Object System.Windows.Forms.Button
$Hide3DObjects.Text = "Hide 3D objects"
$Hide3DObjects.Width = 140
$Hide3DObjects.Height = 40
$Hide3DObjects.Location = New-Object System.Drawing.Point(320,155)
$Hide3DObjects.Font = 'Microsoft Sans Serif,10'

$Show3DObjects = New-Object System.Windows.Forms.Button
$Show3DObjects.Text = "Restore 3D objects"
$Show3DObjects.Width = 140
$Show3DObjects.Height = 40
$Show3DObjects.Location = New-Object System.Drawing.Point(460,155)
$Show3DObjects.Font = 'Microsoft Sans Serif,10'

$ShowVerboseStatus = New-Object System.Windows.Forms.Button
$ShowVerboseStatus.Text = "Show verbose status"
$ShowVerboseStatus.Width = 140
$ShowVerboseStatus.Height = 40
$ShowVerboseStatus.Location = New-Object System.Drawing.Point(320,195)
$ShowVerboseStatus.Font = 'Microsoft Sans Serif,10'

$HideVerboseStatus = New-Object System.Windows.Forms.Button
$HideVerboseStatus.Text = "Hide verbose status"
$HideVerboseStatus.Width = 140
$HideVerboseStatus.Height = 40
$HideVerboseStatus.Location = New-Object System.Drawing.Point(460,195)
$HideVerboseStatus.Font = 'Microsoft Sans Serif,10'

$ShowSeconds = New-Object System.Windows.Forms.Button
$ShowSeconds.Text = "Show Seconds in Taskbar"
$ShowSeconds.Width = 140
$ShowSeconds.Height = 40
$ShowSeconds.Location = New-Object System.Drawing.Point(320,235)
$ShowSeconds.Font = 'Microsoft Sans Serif,10'

$HideSeconds = New-Object System.Windows.Forms.Button
$HideSeconds.Text = "Hide Seconds in Taskbar"
$HideSeconds.Width = 140
$HideSeconds.Height = 40
$HideSeconds.Location = New-Object System.Drawing.Point(460,235)
$HideSeconds.Font = 'Microsoft Sans Serif,10'



############# S E R V I C E S  C H A N G E S ###################
$Label6 = New-Object System.Windows.Forms.Label
$Label6.Text = "                      Services"
$Label6.AutoSize = $true
$Label6.Width = 25
$Label6.Height = 10
$Label6.Location = New-Object System.Drawing.Point(320,290)
$Label6.Font = 'Microsoft Sans Serif,12,style=Bold' 

$DisableAutoUpdates = New-Object System.Windows.Forms.Button
$DisableAutoUpdates.Text = "Disable automatic updates"
$DisableAutoUpdates.Width = 140
$DisableAutoUpdates.Height = 40
$DisableAutoUpdates.Location = New-Object System.Drawing.Point(320,315)
$DisableAutoUpdates.Font = 'Microsoft Sans Serif,10'

$EnableAutoUpdates = New-Object System.Windows.Forms.Button
$EnableAutoUpdates.Text = "Enable automatic updates"
$EnableAutoUpdates.Width = 140
$EnableAutoUpdates.Height = 40
$EnableAutoUpdates.Location = New-Object System.Drawing.Point(460,315)
$EnableAutoUpdates.Font = 'Microsoft Sans Serif,10'

$DisableDefrag = New-Object System.Windows.Forms.Button
$DisableDefrag.Text = "Disable defragmentation"
$DisableDefrag.Width = 140
$DisableDefrag.Height = 40
$DisableDefrag.Location = New-Object System.Drawing.Point(320,355)
$DisableDefrag.Font = 'Microsoft Sans Serif,10'

$EnableDefrag = New-Object System.Windows.Forms.Button
$EnableDefrag.Text = "Enable defragmentation"
$EnableDefrag.Width = 140
$EnableDefrag.Height = 40
$EnableDefrag.Location = New-Object System.Drawing.Point(460,355)
$EnableDefrag.Font = 'Microsoft Sans Serif,10'

$Label7 = New-Object System.Windows.Forms.Label
$Label7.Text = "CleanWin is FOSS, and shall only be downloaded from https://github.com/pratyakshm/CleanWin"
$Label7.AutoSize = $true
$Label7.Width = 25
$Label7.Height = 10
$Label7.Location = New-Object System.Drawing.Point(10,450)
$Label7.Font = 'Microsoft Sans Serif,8,style=Monospace' 

$Form.controls.AddRange(@( $Label2, $Label3, $Label4, $Label5, $Label6, $label7, $RemoveAllBloatware, 
$CustomizeBlacklists, $RemoveBloatRegkeys, $RemoveBlacklist, $InstallNet35, $InstallWSL, 
$UninstallBloatFeatures, $OOShutup10, $DisableDataCollection, $DisableTelemetry, $HostsTelemetry,
$EnableDataCollection, $EnableTelemetry, $CleanExplorer, $DisableStickyKeys, 
$EnablePrtScrForSnip, $Hide3DObjects, $ShowVerboseStatus, $ShowSeconds, $UndoCleanExplorer, 
$EnableStickyKeys, $DisablePrtScrForSnip, $Show3DObjects, $HideVerboseStatus,  $HideSeconds, 
$DisableAutoUpdates, $DisableDefrag, $EnableAutoUpdates, $EnableDefrag))

$CWFolder = "C:\Temp\CleanWin"
If (Test-Path $CWFolder) {
}
Else {
    New-Item -Path "${CWFolder}" -ItemType Directory
}

Start-Transcript -OutputDirectory "${CWFolder}"

#### BUTTONS CODE ###

#### APPS ####
$CustomizeBlacklists.Add_Click( {
        $CustomizeForm = New-Object System.Windows.Forms.Form
        $CustomizeForm.ClientSize = '600,400'
        $CustomizeForm.Text = "Customize whitelist and blacklist"
        $CustomizeForm.TopMost = $false
        $CustomizeForm.AutoScroll = $true

        $SaveList = New-Object System.Windows.Forms.Button
        $SaveList.Text = "Save customized whitelist and blacklist to CleanWin-CustomLists.ps1"
        $SaveList.AutoSize = $true
        $SaveList.Location = New-Object System.Drawing.Point(200, 5)
        $CustomizeForm.controls.Add($SaveList)

        $SaveList.Add_Click( {
                $ErrorActionPreference = 'SilentlyContinue'

                '$global:Bloatware = @(' | Out-File -FilePath $PSScriptRoot\CleanWin-CustomLists.ps1 -Append -Encoding utf8
                @($CustomizeForm.controls) | ForEach {
                    if ($_ -is [System.Windows.Forms.CheckBox] -and $_.Enabled -and $_.Checked) {
                        "    ""$($_.Text)""" | Out-File -FilePath $PSScriptRoot\CleanWin-CustomLists.ps1 -Append -Encoding utf8
                    }
                }
                ')' | Out-File -FilePath $PSScriptRoot\CleanWin-CustomLists.ps1 -Append -Encoding utf8

                #Over-ride the white/blacklist with the newly saved custom list
                dotInclude CleanWin-CustomLists.ps1

                #convert to regular expression to allow for the super-useful -match operator
                $global:BloatwareRegex = $global:Bloatware -join '|'
            })

        Function AddAppToCustomizeForm() {
            Param(
                [Parameter(Mandatory)]
                [int] $position,
                [Parameter(Mandatory)]
                [string] $appName,
                [Parameter(Mandatory)]
                [bool] $enabled,
                [Parameter(Mandatory)]
                [bool] $checked,

                [string] $notes
            )

            $label = New-Object System.Windows.Forms.Label
            $label.Location = New-Object System.Drawing.Point(2, (30 + $position * 16))
            $label.Text = $notes
            $label.Width = 300
            $label.Height = 16
            $Label.TextAlign = [System.Drawing.ContentAlignment]::TopRight
            $CustomizeForm.controls.Add($label)

            $Checkbox = New-Object System.Windows.Forms.CheckBox
            $Checkbox.Text = $appName
            $Checkbox.Location = New-Object System.Drawing.Point(320, (30 + $position * 16))
            $Checkbox.Autosize = 1;
            $Checkbox.Checked = $checked
            $Checkbox.Enabled = $enabled
            $CustomizeForm.controls.Add($CheckBox)
        }


        $Installed = @( (Get-AppxPackage).Name )
        $Online = @( (Get-AppxProvisionedPackage -Online).DisplayName )
        $AllUsers = @( (Get-AppxPackage -AllUsers).Name )
        [int]$checkboxCounter = 0

        ForEach ( $item in $global:Bloatware ) {
            $string = ""
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += "Installed" }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { $string += " AllUsers" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $AllUsers ) {
            $string = "NEW   AllUsers"
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { continue }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += " Installed" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $Installed ) {
            $string = "NEW   Installed"
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { continue }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { continue }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $Online ) {
            $string = "NEW   Online "
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { continue }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { continue }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { continue }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $string
            ++$checkboxCounter
        }
        [void]$CustomizeForm.ShowDialog()

    })


$RemoveBlacklist.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        Function CWBlacklist {
            Write-Host "Requesting removal of $global:BloatwareRegex"
            Write-Host "--- This may take a while - please be patient ---"
            Get-AppxPackage | Where-Object Name -cmatch $global:BloatwareRegex | Remove-AppxPackage
            Write-Host "...now starting the silent ProvisionedPackage bloatware removal..."
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -cmatch $global:BloatwareRegex | Remove-AppxProvisionedPackage -Online
            Write-Host "...and the final cleanup..."
            Get-AppxPackage -AllUsers | Where-Object Name -cmatch $global:BloatwareRegex | Remove-AppxPackage
        }
        Write-Host "`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`nRemoving blacklisted Bloatware.`n"
        CWBlacklist
        Write-Host "Bloatware removed!"
    })

$RemoveAllBloatware.Add_Click( { 
$ErrorActionPreference = 'SilentlyContinue'
        Function DebloatApps {
            #This function finds any AppX/AppXProvisioned package and uninstalls it.
            #Also, to note - This does NOT remove essential system services/software/etc such as .NET framework installations, Cortana, Edge, etc.
            Get-AppxPackage | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online
            Get-AppxPackage -AllUsers | Remove-AppxPackage
        }

        #Creates a PSDrive to be able to access the 'HKCR' tree
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        
        Write-Host "Uninstalling bloatware..."
        DebloatAll
})

$RemoveBloatRegkeys.Add_Click( { 
$ErrorActionPreference = 'SilentlyContinue'
$Keys = @(
         New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        #Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        #Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            
        #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        #Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            
        #Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
               
        #Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        )
        
        #This writes the output of each key it is removing and also removes the keys listed above.
        ForEach ($Key in $Keys) {
            Remove-Item $Key -Recurse
        }
        Write-Host "Bloatware keys have been removed."
    })


###########################
##### E X P L O R E R #####
###########################

$CleanExplorer.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'

   
    # Sets default explorer view to This PC
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

    # Hides 3D objects
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
        
    # Hide search bar
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
    
    # Hide Task view icon
       Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
    
    # Hide Cortana icon
    	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0

    # Show seconds in taskbar clock
         Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
    
    Write-Host "Windows Explorer has been cleaned up."
})

$UndoCleanExplorer.Add_Click( {
    $ErrorActionPreference = 'SilentlyContinue'

    # Enable Sticky keys prompt
         Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"

    # Set Explorer default view to Quick access
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo"

    # Show / Restore 3D objects 
        $Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
        $Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
        $Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
        If (!(Test-Path $Restore3DObjects1)) {
            New-Item -Path $Restore3DObjects1 | Out-Null
            }
        Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy"
        Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy"
    
    # Show search bar icon 
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
    
    # Show taskview icon 
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton"
    
    # Show Cortana icon
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1

    # Hide seconds from taskbar clock
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1

    Write-Host "Reverted Clean Windows Explorer changes."

})

$ShowVerboseStatus.Add_Click( {
    $ErrorActionPreference = 'SilentlyContinue'
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Type DWord -Value 1
        Write-Host "Verbose status has been turned on."
})

$HideVerboseStatus.Add_Click( {
    $ErrorActionPreference = 'SilentlyContinue'
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Type DWord -Value 0
        Write-Host "Verbose status has been turned off."
})

$ShowSeconds.Add_Click( {
    $ErrorActionPreference = 'SilentlyContinue'
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
        Write-Host "Taskbar clock will now display seconds."
})

$HideSeconds.Add_Click( {
    $ErrorActionPreference = 'SilentlyContinue'
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 0
        Write-Host "Taskbar clock will no longer display seconds."
})

$Hide3DObjects.Add_Click( {
    $ErrorActionPreference = 'SilentlyContinue'
        $Hide3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
        $Hide3DObjects2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
        $Hide3DObjects3 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
        If (!(Test-Path $Hide3DObjects1)) {
            New-Item -Path $Hide3DObjects1 -Force | Out-Null
            }
        Set-ItemProperty -Path $Hide3DObjects1 -Name "ThisPCPolicy" -Type String -Value "Hide"
        If (!(Test-Path $Hide3DObjects2)) {
            New-Item -Path $Hide3DObjects2 -Force | Out-Null
            }
        Set-ItemProperty -Path $Hide3DObjects2 -Name "ThisPCPolicy" -Type String -Value "Hide"
        Remove-Item -Path $3DObjects3 -Recurse
        Write-Host "3D Objects has been hidden."
})

$Show3DObjects.Add_Click( {
        $Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
        $Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
        $Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
        If (!(Test-Path $Restore3DObjects1)) {
            New-Item -Path $Restore3DObjects1 | Out-Null
            }
        Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy"
        Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy"
        Write-Host "3D objects has been restored."
})
$EnablePrtScrForSnip.Add_Click( {
        Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1
        Write-Host "Print screen key is now set to launch Screen Snip."
})

$DisablePrtScrForSnip.Add_Click( {
        Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0
        Write-Host "Print screen key will no longer launch Screen Snip."
})

$DisableStickyKeys.Add_Click( {
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
        Write-Host "Sticky keys prompt is turned on."
})

$EnableStickyKeys.Add_Click( {
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
        Write-Host "Sticky keys prompt is turned on."
})

#################
#### PRIVACY ####
#################
$DisableDataCollection.Add_Click( { 
$ErrorActionPreference = 'SilentlyContinue'

	# Disable suggestions and bloatware auto-install
		$Suggestions1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
		$Suggestions2 = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
		Set-ItemProperty -Path $Suggestions1 -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
		Set-ItemProperty -Path $Suggestions1 -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
		Set-ItemProperty -Path $Suggestions1 -Name "SoftLandingEnabled" -Type DWord -Value 0
		Set-ItemProperty -Path $Suggestions1 -Name "SubscribedContent" -Type DWord -Value 0

	# Disable tailored experiences
		$CloudContent = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
		If (!(Test-Path $CloudContent )) {
			New-Item $CloudContent -Force | Out-Null
			}
		Set-ItemProperty -Path $CloudContent -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

	# Disable scheduled tasks
		Get-ScheduledTask Consolidator | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask DmClient | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask DmClientOnScenarioDownload | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask ProgramDataUpdater | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask QueueReporting | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask UsbCeip | Disable-ScheduledTask | Out-Null

	# Disable telemetry
		$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
		$DataCollection2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
		$DataCollection3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
		Set-ItemProperty -Path $DataCollection1 -Name "AllowTelemetry" -Type DWord -Value 0
		Set-ItemProperty -Path $DataCollection2 -Name "AllowTelemetry" -Type DWord -Value 0
		Set-ItemProperty -Path $DataCollection3 -Name "AllowTelemetry" -Type DWord -Value 0

	# Stop and disable telemetry services
		Stop-Service DiagTrack | Set-Service -StartupType Disabled
		Stop-Service dmwappushservice | Set-Service -StartupType Disabled

        $ActivityFeed = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
        Set-ItemProperty -Path $ActivityFeed -Name "EnableActivityFeed" -Type DWord -Value 0
        Set-ItemProperty -Path $ActivityFeed -Name "PublishUserActivities" -Type DWord -Value 0
        Set-ItemProperty -Path $ActivityFeed -Name "UploadUserActivities" -Type DWord -Value 0	
    
    # Disable Advertising ID
        $AdvertisingID = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
        If (!(Test-Path $AdvertisingID)) {
            New-Item -Path $AdvertisingID | Out-Null
        }
        Set-ItemProperty -Path $AdvertisingID -Name "DisabledByGroupPolicy" -Type DWord -Value 1
    
    # Disable Feedback
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
    
    # Disable Background apps
        Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach-Object {
            Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
            Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
            }
    
    # Disable Location Tracking
        $Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
        $Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
        If (!(Test-Path $Location1)) {
            New-Item -Path $Location1 -Force | Out-Null
            }
        Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Deny"
        Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 0
    
    # Disable language list access for relevant content
        $Language = "HKCU:\Control Panel\International\User Profile"
        If (!(Test-Path $Language)) {
            New-Item -Path $Language | Out-Null
        }
        Set-ItemProperty -Path $Language -Name "HttpAcceptLanguageOptOut " -Type DWord -Value 1
    
    # Disable automatic Maps updates
        Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
    
    # Disable Speech Recognition
        $Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
        If (!(Test-Path $Speech)) {
            New-Item -Path $Speech | Out-Null
        }
        Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 0
    
    # Disable suggestions and bloatware auto-install
        $Suggestions1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        $Suggestions2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        Set-ItemProperty -Path $Suggestions1 -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
        Set-ItemProperty -Path $Suggestions1 -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
        Set-ItemProperty -Path $Suggestions2 -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
        Set-ItemProperty -Path $Suggestions1 -Name "SoftLandingEnabled" -Type DWord -Value 0
        Set-ItemProperty -Path $Suggestions1 -Name "SubscribedContent" -Type DWord -Value 0
    
    Write-Host "Data collection has been disabled."
})


$EnableDataCollection.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'

	# Enable advertising ID
        $Advertising = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
        Remove-ItemProperty -Path $Advertising -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue

	# Enable activity history
        $ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
        Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
        Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
        Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	
	# Enable feedback
        $Feedback = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
        If (!(Test-Path $Feedback )) {
            New-Item $Feedback -Force | Out-Null
            }
        Remove-ItemProperty -Path $Feedback -Name "NumberOfSIUFInPeriod"

	# Enable language list
        $LanguageList = "HKCU:\Control Panel\International\User Profile"
        If (!(Test-Path $LanguageList)) {
            New-Item -Path $LanguageList | Out-Null
            }
        Set-ItemProperty -Path $LanguageList  -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
        
	# Enable location tracking
        $Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
        $Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
        If (!(Test-Path )) {
            New-Item -Path $Location1 -Force | Out-Null
            }
        Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Allow"
        Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 1
        
	# Disable Maps updates
        Remove-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled"

	# Enable suggestions and bloatware auto-install
        $Suggestions1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        $Suggestions2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        Remove-ItemProperty -Path $Suggestions1 -Name "SilentInstalledAppsEnabled"
        Remove-ItemProperty -Path $Suggestions1 -Name "SystemPaneSuggestionsEnabled"
        Remove-ItemProperty -Path $Suggestions2 -Name "ShowSyncProviderNotifications"
        Remove-ItemProperty -Path $Suggestions1 -Name "SoftLandingEnabled"
        Remove-ItemProperty -Path $Suggestions1 -Name "SubscribedContent"

	# Enable speech recognition
        $Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
        If (!(Test-Path )) {
            New-Item -Path $Speech | Out-Null
            }
        Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 1
	
	# Enable Tailored Experiences
        $TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        $TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
        $TailoredExp3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        Remove-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData"
        Remove-ItemProperty -Path $TailoredExp2 -Name "Disabled"
        Remove-ItemProperty -Path $TailoredExp3 -Name "DoNotShowFeedbackNotifications"
	
	# Enable telemetry
        $Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        $Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        $Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        Set-ItemProperty -Path $Telemetry1  -Name "AllowTelemetry" -Type DWord -Value 3
        Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 3
        Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 3
	
	# Start telemetry services
        Start-Service DiagTrack | Set-Service -StartupType Automatic
        Start-Service dmwappushservice | Set-Service -StartupType Automatic
	
	# Enable tasks
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
        Enable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
    
    Write-Host "Data collection has been enabled."
})

$OOShutup10.Add_Click( {
        $ErrorActionPreference = 'SilentlyContinue'
	    Import-Module BitsTransfer
	    Start-BitsTransfer -Source "https://raw.githubusercontent.com/pratyakshm/CleanWin/master/files/ooshutup10.cfg" -Destination ooshutup10.cfg
	    Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
	    ./OOSU10.exe ooshutup10.cfg /quiet
        Remove-Item ooshutup10.cfg
        Remove-Item  OOSU10.exe
        Write-Host "O&OShutup10 settings have been applied."
    })

$HostsTelemetry.Add_Click( {
        $ErrorActionPreference = 'SilentlyContinue'
        Import-Module BitsTransfer
        Start-BitsTransfer -Source "https://raw.githubusercontent.com/pratyakshm/CleanWin/master/files/hosts-telemetry.bat" -Destination hoststelemetry.bat
        ./hoststelemetry.bat /quiet
        Remove-Item hoststelemetry.bat
        Write-Host "Telemetry IP addresses have been blocked using the hosts file."
})

####################################
######### F E A T U R E S ##########
####################################

$InstallNet35.Add_Click( {
        DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /NoRestart /Quiet
        Write-Host "dotNET 3.5 has been installed."
    } )

$InstallWSL.Add_Click( {
        dism.exe /Online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /all /NoRestart /Quiet
		dism.exe /Online /Enable-Feature /FeatureName:VirtualMachinePlatform /All /NoRestart /Quiet
        dism.exe /Online /Enable-Feature /FeatureName:Microsoft-Hyper-V /All /NoRestart	/Quiet
        Write-Host "WIndows Subsystem for Linux has been enabled."
})

$UninstallBloatFeatures.Add_Click( {
        Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -like "Internet-Explorer-Optional*" } | Disable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
        Get-WindowsCapability -Online | Where-Object { $_.Name -like "Browser.InternetExplorer*" } | Remove-WindowsCapability -Online | Out-Null	Get-WindowsCapability -Online | Where-Object { $_.Name -like "MathRecognizer*" } | Remove-WindowsCapability -Online | Out-Null
        Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq "WorkFolders-Client" } | Disable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
        Get-WindowsCapability -Online | Where-Object { $_.Name -like "Hello.Face*" } | Remove-WindowsCapability -Online | Out-Null
        Get-WindowsCapability -Online | Where-Object { $_.Name -like "MathRecognizer*" } | Remove-WindowsCapability -Online | Out-Null
        Write-Host "Bloatware features have been uninstalled."
})
##############################
##### S E R V I C E S ########
##############################

$DisableAutoUpdates.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
    $Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
        If (!(Test-Path $Update1)) {
          New-Item -Path $Update1 | Out-Null
          New-Item -Path $Update2 | Out-Null
          }
    Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
    Write-Host "Automatic Windows updates have been disabled."
})

$EnableAutoUpdates.Add_Click( {
$ErrorActionPreference = 'SilentlyContinue'
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse -ErrorAction SilentlyContinue 
    Write-Host "Automatic Windows updates have been enabled."
})

$DisableDefrag.Add_Click( {
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Defrag\ScheduledDefrag" | Out-Null
    Write-Host "Disk defragmentation has been disabled."
})

$EnableDefrag.Add_Click( {
    Enable-ScheduledTask -TaskName "Microsoft\Windows\Defrag\ScheduledDefrag" | Out-Null
    Write-Host "Disk defragmentation has been enabled."
})

[void]$Form.ShowDialog()