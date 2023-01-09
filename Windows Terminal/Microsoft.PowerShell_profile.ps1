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

function Clear-SavedHistory {
  [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
  param(
  )

  $havePSReadline = ($null -ne (Get-Module -EA SilentlyContinue PSReadline))
  Write-Verbose "PSReadline present: $havePSReadline"
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

# Alias
Set-Alias -name "pn" -value "pnpm"
