# Beamer Slide Template

A LaTeX beamer presentation, ready to copy. `main.tex` in this folder **is**
the talk — one copy of this repo is one presentation. Runs on Windows, macOS
and Linux, and Thai (Sarabun) works out of the box with nothing to configure.

**→ Full instructions, in English and Thai: [MANUAL.md](MANUAL.md)**

---

## Quick start

Requires [TeX Live](https://tug.org/texlive/) (or [MacTeX](https://tug.org/mactex/)
on macOS). Nothing else — no fonts or packages to install.

**To start a new talk: copy this whole folder and rename it.** That is the
entire procedure. Nothing inside points outside, and nothing needs repointing.

```powershell
# Windows
.\scripts\build.ps1              # -> build\<folder-name>.pdf
```

```bash
# macOS / Linux
chmod +x scripts/*.sh            # first time only
./scripts/build.sh
```

Or skip the scripts entirely: open `main.tex` in **TeXstudio** and press
build. No configuration required — see below.

Then edit `metadata.tex` (title, author) and `sections/*.tex` (the slides).

## Layout

```
main.tex            THIS PRESENTATION -- the file you build
metadata.tex        title, author, institute, date
sections/           your slides, one file per section
figures/            images for this talk
refs.bib            bibliography, if you cite anything
.latexmkrc          engine choice + build settings

theme/              the beamer theme, 5 .sty files + vendored Sarabun
preamble/           opt-in modules: math, code, figures, bib, Thai
scripts/            build / clean, in .ps1 and .sh
showcase/           worked example exercising every feature -- delete if you like
build/              finished PDFs
```

## Copying is the only mechanism

| Goal | Do this |
|---|---|
| A new talk | Copy this whole folder, rename it, edit `metadata.tex` |
| A second talk beside this one | Copy `main.tex`, `metadata.tex`, `sections/`, `.latexmkrc` into a subfolder |
| Send it away, or Overleaf | Send the folder as-is, or zip it |

There is no export tool, no scaffolding script, and nothing to edit after a
copy. `main.tex` finds `theme/` by searching `./`, `../`, `../../`,
`../../../` and taking the first hit, so it builds at whatever depth it lands.
~430 KB complete, fonts included.

`build.sh` / `build.ps1` name the PDF after the containing folder, so a copy
renamed `opdc-5stars/` produces `build/opdc-5stars.pdf`.

## Design notes

**Base setup.** `10pt`, `aspectratio=169`, `dvipsnames`. Fira Sans throughout,
Computer Modern for maths.

**Three engines, one source.** `preamble/engine.tex` branches on `iftex`, so the
same `main.tex` compiles under pdfLaTeX, XeLaTeX and LuaLaTeX with no edits.
XeLaTeX is the default here because Thai is switched on; `.latexmkrc` sets it.
(LuaLaTeX is fine for English-only decks but is refused when Thai is loaded --
see below.)

**Thai.** Sarabun (= TH Sarabun New, OFL) is vendored in `theme/assets/fonts/`
and loaded by relative path, so it needs no system install and works on
Overleaf.

Thai is typed raw — there is no wrapping macro. On XeLaTeX, `ucharclasses`
fires a transition on entering and leaving the Thai Unicode block; the
transition swaps only `\f@family`, so `\bfseries`/`\itshape` survive the
boundary, and sets `\XeTeXlinebreaklocale "th"` so lines break on ICU word
boundaries instead of acquiring a hyphen mid-word. `\linespread{1.25}` gives
the stacked vowel+tone marks room to clear the descenders above them.

This is not optional polish: Fira Sans has no Thai glyphs and XeTeX drops
missing glyphs *silently*, so unwrapped Thai used to vanish with a clean log
and no warning. `\thaiinline`/`thaipar` remain as no-op aliases.

Sarabun is TTF-only, so pdfLaTeX cannot use it. There, `fonts-tlwg` Garuda is
applied document-wide via `\AtBeginDocument{\thaitext}` — Garuda exists only in
`LTH` encoding, so it cannot sit beside Fira Sans as a second family, and
leaving it unswitched renders Thai as Latin mojibake. It warns.

LuaLaTeX + Thai raises a `\PackageError` instead of building. `ucharclasses`
needs `\XeTeXcharclass` so it is unavailable, and the alternative -- Sarabun as
the document-wide sans -- makes this theme die at shipout under `luaotfload`
with `error: (file ) (type 2): cannot find file ''`. The remaining option was
to let Thai silently vanish, which is the failure the file exists to prevent,
so it stops loudly and names XeLaTeX instead. LuaLaTeX still works for
English-only decks.

`preamble/thai-utf8-pdftex.def` supplies the UTF-8 → LTH character mapping that
TeX Live's Thai support lacks. Without it, pdfLaTeX rejects UTF-8 Thai outright.
babel's `thai` option is deliberately not used: it switches bytes `0xA1–0xFB` to
catcode 11 for TIS-620 input, which disables LaTeX's UTF-8 decoder entirely.

**Theme resolution.** Each deck's `main.tex` opens by searching for its own
dependencies rather than being told where they are:

```latex
\def\deck@probe#1{%
  \ifx\deckroot\@undefined
    \IfFileExists{#1theme/beamerthemedeck.sty}{\xdef\deckroot{#1}}{}%
  \fi
}
\deck@probe{}  \deck@probe{../}  \deck@probe{../../}  \deck@probe{../../../}
\edef\input@path{{\deckroot theme/}{\deckroot preamble/}}
```

`\input@path` is consulted by `\IfFileExists`, which `\usepackage` routes
through — so this resolves `\usetheme{deck}`, the four sub-themes it loads,
and every `\input{...}` from `preamble/`, with no `TEXINPUTS` and no build
tool. That is what makes a bare `xelatex main.tex`, TeXstudio and Overleaf all
work unchanged.

Because `\deckroot` is *discovered* rather than declared, the same unmodified
`main.tex` builds at the repo root with `theme/` beside it, in a subfolder one
level down (`showcase/`), or dropped into another project entirely. That is
what replaced the old export script. `preamble/base.tex` and `preamble/lang-thai.tex` derive the
graphics path and the Sarabun font path from `\deckroot`, so both follow.

Each deck's `.latexmkrc` probes the same way for `scripts/latexmk-common.pl`
and inlines equivalent defaults when it is out of reach, so a copied deck keeps
SyncTeX, biber and `out/` instead of silently reverting to latexmk's own
defaults. It also pins `@default_files = ('main.tex')` — otherwise a bare
`latexmk` compiles `metadata.tex` and every `sections/*.tex` too and reports
failure for files that have no `\begin{document}`.

**Editor integration.** Every `main.tex` carries `% !TeX program`,
`% !BIB program` and `% !TeX encoding`; every `sections/*.tex` carries
`% !TeX root`. TeXstudio, TeXworks, TeXShop and VS Code's LaTeX Workshop all
read these, so the correct engine and biber are selected per deck without
touching editor settings. `latexmk-common.pl` passes `-synctex=1` for
forward/inverse search.

## Customising

Colours live in a single seven-line block at the top of
`theme/beamercolorthemedeck.sty`. Everything else derives from it.

## Font licence

Sarabun is used under the SIL Open Font License; `OFL.txt` ships alongside the
font files in `theme/assets/fonts/` and must stay with them if you redistribute.
