$modulesToImport = @("Terminal-Icons", "Az.Tools.Predictor", "Microsoft.WinGet.CommandNotFound")

foreach ($module in $modulesToImport) {
   if (-not (Get-Module -Name $module -ListAvailable)) {
      Import-Module -Name $module -ErrorAction SilentlyContinue
   }
}

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
   $ohMyPoshConfig = "C:\Users\$([Environment]::UserName)\AppData\Local\Programs\oh-my-posh\themes\emodipt-extend.omp.json"
   if (Test-Path $ohMyPoshConfig) {
      $shells = @("pwsh", "powershell")
      $shell = (oh-my-posh get shell 2>&1)
      if ($shells -contains $shell) {
         oh-my-posh init $shell --config $ohMyPoshConfig | Invoke-Expression
      }
   }
}

if ($PSVersionTable.PSVersion.Major -ge 7) {
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

   Import-Module -Name Microsoft.WinGet.CommandNotFound -ErrorAction SilentlyContinue

   function Clear-SavedHistory {
      [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
      param()

      $havePSReadline = ($null -ne (Get-Module -EA SilentlyContinue PSReadline))
      Write-Verbose "PSReadline present: $havePSReadline"

      if ($havePSReadline) {
         Clear-Host

         $historySavePath = (Get-PSReadlineOption).HistorySavePath

         if (Test-Path $historySavePath) {
            Remove-Item -EA Stop $historySavePath
         }

         $null = New-Item -Type File -Path $historySavePath

         Clear-History
         [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()

         if (Test-Path $historySavePath) {
            $historyItems = Get-Content -Path $historySavePath
            foreach ($command in $historyItems) {
               Add-History -CommandLine $command
            }
         }
      }
      else {
         Clear-Host

         $null = [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
         [System.Windows.Forms.SendKeys]::SendWait('%{F7 2}')
         Clear-History
      }

      $historyFilePath = "$([Environment]::GetFolderPath('MyDocuments'))\PowerShell\auto-complete.txt"
      if (Test-Path $historyFilePath) {
         Copy-Item -Path $historyFilePath -Destination $historySavePath -Recurse
      }

      Get-Content $historyFilePath | ForEach-Object { [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($_) }
   }
}

if ($PSVersionTable.PSVersion.Major -ge 7) {
   function spx {
      Invoke-Expression "& { $(Invoke-WebRequest -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -v 1.2.13.661.ga588f749-4064 -confirm_spoti_recomended_over -block_update_on -funnyprogressBar -dev -lyrics_stat orange"
   }
   function reloaddns {
      ipconfig /flushdns
   }
   function wingetupdate {
      winget upgrade --silent --all
   }
   function wingetupdateall {
      winget upgrade --silent --all --include-unknown
   }
}

Set-Alias -Name pn -Value pnpm
Set-Alias -Name c -Value code
