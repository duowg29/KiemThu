# Script to replace all localhost URLs with GlobalVariable.baseUrl
$files = Get-ChildItem -Path "Scripts" -Recurse -Filter "*.groovy"

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match "WebUI\.navigateToUrl\('http://localhost/CAMNEST/'\)") {
        $newContent = $content -replace "WebUI\.navigateToUrl\('http://localhost/CAMNEST/'\)", "WebUI.navigateToUrl(GlobalVariable.baseUrl)"
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "Updated: $($file.FullName)"
        $count++
    }
}

Write-Host "Total files updated: $count"

