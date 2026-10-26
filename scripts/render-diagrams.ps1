<#
.SYNOPSIS
  Генерує зображення всіх PlantUML-діаграм у diagrams/rendered/.

.DESCRIPTION
  Ім'я вихідного файлу береться з @startuml <name> і збігається з іменем .puml,
  тож посилання в docs/*.md (../diagrams/rendered/<name>.png) працюють одразу.

  Порядок пошуку рушія:
    1. $env:PLANTUML_JAR або scripts/plantuml.jar  -> java -jar
    2. Docker                                      -> образ $env:PLANTUML_IMAGE (типово plantuml/plantuml)

  plantuml.jar: https://github.com/plantuml/plantuml/releases (потрібна Java 11+).

.PARAMETER Format
  png (типово) або svg.

.EXAMPLE
  ./scripts/render-diagrams.ps1
  ./scripts/render-diagrams.ps1 -Format svg
#>
param(
    [ValidateSet('png', 'svg')]
    [string]$Format = 'png'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$sources = Get-ChildItem -Path 'diagrams' -Filter '*.puml' |
    Where-Object { $_.Name -ne '_style.puml' } |
    ForEach-Object { "diagrams/$($_.Name)" }

if (-not $sources) { throw 'У diagrams/ не знайдено жодного .puml' }

# -o задається відносно теки вихідного файлу: diagrams/ + rendered = diagrams/rendered
$plantumlArgs = @("-t$Format", '-charset', 'UTF-8', '-failfast2', '-o', 'rendered') + $sources

$jar = if ($env:PLANTUML_JAR) { $env:PLANTUML_JAR } else { Join-Path $PSScriptRoot 'plantuml.jar' }

if ((Test-Path $jar) -and (Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Host "PlantUML: java -jar $jar"
    & java '-Djava.awt.headless=true' -jar $jar @plantumlArgs
}
elseif (Get-Command docker -ErrorAction SilentlyContinue) {
    $image = if ($env:PLANTUML_IMAGE) { $env:PLANTUML_IMAGE } else { 'plantuml/plantuml' }
    Write-Host "PlantUML: docker $image"
    & docker run --rm -v "${root}:/work" -w /work $image @plantumlArgs
}
else {
    throw 'Не знайдено ні plantuml.jar (+ Java), ні Docker. Покладіть plantuml.jar у scripts/ або задайте $env:PLANTUML_JAR.'
}

if ($LASTEXITCODE -ne 0) { throw "PlantUML завершився з кодом $LASTEXITCODE" }

$count = (Get-ChildItem -Path 'diagrams/rendered' -Filter "*.$Format").Count
Write-Host "Готово: $count файлів .$Format у diagrams/rendered/ (очікується $($sources.Count))"
