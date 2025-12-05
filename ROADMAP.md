# SIMPLE_SHOWCASE Roadmap

---

## Claude: Start Here

**When starting a new conversation, read this file first.**

### Session Startup

1. **Read Eiffel reference docs**: `D:/prod/reference_docs/eiffel/claude/CONTEXT.md`
2. **Read content blueprint**: `D:/prod/reference_docs/eiffel/archive/simple_showcase_content.md`
3. **Review this roadmap** for project-specific context
4. **Ask**: "What would you like to work on this session?"

### Key Reference Files

| File | Purpose |
|------|---------|
| `D:/prod/reference_docs/eiffel/claude/CONTEXT.md` | Generic Eiffel knowledge |
| `D:/prod/reference_docs/eiffel/archive/simple_showcase_content.md` | Complete content blueprint |
| `D:/prod/reference_docs/eiffel/language/gotchas.md` | Generic Eiffel gotchas |
| `D:/prod/reference_docs/eiffel/language/patterns.md` | Verified code patterns |

### Build & Test Commands

```bash
# From Git Bash (project directory)
cd /d/prod/simple_showcase

# Set environment variables
export SIMPLE_SHOWCASE="D:\\prod\\simple_showcase"
export SIMPLE_ALPINE="D:\\prod\\simple_alpine"
export SIMPLE_HTMX="D:\\prod\\simple_htmx"
export SIMPLE_WEB="D:\\prod\\simple_web"
export TESTING_EXT="D:\\prod\\testing_ext"

# Compile library
"/c/Program Files/Eiffel Software/EiffelStudio 25.02 Standard/studio/spec/win64/bin/ec.exe" \
  -batch -config simple_showcase.ecf -target simple_showcase -c_compile

# Run tests
"/c/Program Files/Eiffel Software/EiffelStudio 25.02 Standard/studio/spec/win64/bin/ec.exe" \
  -batch -config simple_showcase.ecf -target simple_showcase_tests -tests

# Compile and run server
"/c/Program Files/Eiffel Software/EiffelStudio 25.02 Standard/studio/spec/win64/bin/ec.exe" \
  -batch -config simple_showcase.ecf -target run_server -c_compile
./EIFGENs/run_server/W_code/simple_showcase.exe
# Then open browser to http://localhost:8080

# Clean compile
rm -rf EIFGENs && "/c/Program Files/Eiffel Software/EiffelStudio 25.02 Standard/studio/spec/win64/bin/ec.exe" \
  -batch -config simple_showcase.ecf -target simple_showcase_tests -c_compile
```

### Current Status

**Phase 2 Complete** - All 11 sub-pages implemented with universal hamburger navigation

Completed work:
- ✅ Project structure created
- ✅ ECF configuration with all targets
- ✅ SSC_SHARED - Color palette, typography, animation constants + invariants
- ✅ SSC_PAGE - Base page class with HTML structure
- ✅ SSC_SECTION - Base section class with Alpine.js integration + contracts
- ✅ All 9 landing page sections implemented (Hero + 8 content sections)
- ✅ SSC_LANDING_PAGE - Main page assembling all sections + contracts
- ✅ SSC_GLOSSARY - Tooltip system for DBC terminology
- ✅ SSC_LOGGER - Aggressive debug logging for development
- ✅ SSC_NAV_OVERLAY - Fixed nav with Home/Up/Down buttons + section dots
- ✅ Smooth scroll-based fade transitions (JavaScript)
- ✅ GitHub links on all Evidence section project cards
- ✅ Third column in Workflow section (DBC/Eiffel as "the airplane")
- ✅ Full contract review pass with preconditions/postconditions/invariants
- ✅ Compiles clean with contracts enabled
- ✅ **Phase 2: All 11 sub-pages implemented**
- ✅ SSC_SUB_PAGE - Base class for sub-pages with common structure
- ✅ SSC_HAMBURGER_MENU - Universal navigation component
- ✅ YouTube video cards on workflow page
- ✅ Citation URLs verified and corrected
- ✅ WIP notation for simple_gui_designer

---

## Project Overview

SIMPLE_SHOWCASE is a web server built in Eiffel using simple_web that serves the AI+DBC paradigm showcase site. Pages are generated dynamically from Eiffel classes with HTMX + Alpine.js for interactivity. The site itself is proof of concept—built and **served** using the same tools and methodology it describes.

### Design Philosophy

1. **Evidence over argument** — Show, don't tell
2. **Invitation, not attack** — Reader is potential ally
3. **Progressive revelation** — AI → DBC → Eiffel
4. **Self-demonstrating** — Site proves the paradigm

### Architecture

```
SSC_SHARED (constants)
    └── SSC_PAGE (base page)
            └── SSC_LANDING_PAGE
            └── SSC_GET_STARTED_PAGE (future)
            └── SSC_PORTFOLIO_PAGE (future)
            └── ...

SSC_SHARED (constants)
    └── SSC_SECTION (base section)
            └── SSC_HERO_SECTION
            └── SSC_RECOGNITION_SECTION
            └── SSC_SHIFT_SECTION
            └── SSC_PROBLEM_SECTION
            └── SSC_UNLOCK_SECTION
            └── SSC_EVIDENCE_SECTION
            └── SSC_REVELATION_SECTION
            └── SSC_WORKFLOW_SECTION
            └── SSC_INVITATION_SECTION

SITE_GENERATOR (main application)
    └── Generates all pages to output/
```

---

## Dependencies

### Required Libraries
- **base** - Eiffel standard library
- **simple_htmx** - HTML element building (set `SIMPLE_HTMX` environment variable)
- **simple_alpine** - Alpine.js directives (set `SIMPLE_ALPINE` environment variable)
- **simple_web** - HTTP server (set `SIMPLE_WEB` environment variable)

### Test Dependencies
- **testing** - EiffelStudio testing framework
- **testing_ext** - TEST_SET_BASE for tests (set `TESTING_EXT` environment variable)

### Environment Variables

Set these in Windows (use setx or System Properties):
```
SIMPLE_SHOWCASE=D:\prod\simple_showcase
SIMPLE_ALPINE=D:\prod\simple_alpine
SIMPLE_HTMX=D:\prod\simple_htmx
SIMPLE_WEB=D:\prod\simple_web
SIMPLE_JSON=D:\prod\simple_json
TESTING_EXT=D:\prod\testing_ext
```

---

## Roadmap

### Phase 1 - Landing Page ✅ COMPLETE

| Feature | Description | Status |
|---------|-------------|--------|
| **Project structure** | ECF, directories, core classes | ✅ |
| **SSC_SHARED** | Colors, typography, animation constants | ✅ |
| **SSC_PAGE** | Base page with HTML structure | ✅ |
| **SSC_SECTION** | Base section with Alpine.js | ✅ |
| **Hero section** | Impact statement with animation | ✅ |
| **Recognition section** | Pain points grid | ✅ |
| **Shift section** | AI arrived narrative | ✅ |
| **Problem section** | Research citations | ✅ |
| **Unlock section** | DBC code example + glossary tooltips | ✅ |
| **Evidence section** | Project portfolio grid + GitHub links | ✅ |
| **Revelation section** | Timeline | ✅ |
| **Workflow section** | Human/AI/DBC three-column comparison | ✅ |
| **Invitation section** | Three CTA paths | ✅ |
| **SSC_GLOSSARY** | Tooltip system for technical terms | ✅ |
| **SSC_LOGGER** | Debug logging infrastructure | ✅ |
| **SSC_NAV_OVERLAY** | Fixed navigation (Home/Up/Down + dots) | ✅ |
| **Smooth scrolling** | Scroll-based fade transitions | ✅ |
| **Contract review** | Preconditions/postconditions/invariants | ✅ |
| **Test compilation** | Verify all compiles with contracts | ✅ |
| **Visual refinement** | Test in browser | ✅ |

### Phase 2 - Sub-Pages ✅ COMPLETE

| Feature | Description | Status |
|---------|-------------|--------|
| **SSC_SUB_PAGE** | Base class for all sub-pages | ✅ |
| **SSC_HAMBURGER_MENU** | Universal hamburger navigation | ✅ |
| **Get Started page** | Quick start guide | ✅ |
| **Portfolio page** | Full project details + GitHub links | ✅ |
| **Design by Contract page** | How contracts work | ✅ |
| **Workflow page** | Methodology + YouTube videos | ✅ |
| **Analysis page** | Competitive analysis with citations | ✅ |
| **Business Case page** | ROI analysis | ✅ |
| **Why Eiffel page** | Language choice explained | ✅ |
| **Probable to Provable page** | Core framework philosophy | ✅ |
| **The Old Way page** | Traditional approach costs | ✅ |
| **AI Changes page** | What AI actually changes | ✅ |

### Phase 3 - Polish

| Feature | Description | Status |
|---------|-------------|--------|
| **Navigation** | Universal hamburger menu | ✅ |
| **Footer** | Links, attribution (in sub-pages) | ✅ |
| **Responsive design** | Mobile optimization | Backlog |
| **Animations** | Fine-tune timing | Backlog |
| **GitHub Pages** | Deployment | Backlog |

---

## Session Notes

### 2025-12-04 (Session 3 - Phase 2 Complete)

**Task**: Complete all sub-pages and universal navigation

**Implementation**:
- Created SSC_SUB_PAGE base class with common header, footer, nav structure
- Implemented all 11 sub-pages with content from blueprint
- Added SSC_HAMBURGER_MENU for universal navigation
  - `make` - always visible (sub-pages)
  - `make_hidden_until_scroll` - appears on scroll (landing page)
- Added YouTube video cards to workflow page
- Fixed hallucinated citation URLs (Uplevel, Veracode, Devin, Apiiro)
- Removed hallucinated Bertrand Meyer CACM 2025 reference
- Added WIP notation to simple_gui_designer entries

**Key Decisions**:
- Hamburger menu hidden on landing page entry, appears on scroll (keeps hero clean)
- Sub-pages always show hamburger menu
- Used parallel arrays instead of tuple iteration (Eiffel limitation)
- Custom scroll container detection for Alpine.js scroll events

**Gotchas Discovered**:
- Eiffel: Named tuple field access doesn't work in `across` loops
- JavaScript: `window.scrollY` is always 0 with custom scroll containers
- AI: Citation URLs can be hallucinated - always verify

### 2025-12-04 (Session 2 - Phase 1 Complete)

**Task**: Complete landing page with smooth scrolling, navigation, glossary tooltips, and contract review

**Implementation**:
- Added SSC_GLOSSARY for tooltip definitions of DBC terms
- Added SSC_LOGGER with timestamped, categorized debug logging
- Created SSC_NAV_OVERLAY with Home/Up/Down buttons and section indicator dots
- Replaced jerky CSS scroll-snap with smooth scroll-based fade transitions
- Added third column to Workflow section (DBC/Eiffel as "the airplane")
- Added GitHub links to all 12 project cards in Evidence section
- Added eiffel_sqlite_2025 project (bringing total to 12)
- Full contract review pass on all classes with Design by Contract

**Key Decisions**:
- Removed all CSS scroll-snap for smooth, natural scrolling
- JavaScript-based opacity/transform transitions for fade effect
- Fixed nav overlay stays visible, tracks current section via scroll position
- Glossary tooltips use hover-reveal for non-intrusive definitions

**Contracts Added**:
- SSC_SECTION: build_section, section_classes postconditions
- SSC_NAV_OVERLAY: section_ids, to_html, nav_script contracts
- SSC_GLOSSARY: tooltip preconditions/postconditions, tooltip_css
- SSC_SHARED: invariants for color hex format, CDN URLs
- SSC_LOGGER: preconditions on all log methods, format_time/padded contracts
- SSC_LANDING_PAGE: make postconditions, to_html, body_content, html_* contracts
- Section components: helper features (project_card, role_item, etc.) with contracts

### 2025-12-04 (Initial Creation)

**Task**: Set up simple_showcase project based on SIMPLE_SHOWCASE_CONTENT.md blueprint

**Implementation**:
- Created project structure: src/core, src/pages, src/components, tests, output
- ECF with three targets: library, tests, run_server
- SSC_SHARED with all visual constants (colors, fonts, animations)
- SSC_PAGE base class with complete HTML structure
- SSC_SECTION base class with Alpine.js x-intersect integration
- All 8 landing page sections with full content from blueprint
- SSC_LANDING_PAGE assembling all sections with scroll-snap
- SSC_SERVER - HTTP server using simple_web (run_server target)
- 9 initial tests

**Key Decisions**:
- Sections use x-intersect for scroll-triggered animations
- Each section handles its own visibility state
- Staggered animations via delay-[] Tailwind classes
- Background colors vary by section to create visual rhythm

---

## Notes

- All development follows Eiffel Design by Contract principles
- Classes use ECMA-367 standard Eiffel
- Testing via EiffelStudio AutoTest framework with TEST_SET_BASE
- Output is static HTML with CDN dependencies (Tailwind, Alpine.js, Lenis)
- The site demonstrates the paradigm it describes (meta-proof)
