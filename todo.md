# todo.md: Academic homepage build plan

Claude Code: work through these phases in order. Tick items (`[x]`) as you complete them, add new items where you find them, and record anything that needs a decision or material from Anas under "Needs input from Anas" at the bottom. Items marked **(Anas)** are for Anas to do himself.

---

## Phase 0: Prerequisites

- [x] **(Anas)** Check that no repository named `anasrana.github.io` already exists on GitHub (if one does, decide whether to reuse or rename it).
  - Checked 2026-11-02: it **does exist**. Created 2019-04-26, three commits (`README.md`, `index.html`, `main.css`: an old "MRC Research Fellow" placeholder), default branch `master`, Pages in legacy mode serving `master` `/`. Decision needed from Anas (see bottom of file).
- [x] Confirm Quarto is installed and at version 1.6 or later (`quarto --version`); if not, tell Anas how to install or upgrade it (e.g. `brew install --cask quarto`).
- [x] Confirm `git` is configured and the GitHub CLI (`gh`) is installed and authenticated (`gh auth status`); if not, give Anas the exact commands.
  - Quarto 1.10.20, git 2.56.0 (user Anas A Rana, a.a.rana@bham.ac.uk), gh 2.103.3 logged in as `anasrana` over SSH with `repo` scope.
- [x] Initialise the git repository in this folder with default branch `main`.
- [x] Add `.gitignore` (`_site/`, `.quarto/`, `.DS_Store`, `*_files/` scratch folders, `/.luarc.json`).

## Phase 1: Scaffold and first deploy (deploy early, then iterate)

- [ ] Create a minimal Quarto website: `_quarto.yml` (`project: type: website`, output dir `_site`), `index.qmd` with a one-line placeholder.
- [ ] Add `.github/workflows/publish.yml` as specified in `CLAUDE.md` section 8 (render with Quarto, deploy with `upload-pages-artifact` + `deploy-pages`, `workflow_dispatch` enabled).
- [ ] Render locally (`quarto render`) and confirm `_site/index.html` exists.
- [ ] Commit and create/push the GitHub repository `anasrana/anasrana.github.io` (public).
- [ ] **(Anas)** In the repository: Settings > Pages > Build and deployment > Source = **GitHub Actions**.
- [ ] Re-run the workflow if needed; confirm `https://anasrana.github.io/` shows the placeholder page.
- [ ] Confirm `https://anasrana.github.io/ems-practicals/` still loads (it should be unaffected).

## Phase 2: Brand and typography

- [ ] Download ET Book (MIT licence) into `brand/fonts/et-book/` and include its licence file.
- [ ] Write `_brand.yml` with fonts and colours (check the current schema in the Quarto docs first).
- [ ] Write `brand/tufte.scss`: base font size and line-height, off-white background, text colours, italic `h2`/`h3`, `.newthought` small caps, light link underlines, thin rules, sidenote and margin-note styling, figure captions.
- [ ] Wire both into `_quarto.yml` (`format: html: theme: [cosmo or none, brand/tufte.scss]`, or as the docs recommend with `_brand.yml`).
- [ ] Build a temporary `typography-test.qmd` exercising headings, a long paragraph, footnotes as sidenotes, a margin figure, a block quote, a list, inline and display maths, a code block and a table. Review it in preview, then exclude it from the site (or delete it) before Phase 6.

## Phase 3: Layout (Option B)

- [ ] Create `_profile.yml` (or the chosen single-source mechanism) with: name, title, department, institution, photo path, email, Google Scholar, ORCID, GitHub, plus optional others. Use `TODO(Anas)` placeholders for unknown values.
- [ ] Implement the left profile sidebar (photo, name, title, text links, thin rule, navigation) reading from the profile file.
- [ ] Set grid widths so the body measure is about 34-38em and the right margin about 12-16em.
- [ ] Set `reference-location: margin` and `citation-location: margin` site-wide.
- [ ] Highlight the current page in the sidebar navigation.
- [ ] Mobile: sidebar collapses to a compact header with menu; margin content flows inline; no horizontal scroll at 375px. Check at 375px, 768px and 1280px+.
- [ ] Add a minimal footer: name, year, "Built with Quarto", link to the source repository.

## Phase 4: Pages and content structure

- [ ] `index.qmd` (About): short bio with `.newthought` opening, research summary, latest 3-5 news items, a few selected publications.
- [ ] `research.qmd`: research themes as short sections, each with optional margin figure.
- [ ] `teaching.qmd`: programmes and modules; link to the EMS practicals (`https://anasrana.github.io/ems-practicals/`) with a one-line description.
- [ ] `group.qmd`: current and former PhD and Master's students (placeholders only until Anas supplies names).
- [ ] `news.qmd`: full news listing from `data/news.yml`, dates in the margin.
- [ ] `cv.qmd`: short summary plus a link to `files/cv.pdf`.
- [ ] Awards section (on About or CV page) from `data/awards.yml`.
- [ ] `404.qmd`: short, on-brand "page not found" with a link home.
- [ ] Create `data/news.yml` and `data/awards.yml` with the structure in `CLAUDE.md` section 7 and placeholder entries clearly marked `TODO(Anas)`.

## Phase 5: Publications

- [ ] Create `data/publications.yml` (selected papers) with the schema in `CLAUDE.md` section 7.
- [ ] Write an EJS listing template in `_templates/` that renders: title; authors with Anas's name in small caps; venue in italic with year; text links (paper, preprint, code, data); thumbnail and caption in the right margin.
- [ ] Use the same template for selected publications on the home page (limited to 3-4).
- [ ] Full list: `publications.qmd` renders every entry in `data/references.bib` (`nocite: "@*"`), newest first, grouped by year if feasible. Choose a clean author-year CSL style and include it in the repo.
- [ ] **(Anas)** Export the publication list from Zotero (Better BibTeX) to `data/references.bib`, and supply thumbnails for selected papers (PNG, about 600px wide).

## Phase 6: Polish and checks

- [ ] Favicon (a simple monogram in the brand serif, or a plain glyph).
- [ ] Site metadata: `site-url: https://anasrana.github.io`, description, Open Graph title and description, `sitemap.xml` (Quarto generates it when `site-url` is set).
- [ ] Remove or exclude `typography-test.qmd`.
- [ ] Check all internal and external links (e.g. with `lychee` or a short script); fix broken ones.
- [ ] Accessibility pass: alt text everywhere, heading order, contrast (WCAG AA), visible keyboard focus.
- [ ] Performance: compress images, confirm fonts are `woff2` and preloaded, no unused JavaScript beyond Quarto's own.
- [ ] Final review with Anas on desktop and phone; collect changes into this file.

## Phase 7: Later (not now; leave as notes)

- [ ] Extract `_brand.yml` and `brand/` into a shared repository or Quarto extension, then use it here, in the practicals, and in lecture slides (reveal.js), so one font configuration carries across all outputs.
- [ ] Migrate EMS practicals from bookdown to a Quarto book: `.Rmd` to `.qmd`, `_bookdown.yml` to `_quarto.yml` with the same parts, convert cross-references (`\@ref(fig:x)` to `@fig-x`) and chunk options to `#|` style. **Preserve existing page URLs** (e.g. `simulating-random-numbers.html`, `markov-chains.html`) by matching file names or adding redirects, so links from slides and students' bookmarks keep working.
- [ ] Optional citation metrics line (citations, h-index) refreshed by a scheduled GitHub Action. Prefer the OpenAlex API over scraping Google Scholar, which is fragile and against Scholar's terms.
- [ ] Optional notes or blog section (Quarto listing of posts).
- [ ] Optional custom domain (ask first).

---

## Needs input from Anas

- [ ] **Existing `anasrana.github.io` repo (blocks Phase 1 push).** Recommended: reuse it. Push the new `main` with `--force` (replacing the 2019 placeholder; its history stays recoverable from a local backup clone), make `main` the default branch, delete `master`, and switch Pages source to GitHub Actions. Alternative: delete the repo on GitHub and recreate it. Confirm which.
- [ ] This folder lives in Dropbox. Git repositories in Dropbox can be corrupted by sync conflicts in `.git/`; consider excluding `.git` from sync or moving the working copy outside Dropbox (GitHub is then the backup).
- [ ] Profile photo (square, at least 400px).
- [ ] Email address to display, Google Scholar URL, ORCID iD, any other profile links.
- [ ] Short bio (or approval of a drafted one).
- [ ] Research themes to feature.
- [ ] `references.bib` export and the list of selected papers with thumbnails.
- [ ] News items and awards.
- [ ] Group members (current and former) and whether to show photos.
- [ ] CV PDF.
- [ ] Final sidebar section list (current plan: About, Research, Publications, Teaching, Group, News, CV).
