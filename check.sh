#!/usr/bin/env bash
# Checks ./theme with the product's own checker, then photographs it on every kind of page.
#
#   ./check.sh <path to a Quire Ink checkout> [theme:preview options]
#   QUIREINK=<path> ./check.sh [theme:preview options]
#
# Exits with theme:check's code when the check fails, otherwise with theme:preview's.
# --force is always passed to theme:preview so the loop can run again over its own output;
# it only ever replaces a directory theme:preview made.
set -u

here="$(cd "$(dirname "$0")" && pwd)"
product="${QUIREINK:-}"
if [ $# -gt 0 ] && [ "${1#--}" = "$1" ]; then
  product="$1"
  shift
fi
if [ -z "$product" ] || [ ! -f "$product/package.json" ]; then
  echo "usage: ./check.sh <path to a Quire Ink checkout> [theme:preview options]" >&2
  echo "       or set QUIREINK to that path" >&2
  exit 2
fi

cd "$product" || exit 2
bun run theme:check "$here/theme"
rc=$?
if [ "$rc" -ne 0 ]; then
  exit "$rc"
fi
bun run theme:preview "$here/theme" --force "$@"
exit $?
