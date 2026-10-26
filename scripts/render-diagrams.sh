#!/usr/bin/env sh
# Генерує зображення всіх PlantUML-діаграм у diagrams/rendered/.
#
# Ім'я вихідного файлу береться з @startuml <name> і збігається з іменем .puml,
# тож посилання в docs/*.md (../diagrams/rendered/<name>.png) працюють одразу.
#
# Порядок пошуку рушія:
#   1. $PLANTUML_JAR або scripts/plantuml.jar  -> java -jar
#   2. Docker                                  -> образ $PLANTUML_IMAGE (типово plantuml/plantuml)
#
# plantuml.jar: https://github.com/plantuml/plantuml/releases (потрібна Java 11+).
#
# Використання:
#   ./scripts/render-diagrams.sh          # PNG
#   ./scripts/render-diagrams.sh svg      # SVG
set -eu

format="${1:-png}"
case "$format" in
  png|svg) ;;
  *) echo "Формат має бути png або svg" >&2; exit 1 ;;
esac

script_dir=$(cd "$(dirname "$0")" && pwd)
root=$(dirname "$script_dir")
cd "$root"

sources=$(ls diagrams/*.puml | grep -v '/_style\.puml$')
[ -n "$sources" ] || { echo "У diagrams/ не знайдено жодного .puml" >&2; exit 1; }

# -o задається відносно теки вихідного файлу: diagrams/ + rendered = diagrams/rendered
jar="${PLANTUML_JAR:-$script_dir/plantuml.jar}"

if [ -f "$jar" ] && command -v java >/dev/null 2>&1; then
  echo "PlantUML: java -jar $jar"
  # shellcheck disable=SC2086
  java -Djava.awt.headless=true -jar "$jar" -t"$format" -charset UTF-8 -failfast2 -o rendered $sources
elif command -v docker >/dev/null 2>&1; then
  image="${PLANTUML_IMAGE:-plantuml/plantuml}"
  echo "PlantUML: docker $image"
  # shellcheck disable=SC2086
  docker run --rm -v "$root:/work" -w /work "$image" -t"$format" -charset UTF-8 -failfast2 -o rendered $sources
else
  echo "Не знайдено ні plantuml.jar (+ Java), ні Docker. Покладіть plantuml.jar у scripts/ або задайте PLANTUML_JAR." >&2
  exit 1
fi

count=$(ls diagrams/rendered/*."$format" 2>/dev/null | wc -l | tr -d ' ')
expected=$(echo "$sources" | wc -l | tr -d ' ')
echo "Готово: $count файлів .$format у diagrams/rendered/ (очікується $expected)"
