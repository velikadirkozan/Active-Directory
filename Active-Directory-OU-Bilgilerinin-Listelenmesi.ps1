# Active Directory modülünü yüklenmesi;
Import-Module ActiveDirectory

# Tüm OU'ların alınması
$ous = Get-ADOrganizationalUnit -Filter *

# OU bilgilerini dosyaya kaydetmek için bir dosya yolu belirlenmesi;
$outputFile = "C:\Temp\OU_Info.csv"

# OU bilgilerini saklamak için bir liste oluşturulması;
$ouList = @()

# Her bir OU'yu döngüyle gezerek bilgilerin alınması;
foreach ($ou in $ous) {
    $ouInfo = New-Object PSObject -Property @{
        "Name"           = $ou.Name
        "DistinguishedName" = $ou.DistinguishedName
        "ObjectGUID"     = $ou.ObjectGUID
        "CreationTime"   = $ou.whenCreated
        "Description"    = $ou.Description
    }
    $ouList += $ouInfo
}

# OU bilgilerini CSV dosyasına yazılması;
$ouList | Export-Csv -Path $outputFile -NoTypeInformation

Write-Output "OU bilgileri $outputFile dosyasına kaydedildi."