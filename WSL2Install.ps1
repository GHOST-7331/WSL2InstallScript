# PowerShell script to install WSL and handle potential errors

# Function to check for Windows version compatibility
function Check-WindowsVersion {
    $version = [Environment]::OSVersion.Version
    Write-Output "Windows version detected: $($version)"
    if ($version.Major -lt 10 -or ($version.Major -eq 10 -and $version.Build -lt 19041)) {
        throw "WSL requires at least Windows 10 version 2004, Build 19041 or higher. Please update Windows."
    }
}

# Function to enable the necessary Windows features for WSL
function Enable-WindowsFeatures {
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
}

# Function to install WSL
function Install-WSL {
    try {
        wsl --install
        wsl --set-default-version 2
    } catch {
        Write-Error "An error occurred during WSL installation: $_"
        # Basic troubleshooting steps
        # Attempt to re-enable WSL components
        Enable-WindowsFeatures
        # Recommend manual kernel update
        Write-Output "Please consider manually downloading and installing the WSL2 Linux kernel from Microsoft's website."
        # Exit with error code
        exit -1
    }
}

# Main script logic

# Ensure script is running with administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    throw "This script must be run as Administrator. Right-click PowerShell and select 'Run as administrator'."
}

# Check Windows version compatibility
Check-WindowsVersion

# Enable necessary Windows features
Enable-WindowsFeatures

# Install WSL
Install-WSL

# Final message
Write-Output "WSL installation script has completed. If there were no errors, please restart your computer."
