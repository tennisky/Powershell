####
#
#	registory_bk.ps1 ※レジストリ バックアップ用シェル
#
####


### バックアップ用ディレクトの作成 ###

New-Item C:\Registry_bak -ItemType Directory


### バックアップ対象を取得 ###

$registry = Get-ChildItem -Path Registry::*

Set-Location -Path Registry::HKEY_CURRENT_CONFIG
