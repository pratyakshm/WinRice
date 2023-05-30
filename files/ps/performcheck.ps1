#Import RunWithProgress
. "$PSScriptRoot\RunWithProgress.ps1"

# Check 1: If supported OS build.
$oscheck = {
	$CurrentBuild = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuild
	if ($CurrentBuild -lt 19044) {
		return $false
	}
	elseif ($CurrentBuild -ge 19044) {
		return $true
	}
}
RunWithProgress -Text "[1/4] Windows version is supported" -Task $oscheck -Exit $true | Out-Null


# Check 2: If session is elevated.
$isadmin = {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	$admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
	return $admin
}
RunWithProgress -Text "[2/4] Session is elevated" -Task $isadmin -Exit $true | Out-Null


# Check 3: Internet Connection.
$isonline = {
	Import-Module BitsTransfer
	Start-BitsTransfer "https://raw.githubusercontent.com/WinRice/Files/main/File.txt"
	if (Test-Path File.txt) {
		Remove-Item File.txt
		return $true
	}
	elseif (!(Test-Path File.txt)) {
		return $false | Out-Null
	}
}
RunWithProgress -Text "[3/4] Device is connected to the Internet" -Task $isonline -Exit $true | Out-Null


# Task 1: Import Appx Module to PowerShell if necessary.
$pwshver = {
	Import-Module -Name Appx -UseWindowsPowerShell -WarningAction "SilentlyContinue" | Out-Null
	return $true
}
RunWithProgress -Text "[4/5] Setting up PowerShell" -Task $pwshver -Exit $true | Out-Null


# Check 5: Check for pending restarts (part of code used here was picked from https://thesysadminchannel.com/remotely-check-pending-reboot-status-powershell).
$isrestartpending = {
	param (
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 0
		)]
		[string[]]  $ComputerName = $env:COMPUTERNAME
	)
	ForEach ($Computer in $ComputerName) {
		$PendingReboot = $false
		$HKLM = [UInt32] "0x80000002"
		$WMI_Reg = [WMIClass] "\\$Computer\root\default:StdRegProv"
		if ($WMI_Reg) {
			if (($WMI_Reg.EnumKey($HKLM, "SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\")).sNames -contains 'RebootPending') { $PendingReboot = $true }
			if (($WMI_Reg.EnumKey($HKLM, "SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\")).sNames -contains 'RebootRequired') { $PendingReboot = $true }
		
			# Check for SCCM namespace.
			$SCCM_Namespace = Get-WmiObject -Namespace ROOT\CCM\ClientSDK -List -ComputerName $Computer -ErrorAction Ignore
			if ($SCCM_Namespace) {
				if (([WmiClass]"\\$Computer\ROOT\CCM\ClientSDK:CCM_ClientUtilities").DetermineIfRebootPending().RebootPending -eq $true) { $PendingReboot = $true }
			}
		
			if ($PendingReboot -eq $true) {
				return $false
			}
			else {
				return $true
			}
		}   
	}
}
# Clear variables.
$WMI_Reg = $null
$SCCM_Namespace = $null
RunWithProgress -Text "[4/4] Device session is fresh" -Task $isrestartpending -Exit $true | Out-Null
