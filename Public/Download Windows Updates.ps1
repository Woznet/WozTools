
function Search-WUA{
  $updateSession = New-Object -ComObject Microsoft.Update.Session
  $search = $updateSession.CreateUpdateSearcher()
  $searchResult = $search.Search("IsInstalled=0 and Type='Software'")


  $updatesToDownload = New-Object -ComObject 'Microsoft.Update.UpdateColl'
  for ($x = 0; $x -lt $searchResult.Updates.Count; $x += 1) {
    $update = $searchResult.Updates.Item($x)
    $updatesToDownload.Add($update)
    'Added - {0}' -f $update.title
  }

  $downloader = $updateSession.CreateUpdateDownloader()
  $downloader.Updates = $updatesToDownload
  $downloader.Download()


  $updatesToInstall = New-Object -ComObject 'Microsoft.Update.UpdateColl'
  for ($x = 0; $x -lt $searchResult.Updates.Count; $x += 1) {
    $update = $searchResult.Updates.Item($x)
    $updatesToInstall.Add($update)
    'Added - {0}' -f $update.title
  }

  $installer = $updateSession.CreateUpdateInstaller()
  $installer.Updates = $updatesToInstall
  $installationResult = $installer.Install()
}