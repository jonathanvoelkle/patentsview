Get-ChildItem .\data\**\*.zip -Recurse | % { Expand-Archive $_.FullName -DestinationPath $_.Directory }