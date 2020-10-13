#!/bin/pwsh
param (
  $Version = '1.1'
)

git config user.email "github@cannonsoftware.com"
git config user.name "GitHub Action"

$versions = $(git tag) | ?{ $_ -match "^v$Version\.\d+" } | %{ [Version]($_ -replace 'v','') }
$max_version = $versions | Measure-Object -Maximum | % Maximum
if (-Not $max_version) { $Max_version = [Version]::new($Version) }
$next_version = [Version]::new($max_version.Major, $max_version.Minor, $max_version.Build + 1)

$tag = "v$($next_version.ToString())"

Write-Host "Setting tag for $tag"
# Add the new tag
Write-Host "Adding $tag"
git tag -a $tag -m $tag -f
git push origin $tag

Write-Output "::set-output name=tag::$tag"
