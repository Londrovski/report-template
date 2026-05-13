# report-template

A modular LaTeX report skeleton, Overleaf-ready. Designed for engineering
and technical reports with marking rubrics, but the structural conventions
generalise to most multi-section academic or professional reports.

## What you get

- **Thin `main.tex` orchestrator** — `\input`s preamble, sections, and
  back matter; nothing else.
- **Split preamble** — `packages`, `colours`, `style`, `boxes`, `markers`,
  `wordcount`, `shorthands`. One concern per file.
- **Modular sections** — every section is a wrapper `sections/0X_name.tex`
  that `\input`s subsection files from `sections/0X_name/`.
- **Live word-count dashboard** — `working-notes/00-progress.tex` renders
  a table of every file vs target vs current word count, rebuilding on
  each compile.
- **Per-section colour-coded count badges** — `[1234 / 1500 words]` at
  the end of each section, red when over limit.
- **Single source of truth for targets** — a `% TARGET: N` comment at
  the top of each section file. `scripts/update-targets.py` regenerates
  `meta/targets.tex` from those comments (or the GitHub Action does it
  on push).
- **Rubric mapping** in two places:
  - `sections/A1_rubric_mapping.tex` — appendix in the published PDF,
    marker-facing.
  - `working-notes/04-rubric-improvements.tex` — internal priority-ordered
    list of additions that would lift coverage.
- **Working-notes pages** for progress, conventions, scoring insights,
  known errors, rubric improvements, and restore points. All wrapped in
  `%TC:ignore` and toggled by comment in `main.tex`.
- **Drafting markers** — `\todo{}`, `\needcite{}`, `\gap{}`, plus the
  `gapbox` environment. All greppable for strip-before-submission passes.
- **Per-section `.bib` support** — add `references/sec1.bib`,
  `references/sec2.bib`, etc. as the report grows. The default ships
  with one general `references.bib`.

## Using it on a new project

### Option 1 — manual

1. Click **Use this template** → create your new repo.
2. Edit `meta/project.tex` — title, author, unit, deadline, total word
   limit, bibliography style.
3. Edit the `% TARGET: N` comments at the top of each section file. Run
   `python3 scripts/update-targets.py` (or push, and the GitHub Action
   does it).
4. Rename / add / remove section files to match your structure. Keep the
   `\input` list in `content/body-sections.tex` and the counter list in
   `preamble/wordcount.tex` in sync.
5. Import into Overleaf: **Menu → GitHub → Import from GitHub**.
6. Compiler: **LuaLaTeX** (the `.latexmkrc` should pick this up).

### Option 2 — let the `report-scaffold` skill do it

If you're running Cowork or Claude Code with the `report-scaffold` skill
installed, just say *"I'm starting a new report for X"* and the skill
will interview you (mark scheme, sections, word targets, optional
appendices) and pre-fill a fork for you.

## Repository structure

```
.
├── main.tex                       # Thin orchestrator
├── README.md                      # This file
├── .latexmkrc                     # Compiler config (lualatex + biber)
├── texcount.cfg                   # Word-count exclusion rules
├── .gitignore                     # LaTeX build artefacts + .wcsum sidecars
│
├── meta/
│   ├── project.tex                # Title, author, deadline, total limit
│   └── targets.tex                # AUTO-GENERATED from % TARGET comments
│
├── preamble/
│   ├── packages.tex               # All \usepackage calls
│   ├── colours.tex                # Palette + semantic colours
│   ├── style.tex                  # hyperref + biblatex + heading styles
│   ├── boxes.tex                  # notesbox, insightnotesbox, gapbox
│   ├── markers.tex                # \qContext, \qOptions, \qDecision...
│   ├── wordcount.tex              # Live texcount-driven counters
│   └── shorthands.tex             # \todo, \needcite, \gap, \pass, \fail
│
├── content/
│   └── body-sections.tex          # Ordered \input list — body only
│
├── sections/
│   ├── 00_frontmatter.tex         # Title page + TOC + LoF/LoT
│   ├── 00_abbreviations.tex       # Optional abbreviations table
│   ├── 01_introduction.tex        # § wrapper; \input's subsection files
│   ├── 01_introduction/
│   │   ├── 11_overview.tex
│   │   └── 12_scope.tex
│   ├── 02_market.tex
│   ├── 02_market/
│   │   ├── 21_landscape.tex
│   │   └── 22_competitors.tex
│   ├── A1_rubric_mapping.tex      # Compliance matrix appendix
│   └── A2_genai_acknowledgement.tex
│
├── working-notes/                  # Pages compiled but TC:ignored
│   ├── 00-progress.tex             # ← the live dashboard
│   ├── 01-conventions.tex
│   ├── 02-scoring-insights.tex
│   ├── 03-known-errors.tex
│   ├── 04-rubric-improvements.tex
│   └── 05-restore-points.tex
│
├── references/
│   └── references.bib              # Add sec1.bib, sec2.bib... as needed
│
├── figures/
│   └── FIGURES.md                  # Register of planned figures + tables
│
├── scripts/
│   ├── update-targets.py           # Regenerates meta/targets.tex
│   └── wordcount.sh                # CLI body word count for offline checks
│
└── .github/workflows/
    └── regen-targets.yml           # Re-runs update-targets.py on push
```

## Adding a new section

1. Create `sections/0X_name.tex` and `sections/0X_name/` (folder for
   subsections).
2. Add `% TARGET: N` as the first line of the new section file.
3. For each subsection, add `% TARGET: N` to its first line and `\input`
   it from the section wrapper.
4. Add `\input{sections/0X_name}` + `\sectionwordcount{X}` to
   `content/body-sections.tex` (capword position: Three, Four, ...).
5. Add the matching `\countmerged` / `\countsingle` calls to
   `\runallcounts` in `preamble/wordcount.tex`, and the
   `\addtowc{wctotal}{...}` calls to `\totalwordcount`. (TODO: this could
   be auto-generated by the parser too — open issue.)
6. Add a row to `working-notes/00-progress.tex` for the dashboard.
7. Run `python3 scripts/update-targets.py` and commit.

## Conventions worth knowing

- **Cross-references** always via `\cref{label}` — auto-prefixes
  "Section"/"Table"/"Figure". Never hardcode "Table 2" in prose.
- **Tables and figures introduced in prose before they appear.**
- **Drafting markers** (`\todo`, `\needcite`, `\gap`) are excluded from
  the word count. Strip-grep them before submission:
  `grep -rn -E '\\(todo|needcite|gap)\{' sections/`.
- **Working-notes are wrapped in `%TC:ignore`** — they compile but don't
  count toward the limit. Comment them out in `main.tex` before final
  submission if you don't want them in the submitted PDF.
- **British English** by default via `[british]{babel}`. Spell-check is
  manual — no LaTeX package enforces spelling.

## How the live word count works

`preamble/wordcount.tex` uses `\write18` to invoke `texcount` on each
section file, dumping `.wcsum` sidecar files containing the integer
count. Then LaTeX reads them back via `\newread\wcfile` and sums into
`\newcounter` totals.

Two-pass compile required: first pass writes the `.wcsum` files,
second pass reads them. Overleaf recompiles automatically so this is
transparent.

Shell-escape required — Overleaf whitelists `texcount` specifically, so
it Just Works on Overleaf. Locally, `pdflatex -shell-escape main.tex`
or `lualatex --shell-escape main.tex`.

If shell-escape is disabled, counts render as `?` (not fatal).

## Credits

Mechanism lifted from `Londrovski/G10-Technical-Report` and
`Londrovski/G10-Commercial-Viability`, generalised into a starter
template for future projects.
