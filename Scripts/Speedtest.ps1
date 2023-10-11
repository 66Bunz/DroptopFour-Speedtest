
function Speedtest {
    # This will be used when the speedtest button is clicked

    # $RmAPI.Log("Script started")
    
    $SavePath = $RmAPI.OptionStr('SavePath')

    $VarsLocation = $RmAPI.OptionStr('VarsLocation')

    $SpeedtestExePath = "$SavePath\speedtest.exe"

    if (-Not (Test-Path $SpeedtestExePath -PathType leaf)) {
        Get-App
    }
    
    $Output = RunTest

    $LatencyPattern = "Latency:\s+(\d+\.\d+)\s+ms"
    $DownloadPattern = "Download:\s+(\d+\.\d+)\s+Mbps"
    $UploadPattern = "Upload:\s+(\d+\.\d+)\s+Mbps"
    $PacketLossPattern = "Packet Loss:\s+(\d+\.\d+)\s+%"
    $UrlPattern = "Result URL: (https:\/\/www\.speedtest\.net\/result\/c\/\w+-\w+-\w+-\w+-\w+)"
    
    $Latency = [regex]::Match($Output, $LatencyPattern).Groups[1].Value
    $Download = [regex]::Match($Output, $DownloadPattern).Groups[1].Value
    $Upload = [regex]::Match($Output, $UploadPattern).Groups[1].Value
    $PacketLoss = [regex]::Match($Output, $PacketLossPattern).Groups[1].Value
    $Url = [regex]::Match($Output, $UrlPattern).Groups[1].Value

    # $RmAPI.Log("Latency: $Latency ms")
    # $RmAPI.Log("Download: $Download Mbps")
    # $RmAPI.Log("Upload: $Upload Mbps")
    # $RmAPI.Log("PacketLoss: $PacketLoss%")
    # $RmAPI.Log("Url: $Url")    

    $RmAPI.Bang('!SetVariable Latency "' + $Latency + '"')
    $RmAPI.Bang('!WriteKeyValue Variables Latency "' + $Latency + '" "' + $VarsLocation + '"')

    $RmAPI.Bang('!SetVariable Download "' + $Download + '"')
    $RmAPI.Bang('!WriteKeyValue Variables Download "' + $Download + '" "' + $VarsLocation + '"')
    
    $RmAPI.Bang('!SetVariable Upload "' + $Upload + '"')
    $RmAPI.Bang('!WriteKeyValue Variables Upload "' + $Upload + '" "' + $VarsLocation + '"')
    
    $RmAPI.Bang('!SetVariable PacketLoss "' + $PacketLoss + '"')
    $RmAPI.Bang('!WriteKeyValue Variables PacketLoss "' + $PacketLoss + '" "' + $VarsLocation + '"')
    
    $RmAPI.Bang('!SetVariable Url "' + $Url + '"')
    $RmAPI.Bang('!WriteKeyValue Variables Url "' + $Url + '" "' + $VarsLocation + '"')

    $RmAPI.Bang('!UpdateMeter *')
    $RmAPI.Bang('!Update')
}

function Get-App {
    # This can be also used the first time the app is loaded/installed

    $SavePath = $RmAPI.OptionStr('SavePath')

    $DownloadPath = "$SavePath\speedtest.zip"
    $ExtractToPath = "$SavePath"

    $DownloadURL = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"

    # $RmAPI.Log("SpeedTest EXE Doesn't Exist, starting file download")
    Invoke-WebRequest $DownloadURL -outfile $DownloadPath
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    Unzip $DownloadPath $ExtractToPath

    Remove-Item -Path "$SavePath\speedtest.md" -Force 
    Remove-Item -Path "$SavePath\speedtest.zip" -Force 
}

function RunTest() {
    # $RmAPI.Log("--------------------------------")
    # $RmAPI.Log("Running speedtest, please wait...")
    $test = & $SpeedtestExePath --accept-license
    # $RmAPI.Log("Speedtest completed successfully!")
    # $RmAPI.Log("--------------------------------")
    return $test
}

function Unzip {
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}



# function Remove-Speedtest {
#     $SavePath = "D:\alebu\Documents\Rainmeter\Skins\Droptop Community Apps\Apps\Speedtest-Bunz\Scripts"
#     $SpeedtestExePath = "$SavePath\speedtest.exe"
#     if (Test-Path $SpeedtestExePath -PathType leaf) {
#         Remove-Item -Path "D:\alebu\Documents\Rainmeter\Skins\Droptop Community Apps\Apps\Speedtest-Bunz\Scripts\speedtest.exe" -Force -ErrorAction:SilentlyContinue
#         Remove-Item -Path "D:\alebu\Documents\Rainmeter\Skins\Droptop Community Apps\Apps\Speedtest-Bunz\Scripts\speedtest.md" -Force -ErrorAction:SilentlyContinue
#         Remove-Item -Path "D:\alebu\Documents\Rainmeter\Skins\Droptop Community Apps\Apps\Speedtest-Bunz\Scripts\speedtest.zip" -Force -ErrorAction:SilentlyContinue
#         Remove-Item -Path "D:\alebu\Documents\Rainmeter\Skins\Droptop Community Apps\Apps\Speedtest-Bunz\Scripts\speedtestlog.txt" -Force -ErrorAction:SilentlyContinue
#     }
# }

# Speedtest