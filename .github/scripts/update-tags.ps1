#!/bin/pwsh
param (
  $MajorVersion = '1'
)

git config user.email "github@cannonsoftware.com"
git config user.name "GitHub Action"

$versions = $(git tag) | ?{ $_ -match "^v$MajorVersion\.\d+" } | %{ [Version]($_ -replace 'v','') }
$max_version = $versions | Measure-Object -Maximum | % Maximum
$next_version = $max_version ? [Version]::new($max_version.Major, $max_version.Minor + 1) : [Version]::new($MajorVersion,0)

$tag = "v$($next_version.ToString())"

Write-Host "Setting tag for $tag"
# Add the new tag
Write-Host "Adding $tag"
git tag -a $tag -m $tag -f
git push origin $tag

Write-Output "::set-output name=tag::$tag"
