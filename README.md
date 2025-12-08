<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/claude_eiffel_op_docs/main/artwork/LOGO.png" alt="simple_ library logo" width="400">
</p>

# SIMPLE_SHOWCASE
### AI+DBC Paradigm Showcase Website

[![Language](https://img.shields.io/badge/language-Eiffel-blue.svg)](https://www.eiffel.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()
[![Live Demo](https://img.shields.io/badge/demo-live-brightgreen.svg)](http://localhost:8080)

---

## Overview

SIMPLE_SHOWCASE is a web application built entirely in Eiffel that demonstrates the AI+DBC (Design by Contract) development paradigm. The site itself serves as proof of concept - built using the same methodology it describes.

**Key Message**: 25 libraries + 4 apps, 1,200+ tests, 13 days, one person - AI-assisted, contract-verified development. Christmas Sprint: 14 libraries in 2 days.

**Developed using AI-assisted methodology:** Built interactively with Claude following rigorous Design by Contract principles.

---

## Quick Start

### Prerequisites

- EiffelStudio 25.02+
- Environment variables set (see below)

### Environment Variables

```powershell
# Set at User level
[System.Environment]::SetEnvironmentVariable('SIMPLE_SHOWCASE', 'D:\prod\simple_showcase', 'User')
[System.Environment]::SetEnvironmentVariable('SIMPLE_ALPINE', 'D:\prod\simple_alpine', 'User')
[System.Environment]::SetEnvironmentVariable('SIMPLE_HTMX', 'D:\prod\simple_htmx', 'User')
[System.Environment]::SetEnvironmentVariable('SIMPLE_WEB', 'D:\prod\simple_web', 'User')
[System.Environment]::SetEnvironmentVariable('TESTING_EXT', 'D:\prod\testing_ext', 'User')
```

### Run the Server

```bash
# From Git Bash
cd /d/prod/simple_showcase

# Set environment variables for session
export SIMPLE_SHOWCASE="D:\\prod\\simple_showcase"
export SIMPLE_ALPINE="D:\\prod\\simple_alpine"
export SIMPLE_HTMX="D:\\prod\\simple_htmx"
export SIMPLE_WEB="D:\\prod\\simple_web"
export TESTING_EXT="D:\\prod\\testing_ext"

# Compile and run
"/c/Program Files/Eiffel Software/EiffelStudio 25.02 Standard/studio/spec/win64/bin/ec.exe" \
  -batch -config simple_showcase.ecf -target run_server -c_compile

./EIFGENs/run_server/W_code/simple_showcase.exe
```

Then open http://localhost:8080 in your browser.

---

## Site Structure

### Landing Page (/)

Scroll-based narrative with 9 sections:
1. **Hero** - Impact statement
2. **Recognition** - Pain points grid
3. **Shift** - AI arrived narrative
4. **Problem** - Research citations on AI code quality
5. **Unlock** - DBC code example with glossary tooltips
6. **Evidence** - Project portfolio with GitHub links
7. **Revelation** - Development timeline
8. **Workflow** - Human/AI/DBC collaboration model
9. **Invitation** - Three CTA paths

### Sub-Pages

| URL | Page | Description |
|-----|------|-------------|
| /get-started | Get Started | Quick start guide |
| /portfolio | Portfolio | Full project details |
| /design-by-contract | Design by Contract | How DBC works |
| /workflow | Workflow | Methodology + YouTube videos |
| /analysis | Analysis | Competitive analysis |
| /business-case | Business Case | ROI analysis |
| /why-eiffel | Why Eiffel | Language choice explained |
| /probable-to-provable | Probable to Provable | Core framework philosophy |
| /old-way | The Old Way | Traditional approach costs |
| /ai-changes | AI Changes | What AI actually changes |

---

## Architecture

```
SSC_SHARED (constants: colors, typography, CDNs)
    |
    +-- SSC_SECTION (base section with Alpine.js)
    |       |
    |       +-- SSC_HERO_SECTION
    |       +-- SSC_RECOGNITION_SECTION
    |       +-- SSC_SHIFT_SECTION
    |       +-- SSC_PROBLEM_SECTION
    |       +-- SSC_UNLOCK_SECTION
    |       +-- SSC_EVIDENCE_SECTION
    |       +-- SSC_REVELATION_SECTION
    |       +-- SSC_WORKFLOW_SECTION
    |       +-- SSC_INVITATION_SECTION
    |
    +-- SSC_LANDING_PAGE (assembles all sections)
    |
    +-- SSC_SUB_PAGE (base class for sub-pages)
    |       |
    |       +-- SSC_GET_STARTED_PAGE
    |       +-- SSC_PORTFOLIO_PAGE
    |       +-- SSC_DBC_PAGE
    |       +-- SSC_WORKFLOW_PAGE
    |       +-- SSC_ANALYSIS_PAGE
    |       +-- SSC_BUSINESS_CASE_PAGE
    |       +-- SSC_WHY_EIFFEL_PAGE
    |       +-- SSC_PROBABLE_PAGE
    |       +-- SSC_OLD_WAY_PAGE
    |       +-- SSC_AI_CHANGES_PAGE
    |
    +-- SSC_HAMBURGER_MENU (universal navigation)
    +-- SSC_NAV_OVERLAY (landing page nav dots)
    +-- SSC_GLOSSARY (DBC term tooltips)
    +-- SSC_LOGGER (debug logging)

SSC_SERVER (HTTP server using simple_web)
```

---

## Features

### Universal Hamburger Navigation

- **Landing page**: Hidden initially, appears on scroll
- **Sub-pages**: Always visible
- **11 navigation items** with descriptions
- Animated hamburger icon transforms to X

### Scroll-Based Fade Transitions

JavaScript-powered opacity transitions as sections come into view, creating a smooth reveal effect.

### Glossary Tooltips

Technical DBC terms (precondition, postcondition, invariant) have hover tooltips explaining their meaning.

### GitHub Integration

All project cards link directly to their GitHub repositories.

### YouTube Video Cards

Workflow page includes embedded links to relevant videos.

---

## Design Philosophy

1. **Evidence over argument** - Show, don't tell
2. **Invitation, not attack** - Reader is potential ally
3. **Progressive revelation** - AI -> DBC -> Eiffel
4. **Self-demonstrating** - Site proves the paradigm

---

## Dependencies

| Library | Purpose |
|---------|---------|
| simple_htmx | HTML element building |
| simple_alpine | Alpine.js directives |
| simple_web | HTTP server |
| testing_ext | TEST_SET_BASE for tests |

### CDN Dependencies (loaded at runtime)

- Tailwind CSS - Styling
- Alpine.js - Interactivity

---

## Project Structure

```
simple_showcase/
+-- src/
|   +-- core/           # Base classes, shared constants
|   +-- components/     # Reusable UI components
|   +-- pages/          # Sub-page implementations
+-- tests/              # Test suites
+-- EIFGENs/            # Compiled output (generated)
+-- simple_showcase.ecf # Project configuration
+-- ROADMAP.md          # Development roadmap
+-- README.md           # This file
```

---

## Building & Testing

### Compile Library

```bash
"/c/Program Files/Eiffel Software/EiffelStudio 25.02 Standard/studio/spec/win64/bin/ec.exe" \
  -batch -config simple_showcase.ecf -target simple_showcase -c_compile
```

### Run Tests

```bash
"/c/Program Files/Eiffel Software/EiffelStudio 25.02 Standard/studio/spec/win64/bin/ec.exe" \
  -batch -config simple_showcase.ecf -target simple_showcase_tests -tests
```

### Finalized Build (Production)

```bash
"/c/Program Files/Eiffel Software/EiffelStudio 25.02 Standard/studio/spec/win64/bin/ec.exe" \
  -batch -config simple_showcase.ecf -target run_server -finalize -c_compile
```

---

## Development Status

| Phase | Status |
|-------|--------|
| Phase 1 - Landing Page | Complete |
| Phase 2 - Sub-Pages | Complete |
| Phase 3 - Polish | In Progress |

### Remaining Work

- Mobile responsive optimization
- Animation fine-tuning
- GitHub Pages deployment

---

## Design by Contract

All classes include comprehensive contracts:

```eiffel
to_html: STRING
    -- Generate complete HTML page
    do
        create Result.make (50000)
        Result.append (html_doctype)
        Result.append (html_head)
        Result.append (html_body)
    ensure
        not_empty: not Result.is_empty
        is_html: Result.has_substring ("<!DOCTYPE html>")
    end
```

---

## Development Methodology

### AI-Assisted Development

SIMPLE_SHOWCASE demonstrates the AI+DBC paradigm it describes:

- **Interactive Design**: Features designed through conversation with Claude
- **Contract-Driven**: All features include preconditions, postconditions, invariants
- **Continuous Validation**: Contracts verified at runtime
- **Self-Documenting**: Code structure reflects design intent

### The Workflow

1. **Human**: Sets direction, defines requirements
2. **AI**: Generates code, handles boilerplate
3. **DBC**: Verifies correctness, catches errors early

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

## Resources

### Project Links
- **Repository**: https://github.com/simple-eiffel/simple_showcase
- **Issues**: https://github.com/simple-eiffel/simple_showcase/issues

### Related Projects
- [simple_json](https://github.com/simple-eiffel/simple_json) - JSON library
- [simple_sql](https://github.com/simple-eiffel/simple_sql) - SQLite wrapper
- [simple_web](https://github.com/simple-eiffel/simple_web) - HTTP client/server
- [simple_htmx](https://github.com/simple-eiffel/simple_htmx) - HTML builder
- [simple_alpine](https://github.com/simple-eiffel/simple_alpine) - Alpine.js integration

### Eiffel Resources
- [Eiffel Software](https://www.eiffel.org/) - Official site
- [EiffelStudio](https://www.eiffel.org/downloads) - Download IDE
- [Bertrand Meyer](https://bertrandmeyer.com/) - DBC creator

---

## Contact

- **Author**: Larry Rix
- **Built with**: Claude (Anthropic)

---

**Note**: This site is built with the approach it describes. No frameworks. No bundlers. No node_modules. Just Eiffel + AI + Design by Contract.
