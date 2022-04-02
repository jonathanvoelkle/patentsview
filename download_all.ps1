$base_path = "https://patentsview.org/download/"
$download_pages = @(
  "data-download-tables"
  "brf_sum_text"
  "claims"
  "detail_desc_text" 
  "draw_desc_text" 
  "pg-download-tables" 
  "pg_brf_sum_text" 
  "pg_claims" 
  "pg_detail_desc_text" 
  "pg_draw_desc_text"
)

New-Item -ItemType Directory -Force ".\data\"

$ProgressPreference = 'SilentlyContinue'
foreach ($item in $download_pages) {
  Write-Host ("Scraping:     " + $base_path + $item)
  Write-Host "-------------------------"
  $url_list = Invoke-WebRequest ($base_path + $item) |
  Select-Object -ExpandProperty "Links" | 
  Select-Object href | 
  Where-Object { $_ -match "https://s3.amazonaws.com/data.patentsview.org/" } | 
  ForEach-Object { $_.href + "" }
  New-Item -ItemType Directory -Force (".\data\" + $item.Replace("-", "_"))
  foreach ($archive in $url_list) {
    Write-Host ("Downloading:  " + $archive)
    Invoke-WebRequest -Uri $archive -OutFile (".\data\" + $item.Replace("-", "_") + "\" + $archive.Split("/")[-1])
  }
}
