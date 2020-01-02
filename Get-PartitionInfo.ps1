function Get-PartitionInfo {
  [CmdletBinding()]
  param(
    [switch]$OpenInNotepad
  )
  function Get-DriveLetter {
    #Get the logical disk mapping
    [CmdletBinding()]
    param(
      $PartPath
    )
    $LogicalDisks = Get-WMIObject -Class Win32_LogicalDiskToPartition | 
    Where-Object {$_.Antecedent -eq $PartPath}
    $LogicalDrive = Get-WMIObject -Class Win32_LogicalDisk | 
    Where-Object {$_.__PATH -eq $LogicalDisks.Dependent}
    $LogicalDrive.DeviceID
  }

  function Get-VolumeBlockSize {
    [CmdletBinding()]
    param(
      $PartPath
    )
    $Drive = Get-DriveLetter -PartPath ($PartPath)
    if ($Drive -gt '') {
      #Get the BlockSize of the volume
      $Volume = Get-WMIObject -Class Win32_Volume | 
      Where-Object {$_.DriveLetter -eq  $Drive}
      $Volume.BlockSize
    }
  }

  function Get-PartitionAlignment {
    Get-WMIObject -Class Win32_DiskPartition |
    Sort-Object -Property DiskIndex, Index |
    Select-Object -Property `
    @{Expression = {$_.DiskIndex};Label='Disk'},`
    @{Expression = {$_.Index};Label='Partition'},`
    @{Expression = {Get-DriveLetter -PartPath ($_.__PATH)};Label='Drive'},`
    @{Expression = {$_.BootPartition};Label='BootPartition'},`
    @{Expression = {'{0:N3}' -f ($_.Size/1Gb)};Label='Size_GB'},`
    @{Expression = {'{0:N0}' -f ($_.BlockSize)};Label='Partition_BlockSize'},`
    @{Expression = {Get-VolumeBlockSize -PartPath ($_.__PATH)};Label='Volume_BlockSize'},
    @{Expression = {'{0:N0}' -f ($_.StartingOffset/1Kb)};Label='Offset_KB'},`
    @{Expression = {'{0:N0}' -f ($_.StartingOffset/$_.BlockSize)}; Label='OffsetSectors'},`
    @{Expression = {IF (($_.StartingOffset % 64KB) -EQ 0) {' Yes'} ELSE {'  No'}};Label='64KB'}
  }

  # Hash table to set the alignment of the properties in the format-table
  $b = `
  @{Expression = {$_.Disk};Label='Disk'},`
  @{Expression = {$_.Partition};Label='Partition'},`
  @{Expression = {$_.Drive};Label='Drive'},`
  @{Expression = {$_.BootPartition};Label='BootPartition'},`
  @{Expression = {'{0:N3}' -f ($_.Size_GB)};Label='Size_GB';align='right'},`
  @{Expression = {'{0:N0}' -f ($_.Partition_BlockSize)};Label='PartitionBlockSize';align='right'},`
  @{Expression = {'{0:N0}' -f ($_.Volume_BlockSize)};Label='VolumeBlockSize';align='right'},`
  @{Expression = {'{0:N0}' -f ($_.Offset_KB)};Label='Offset_KB';align='right'},`
  @{Expression = {'{0:N0}' -f ($_.OffsetSectors)};Label='OffsetSectors';align='right'},`
  @{Expression = {$_.{64KB}};Label='64KB'}

  $a = Get-PartitionAlignment

  # Display formatted data on the screen
  $a | Sort-Object -Property Drive, Disk, Partition | Format-Table -Property $b -AutoSize

  if ($OpenInNotepad) {
    # Export to a pipe-delimited file
    $a | Sort-Object -Property Drive, Disk, Partition | Format-Table -AutoSize -Wrap | Out-File -FilePath $ENV:temp\PartInfo.txt -Force

    # Open the file in NotePad
    Notepad $ENV:temp\PartInfo.txt
  }
}