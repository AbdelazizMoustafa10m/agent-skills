# Aphorisms — Visual Quote Cards Workflow

> Typography-dominant visual cards that elevate sharp observations into shareable art.
> The text IS the art. Illustrations are whispers, not shouts.

---

## Brand Identity

| Token | Hex | Role |
|---|---|---|
| Warm Cream | `#F6F3EB` | Primary background |
| Coral/Orange | `#D67056` | Primary text option, emphasis accents |
| Tan/Sand | `#E6CCAB` | Subtle background texture, secondary accents |
| Teal | `#70B8AD` | Accent marks, decorative elements |
| Dark Charcoal | `#222222` | Primary text option, structural elements |
| Muted Blue | `#5D95C6` | Attribution text, secondary information |
| Dark Grey Blue | `#2C313A` | Alternative dark text, shadows |
| Mustard Yellow | `#EAB64D` | Highlight accent, spark elements |

**Font:** Clean monospace technical font like JetBrains Mono (JetBrainsMono Nerd Font)

---

## Overview

Aphorism cards are typography-first visual pieces. The quote dominates 80-90% of the visual space. Any illustration is minimal — a single line, a geometric accent, a tiny sketch element. The power comes from the words, the typography, and the whitespace.

**Format:** Square 1:1 (1080x1080px ideal for social media)

**Primary text treatments:**
- Coral (#D67056) text on Warm Cream (#F6F3EB) background
- Dark Charcoal (#222222) text on Warm Cream (#F6F3EB) background

---

## Typography System

### Hierarchy

| Level | Content | Size (relative) | Weight | Color |
|---|---|---|---|---|
| **Quote Text** | The aphorism itself | 100% (largest) | Bold or Regular | Coral or Dark Charcoal |
| **Emphasis Word** | One key word in the quote | 120-140% of quote | Bold | Opposite of quote color |
| **Attribution** | Who said it | 40-50% of quote | Regular | Muted Blue (#5D95C6) |
| **Context** | Where/when, optional | 30-40% of quote | Light/Italic | Tan/Sand (#E6CCAB) |

### Text Layout Patterns

#### Pattern A: Centered Stack
```
        [small decorative element]

     "The best code is no code
              at all."

           — Author Name
```
Best for: Short quotes (under 10 words), philosophical tone.

#### Pattern B: Left-Aligned Block
```
  "The best code is
   no code at all."

   — Author Name
   Context, 2024
```
Best for: Medium quotes, technical/editorial tone.

#### Pattern C: Emphasis Word Breakout
```
         The best
          CODE
      is no code at all.

      — Author Name
```
Best for: Quotes with a pivotal word, dramatic effect.

#### Pattern D: Staggered Lines
```
  "The best code
          is no code
                  at all."

  — Author Name
```
Best for: Rhythmic quotes, poetic feel, creating visual movement.

#### Pattern E: Full Bleed
```
"THE BEST CODE
 IS NO CODE
 AT ALL."

                — Author Name
```
Best for: Bold statements, maximum impact, short quotes only.

---

## Workflow Steps

### Step 1: PARSE THE QUOTE

**Goal:** Break the aphorism into typographic components.

1. **Extract the quote text** — exact wording, punctuation
2. **Identify the emphasis word** — which single word carries the most weight?
3. **Determine attribution** — author, source, date
4. **Measure quote length:**
   - Short: 1-8 words → Patterns A, C, or E
   - Medium: 9-20 words → Patterns A, B, or D
   - Long: 21+ words → Pattern B or D (requires careful sizing)
5. **Assess emotional tone:**
   - Warm/human/encouraging → Coral text
   - Sharp/technical/definitive → Dark Charcoal text
   - Provocative/challenging → Coral emphasis word + Charcoal body

**Output:** Quote breakdown with pattern and color selections.

---

### Step 2: CHOOSE TEXT COLOR TREATMENT

**Goal:** Select the primary and accent color combination.

#### Treatment Options

| Treatment | Quote Color | Emphasis Color | Background | Best For |
|---|---|---|---|---|
| **Warm Voice** | Coral (#D67056) | Dark Charcoal (#222222) | Warm Cream (#F6F3EB) | Encouraging, human, personal |
| **Sharp Voice** | Dark Charcoal (#222222) | Coral (#D67056) | Warm Cream (#F6F3EB) | Technical, definitive, authoritative |
| **Teal Accent** | Dark Charcoal (#222222) | Teal (#70B8AD) | Warm Cream (#F6F3EB) | Calm, technical, systems thinking |
| **Bold Contrast** | Dark Grey Blue (#2C313A) | Mustard (#EAB64D) | Warm Cream (#F6F3EB) | Bold, attention-grabbing, startling |
| **Inverted** | Warm Cream (#F6F3EB) | Coral (#D67056) | Dark Charcoal (#222222) | Dramatic, night-mode, striking |

Rules:
- **Warm Voice** and **Sharp Voice** are the defaults — use them 80% of the time
- **Inverted** is reserved for exceptionally dramatic quotes
- Attribution always uses Muted Blue (#5D95C6) unless on dark backgrounds

---

### Step 3: DESIGN MINIMAL ILLUSTRATION

**Goal:** Add a tiny illustrative accent (optional but encouraged).

The illustration should occupy no more than **10-20% of the visual space**. It serves as a whisper of visual interest, not a competing element.

#### Illustration Types

| Type | Description | When to Use |
|---|---|---|
| **Single Line** | One continuous hand-drawn line suggesting a shape | Abstract quotes |
| **Geometric Accent** | A triangle, circle, or line in Teal or Coral | Technical quotes |
| **Tiny Sketch** | Miniature charcoal sketch (keyboard, coffee cup, pen) | Relatable quotes |
| **Border Element** | Thin line or dot pattern framing one edge | Formal/structured quotes |
| **Gradient Wash** | Subtle Coral or Teal watercolor wash in one corner | Poetic/reflective quotes |
| **Code Fragment** | Faint monospace text in background at 10% opacity | Programming quotes |
| **None** | Pure typography, no illustration | When the words are enough |

#### Illustration Placement

```
┌─────────────────────┐
│ ·                   │  · = Top-left accent (geometric, small)
│                     │
│    QUOTE TEXT        │
│    QUOTE TEXT        │
│                     │
│         — Author    │
│                 ──  │  ── = Bottom-right accent (line, border)
└─────────────────────┘
```

Illustrations go in corners or edges, never competing with text. A single accent point is preferred over multiple.

---

### Step 4: CRAFT THE PROMPT

**Goal:** Build the generation prompt combining typography, color, and illustration decisions.

#### Prompt Template

```
Square 1:1 visual quote card on warm cream (#F6F3EB) background.

Typography (dominant — 80-90% of visual space):
Quote text: "[THE FULL QUOTE]"
Layout: [PATTERN NAME from Step 1]
Primary text color: [COLOR NAME] ([HEX])
Emphasis word "[WORD]" in [EMPHASIS COLOR NAME] ([HEX])
Attribution "— [AUTHOR]" in muted blue (#5D95C6), smaller size, [PLACEMENT]
Font style: Clean monospace technical font like JetBrains Mono. Crisp, precise letterforms.

Minimal illustration accent (10-20% of space):
[ILLUSTRATION TYPE] in [COLOR] at [PLACEMENT]

Design rules:
- Typography is the hero — large, confident, well-spaced
- Generous whitespace / breathing room
- Background is solid warm cream (#F6F3EB) or warm cream with very subtle tan/sand (#E6CCAB) texture
- No busy patterns, no gradients behind text, no drop shadows on text
- The card should feel like a premium print piece — minimal, intentional, every element earned its place
- Square format, 1:1 aspect ratio
```

---

### Step 5: GENERATE

**Goal:** Produce the quote card.

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[QUOTE CARD PROMPT]" \
  --size 2K \
  --aspect-ratio 1:1 \
  --output ~/prj/art-skill/outputs/aphorism-card.png
```

For quick drafts during iteration:
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-flash \
  --prompt "[QUOTE CARD PROMPT]" \
  --size 2K \
  --aspect-ratio 1:1 \
  --output ~/prj/art-skill/outputs/aphorism-card-draft.png
```

#### Batch Generation

For a set of quotes (e.g., a series):
```bash
# Quote 1
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT 1]" \
  --size 2K \
  --aspect-ratio 1:1 \
  --output ~/prj/art-skill/outputs/aphorism-01.png

# Quote 2
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT 2]" \
  --size 2K \
  --aspect-ratio 1:1 \
  --output ~/prj/art-skill/outputs/aphorism-02.png

# ... and so on
```

---

### Step 6: OPTIMIZE

**Goal:** Prepare for social media delivery.

```bash
# Social media optimized (1080x1080)
sips --resampleWidth 1080 --resampleHeight 1080 \
  ~/prj/art-skill/outputs/aphorism-card.png \
  --out ~/prj/art-skill/outputs/aphorism-card-1080.png

# WebP for web embedding
cwebp -q 90 ~/prj/art-skill/outputs/aphorism-card-1080.png \
  -o ~/prj/art-skill/outputs/aphorism-card-1080.webp

# Small preview thumbnail
sips --resampleWidth 400 --resampleHeight 400 \
  ~/prj/art-skill/outputs/aphorism-card.png \
  --out ~/prj/art-skill/outputs/aphorism-card-thumb.png
```

Higher quality (90) for quote cards — text legibility is paramount.

---

### Step 7: VALIDATE

**Goal:** Verify the quote card meets all quality standards.

#### Validation Checklist

**Typography:**
- [ ] Quote text is the dominant visual element (80-90% of space)
- [ ] Text is fully legible at 1080x1080 resolution
- [ ] Font styling appears monospace/technical (JetBrains Mono feel)
- [ ] Quote text spelling is exact — no AI-introduced errors
- [ ] Attribution is present, smaller, and in Muted Blue
- [ ] Emphasis word (if used) is visually distinct
- [ ] No text is cut off at edges

**Color Compliance:**
- [ ] Background is Warm Cream (#F6F3EB) or very close
- [ ] Primary text is either Coral (#D67056) or Dark Charcoal (#222222)
- [ ] No off-brand colors introduced
- [ ] Sufficient contrast between text and background (WCAG AA minimum)

**Composition:**
- [ ] Square 1:1 format
- [ ] Generous whitespace — the card breathes
- [ ] Illustration accent (if present) is minimal, 10-20% max
- [ ] No competing visual elements
- [ ] Visual hierarchy: Quote > Emphasis > Attribution > Accent

**Quality:**
- [ ] No AI artifacts or distortions in letterforms
- [ ] Clean edges on text
- [ ] Consistent style (looks intentionally designed, not randomly generated)
- [ ] Would pass as a professional designed card on social media

**Technical:**
- [ ] 1080x1080 version created
- [ ] WebP version created
- [ ] Thumbnail created
- [ ] All files in `~/prj/art-skill/outputs/`

#### Typography Failure Modes

| Issue | Fix |
|---|---|
| AI garbled the text | Add text post-generation using ImageMagick or regenerate with clearer prompt |
| Text too small | Reduce quote length in prompt or choose Pattern E (full bleed) |
| Wrong font style | Emphasize "monospace, technical, JetBrains Mono style" more strongly in prompt |
| Poor contrast | Switch to higher-contrast treatment (Sharp Voice or Inverted) |

---

## Quick Reference

### Minimal Invocation
```
Create a quote card: "The best code is no code at all." — Author Name
```

### Full Invocation
```
Create a quote card:
Quote: "The best code is no code at all."
Author: Author Name
Context: Conference Talk, 2025
Emphasis word: "no"
Treatment: Sharp Voice
Pattern: Emphasis Word Breakout
Illustration: Tiny charcoal keyboard sketch, bottom-right corner
```

### Series Invocation
```
Create a series of 5 quote cards with consistent style:
1. "Quote one..." — Author
2. "Quote two..." — Author
...
Use Warm Voice treatment, Pattern A, geometric accent.
```

---

## Examples

### Example 1: Technical Aphorism

**Quote:** "Make it work, make it right, make it fast."
**Author:** Kent Beck
**Treatment:** Sharp Voice (Charcoal text, Coral emphasis)
**Pattern:** Pattern C (Emphasis Word Breakout)
**Emphasis:** "right"

**Prompt:**
```
Square 1:1 visual quote card on warm cream (#F6F3EB) background.

Typography (dominant, 85% of visual space):
Three lines centered:
"Make it work, make it" in dark charcoal (#222222), clean monospace font
"RIGHT" in coral (#D67056), 140% size, bold, same monospace font
"make it fast." in dark charcoal (#222222)

Attribution "— Kent Beck" in muted blue (#5D95C6), 40% of quote size, centered below with generous spacing.

Font: Clean monospace technical font like JetBrains Mono.

Minimal accent: Single thin teal (#70B8AD) horizontal line below attribution, 30% width of card, centered.

Warm cream background, generous whitespace. Premium, minimal, intentional design. Square 1:1 format.
```

### Example 2: Philosophical Aphorism

**Quote:** "We shape our tools, and thereafter our tools shape us."
**Author:** Marshall McLuhan
**Treatment:** Warm Voice (Coral text)
**Pattern:** Pattern D (Staggered Lines)

**Prompt:**
```
Square 1:1 visual quote card on warm cream (#F6F3EB) background.

Typography (dominant, 90% of visual space):
Staggered lines, left-aligned with increasing indent:
"We shape our tools," — first line, left
"and thereafter" — second line, indented 20%
"our tools shape us." — third line, indented 40%

All text in coral (#D67056), clean monospace technical font like JetBrains Mono.

Attribution "— Marshall McLuhan" in muted blue (#5D95C6), right-aligned, bottom area.

Minimal accent: Faint charcoal (#222222) sketch of a hammer at 8% opacity in the bottom-left corner, very small.

Warm cream (#F6F3EB) background, vast whitespace. The stagger of text creates visual movement from top-left to bottom-right. Square 1:1 format. Minimal, premium feel.
```

### Example 3: Bold Statement

**Quote:** "Ship it."
**Author:** (none)
**Treatment:** Bold Contrast (Dark Grey Blue text, Mustard accent)
**Pattern:** Pattern E (Full Bleed)

**Prompt:**
```
Square 1:1 visual quote card on warm cream (#F6F3EB) background.

Typography (dominant, 80% of visual space):
"SHIP IT." in dark grey blue (#2C313A), very large, centered, clean monospace technical font like JetBrains Mono. The text should fill the horizontal width of the card with generous side margins.

The period is rendered in mustard yellow (#EAB64D) as a bold, slightly oversized dot — a deliberate design accent.

No attribution.

Minimal accent: Single mustard yellow (#EAB64D) dot/circle in top-right corner echoing the period, very small.

Warm cream (#F6F3EB) background. Maximum whitespace above and below. The two words and the colored period are the entire design. Square 1:1 format. Confident, minimal, bold.
```
