param(
    [switch] $ClearCache,
    [switch] $Verbose
)

$ErrorActionPreference = "Stop"
$VerbosePreference = if ($Verbose) { "Continue" } else { $VerbosePreference }

$image = "golang:1.12"
$here = (Resolve-Path $PSScriptRoot).Path -replace "\\","/"
$localModCache = "$($here)/.bashgo-mod"

if ($ClearCache) {
    Remove-Item $localModCache -ErrorAction SilentlyContinue >$null
}
if (-not (Test-Path $localModCache)) {
    New-item -Type Directory $localModCache >$null
}

$scriptVolBinding = "$($here):/src"
Write-Verbose "scriptVolBinding: $scriptVolBinding"
$cacheVolBinding = "$($localModCache):/go/pkg/mod"
Write-Verbose "localModCache: $localModCache"

Write-Verbose "Running docker $image"
docker run --rm -it -v $scriptVolBinding -v $cacheVolBinding -w/src $image bash