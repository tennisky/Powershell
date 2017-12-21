####
#
#	AddVPNConnections.ps1 ※ VPN設定スクリプト
#
####

### モジュールインポート ###
# ※ 個人が作成したモジュールの為、今後使えなくなる可能性あり
Install-Module -Name VPNCredentialsHelper


### 環境共通設定 ###

[bool]$AllUserConnection = $False
[string]$TunnelType = "L2tp"
[string]$AuthenticationMethod = "MsChapv2"
[string]$EncryptionLevel = "Required"
[string]$L2tpIPsecAuth = "Psk"
[bool]$UseWinlogonCredential = $False
[bool]$RememberCredential = $True
[bool]$SplitTunneling = $True
[string]$AutomaticMetric = "disabled"
[int32]$InterfaceMetric = 1
[int32]$RouteMetric = 1


####
#	関数定義	
####

### VPN作成 ###
function AddVpn{
    Add-VpnConnection `
	    -Name $Name `
	    -ServerAddress $ServerAddress `
}

### VPN設定 ###

# 設定情報更新
function SetVpn{
    Set-VpnConnection `
	    -Name $Name `
	    -ServerAddress $ServerAddress `
	    -L2tpPsk $L2tpPsk `
	    -TunnelType $TunnelType `
	    -EncryptionLevel $EncryptionLevel `
	    -SplitTunneling $SplitTunneling `
	    -RememberCredential $RememberCredential 
	    -Force
}

# クレデンシャル設定
function SetCredential{
    Set-VpnConnectionUsernamePassword `
	    -connectionname $Name `
	    -username $UserName `
	    -password $PassWord `
	    -domain ''
}

# ルート更新
function SetRoute{

    Add-VpnConnectionRoute `
	    -ConnectionName $Name `
	    -DestinationPrefix $DestinationPrefix `
	    -RouteMetric $RouteMetric

}


### Main ###
for ($i=0; $i -lt 3; $i++){
    
    if($i -eq 0){

        # 検証環境用設定 
        [string]$Name = "STG"
        [string]$ServerAddress = "172.0.0.1"
        [string]$L2tpPsk = "共有キー"
        [string]$DestinationPrefix = "172.0.0.1/20"
        [string]$UserName = "VPNUser"
        [string]$PassWord = "Pass"

    }elseif($i -eq 1){

        # 本番環境用設定
        [String]$Name = "PRD"
        [String]$ServerAddress = "172.0.0.1"
        [String]$L2tpPsk = "共有キー"
        [String]$DestinationPrefix = "172.0.0.1/20"
        [String]$UserName = "VPNUser"
        [String]$PassWord = "Pass"

    }elseif($i -eq 2){

        # テスト環境用設定
        [String]$Name = "TEST"
        [String]$ServerAddress = "172.0.0.1"
        [String]$L2tpPsk = "共有キー"
        [String]$DestinationPrefix = "172.0.0.1/20"
        [String]$UserName = "VPNUser"
        [String]$PassWord = "Pass"

    }

	### 関数の呼び出し ###
	AddVpn
	SetVpn
	SetCredential
	SetRoute

}
