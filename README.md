# Beamer Slide Template

A structured LaTeX template for producing presentation PDFs. One shared theme,
many independent decks. Runs on Windows, macOS and Linux, and supports Thai
(Sarabun) out of the box.

**→ Full instructions, in English and Thai: [MANUAL.md](MANUAL.md)**

---

## Quick start

Requires [TeX Live](https://tug.org/texlive/) (or [MacTeX](https://tug.org/mactex/)
on macOS). Nothing else — no fonts or packages to install.

```powershell
# Windows
.\scripts\build.ps1 -Deck showcase       # build the example -> build\showcase.pdf
.\scripts\new-deck.ps1 -Name my-talk     # start your own
```

```bash
# macOS / Linux
chmod +x scripts/*.sh                    # first time only
./scripts/build.sh -d showcase
./scripts/new-deck.sh -n my-talk
```

Add `-Thai` / `-t` when creating a deck that contains Thai.

## Layout

```
decks/_template/    blank starting point (copied by new-deck)
decks/showcase/     worked example exercising every feature
theme/              the beamer theme, 5 .sty files + vendored Sarabun
preamble/           opt-in modules: math, code, figures, bib, Thai
scripts/            build / new-deck / clean, in .ps1 and .sh
build/              finished PDFs
```

## Design notes

**Base setup.** `10pt`, `aspectratio=169`, `dvipsnames`. Fira Sans throughout,
Computer Modern for maths.

**Three engines, one source.** `preamble/engine.tex` branches on `iftex`, so the
same `main.tex` compiles under pdfLaTeX, XeLaTeX and LuaLaTeX with no edits.
pdfLaTeX is the default; each deck's `.latexmkrc` can override it.

**Thai.** Sarabun (= TH Sarabun New, OFL) is vendored in `theme/assets/fonts/`
and loaded by relative path, so it needs no system install and works on
Overleaf. Sarabun is TTF-only and pdfLaTeX cannot read TTF, so Thai decks build
with XeLaTeX; under pdfLaTeX they fall back to Garuda with a warning rather
than failing.

`preamble/thai-utf8-pdftex.def` supplies the UTF-8 → LTH character mapping that
TeX Live's Thai support lacks. Without it, pdfLaTeX rejects UTF-8 Thai outright.
babel's `thai` option is deliberately not used: it switches bytes `0xA1–0xFB` to
catcode 11 for TIS-620 input, which disables LaTeX's UTF-8 decoder entirely.

**Theme resolution.** `\usetheme{deck}` finds `theme/` because each deck's
`.latexmkrc` prepends it to `TEXINPUTS` via `scripts/latexmk-common.pl`. For
Overleaf or a bare `pdflatex` run, define `\def\themepath{../../theme/}` before
`\usetheme` and the sub-themes resolve by relative path instead.

## Customising

Colours live in a single seven-line block at the top of
`theme/beamercolorthemedeck.sty`. Everything else derives from it.

## Font licence

Sarabun is used under the SIL Open Font License; `OFL.txt` ships alongside the
font files in `theme/assets/fonts/` and must stay with them if you redistribute.
