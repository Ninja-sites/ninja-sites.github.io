
$ErrorActionPreference='SilentlyContinue'
$o=@()
$cs=Get-CimInstance Win32_ComputerSystem
$b=Get-CimInstance Win32_BIOS
$os=Get-CimInstance Win32_OperatingSystem
$o+="MODEL: $($cs.Manufacturer) / $($cs.Model)"
$o+="BIOS: $($b.SMBIOSBIOSVersion) ($($b.ReleaseDate))"
$o+="FIRMWARE: $env:firmware_type   SECUREBOOT: $(try{Confirm-SecureBootUEFI}catch{'n/a'})"
$o+="CPU: $((Get-CimInstance Win32_Processor).Name)"
$o+="RAM_GB: $([math]::Round($cs.TotalPhysicalMemory/1GB,1))"
foreach($g in Get-CimInstance Win32_VideoController){ $o+="GPU: $($g.Name)" }
foreach($n in Get-NetAdapter -Physical){ $o+="NET: $($n.InterfaceDescription) [$($n.LinkSpeed)]" }
foreach($s in Get-CimInstance Win32_SoundDevice){ $o+="AUDIO: $($s.Name)" }
foreach($d in Get-PhysicalDisk){ $o+="DISK: $($d.FriendlyName) | $([math]::Round($d.Size/1GB))GB | $($d.MediaType) | $($d.BusType)" }
$o+="OS: $($os.Caption) $($os.Version)"
$txt=$o -join "`n"
Write-Host $txt
$p="$env:USERPROFILE\Desktop\hackintosh-report.txt"
$txt | Out-File -FilePath $p -Encoding utf8
notepad $p
