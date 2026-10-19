# Quire Ink theme starter

A complete theme for [Quire Ink](https://github.com/joiha-steven/quireink), written to be copied.
Clone it, rename it, change the CSS, and you have your own theme.

## What a theme is

A Quire Ink theme is a zip with a manifest (`theme.json`), one stylesheet (`theme.css`), a
screenshot and, if you like, fonts and images. It brings no HTML and no JavaScript: every page
keeps the engine's markup, and the theme dresses it. Colours come from palettes the theme
declares, sizes and faces from the engine's variables, and the owner's own settings and Custom
CSS still win over anything the theme says. The blog checks every theme when it is installed and
refuses one that breaks a rule, so the same checker runs on your machine before you ship
([ADR 0072](https://github.com/joiha-steven/quireink/blob/main/docs/decisions/0072-a-theme-is-a-checked-skin-over-the-one-markup.md)).

**The main reference is the author guide,
[docs/themes.md](https://github.com/joiha-steven/quireink/blob/main/docs/themes.md)**: what a theme may touch, how the
pages are built, and the loop from first edit to install. This repository is its worked example.

This one is called **Starter**: a calm reading theme with the menu in the masthead, soft cards
for lists and the front page, hairlines between sections, and three palettes (Linen, Slate,
Heather), each with a light and a dark half.

## What is in this repository

```
theme/                 the theme itself: zip the CONTENTS of this folder
  theme.json           the manifest: id, name, version, palettes, fonts, layout switches
  theme.css            the stylesheet, grouped by the part of the page it styles
  screenshot.webp      what the admin shows on the theme's tile, exactly 1200 x 900
  fonts/literata.woff2 the reading face the theme adds
licenses/              the font's licence (it may not travel inside the zip, see below)
check.sh, check.ps1    run the checker and the preview in one go
LICENSE                MIT-0, for everything except the font
```

A package may hold only `theme.json`, `theme.css`, `screenshot.webp`, `fonts/<name>.woff2` and
`images/<name>.(webp|png|jpg|jpeg|avif|svg)`, at most 64 files. Anything else is refused,
a licence text in `fonts/` included, which is why the font's licence lives in `licenses/`.

## Make it yours

1. In `theme/theme.json`, change `id` (lowercase letters, digits and single hyphens, at most 40
   characters, not `plain`, `code`, `paper` or `notes`), `name`, `author`, `homepage` and
   `description`. Start `version` at `1.0.0` and raise it with each release you hand out.
2. Change the palettes, or add your own (up to 8). Each needs `bg`, `text`, `heading`, `meta`,
   `link`, `rule` and `accent` as `#rrggbb`, for `light` and for `dark`. `text`, `heading`,
   `meta` and `link` must each reach a contrast of **5.0:1** against `bg`, in both halves. Palette
   ids may not be a built-in palette's (`mono`, `sepia`, `forest`, `ocean`, `scifi`, `amber`).
3. Change `suggests`: the palette and fonts the admin offers to switch on with the theme. A
   suggestion may name the theme's own palettes and fonts or the built-in ones.
4. Edit `theme/theme.css`. Every group opens with a line saying what it styles and which
   names it uses; the comments say why each rule is there.
5. Replace `theme/screenshot.webp` with a picture of your theme at exactly 1200 x 900 pixels.
   The preview below writes full-page shots you can crop one from.

## The loop: edit, check, preview

The checker and the preview live in the product repository. Clone it once and install it:

```
git clone https://github.com/joiha-steven/quireink.git
cd quireink
bun install
```

Then, from inside that clone, with the path to this repository's `theme` folder:

```
bun run theme:check /path/to/quireink-theme-starter/theme
bun run theme:preview /path/to/quireink-theme-starter/theme
```

- **`theme:check`** runs the blog's own install checker on the folder and writes nothing. It
  prints `ok · <id> <version> · <n> files` and exits 0, or one line per problem
  (`rule · file:line:col · what`) with a sentence explaining the rule, and exits 1.
- **`theme:preview`** checks first, then starts a throwaway blog with sample posts, installs the
  theme the way the admin does and photographs every kind of page a reader reaches (the post
  list, the front page with pictures and as text, a post with every block, an untitled post, book
  mode, a page, a category, a tag, a series, the archive, search, the notebook, a note and the
  404) at 375, 768 and 1440 pixels, light and dark, once per palette. Each shot is measured for
  a page wider than the window, a box past its edge, clipped text, and images or fonts that did
  not load. The shots, `REPORT.txt` and a contact sheet (`index.html`) land in
  `.tmp/theme-preview/<id>/` inside the clone. It needs a headless Chrome; if it cannot find
  one it says how to install it, or set `CHROME` to its path. One palette takes about a minute;
  `--pages`, `--widths` and `--force` (run again over the last output) are listed in the
  [preview docs](https://github.com/joiha-steven/quireink/blob/main/docs/theme-install-api.md#preview-before-installing).

`check.sh` and `check.ps1` run both, from anywhere, given the clone's path as the first
argument or in `QUIREINK`. They pass `--force` to the preview and any other options through,
and exit with the checker's code when it refuses, otherwise with the preview's:

```
./check.sh ~/src/quireink                       # macOS, Linux, Git Bash
QUIREINK=~/src/quireink ./check.sh --widths 375

.\check.ps1 C:\src\quireink                     # Windows PowerShell
$env:QUIREINK = 'C:\src\quireink'; .\check.ps1 --pages 'home-list,post-all-blocks'

# When PowerShell refuses to run scripts (the default policy on Windows, or a script that
# came in a downloaded zip), run it through a one-off bypass instead:
powershell -ExecutionPolicy Bypass -File .\check.ps1 C:\src\quireink
```

## Zip it

**Zip the folder's contents, not the folder.** `theme.json` must sit at the top of the zip.
Finder's Compress and Explorer's "Send to compressed folder" on the folder itself put everything
one level down, and the install refuses that. Hidden files are refused too (`.DS_Store`,
`Thumbs.db`, `__MACOSX/`), so leave them out.

```
# macOS / Linux, from inside the theme folder
cd theme
zip -r ../my-theme.zip . -x '.*' '*/.*' '__MACOSX/*'

# Windows PowerShell, from inside the theme folder (the built-in bsdtar, not Compress-Archive,
# which writes backslashes in names on Windows PowerShell 5)
cd theme
& "$env:SystemRoot\System32\tar.exe" -a -cf ..\my-theme.zip --exclude Thumbs.db --exclude .DS_Store (Get-ChildItem -Name)
```

Run the checker on the zip before you hand it out: `bun run theme:check /path/to/my-theme.zip`.
A zip is at most 5 MB, a font at most 400 KB, an image at most 1 MB, `theme.css` at most 64 KB.

## Install it

On the blog: **Settings → Appearance → Theme → Install from a file**, and pick the zip. The
admin says what came back: installed, already installed, or refused with one line per problem.
The new tile carries an **Unreviewed** badge, as every installed theme does. **Preview** opens
the site in the theme in a new tab without changing anything; choosing the tile and pressing
**Save** puts it on the blog. **Use this theme's suggested palette and fonts** switches on what
`suggests` names. Installing the same id with a higher version keeps the old one for
**Roll back**. The full story, including the HTTP routes, is in
[theme-install-api.md](https://github.com/joiha-steven/quireink/blob/main/docs/theme-install-api.md).

## The rules, in short

- **Colour only from the palette**: `var(--c-bg)`, `--c-text`, `--c-heading`, `--c-meta`,
  `--c-link`, `--c-rule`, `--c-accent`, or mixed or derived from them (`color-mix()`,
  `oklch(from var(--c-bg) calc(l * .9) c h)`). No hex, no colour names, no fixed `rgb()`. (C1)
- **Sizes only from the type scale**: `var(--fs-*)`, `em` or `%`, or `calc()` over a `--fs-*`.
  No `px` or `rem` font sizes, no `font:` shorthand, no `zoom`. (T1)
- **Faces only from the engine**: `var(--font-reading)`, `var(--font-sans)`,
  `var(--font-mono)`, `var(--font-display)` or `inherit`. Your own fonts are declared in
  `theme.json` and reach the page through those variables. (F1)
- **Selectors only from the appearance contract**: any element, but only the classes, ids and
  `data-*` attributes the product promises to keep. The list is in
  [appearance-contract.md](https://github.com/joiha-steven/quireink/blob/main/docs/appearance-contract.md)
  and in
  [`src/content/appearance-contract.ts`](https://github.com/joiha-steven/quireink/blob/main/src/content/appearance-contract.ts).
  Reach a part by its contract name (`.listing-head`, `.card-exc`, `.card-meta`, `.note-source`,
  `.tl-yr`, `data-lead`, `data-thumb`, `data-short`), not by its position in the markup. (S1)
- **Style both the blog pages and the front page**: a sheet that touches only one is refused. (S2)
- **No words in `content:`**: only `""`, counters and the engine's labels (`var(--l-figure)`,
  `var(--l-table)`), because a word in a stylesheet cannot be translated. (S3)
- **Custom properties of your own are named `--t-*`**, and `var()` reads only those, the
  `--l-*` labels and the engine's promised variables. (V1)
- **No `!important`** (P1), **no `@import`, `@font-face` or `@layer`**: only `@media`,
  `@supports`, `@container` and `@keyframes` (A1); **no URL outside the package** (A2).
- **A theme that hides `.post-info` must bring back an untitled post's header**, or a post with
  no title shows its date nowhere on a wide screen. Starter keeps the panel; the Newspaper theme
  shows the other way in [looks.md](https://github.com/joiha-steven/quireink/blob/main/docs/conventions/looks.md).
- **`layout.menu: "header"` draws the menu in the masthead and the engine does the rest**: it
  hides the rail's copy (`.rail-menu-copy`) and a rail left holding only that copy
  (`.rail-menu-only`) from 60rem, and the phone drawer keeps the menu. The theme only places the
  menu in its header; Starter's chrome group shows how.

The rule codes are listed in
[`src/theme/types.ts`](https://github.com/joiha-steven/quireink/blob/main/src/theme/types.ts), and
the whole story is in the [author guide](https://github.com/joiha-steven/quireink/blob/main/docs/themes.md).

## The font

`theme/fonts/literata.woff2` is [Literata](https://github.com/googlefonts/literata), the face
Quire Ink itself reads in, under the SIL Open Font License 1.1 (`licenses/OFL-Literata.txt`).
Literata reserves no font name, so a cut-down copy may keep its name.

The product serves its fonts split by script into three files each. A theme font face is one
file with no `unicode-range`, so this one is built as a single file covering Latin, Latin
Extended and Vietnamese, from the same upstream source and with the product's settings (weight
axis 400 to 700, optical size fixed at 18), and keeps every name record, so the file carries its
own copyright line and licence URL:

```
pip install fonttools brotli
# Literata[opsz,wght].ttf from github.com/googlefonts/literata, fonts/variable/
python - <<'EOF'
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer
f = instancer.instantiateVariableFont(TTFont("Literata[opsz,wght].ttf"), {"wght": (400, 400, 700), "opsz": 18})
f.save("literata-instanced.ttf")
EOF
python -m fontTools.subset literata-instanced.ttf --flavor=woff2 --name-IDs='*' --name-languages='*' \
  --layout-features+=onum,dlig --output-file=literata.woff2 \
  --unicodes='U+0000-00FF,U+0100-02FF,U+0300-036F,U+1D00-1DBF,U+1E00-1EFF,U+2000-206F,U+20A0-20C0,U+2074,U+2113,U+2122,U+2191,U+2193,U+2212,U+2215,U+2C60-2C7F,U+A720-A7FF,U+FB00-FB06,U+FEFF,U+FFFD'
```

It is one variable file declared four times in `theme.json`, at 400, 500, 600 and 700, so the
browser draws each weight from the font's own axis rather than faking bold. To use another
face, check its licence first: a font with a Reserved Font Name may not keep that name once it
is subset.

## Licence

The theme's code, manifest, screenshot and scripts are MIT No Attribution (MIT-0, `LICENSE`):
copy, change and ship them without keeping any notice, so a theme built from this starter
carries no licence duty from it. The font is not covered: it keeps its own licence, the SIL
Open Font License 1.1, in `licenses/`.
