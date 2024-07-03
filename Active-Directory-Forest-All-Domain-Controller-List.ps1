# Active Directory modülünü yüklenmesi;
Import-Module ActiveDirectory

# Tüm Domain Controller'lara ait bilgilerin alınması;
$DomainControllers = Get-ADDomainController -Filter *

# Domain Controller bilgilerini toplamak için bir boş dizin oluşturulması;
$DCInfo = @()

# Her bir Domain Controller için bilgi toplamak;
foreach ($DC in $DomainControllers) {
    $DCProps = Get-ADDomainController -Identity $DC.HostName
    $DCObj = [PSCustomObject]@{
        Name = $DC.HostName
        SiteName = $DC.Site
        IPv4Address = $DC.IPv4Address
        IPv6Address = $DC.IPv6Address
        OSVersion = $DCProps.OperatingSystem
        OSServicePack = $DCProps.OperatingSystemServicePack
        OSHotFix = $DCProps.OperatingSystemHotfix
        IsGlobalCatalog = $DC.IsGlobalCatalog
        IsReadOnly = $DC.IsReadOnly
        ServerObjectGuid = $DC.ServerObjectGuid
        NumberOfPartitions = ($DCProps.Partitions | Measure-Object).Count
        Partitions = $DCProps.Partitions
    }
    $DCInfo += $DCObj
}

# Domain Controller bilgilerini ekranda görüntülemek;
$DCInfo | Format-Table -AutoSize

# Bilgileri CSV dosyasına kaydetmek;
$DCInfo | Export-Csv -Path "C:\Temp\DomainControllersInfo.csv" -NoTypeInformation
