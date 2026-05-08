# Stats -- Illustrated Statistics and Stat Cards

> Generate number-dominant illustrated stat cards where a massive statistic
> commands the visual, supported by a small contextual illustration and
> brand-consistent typography.

---

## When to Use

- Highlighting a key metric, KPI, or data point
- Creating social media stat cards for sharing
- Building dashboard-style visual summaries
- Making a single number feel impactful and memorable
- Presenting survey results, milestones, or achievements

---

## Visual Hierarchy

The stat card follows a strict visual weight distribution:

### Primary: The Number (60-70% of visual space)
- The statistic itself dominates the composition
- Massive typography, impossible to miss
- Positioned center or slightly above center
- Uses the strongest brand color for maximum impact

### Secondary: Supporting Illustration (20-30% of visual space)
- Small hand-drawn illustration that contextualizes the number
- Positioned below, beside, or behind the number
- Never competes with the number for attention
- Adds warmth and narrative to the raw data

### Tertiary: Label and Context (10-15% of visual space)
- Short label explaining what the number represents
- Optional trend indicator (up/down arrow, comparison)
- Source attribution or time period if relevant
- Smallest text, but still legible

---

## Brand Color System for Stats

| Element              | Color              | Hex       | Usage                                |
|----------------------|--------------------|-----------|--------------------------------------|
| Card Background      | Warm Cream         | #F6F3EB   | Default card background              |
| Primary Number       | Coral/Orange       | #D67056   | The main statistic (most common)     |
| Alt Number           | Teal               | #70B8AD   | Secondary stat or positive metric    |
| Card Surface         | Tan/Sand           | #E6CCAB   | Inner card panel if layered          |
| Trend Positive       | Teal               | #70B8AD   | Upward trend arrows, positive change |
| Trend Negative       | Coral/Orange       | #D67056   | Downward trend, alerts               |
| Trend Neutral        | Mustard Yellow     | #EAB64D   | Flat/stable indicators               |
| Label Text           | Dark Charcoal      | #222222   | Description labels                   |
| Supporting Detail    | Muted Blue         | #5D95C6   | Source text, time period, footnotes  |
| Dark Card Variant    | Dark Grey Blue     | #2C313A   | Alternative dark card background     |

### Color Pairing Rules

- **Coral number on Cream background**: Default, highest contrast
- **White number on Dark Grey Blue background**: Dark mode variant
- **Teal number on Cream background**: For positive/growth metrics
- **Coral number on Tan panel**: Softer, embedded feel
- **Mustard number on Dark Grey Blue**: High-energy, attention-grabbing

---

## Typography System

All text uses JetBrainsMono Nerd Font:

### Tier 1 -- The Number
- ExtraBold weight (heaviest available)
- Massive size: 60-70% of the card's vertical space
- The number should feel like it could break out of the card
- Color: Coral (#D67056) default, or per pairing rules above
- Optional: Subtle text shadow for depth

### Tier 2 -- Unit / Suffix
- Bold weight
- Attached to or near the number, but noticeably smaller (40-50% of number size)
- Examples: %, x, ms, K, M, /day, hrs
- Color: Same as number but at 70% opacity, or Dark Charcoal

### Tier 3 -- Label / Description
- Medium weight
- Below or above the number
- 1-5 words that explain what the number means
- Color: Dark Charcoal (#222222)

### Tier 4 -- Context / Source
- Regular or Light weight
- Smallest text on the card
- Time period, comparison, source attribution
- Color: Muted Blue (#5D95C6) or Dark Charcoal at 50% opacity

---

## Number Formatting

### General Rules
- **Use shorthand for large numbers**: 1.2M not 1,200,000
- **Round to meaningful precision**: 99.7% not 99.7284%
- **Include the unit**: Always show %, x, ms, K, etc.
- **Use locale-appropriate separators**: 1,234 or 1.234 depending on context

### Format Examples

| Raw Value      | Formatted   | Unit Position |
|----------------|-------------|---------------|
| 1200000        | 1.2M        | Suffix        |
| 0.997          | 99.7%       | Suffix        |
| 3.5            | 3.5x        | Suffix        |
| 42             | 42          | None needed   |
| 150            | 150ms       | Suffix        |
| 86400          | 24hrs       | Suffix        |
| 0.5            | 50%         | Suffix        |

---

## Supporting Illustration Guidelines

The small illustration (20-30% of visual) should:

1. **Be hand-drawn**: Consistent with the Art skill's organic style
2. **Be simple**: 5-10 strokes, instantly recognizable silhouette
3. **Relate directly**: Visually represent the metric's domain
4. **Not distract**: Lower opacity, positioned to not overlap the number
5. **Use brand colors**: Teal or Muted Blue for illustrations, never
   the same color as the number

### Illustration Suggestions by Metric Type

| Metric Domain    | Illustration Ideas                              |
|------------------|-------------------------------------------------|
| Users / People   | Simple crowd silhouette, person icon, hands      |
| Revenue / Money  | Coins stack, simple chart line going up, wallet  |
| Time / Speed     | Clock face, stopwatch, lightning bolt            |
| Growth           | Plant sprouting, upward arrow, mountain peak     |
| Performance      | Rocket, speedometer, flame                       |
| Reliability      | Shield, lock, chain link                         |
| Scale            | Globe, server rack, expanding circles            |
| Engagement       | Heart, speech bubbles, hands clapping            |
| Code / Technical | Terminal window, code brackets, gear             |
| Environmental    | Leaf, tree, water droplet                        |

---

## Prompt Template

```
A bold illustrated stat card on a warm cream (#F6F3EB) background with subtle
paper texture. Square format (1:1) optimized for social media.

The number: [NUMBER WITH UNIT]
Label: [What this number represents, 1-5 words]
Context: [Time period, comparison, or source -- optional]

Visual composition:
- The number "[NUMBER]" dominates 60-70% of the card in massive JetBrainsMono
  Nerd Font ExtraBold typography, colored [Coral #D67056 | Teal #70B8AD]
- The unit "[UNIT]" is attached to the number at 40-50% of its size,
  same color at 70% opacity
- Below the number, the label "[LABEL]" in JetBrainsMono Nerd Font Medium,
  Dark Charcoal (#222222)
- A small hand-drawn illustration of [ILLUSTRATION DESCRIPTION] occupies
  20-30% of the visual space, positioned [below | beside | behind] the number,
  drawn in [Teal #70B8AD | Muted Blue #5D95C6] with sketchy organic lines
- [Optional: Trend arrow pointing [up/down] in [Teal/Coral/Mustard]]
- [Optional: Context line "[CONTEXT]" in small Muted Blue #5D95C6 text at bottom]

Style: Clean, bold, number-first composition. The statistic is the hero.
The illustration adds warmth without competing. Hand-drawn aesthetic with
slightly wobbly lines on the illustration. Subtle drop shadow behind the
number for depth.

Card has rounded corners with a thin Dark Charcoal (#222222) border.
```

---

## Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio 1:1 \
  --output ~/prj/art-skill/outputs/[name].png
```

### Recommended Aspect Ratios

| Use Case             | Aspect Ratio | Reason                              |
|----------------------|--------------|-------------------------------------|
| Social media post    | 1:1          | Universal square format             |
| Story / vertical     | 9:16         | Instagram/TikTok stories            |
| Dashboard widget     | 4:3          | Fits dashboard grid                 |
| Banner stat          | 16:9         | Wide format, number centered        |
| Multi-stat strip     | 21:9         | Multiple numbers side by side       |

---

## Validation Checklist

Before delivering, verify:

- [ ] The number occupies 60-70% of the visual space
- [ ] Number typography is JetBrainsMono Nerd Font ExtraBold (or described as such)
- [ ] Number color follows brand pairing rules
- [ ] Unit/suffix is attached and appropriately sized (40-50% of number)
- [ ] Label is concise (1-5 words) and clearly explains the metric
- [ ] Background is Warm Cream (#F6F3EB) or Dark Grey Blue (#2C313A)
- [ ] Supporting illustration is present and occupies 20-30%
- [ ] Illustration does not compete with the number
- [ ] Illustration uses different color than the number
- [ ] Illustration style is hand-drawn with organic lines
- [ ] Card has rounded corners and subtle border
- [ ] All text is legible at the intended display size
- [ ] Number is formatted with appropriate shorthand and unit
- [ ] Aspect ratio is 1:1 unless specifically requested otherwise
- [ ] Overall impression: the number hits you first, then the illustration
- [ ] Output saved to ~/prj/art-skill/outputs/
- [ ] No voice notifications triggered

---

## Examples

### Example 1: User Growth Metric

- **Number**: 2.4M
- **Label**: Active Users
- **Context**: Up 34% from last quarter
- **Illustration**: Small crowd silhouette in Teal
- **Trend**: Upward arrow in Teal
- **Number color**: Coral (#D67056) on Cream
- **Aspect ratio**: 1:1

### Example 2: Performance Metric

- **Number**: 47ms
- **Label**: API Response Time
- **Context**: p95 latency, March 2026
- **Illustration**: Small lightning bolt in Muted Blue
- **Trend**: Downward arrow in Teal (lower is better)
- **Number color**: Teal (#70B8AD) on Cream
- **Aspect ratio**: 1:1

### Example 3: Reliability Metric

- **Number**: 99.97%
- **Label**: Uptime
- **Context**: Last 12 months
- **Illustration**: Small shield icon in Muted Blue
- **Number color**: Coral (#D67056) on Cream
- **Aspect ratio**: 1:1

### Example 4: Achievement Milestone

- **Number**: 1,000
- **Label**: Commits This Year
- **Illustration**: Small terminal window with code brackets in Teal
- **Number color**: Mustard Yellow (#EAB64D) on Dark Grey Blue (#2C313A)
- **Aspect ratio**: 1:1

### Example 5: Environmental Impact

- **Number**: 42%
- **Label**: Carbon Reduction
- **Context**: Year over year
- **Illustration**: Small sprouting plant in Teal
- **Trend**: Downward arrow in Teal (reduction is positive)
- **Number color**: Teal (#70B8AD) on Cream
- **Aspect ratio**: 1:1

---

## Multi-Stat Compositions

For presenting multiple related statistics together:

### Side-by-Side (21:9 or 16:9)
- 2-4 stat cards arranged horizontally
- Each card is a self-contained stat with its own number and illustration
- Use alternating brand colors (Coral, Teal, Mustard) for variety
- Consistent label positioning across all cards

### Grid Layout (1:1)
- 4 stats in a 2x2 grid within a single square card
- Each quadrant has one number and a tiny illustration
- Grid lines in Tan (#E6CCAB)
- Each number in a different brand accent color

### Stacked Vertical (9:16)
- 3-5 stats stacked vertically
- Each stat is a horizontal strip with number left, illustration right
- Alternating subtle background tones (Cream and Tan)
- Good for story-format social media

---

## Dark Mode Variant

For dark backgrounds, adjust the color system:

| Element              | Light Mode       | Dark Mode                    |
|----------------------|------------------|------------------------------|
| Background           | #F6F3EB (Cream)  | #2C313A (Dark Grey Blue)     |
| Number               | #D67056 (Coral)  | #D67056 (Coral) or white     |
| Label text           | #222222          | #F6F3EB (Cream)              |
| Context text         | #5D95C6          | #5D95C6 (Muted Blue)        |
| Illustration         | #70B8AD (Teal)   | #70B8AD (Teal) at 80%       |
| Card border          | #222222          | #E6CCAB (Tan) at 30%        |

Specify "dark mode" in the prompt when generating dark variant cards.
