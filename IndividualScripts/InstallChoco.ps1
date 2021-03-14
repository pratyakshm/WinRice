# This file is a part of the CleanWin software
# Copyright (c) 2021 PratyakshM <pratyakshm@protonmail.com>
# All rights reserved.

<#
    .SYNOPSIS
    Downloads and installs Chocolatey on the local machine.

    .DESCRIPTION
    Retrieves the Chocolatey nupkg for the latest or a specified version, and
    downloads and installs the application to the local machine.

    .NOTES
    =====================================================================
    Copyright 2017 - 2020 Chocolatey Software, Inc, and the
    original authors/contributors from ChocolateyGallery
    Copyright 2011 - 2017 RealDimensions Software, LLC, and the
    original authors/contributors from ChocolateyGallery
    at https://github.com/chocolatey/chocolatey.org

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    =====================================================================

    Environment Variables, specified as $env:NAME in PowerShell.exe and %NAME% in cmd.exe.
    For explicit proxy, please set $env:chocolateyProxyLocation and optionally $env:chocolateyProxyUser and $env:chocolateyProxyPassword
    For an explicit version of Chocolatey, please set $env:chocolateyVersion = 'versionnumber'
    To target a different url for chocolatey.nupkg, please set $env:chocolateyDownloadUrl = 'full url to nupkg file'
    NOTE: $env:chocolateyDownloadUrl does not work with $env:chocolateyVersion.
    To use built-in compression instead of 7zip (requires additional download), please set $env:chocolateyUseWindowsCompression = 'true'
    To bypass the use of any proxy, please set $env:chocolateyIgnoreProxy = 'true'

    .LINK
    For organizational deployments of Chocolatey, please see https://docs.chocolatey.org/en-us/guides/organizations/organizational-deployment-guide

#>
[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
    # The URL to download Chocolatey from. This defaults to the value of
    # $env:chocolateyDownloadUrl, if it is set, and otherwise falls back to the
    # official Chocolatey community repository to download the Chocolatey package.
    [Parameter(Mandatory = $false)]
    [string]
    $ChocolateyDownloadUrl = $env:chocolateyDownloadUrl,

    # Specifies a target version of Chocolatey to install. By default, the latest
    # stable version is installed. This will use the value in
    # $env:chocolateyVersion by default, if that environment variable is present.
    # This parameter is ignored if -ChocolateyDownloadUrl is set.
    [Parameter(Mandatory = $false)]
    [string]
    $ChocolateyVersion = $env:chocolateyVersion,

    # If set, uses built-in Windows decompression tools instead of 7zip when
    # unpacking the downloaded nupkg. This will be set by default if
    # $env:chocolateyUseWindowsCompression is set to a value other than 'false' or '0'.
    #
    # This parameter will be ignored in PS 5+ in favour of using the
    # Expand-Archive built in PowerShell cmdlet directly.
    [Parameter(Mandatory = $false)]
    [switch]
    $UseNativeUnzip = $(
        $envVar = "$env:chocolateyUseWindowsCompression".Trim()
        $value = $null
        if ([bool]::TryParse($envVar, [ref] $value)) {
            $value
        } elseif ([int]::TryParse($envVar, [ref] $value)) {
            [bool]$value
        } else {
            [bool]$envVar
        }
    ),

    # If set, ignores any configured proxy. This will override any proxy
    # environment variables or parameters. This will be set by default if
    # $env:chocolateyIgnoreProxy is set to a value other than 'false' or '0'.
    [Parameter(Mandatory = $false)]
    [switch]
    $IgnoreProxy = $(
        $envVar = "$env:chocolateyIgnoreProxy".Trim()
        $value = $null
        if ([bool]::TryParse($envVar, [ref] $value)) {
            $value
        }
        elseif ([int]::TryParse($envVar, [ref] $value)) {
            [bool]$value
        }
        else {
            [bool]$envVar
        }
    ),

    # Specifies the proxy URL to use during the download. This will default to
    # the value of $env:chocolateyProxyLocation, if any is set.
    [Parameter(ParameterSetName = 'Proxy', Mandatory = $false)]
    [string]
    $ProxyUrl = $env:chocolateyProxyLocation,

    # Specifies the credential to use for an authenticated proxy. By default, a
    # proxy credential will be constructed from the $env:chocolateyProxyUser and
    # $env:chocolateyProxyPassword environment variables, if both are set.
    [Parameter(ParameterSetName = 'Proxy', Mandatory = $false)]
    [System.Management.Automation.PSCredential]
    $ProxyCredential
)

#region Functions

function Get-Downloader {
    <#
    .SYNOPSIS
    Gets a System.Net.WebClient that respects relevant proxies to be used for
    downloading data.

    .DESCRIPTION
    Retrieves a WebClient object that is pre-configured according to specified
    environment variables for any proxy and authentication for the proxy.
    Proxy information may be omitted if the target URL is considered to be
    bypassed by the proxy (originates from the local network.)

    .PARAMETER Url
    Target URL that the WebClient will be querying. This URL is not queried by
    the function, it is only a reference to determine if a proxy is needed.

    .EXAMPLE
    Get-Downloader -Url $fileUrl

    Verifies whether any proxy configuration is needed, and/or whether $fileUrl
    is a URL that would need to bypass the proxy, and then outputs the
    already-configured WebClient object.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]
        $Url,

        [Parameter(Mandatory = $false)]
        [string]
        $ProxyUrl,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        $ProxyCredential
    )

    $downloader = New-Object System.Net.WebClient

    $defaultCreds = [System.Net.CredentialCache]::DefaultCredentials
    if ($defaultCreds) {
        $downloader.Credentials = $defaultCreds
    }

    if ($ProxyUrl) {
        # Use explicitly set proxy.
        Write-Host "Using explicit proxy server '$ProxyUrl'."
        $proxy = New-Object System.Net.WebProxy -ArgumentList $ProxyUrl, <# bypassOnLocal: #> $true

        $proxy.Credentials = if ($ProxyCredential) {
            $ProxyCredential.GetNetworkCredential()
        } elseif ($defaultCreds) {
            $defaultCreds
        } else {
            Write-Warning "Default credentials were null, and no explicitly set proxy credentials were found. Attempting backup method."
            (Get-Credential).GetNetworkCredential()
        }

        if (-not $proxy.IsBypassed($Url)) {
            $downloader.Proxy = $proxy
        }
    } else {
        Write-Host "Not using proxy."
    }

    $downloader
}

function Request-String {
    <#
    .SYNOPSIS
    Downloads content from a remote server as a string.

    .DESCRIPTION
    Downloads target string content from a URL and outputs the resulting string.
    Any existing proxy that may be in use will be utilised.

    .PARAMETER Url
    URL to download string data from.

    .PARAMETER ProxyConfiguration
    A hashtable containing proxy parameters (ProxyUrl and ProxyCredential)

    .EXAMPLE
    Request-String https://chocolatey.org/install.ps1

    Retrieves the contents of the string data at the targeted URL and outputs
    it to the pipeline.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Url,

        [Parameter(Mandatory = $false)]
        [hashtable]
        $ProxyConfiguration
    )

    (Get-Downloader $url @ProxyConfiguration).DownloadString($url)
}

function Request-File {
    <#
    .SYNOPSIS
    Downloads a file from a given URL.

    .DESCRIPTION
    Downloads a target file from a URL to the specified local path.
    Any existing proxy that may be in use will be utilised.

    .PARAMETER Url
    URL of the file to download from the remote host.

    .PARAMETER File
    Local path for the file to be downloaded to.

    .PARAMETER ProxyConfiguration
    A hashtable containing proxy parameters (ProxyUrl and ProxyCredential)

    .EXAMPLE
    Request-File -Url https://chocolatey.org/install.ps1 -File $targetFile

    Downloads the install.ps1 script to the path specified in $targetFile.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]
        $Url,

        [Parameter(Mandatory = $false)]
        [string]
        $File,

        [Parameter(Mandatory = $false)]
        [hashtable]
        $ProxyConfiguration
    )

    Write-Host "Downloading $url to $file"
    (Get-Downloader $url @ProxyConfiguration).DownloadFile($url, $file)
}

function Set-PSConsoleWriter {
    <#
    .SYNOPSIS
    Workaround for a bug in output stream handling PS v2 or v3.

    .DESCRIPTION
    PowerShell v2/3 caches the output stream. Then it throws errors due to the
    FileStream not being what is expected. Fixes "The OS handle's position is
    not what FileStream expected. Do not use a handle simultaneously in one
    FileStream and in Win32 code or another FileStream." error.

    .EXAMPLE
    Set-PSConsoleWriter

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param()
    if ($PSVersionTable.PSVersion.Major -gt 3) {
        return
    }

    try {
        # http://www.leeholmes.com/blog/2008/07/30/workaround-the-os-handles-position-is-not-what-filestream-expected/ plus comments
        $bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
        $objectRef = $host.GetType().GetField("externalHostRef", $bindingFlags).GetValue($host)

        $bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetProperty"
        $consoleHost = $objectRef.GetType().GetProperty("Value", $bindingFlags).GetValue($objectRef, @())
        [void] $consoleHost.GetType().GetProperty("IsStandardOutputRedirected", $bindingFlags).GetValue($consoleHost, @())

        $bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
        $field = $consoleHost.GetType().GetField("standardOutputWriter", $bindingFlags)
        $field.SetValue($consoleHost, [Console]::Out)

        [void] $consoleHost.GetType().GetProperty("IsStandardErrorRedirected", $bindingFlags).GetValue($consoleHost, @())
        $field2 = $consoleHost.GetType().GetField("standardErrorWriter", $bindingFlags)
        $field2.SetValue($consoleHost, [Console]::Error)
    } catch {
        Write-Warning "Unable to apply redirection fix."
    }
}

function Test-ChocolateyInstalled {
    [CmdletBinding()]
    param()

    $checkPath = if ($env:ChocolateyInstall) { $env:ChocolateyInstall } else { "$env:PROGRAMDATA\chocolatey" }

    if (Get-Command choco -CommandType Application -ErrorAction Ignore) {
        # choco is on the PATH, assume it's installed
        $true
    }
    elseif (-not (Test-Path $checkPath)) {
        # Install folder doesn't exist
        $false
    }
    elseif (-not (Get-ChildItem -Path $checkPath)) {
        # Install folder exists but is empty
        $false
    }
    else {
        # Install folder exists and is not empty
        $true
    }
}

function Install-7zip {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Path,

        [Parameter(Mandatory = $false)]
        [hashtable]
        $ProxyConfiguration
    )

    if (-not (Test-Path ($Path))) {
        Write-Host "Downloading 7-Zip commandline tool prior to extraction."
        Request-File -Url 'https://chocolatey.org/7za.exe' -File $Path -ProxyConfiguration $ProxyConfiguration

    }
    else {
        Write-Host "7zip already present, skipping installation."
    }
}

#endregion Functions

#region Pre-check

# Ensure we have all our streams setup correctly, needed for older PSVersions.
Set-PSConsoleWriter

if (Test-ChocolateyInstalled) {
    $message = @(
        "An existing Chocolatey installation was detected. Installation will not continue."
        "For security reasons, this script will not overwrite existing installations."
        ""
        "Please use `choco upgrade chocolatey` to handle upgrades of Chocolatey itself."
    ) -join [Environment]::NewLine

    Write-Warning $message

    return
}

#endregion Pre-check

#region Setup

$proxyConfig = if ($IgnoreProxy -or -not $ProxyUrl) {
    @{}
} else {
    $config = @{
        ProxyUrl = $ProxyUrl
    }

    if ($ProxyCredential) {
        $config['ProxyCredential'] = $ProxyCredential
    } elseif ($env:chocolateyProxyUser -and $env:chocolateyProxyPassword) {
        $securePass = ConvertTo-SecureString $env:chocolateyProxyPassword -AsPlainText -Force
        $config['ProxyCredential'] = [System.Management.Automation.PSCredential]::new($env:chocolateyProxyUser, $securePass)
    }

    $config
}

# Attempt to set highest encryption available for SecurityProtocol.
# PowerShell will not set this by default (until maybe .NET 4.6.x). This
# will typically produce a message for PowerShell v2 (just an info
# message though)
try {
    # Set TLS 1.2 (3072) as that is the minimum required by Chocolatey.org.
    # Use integers because the enumeration value for TLS 1.2 won't exist
    # in .NET 4.0, even though they are addressable if .NET 4.5+ is
    # installed (.NET 4.5 is an in-place upgrade).
    Write-Host "Forcing web requests to allow TLS v1.2 (Required for requests to Chocolatey.org)"
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
}
catch {
    $errorMessage = @(
        'Unable to set PowerShell to use TLS 1.2. This is required for contacting Chocolatey as of 03 FEB 2020.'
        'https://chocolatey.org/blog/remove-support-for-old-tls-versions.'
        'If you see underlying connection closed or trust errors, you may need to do one or more of the following:'
        '(1) upgrade to .NET Framework 4.5+ and PowerShell v3+,'
        '(2) Call [System.Net.ServicePointManager]::SecurityProtocol = 3072; in PowerShell prior to attempting installation,'
        '(3) specify internal Chocolatey package location (set $env:chocolateyDownloadUrl prior to install or host the package internally),'
        '(4) use the Download + PowerShell method of install.'
        'See https://chocolatey.org/docs/installation for all install options.'
    ) -join [Environment]::NewLine
    Write-Warning $errorMessage
}

if ($ChocolateyDownloadUrl) {
    if ($ChocolateyVersion) {
        Write-Warning "Ignoring -ChocolateyVersion parameter ($ChocolateyVersion) because -ChocolateyDownloadUrl is set."
    }

    Write-Host "Downloading Chocolatey from: $ChocolateyDownloadUrl"
} elseif ($ChocolateyVersion) {
    Write-Host "Downloading specific version of Chocolatey: $ChocolateyVersion"
    $ChocolateyDownloadUrl = "https://chocolatey.org/api/v2/package/chocolatey/$ChocolateyVersion"
} else {
    Write-Host "Getting latest version of the Chocolatey package for download."
    $queryString = [uri]::EscapeUriString("((Id eq 'chocolatey') and (not IsPrerelease)) and IsLatestVersion")
    $queryUrl = 'https://chocolatey.org/api/v2/Packages()?$filter={0}' -f $queryString

    [xml]$result = Request-String -Url $queryUrl -ProxyConfiguration $proxyConfig
    $ChocolateyDownloadUrl = $result.feed.entry.content.src
}

if (-not $env:TEMP) {
    $env:TEMP = Join-Path $env:SystemDrive -ChildPath 'temp'
}

$chocoTempDir = Join-Path $env:TEMP -ChildPath "chocolatey"
$tempDir = Join-Path $chocoTempDir -ChildPath "chocoInstall"

if (-not (Test-Path $tempDir -PathType Container)) {
    $null = New-Item -Path $tempDir -ItemType Directory
}

$file = Join-Path $tempDir "chocolatey.zip"

#endregion Setup

#region Download & Extract Chocolatey

Write-Host "Getting Chocolatey from $ChocolateyDownloadUrl."
Request-File -Url $ChocolateyDownloadUrl -File $file -ProxyConfiguration $proxyConfig

Write-Host "Extracting $file to $tempDir"
if ($PSVersionTable.PSVersion.Major -lt 5) {
    # Determine unzipping method
    # 7zip is the most compatible pre-PSv5.1 so use it unless asked to use builtin
    if ($UseNativeUnzip) {
        Write-Host 'Using built-in compression to unzip'

        try {
            $shellApplication = New-Object -ComObject Shell.Application
            $zipPackage = $shellApplication.NameSpace($file)
            $destinationFolder = $shellApplication.NameSpace($tempDir)
            $destinationFolder.CopyHere($zipPackage.Items(), 0x10)
        } catch {
            Write-Warning "Unable to unzip package using built-in compression. Set `$env:chocolateyUseWindowsCompression = ''` or omit -UseNativeUnzip and retry to use 7zip to unzip."
            throw $_
        }
    } else {
        $7zaExe = Join-Path $tempDir -ChildPath '7za.exe'
        Install-7zip -Path $7zaExe -ProxyConfiguration $proxyConfig

        $params = 'x -o"{0}" -bd -y "{1}"' -f $tempDir, $file

        # use more robust Process as compared to Start-Process -Wait (which doesn't
        # wait for the process to finish in PowerShell v3)
        $process = New-Object System.Diagnostics.Process

        try {
            $process.StartInfo = New-Object System.Diagnostics.ProcessStartInfo -ArgumentList $7zaExe, $params
            $process.StartInfo.RedirectStandardOutput = $true
            $process.StartInfo.UseShellExecute = $false
            $process.StartInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden

            $null = $process.Start()
            $process.BeginOutputReadLine()
            $process.WaitForExit()

            $exitCode = $process.ExitCode
        }
        finally {
            $process.Dispose()
        }

        $errorMessage = "Unable to unzip package using 7zip. Perhaps try setting `$env:chocolateyUseWindowsCompression = 'true' and call install again. Error:"
        if ($exitCode -ne 0) {
            $errorDetails = switch ($exitCode) {
                1 { "Some files could not be extracted" }
                2 { "7-Zip encountered a fatal error while extracting the files" }
                7 { "7-Zip command line error" }
                8 { "7-Zip out of memory" }
                255 { "Extraction cancelled by the user" }
                default { "7-Zip signalled an unknown error (code $exitCode)" }
            }

            throw ($errorMessage, $errorDetails -join [Environment]::NewLine)
        }
    }
} else {
    Microsoft.PowerShell.Archive\Expand-Archive -Path $file -DestinationPath $tempDir -Force
}

#endregion Download & Extract Chocolatey

#region Install Chocolatey

Write-Host "Installing Chocolatey on the local machine"
$toolsFolder = Join-Path $tempDir -ChildPath "tools"
$chocoInstallPS1 = Join-Path $toolsFolder -ChildPath "chocolateyInstall.ps1"

& $chocoInstallPS1

Write-Host 'Ensuring Chocolatey commands are on the path'
$chocoInstallVariableName = "ChocolateyInstall"
$chocoPath = [Environment]::GetEnvironmentVariable($chocoInstallVariableName)

if (-not $chocoPath) {
    $chocoPath = "$env:ALLUSERSPROFILE\Chocolatey"
}

if (-not (Test-Path ($chocoPath))) {
    $chocoPath = "$env:PROGRAMDATA\chocolatey"
}

$chocoExePath = Join-Path $chocoPath -ChildPath 'bin'

# Update current process PATH environment variable if it needs updating.
if ($env:Path -notlike "*$chocoExePath*") {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine);
}

Write-Host 'Ensuring chocolatey.nupkg is in the lib folder'
$chocoPkgDir = Join-Path $chocoPath -ChildPath 'lib\chocolatey'
$nupkg = Join-Path $chocoPkgDir -ChildPath 'chocolatey.nupkg'

if (-not (Test-Path $chocoPkgDir -PathType Container)) {
    $null = New-Item -ItemType Directory -Path $chocoPkgDir
}

Copy-Item -Path $file -Destination $nupkg -Force -ErrorAction SilentlyContinue

#endregion Install Chocolatey

# SIG # Begin signature block
# MIIZsAYJKoZIhvcNAQcCoIIZoTCCGZ0CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAzlIBFeN+ynYN8
# JNM5ASZCpOKfrMEgLzLoVRUonuhY7KCCFKkwggT+MIID5qADAgECAhANQkrgvjqI
# /2BAIc4UAPDdMA0GCSqGSIb3DQEBCwUAMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNV
# BAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0EwHhcN
# MjEwMTAxMDAwMDAwWhcNMzEwMTA2MDAwMDAwWjBIMQswCQYDVQQGEwJVUzEXMBUG
# A1UEChMORGlnaUNlcnQsIEluYy4xIDAeBgNVBAMTF0RpZ2lDZXJ0IFRpbWVzdGFt
# cCAyMDIxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwuZhhGfFivUN
# CKRFymNrUdc6EUK9CnV1TZS0DFC1JhD+HchvkWsMlucaXEjvROW/m2HNFZFiWrj/
# ZwucY/02aoH6KfjdK3CF3gIY83htvH35x20JPb5qdofpir34hF0edsnkxnZ2OlPR
# 0dNaNo/Go+EvGzq3YdZz7E5tM4p8XUUtS7FQ5kE6N1aG3JMjjfdQJehk5t3Tjy9X
# tYcg6w6OLNUj2vRNeEbjA4MxKUpcDDGKSoyIxfcwWvkUrxVfbENJCf0mI1P2jWPo
# GqtbsR0wwptpgrTb/FZUvB+hh6u+elsKIC9LCcmVp42y+tZji06lchzun3oBc/gZ
# 1v4NSYS9AQIDAQABo4IBuDCCAbQwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQC
# MAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwQQYDVR0gBDowODA2BglghkgBhv1s
# BwEwKTAnBggrBgEFBQcCARYbaHR0cDovL3d3dy5kaWdpY2VydC5jb20vQ1BTMB8G
# A1UdIwQYMBaAFPS24SAd/imu0uRhpbKiJbLIFzVuMB0GA1UdDgQWBBQ2RIaOpLqw
# Zr68KC0dRDbd42p6vDBxBgNVHR8EajBoMDKgMKAuhixodHRwOi8vY3JsMy5kaWdp
# Y2VydC5jb20vc2hhMi1hc3N1cmVkLXRzLmNybDAyoDCgLoYsaHR0cDovL2NybDQu
# ZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC10cy5jcmwwgYUGCCsGAQUFBwEBBHkw
# dzAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME8GCCsGAQUF
# BzAChkNodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEyQXNz
# dXJlZElEVGltZXN0YW1waW5nQ0EuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBIHNy1
# 6ZojvOca5yAOjmdG/UJyUXQKI0ejq5LSJcRwWb4UoOUngaVNFBUZB3nw0QTDhtk7
# vf5EAmZN7WmkD/a4cM9i6PVRSnh5Nnont/PnUp+Tp+1DnnvntN1BIon7h6JGA078
# 9P63ZHdjXyNSaYOC+hpT7ZDMjaEXcw3082U5cEvznNZ6e9oMvD0y0BvL9WH8dQgA
# dryBDvjA4VzPxBFy5xtkSdgimnUVQvUtMjiB2vRgorq0Uvtc4GEkJU+y38kpqHND
# Udq9Y9YfW5v3LhtPEx33Sg1xfpe39D+E68Hjo0mh+s6nv1bPull2YYlffqe0jmd4
# +TaY4cso2luHpoovMIIFMDCCBBigAwIBAgIQBAkYG1/Vu2Z1U0O1b5VQCDANBgkq
# hkiG9w0BAQsFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
# MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBB
# c3N1cmVkIElEIFJvb3QgQ0EwHhcNMTMxMDIyMTIwMDAwWhcNMjgxMDIyMTIwMDAw
# WjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3Vy
# ZWQgSUQgQ29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
# CgKCAQEA+NOzHH8OEa9ndwfTCzFJGc/Q+0WZsTrbRPV/5aid2zLXcep2nQUut4/6
# kkPApfmJ1DcZ17aq8JyGpdglrA55KDp+6dFn08b7KSfH03sjlOSRI5aQd4L5oYQj
# ZhJUM1B0sSgmuyRpwsJS8hRniolF1C2ho+mILCCVrhxKhwjfDPXiTWAYvqrEsq5w
# MWYzcT6scKKrzn/pfMuSoeU7MRzP6vIK5Fe7SrXpdOYr/mzLfnQ5Ng2Q7+S1TqSp
# 6moKq4TzrGdOtcT3jNEgJSPrCGQ+UpbB8g8S9MWOD8Gi6CxR93O8vYWxYoNzQYIH
# 5DiLanMg0A9kczyen6Yzqf0Z3yWT0QIDAQABo4IBzTCCAckwEgYDVR0TAQH/BAgw
# BgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwMweQYI
# KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6
# Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmww
# OqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJ
# RFJvb3RDQS5jcmwwTwYDVR0gBEgwRjA4BgpghkgBhv1sAAIEMCowKAYIKwYBBQUH
# AgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCgYIYIZIAYb9bAMwHQYD
# VR0OBBYEFFrEuXsqCqOl6nEDwGD5LfZldQ5YMB8GA1UdIwQYMBaAFEXroq/0ksuC
# MS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBCwUAA4IBAQA+7A1aJLPzItEVyCx8JSl2
# qB1dHC06GsTvMGHXfgtg/cM9D8Svi/3vKt8gVTew4fbRknUPUbRupY5a4l4kgU4Q
# pO4/cY5jDhNLrddfRHnzNhQGivecRk5c/5CxGwcOkRX7uq+1UcKNJK4kxscnKqEp
# KBo6cSgCPC6Ro8AlEeKcFEehemhor5unXCBc2XGxDI+7qPjFEmifz0DLQESlE/Dm
# ZAwlCEIysjaKJAL+L3J+HNdJRZboWR3p+nRka7LrZkPas7CM1ekN3fYBIM6ZMWM9
# CBoYs4GbT8aTEAb8B4H6i9r5gkn3Ym6hU/oSlBiFLpKR6mhsRDKyZqHnGKSaZFHv
# MIIFMTCCBBmgAwIBAgIQCqEl1tYyG35B5AXaNpfCFTANBgkqhkiG9w0BAQsFADBl
# MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
# d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJv
# b3QgQ0EwHhcNMTYwMTA3MTIwMDAwWhcNMzEwMTA3MTIwMDAwWjByMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0
# YW1waW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvdAy7kvN
# j3/dqbqCmcU5VChXtiNKxA4HRTNREH3Q+X1NaH7ntqD0jbOI5Je/YyGQmL8TvFfT
# w+F+CNZqFAA49y4eO+7MpvYyWf5fZT/gm+vjRkcGGlV+Cyd+wKL1oODeIj8O/36V
# +/OjuiI+GKwR5PCZA207hXwJ0+5dyJoLVOOoCXFr4M8iEA91z3FyTgqt30A6XLdR
# 4aF5FMZNJCMwXbzsPGBqrC8HzP3w6kfZiFBe/WZuVmEnKYmEUeaC50ZQ/ZQqLKfk
# dT66mA+Ef58xFNat1fJky3seBdCEGXIX8RcG7z3N1k3vBkL9olMqT4UdxB08r8/a
# rBD13ays6Vb/kwIDAQABo4IBzjCCAcowHQYDVR0OBBYEFPS24SAd/imu0uRhpbKi
# JbLIFzVuMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMBIGA1UdEwEB
# /wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMI
# MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNl
# cnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRo
# dHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
# Y3JsMDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3JsMFAGA1UdIARJMEcwOAYKYIZIAYb9bAACBDAqMCgGCCsG
# AQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAsGCWCGSAGG/WwH
# ATANBgkqhkiG9w0BAQsFAAOCAQEAcZUS6VGHVmnN793afKpjerN4zwY3QITvS4S/
# ys8DAv3Fp8MOIEIsr3fzKx8MIVoqtwU0HWqumfgnoma/Capg33akOpMP+LLR2HwZ
# YuhegiUexLoceywh4tZbLBQ1QwRostt1AuByx5jWPGTlH0gQGF+JOGFNYkYkh2OM
# kVIsrymJ5Xgf1gsUpYDXEkdws3XVk4WTfraSZ/tTYYmo9WuWwPRYaQ18yAGxuSh1
# t5ljhSKMYcp5lH5Z/IwP42+1ASa2bKXuh1Eh5Fhgm7oMLSttosR+u8QlK0cCCHxJ
# rhO24XxCQijGGFbPQTS2Zl22dHv1VjMiLyI2skuiSpXY9aaOUjCCBTowggQioAMC
# AQICEAf7Rdn3C1UpA2CXtPThQ3AwDQYJKoZIhvcNAQELBQAwcjELMAkGA1UEBhMC
# VVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0
# LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIENvZGUgU2ln
# bmluZyBDQTAeFw0xODAzMzAwMDAwMDBaFw0yMTA0MTQxMjAwMDBaMHcxCzAJBgNV
# BAYTAlVTMQ8wDQYDVQQIEwZLYW5zYXMxDzANBgNVBAcTBlRvcGVrYTEiMCAGA1UE
# ChMZQ2hvY29sYXRleSBTb2Z0d2FyZSwgSW5jLjEiMCAGA1UEAxMZQ2hvY29sYXRl
# eSBTb2Z0d2FyZSwgSW5jLjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# ALiKt0tZUmvJ8pKA88LIw36cGbG1kiaZMGEkxphUnqC1+8dwVqQfsgLxNyNwQiuQ
# rvAH/a8QmQSqI5OBtVA9kud9fxkDGF1SImbBAcSJLAvOijYHflE5D2p06yfVtggT
# MOlqqb9fBgf3bksunGGv2gKQE1/l1mx7ltz+zUnmxD0dFjClvcyKaY0cak0/9iGN
# df+Q0UJki/eZRp0UeL61qVgg3l2npqL+T6qBl4vmSU92aPIiB/cmIPLAJ/uPmdJu
# bexZqtiMzm8t7+gP54rvR97PfRrXsLL3sm2qZ3PpZRXUFxsxZ5v1vzHfr1Qmrm+3
# u8bBUUM54aPB9+5UctG9YucCAwEAAaOCAcUwggHBMB8GA1UdIwQYMBaAFFrEuXsq
# CqOl6nEDwGD5LfZldQ5YMB0GA1UdDgQWBBSpGVgIws6+wNRLibH1QDVq8Pd++DAO
# BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwdwYDVR0fBHAwbjA1
# oDOgMYYvaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1jcy1n
# MS5jcmwwNaAzoDGGL2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3Vy
# ZWQtY3MtZzEuY3JsMEwGA1UdIARFMEMwNwYJYIZIAYb9bAMBMCowKAYIKwYBBQUH
# AgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCAYGZ4EMAQQBMIGEBggr
# BgEFBQcBAQR4MHYwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBOBggrBgEFBQcwAoZCaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0U0hBMkFzc3VyZWRJRENvZGVTaWduaW5nQ0EuY3J0MAwGA1UdEwEB/wQCMAAw
# DQYJKoZIhvcNAQELBQADggEBAD511yzP80H/5X4AiVQ05VOUYM0K2fUB+/ChFmD1
# cybHT9LQQprJ9UVOT/H3pYxCDEv7/nEHxSHDpqeWFs8LpuMFwjFGP8hSBHvIn80D
# KTIzXH6la+Q9lXeyXB7QYM/CFqoZRNRobyeM7gS8DrzZrWjvCpAVHUwiW2O248Ha
# CnfXUsvE/WTl2lQyBoDSUB+dtGv7l1xA4VayWSGjV4F/TGXNKuFEY/LR78hhamX7
# +wTBeEPzxBSQ3t1JdjR8yXIZB+fofh+jMFC8KTft6gTS4C2RStYCUnE7/gSyLzeS
# jiGiTBAkdo3rj/s101oqUbeyEL37ZAyRjePcFT5ibYZmC0ExggRdMIIEWQIBATCB
# hjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3Vy
# ZWQgSUQgQ29kZSBTaWduaW5nIENBAhAH+0XZ9wtVKQNgl7T04UNwMA0GCWCGSAFl
# AwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkD
# MQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJ
# KoZIhvcNAQkEMSIEIK+zs81x/NQLVvBdylOIfNCUWZE/lkz6GCjek4PZ0g0sMA0G
# CSqGSIb3DQEBAQUABIIBAK0aveKjKnLSDMW+BAo4VxeVoAEABC3pbS7G23+Y7YGf
# pF0l0/CYqO/lCbIhuU2bFdfUlB6dUXK457q2nbFpgqBE7eL0DaEM9LIUtGxvQPgL
# rlwP6dTjpy2eMpvGSUAuAMrpfE2qO56usRzzjgwHDpCwtT2JjLgtM8MdVv3TYPVi
# ZqXyxHAcP51OUEBTknL+kelIKOp/oNASKkFfeSKsmu9nUIAgzCRZU+yDLX3+8HBw
# oLWdCluBs8NzRMw8SUNesPisuI14gGkCE0edSMOgU9gTI6oX9/A5KXws9ISxt0xD
# FrO1K4QxONz1+YufvTmwbgxjQcL8Jimt8hUrMFLaAVehggIgMIICHAYJKoZIhvcN
# AQkGMYICDTCCAgkCAQEwgYYwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lD
# ZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGln
# aUNlcnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQQIQDUJK4L46iP9g
# QCHOFADw3TAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
# BgkqhkiG9w0BCQUxDxcNMjEwMjIzMTExODM2WjAjBgkqhkiG9w0BCQQxFgQU9/dn
# VONwrqsu2FIfgrr4dBVKwIEwDQYJKoZIhvcNAQEBBQAEggEAgLBazAX6f0VdXzgH
# ITYC4+Q1D5iqbhSyolTzsQg9JXC1TCFyW7jQFS9ISrOfYigfXdqcUom1NleWFSEx
# IMj0u82pMN/0clx5ZCp+atOt0yhMclKJOyfeOENGtJ4bt4QGgfovLRzCoXP1D6u8
# Wvue67KP0C5zOhNh3v5HzZvqFEYSP8Zi2v/gLbm0F+wCLapjNSGqHBsfe4HaoXL9
# 42ZlC9nz4uBFA623rudxKc5j2t6CwRd2Ayy+52JxqbCm79ma1OtfECNphLa7jKPG
# v2tK/LpV1a3TEeNKorDqN1BXqJGgb4eUUELyWIH+7M7SF+Rlpgyrg4wRSpHMsLJA
# 0s6hFg==
# SIG # End signature block