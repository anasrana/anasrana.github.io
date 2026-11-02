# CLAUDE.md: Academic homepage for Anas A Rana

This file is the standing brief for Claude Code. Read it at the start of every session, then read `todo.md` and continue from the first unchecked item. Update `todo.md` as items are completed.

## 1. Purpose

Build and maintain a personal academic website for Anas A Rana, Associate Professor in Statistical Machine Learning, Department of Cancer and Genomic Sciences, University of Birmingham.

- Hosted on GitHub Pages as a **user site**: repository `anasrana/anasrana.github.io`, served at `https://anasrana.github.io/`.
- Authored in **Markdown / Quarto (`.qmd`)**, one file per page, so content can be edited without touching layout code.
- Built and deployed automatically by **GitHub Actions** on every push to `main`.

## 2. Decisions already made (do not revisit without asking)

| Area | Decision |
|---|---|
| Engine | Quarto website project (`project: type: website`). No Jekyll, Hugo or hand-written HTML pages. |
| Layout | "Option B": left profile sidebar, Tufte-style body, right margin column. Details in section 4. |
| Typography | Tufte style. ET Book for text (self-hosted), EB Garamond as fallback. Small caps for opening phrases, italic section headings, no bold headings in body. |
| Design references | Tufte CSS (`edwardtufte.github.io/tufte-css`), `itsjustmath.github.io` (typography, sidenotes), `linzy19.github.io` (profile block, publication entries with thumbnail and links, news, awards). Take the typography from the first two and the content structure from the third. |
| Tone of design | Minimal and typographic. No gradients, shadows, cards, animations, icon clutter or hero images. Generous whitespace; thin rules only where needed. |
| Profile data | Defined once, in a single file, and reused by the sidebar and any page that needs it. Never duplicated. |
| Publications | Selected papers from a YAML data file (with thumbnail and links); full list generated from a `.bib` file exported from Zotero (Better BibTeX). |
| Deployment | GitHub Actions workflow that renders with Quarto and deploys with the official Pages actions (`upload-pages-artifact` + `deploy-pages`). No `gh-pages` branch. |
| Brand | Fonts, colours and the Tufte stylesheet live together in `brand/` and `_brand.yml`, written so they can later be extracted into a shared repository or Quarto extension used by the practicals book and lecture slides. |

## 3. Related sites

- **EMS practicals**: `https://anasrana.github.io/ems-practicals/` (repo `anasrana/ems-practicals`), currently a bookdown `bs4_book` built from `.Rmd`. It is a separate GitHub Pages *project* site and continues to work unchanged under the user site. Link to it from the Teaching page.
- Never create a page or folder in this repository at the path `ems-practicals/`, since it would clash with that project site.
- Future work (not in scope now): migrate the practicals to a Quarto book that uses the same brand. Keep the brand files self-contained so this is easy.

## 4. Layout specification (Option B)

Desktop (width at least ~1100px), three columns:

1. **Left sidebar (about 180-200px)**, separated by a thin vertical rule:
   - Circular photo (about 96px).
   - Name, then title and institution in italic, smaller.
   - Contact and profile links as plain text links: Email, Google Scholar, ORCID, GitHub (and others as added). Text links, no icon rows.
   - A thin rule, then site navigation: About, Research, Publications, Teaching, Group, News, CV. Current page shown in the primary text colour, others in the secondary colour.
2. **Body column (about 34-38em measure)**: Tufte body text, roughly 1.1-1.2rem with line-height about 1.5.
3. **Right margin column (about 12-16em)**: sidenotes (from Markdown footnotes), margin figures and thumbnails, dates for news items, small captions.

Mobile and narrow screens:
- The sidebar collapses to a compact header (photo, name, links) with a simple menu.
- Margin content flows inline below the paragraph it belongs to, as Tufte CSS does.
- No horizontal scrolling at 375px width.

Implementation notes (verify each against current Quarto documentation before relying on it):
- Use Quarto's website sidebar (`website.sidebar`) with its `header` content for the profile block, or a small custom partial if the header cannot pull from the profile data file.
- Use `page-layout: article` and Quarto's `grid` options (`sidebar-width`, `body-width`, `margin-width`, `gutter-width`) for column widths.
- Use `reference-location: margin` and `citation-location: margin` so footnotes and citations become sidenotes; use `column: margin` / `.column-margin` for margin figures.
- Override Bootstrap defaults in `brand/tufte.scss` rather than fighting them page by page.

## 5. Typography and brand

- `_brand.yml` holds colours and font declarations; `brand/tufte.scss` holds the Tufte rules (headings, small caps, sidenote styling, rules, link styling). Check the current `_brand.yml` schema in the Quarto docs before writing it.
- Self-host ET Book in `brand/fonts/et-book/` (MIT licence, from the `edwardtufte/et-book` repository). Fallback stack: `"ET Book", "EB Garamond", Palatino, "Palatino Linotype", Georgia, serif`.
- A sans face is used only for tiny UI labels if needed; default to the serif everywhere.
- Colours: near-black text on off-white (Tufte uses `#fffff8` and `#111`); one muted secondary text colour; links underlined lightly, not coloured blocks.
- Headings: `h1` page title in roman, `h2` and `h3` in italic, normal weight. No bold headings.
- `.newthought` class (small caps) for the opening words of a section.
- Maths via MathJax (Quarto default). Check that MathJax output inherits the text colour.
- Dark mode: not required at launch. If added later, keep it as a separate theme and keep contrast at WCAG AA.

## 6. Repository structure (target)

```
anasrana.github.io/
├── CLAUDE.md
├── todo.md
├── _quarto.yml              # site config: sidebar, navigation, grid, format
├── _brand.yml               # fonts and colours
├── _profile.yml             # SINGLE source of profile data (name, title, links, photo)
├── brand/
│   ├── tufte.scss           # Tufte styling layered on Quarto's theme
│   └── fonts/et-book/       # self-hosted ET Book
├── index.qmd                # About (home)
├── research.qmd
├── publications.qmd
├── teaching.qmd
├── group.qmd
├── news.qmd
├── cv.qmd                   # short page + link to PDF
├── data/
│   ├── publications.yml     # selected papers (title, authors, venue, year, thumbnail, links)
│   ├── news.yml             # dated news items
│   ├── awards.yml
│   └── references.bib       # full list, exported from Zotero Better BibTeX
├── _templates/              # EJS listing templates for publications, news, awards
├── images/
│   ├── profile.jpg
│   └── thumbs/              # publication thumbnails
├── files/cv.pdf
├── 404.qmd
└── .github/workflows/publish.yml
```

The exact mechanism for reading `_profile.yml` (Quarto `_variables.yml` with `{{< var >}}`, document metadata, or a Lua filter / partial) is for you to choose after checking the docs. Requirement: the person edits profile details in exactly one file.

## 7. Content model

- **Pages**: plain `.qmd` with YAML front matter (`title`, optional `description`). Prose in Markdown; footnotes for sidenotes.
- **Selected publications** (`data/publications.yml`), rendered with a Quarto listing and a custom EJS template:
  ```yaml
  - title: "Paper title"
    authors: "A. A. Rana, B. Coauthor, et al."
    venue: "Bioinformatics"
    year: 2025
    thumbnail: images/thumbs/paper-slug.png   # shown in the margin
    links:
      paper: https://doi.org/...
      preprint: https://www.biorxiv.org/...
      code: https://github.com/...
    note: "Optional one-line description"
  ```
  Layout per entry: title in roman, authors with Anas's name in small caps, venue in italic with year, then plain text links ("paper", "code"). Thumbnail and an optional caption in the right margin.
- **Full publication list**: `publications.qmd` uses `bibliography: data/references.bib` with `nocite: "@*"` and a CSL style, grouped by year if feasible.
- **News** (`data/news.yml`): `date`, `text` (Markdown allowed). Date shown in the margin; newest first; home page shows the latest 3-5.
- **Awards** (`data/awards.yml`): `year`, `title`, `body`.

## 8. Deployment (GitHub Actions)

- Workflow: `.github/workflows/publish.yml`, triggered on push to `main` and manually (`workflow_dispatch`).
- Steps: checkout, set up Quarto (`quarto-dev/quarto-actions/setup`), `quarto render`, configure Pages, upload `_site/` with `actions/upload-pages-artifact`, deploy with `actions/deploy-pages`.
- Permissions: `contents: read`, `pages: write`, `id-token: write`; use a `concurrency` group for Pages.
- Use the current major version of each action; check their READMEs rather than assuming versions.
- The site does not execute R or Python code, so do not install R or Python in the workflow unless that changes. If computation is ever added, use Quarto's `freeze: auto` and commit `_freeze/`.
- One-time setting the person must do: repository Settings > Pages > Build and deployment > Source = **GitHub Actions**.
- `_site/` and `.quarto/` are in `.gitignore`; never commit rendered output.

## 9. Working conventions

- **Never invent facts.** No made-up publications, grants, awards, dates, students or biography. Where content is missing, insert a clearly marked placeholder (`TODO(Anas): ...`) and list it in `todo.md` under "Needs input from Anas".
- British English spelling throughout (organisation, modelling, programme).
- Concise, formal academic prose in any text you draft; keep drafts short and mark them for review.
- Preview locally with `quarto preview` before committing; check desktop and a 375px-wide mobile view.
- Small, focused commits with clear messages (e.g. `layout: add profile sidebar`, `content: add teaching page`).
- Do not add JavaScript frameworks, analytics, trackers, cookie banners or external font CDNs. Keep the site static and light.
- Accessibility: meaningful `alt` text on every image, sufficient contrast, visible focus states, semantic headings in order.
- Ask before: changing any decision in section 2, deleting content, adding a dependency, or adding a custom domain.

## 10. Commands

```bash
quarto --version            # confirm Quarto is installed (1.6 or later needed for _brand.yml)
quarto preview              # live local preview
quarto render               # full build into _site/
gh repo create anasrana/anasrana.github.io --public --source=. --push   # first push, if gh CLI is used
gh run watch                # follow the deploy workflow
```
