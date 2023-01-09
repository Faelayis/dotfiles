if (!([Security.Principal.WindowsPrincipal] `
            [Security.Principal.WindowsIdentity]::GetCurrent() `
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process pwsh -Verb RunAs -ArgumentList ('-nologo -noexit -noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    exit
}
else {
    if (!(winget list --name "oh-my-posh")) {
        winget install JanDeDobbeleer.OhMyPosh -s winget
    }

    Write-Output "Check Font"

    if (@(New-Object System.Drawing.Text.InstalledFontCollection).Families.Name -match "CaskaydiaCove Nerd Font Mono") {
        Write-Output "CaskaydiaCove Nerd Font Mono already exists."
    }
    else {
        Write-Output "Not Found CaskaydiaCove Nerd Font Mono"
        Start-BitsTransfer -Source "https://raw.githubusercontent.com/Faelayis/my-terminal/master/Font/Caskaydia%20Cove%20Nerd%20Font%20Complete%20Mono.ttf" -Destination "CaskaydiaCove Nerd Font Mono.ttf"
        & '.\CaskaydiaCove Nerd Font Mono.ttf' -Wait
    }

    Write-Output ""

    Write-Output "Check Module"
    
    $module = Get-Content -Path ".\Module.json" -Raw | ConvertFrom-Json
    foreach ($i in $module.Module.psobject.properties.name) {
        if (!(Get-InstalledModule -Name $i)) {
            Write-Output "Install Module $i"
            Install-Module -Name @("$i") -Scope AllUsers -Force
            Write-Output ""
        }
    }


    Pause
}