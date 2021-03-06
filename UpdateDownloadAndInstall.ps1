####
#
#	UpdateDownloadAndInstall.ps1
#
####

param($targetUpdateIDFile)

$UpdateCollection = New-Object -ComObject Microsoft.Update.UpdateColl  
$Searcher = New-Object -ComObject Microsoft.Update.Searcher  
$Session = New-Object -ComObject Microsoft.Update.Session

Get-Content $targetUpdateIDFile | ForEach-Object {
	$targetUpdateSearchResult = $Searcher.Search("UpdateID='$_' AND IsInstalled = 0")
	$targetUpdate = $targetUpdateSearchResult.Updates
	$UpdateCollection.Add($targetUpdate.Item(0))
}

$Downloader = $Session.CreateUpdateDownloader()  
$Downloader.Updates = $UpdateCollection  
$Downloader.Download()

$Installer = New-Object -ComObject Microsoft.Update.Installer  
$Installer.Updates = $UpdateCollection  
$Installer.Install() 
