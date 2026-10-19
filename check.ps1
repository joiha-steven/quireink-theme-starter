# Checks .\theme with the product's own checker, then photographs it on every kind of page.
#
#   .\check.ps1 <path to a Quire Ink checkout> [theme:preview options]
#   $env:QUIREINK = '<path>'; .\check.ps1 [theme:preview options]
#   powershell -ExecutionPolicy Bypass -File .\check.ps1 <path> [options]   (when scripts are blocked)
#
# Exits with theme:check's code when the check fails, otherwise with theme:preview's.
# --force is always passed to theme:preview so the loop can run again over its own output;
# it only ever replaces a directory theme:preview made.

$product = $env:QUIREINK
# Inside a PowerShell session an unquoted list such as --pages home-list,post-all-blocks
# arrives as an array, and passing it on would split it into two arguments. Join it back.
$rest = @($args | ForEach-Object { if ($_ -is [array]) { $_ -join ',' } else { "$_" } })
if ($rest.Count -gt 0 -and -not "$($rest[0])".StartsWith('--')) {
  $product = "$($rest[0])"
  $rest = @($rest | Select-Object -Skip 1)
}
if (-not $product -or -not (Test-Path -LiteralPath (Join-Path $product 'package.json'))) {
  [Console]::Error.WriteLine('usage: .\check.ps1 <path to a Quire Ink checkout> [theme:preview options]')
  [Console]::Error.WriteLine('       or set $env:QUIREINK to that path')
  exit 2
}

$theme = Join-Path $PSScriptRoot 'theme'
Push-Location -LiteralPath $product
try {
  & bun run theme:check $theme
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  & bun run theme:preview $theme --force @rest
  exit $LASTEXITCODE
} finally {
  Pop-Location
}
