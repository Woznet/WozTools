function Flatten-Object {
  # https://powersnippets.com/flatten-object/
  # Version 02.00.16, by iRon
  Param (
    [Parameter(ValueFromPipeLine)]
    [Object[]]$Objects,
    [String]$Separator = '.',
    [ValidateSet('', 0, 1)]
    $Base = 1,
    [Int]$Depth = 5,
    [Int]$Uncut = 1,
    [String[]]$ToString = ([String], [DateTime], [TimeSpan], [Version], [Enum]),
    [String[]]$Path = @()
  )
  $PipeLine = $Input | ForEach-Object {
    $_
  }
  If ($PipeLine) {
    $Objects = $PipeLine
  }
  If (@(Get-PSCallStack)[1].Command -eq $MyInvocation.MyCommand.Name -or @(Get-PSCallStack)[1].Command -eq '<position>') {
    $Object = @($Objects)[0]
    $Iterate = [System.Collections.Specialized.OrderedDictionary]::new()
    If ($ToString | Where-Object { $Object -is $_ }) {
      $Object = $Object.ToString()
    }
    ElseIf ($Depth) {
      $Depth--
      If ($Object.GetEnumerator.OverloadDefinitions -match '[\W]IDictionaryEnumerator[\W]') {
        $Iterate = $Object
      }
      ElseIf ($Object.GetEnumerator.OverloadDefinitions -match '[\W]IEnumerator[\W]') {
        $Object.GetEnumerator() | ForEach-Object -Begin { $i = $Base } -Process {
          $Iterate.($i) = $_
          $i += 1
        }
      }
      Else {
        $Names = If ($Uncut) {
          $Uncut--
        }
        Else {
          $Object.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames
        }
        If (!$Names) {
          $Names = $Object.PSObject.Properties | Where-Object { $_.IsGettable } | Select-Object -ExpandProperty Name
        }
        If ($Names) {
          $Names | ForEach-Object { $Iterate.$_ = $Object.$_ }
        }
      }
    }
    If (@($Iterate.Keys).Count) {
      $Iterate.Keys | ForEach-Object {
        Flatten-Object -Objects @(,$Iterate.$_) -Separator $Separator -Base $Base -Depth $Depth -Uncut $Uncut -ToString $ToString -Path ($Path + $_)
      }
    }
    Else {
      $Property.(($Path | Where-Object { $_ }) -Join $Separator) = $Object
    }
  }
  ElseIf ($Objects -ne $Null) {
    @($Objects) | ForEach-Object -Begin {
      $Output = @()
      $Names = @()
    } -Process {
      New-Variable -Force -Option AllScope -Name Property -Value ([System.Collections.Specialized.OrderedDictionary]::new())
      Flatten-Object -Objects @(,$_) -Separator $Separator -Base $Base -Depth $Depth -Uncut $Uncut -ToString $ToString -Path $Path
      $Output += New-Object -TypeName PSObject -Property $Property
      $Names += $Output[-1].PSObject.Properties | Select-Object -ExpandProperty Name
    }
    $Output | Select-Object -ExpandProperty ([String[]]($Names | Select-Object -Unique))
  }
}
