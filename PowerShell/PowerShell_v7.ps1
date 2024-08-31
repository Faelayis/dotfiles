# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Import-Module -Name Terminal-Icons
# Import-Module Az.Tools.Predictor

oh-my-posh init pwsh --config "C:\Users\$([Environment]::UserName)\AppData\Local\Programs\oh-my-posh\themes\emodipt-extend.omp.json" | Invoke-Expression

switch (oh-my-posh get shell) {
   pwsh {
      $PSReadLineOptions = @{
         EditMode                      = "Windows"
         BellStyle                     = "None"
         ShowToolTips                  = $true
         PredictionSource              = "HistoryAndPlugin"
         HistoryNoDuplicates           = $true
         PredictionViewStyle           = "ListView"
         HistorySearchCursorMovesToEnd = $true
      }
    
      Set-PSReadLineOption @PSReadLineOptions
      Set-PSReadLineOption -Colors @{ emphasis = '#00FF00'; inlinePrediction = 'magenta' }
   }
}


# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
   Import-Module "$ChocolateyProfile"
}

# Only in PowerShell 7
if ($PSVersionTable.PSVersion.Major -ge 7) {
   Import-Module -Name Microsoft.WinGet.CommandNotFound
   #f45873b3-b655-43a6-b217-97c00aa0db58
}

# Alias
Set-Alias -name "pn" -value "pnpm"
Set-Alias -name "c" -value "code"

function Clear-SavedHistory {
   [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
   param(
   )

   $havePSReadline = ($null -ne (Get-Module -EA SilentlyContinue PSReadline))
   Write-Verbose "PSReadline present: $havePSReadline"
   # $target = if ($havePSReadline) { "entire command history, including from previous sessions" } else { "command history" } 
   # if (-not $pscmdlet.ShouldProcess($target)) {
   #    return
   #  }
   if ($havePSReadline) {
      Clear-Host
      if (Test-Path (Get-PSReadlineOption).HistorySavePath) { 
         Remove-Item -EA Stop (Get-PSReadlineOption).HistorySavePath 
         $null = New-Item -Type File -Path (Get-PSReadlineOption).HistorySavePath
      }
      Clear-History
      [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
   }
   else {
      Clear-Host
      $null = [system.reflection.assembly]::loadwithpartialname("System.Windows.Forms")
      [System.Windows.Forms.SendKeys]::Sendwait('%{F7 2}')
      Clear-History
   }
   Copy-Item -Path "$([Environment]::GetFolderPath("MyDocuments"))\PowerShell\History.txt" -Destination (Get-PSReadLineOption).HistorySavePath -Recurse
}

function wingetupdate {
   winget upgrade --silent --all
}
function wingetupdateall {
   winget upgrade --silent --all --include-unknown
}

function spx {
   Invoke-Expression "& { $(Invoke-WebRequest -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -v 1.2.13.661.ga588f749-4064 -confirm_spoti_recomended_over -block_update_on -funnyprogressBar -lyrics_stat orange"
}