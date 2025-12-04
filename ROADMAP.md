# SIMPLE_SHOWCASE Roadmap

---

## Claude: Start Here

**When starting a new conversation, read this file first.**

### Session Startup

1. **Read Eiffel reference docs**: `D:/prod/reference_docs/eiffel/CLAUDE_CONTEXT.md`
2. **Read content blueprint**: `D:/prod/reference_docs/eiffel/SIMPLE_SHOWCASE_CONTENT.md`
3. **Review this roadmap** for project-specific context
4. **Ask**: "What would you like to work on this session?"

### Key Reference Files

| File | Purpose |
|------|---------|
| `D:/prod/reference_docs/eiffel/CLAUDE_CONTEXT.md` | Generic Eiffel knowledge |
| `D:/prod/reference_docs/eiffel/SIMPLE_SHOWCASE_CONTENT.md` | Complete content blueprint |
| `D:/prod/reference_docs/eiffel/gotchas.md` | Generic Eiffel gotchas |
| `D:/prod/reference_docs/eiffel/patterns.md` | Verified code patterns |

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

**Phase 1 In Progress** - Core structure built, landing page implemented

Completed work:
- ✅ Project structure created
- ✅ ECF configuration with all targets
- ✅ SSC_SHARED - Color palette, typography, animation constants
- ✅ SSC_PAGE - Base page class with HTML structure
- ✅ SSC_SECTION - Base section class with Alpine.js integration
- ✅ All 8 landing page sections implemented
- ✅ SSC_LANDING_PAGE - Main page assembling all sections
- ✅ SITE_GENERATOR - Generates HTML files
- ✅ Basic test suite (9 tests)

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
TESTING_EXT=D:\prod\testing_ext
```

---

## Roadmap

### Phase 1 - Landing Page ✅ IN PROGRESS

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
| **Unlock section** | DBC code example | ✅ |
| **Evidence section** | Project portfolio grid | ✅ |
| **Revelation section** | Timeline | ✅ |
| **Workflow section** | Human/AI comparison | ✅ |
| **Invitation section** | Three CTA paths | ✅ |
| **Test compilation** | Verify all compiles | Pending |
| **Visual refinement** | Test in browser | Pending |

### Phase 2 - Sub-Pages

| Feature | Description | Status |
|---------|-------------|--------|
| **Get Started page** | Quick start guide | Backlog |
| **Portfolio page** | Full project details | Backlog |
| **DBC page** | How contracts work | Backlog |
| **Workflow page** | Detailed methodology | Backlog |
| **Business Case page** | ROI analysis | Backlog |

### Phase 3 - Polish

| Feature | Description | Status |
|---------|-------------|--------|
| **Navigation** | Header with links | Backlog |
| **Footer** | Links, attribution | Backlog |
| **Responsive design** | Mobile optimization | Backlog |
| **Animations** | Fine-tune timing | Backlog |
| **GitHub Pages** | Deployment | Backlog |

---

## Session Notes

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
