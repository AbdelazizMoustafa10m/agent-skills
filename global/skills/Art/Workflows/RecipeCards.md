# Recipe Cards -- Process Recipe Cards

> Generate illustrated process recipe cards with numbered steps, hand-drawn icons,
> and a scannable layout that makes any process feel approachable and actionable.

---

## When to Use

- Breaking down a multi-step process into clear sequential actions
- Creating quick-reference guides for workflows or procedures
- Making technical processes feel approachable and human
- Building instructional content with visual anchors per step
- Documenting playbooks, runbooks, or standard operating procedures

---

## Card Layout Structure

### Anatomy of a Recipe Card

```
+--------------------------------------------------+
|  [Title Banner -- Coral accent bar]               |
|  RECIPE: [Process Name]                           |
|  Subtitle / one-line description                  |
+--------------------------------------------------+
|                                                    |
|  PREP / PREREQUISITES                             |
|  - [Prerequisite 1]                               |
|  - [Prerequisite 2]                               |
|                                                    |
|  INGREDIENTS / INPUTS                             |
|  - [Input 1]     - [Input 3]                      |
|  - [Input 2]     - [Input 4]                      |
|                                                    |
+--------------------------------------------------+
|                                                    |
|  [1]  Step Title              [hand-drawn icon]   |
|       Brief instruction text                      |
|       ......................................       |
|  [2]  Step Title              [hand-drawn icon]   |
|       Brief instruction text                      |
|       ......................................       |
|  [3]  Step Title              [hand-drawn icon]   |
|       Brief instruction text                      |
|       ......................................       |
|  [4]  CRITICAL: Step Title    [hand-drawn icon]   |
|       Brief instruction text  (Coral highlight)   |
|       ......................................       |
|  [5]  Step Title              [hand-drawn icon]   |
|       Brief instruction text                      |
|                                                    |
+--------------------------------------------------+
|  OUTPUT / RESULT                                  |
|  [Description of the final outcome]               |
|  [Small illustration of the result]               |
+--------------------------------------------------+
|  TIPS & VARIATIONS                                |
|  - Tip 1        - Tip 2        - Tip 3            |
+--------------------------------------------------+
```

### Layout Principles

1. **Scannable in 10 seconds**: A reader should grasp the full process
   flow by scanning step numbers and titles alone.
2. **One action per step**: Each numbered step contains exactly one
   primary action. Never combine multiple actions.
3. **Visual anchors**: Every step has a hand-drawn icon on the right
   that visually represents the action.
4. **Progressive flow**: Steps flow top-to-bottom with clear separation.
5. **Critical callouts**: Important or outcome-defining steps get Coral
   highlighting and a "CRITICAL" tag.

---

## Brand Color Application

| Element              | Color              | Hex       | Usage                                |
|----------------------|--------------------|-----------|--------------------------------------|
| Card Background      | Warm Cream         | #F6F3EB   | Main card background                 |
| Title Bar            | Coral/Orange       | #D67056   | Top banner, accent strip             |
| Critical Steps       | Coral/Orange       | #D67056   | Step number circle, left border      |
| Regular Steps        | Teal               | #70B8AD   | Step number circle for normal steps  |
| Step Separators      | Tan/Sand           | #E6CCAB   | Dotted lines between steps           |
| Callout Boxes        | Mustard Yellow     | #EAB64D   | Tips, warnings, pro-tips             |
| Body Text            | Dark Charcoal      | #222222   | All instruction text                 |
| Info / Notes         | Muted Blue         | #5D95C6   | Prerequisites, optional notes        |
| Card Border/Shadow   | Dark Grey Blue     | #2C313A   | Outer card border, drop shadow       |

### Step Number Styling

- **Regular steps**: Teal (#70B8AD) filled circle with white number
- **Critical/outcome steps**: Coral (#D67056) filled circle with white number
- **Optional steps**: Muted Blue (#5D95C6) filled circle, dashed border

---

## Hand-Drawn Icons Per Step

Each step must have a small hand-drawn icon (roughly 40x40px equivalent)
that visually represents the action. Icons should be:

- **Simple**: 3-5 strokes maximum, instantly recognizable
- **Consistent style**: Same line weight and wobble as the overall card
- **Brand-colored**: Icon strokes use the same color as the step number
- **Positioned right**: Aligned to the right margin of each step row

### Common Icon Library

| Action Type       | Icon Description                                    |
|-------------------|-----------------------------------------------------|
| Start / Begin     | Play triangle or flag                               |
| Click / Select    | Mouse cursor with click ripple                      |
| Type / Enter      | Keyboard or text cursor                             |
| Upload / Import   | Upward arrow into box                               |
| Download / Export  | Downward arrow from box                             |
| Configure         | Gear/cog wheel                                      |
| Review / Check    | Magnifying glass or eye                             |
| Approve / Confirm | Checkmark in circle                                 |
| Wait / Pause      | Hourglass or clock                                  |
| Connect / Link    | Chain link or plug                                  |
| Transform         | Arrows forming a cycle                              |
| Deploy / Ship     | Rocket or paper airplane                            |
| Test / Verify     | Flask or beaker                                     |
| Document / Write  | Pencil on paper                                     |
| Communicate       | Speech bubble or envelope                           |
| Delete / Remove   | Trash can or X mark                                 |
| Secure / Lock     | Padlock                                             |
| Celebrate         | Star burst or confetti                              |

---

## Typography System

All text uses JetBrainsMono Nerd Font:

### Tier 1 -- Recipe Title
- ExtraBold weight
- Largest size, inside the Coral title banner
- Color: White on Coral, or Dark Charcoal on light backgrounds

### Tier 2 -- Step Titles
- Bold weight
- Medium size, on the same line as the step number
- Color: Dark Charcoal (#222222)

### Tier 3 -- Instruction Text
- Regular weight
- Standard body size, below each step title
- Color: Dark Charcoal (#222222) at 85% opacity

### Tier 4 -- Section Headers & Notes
- Medium weight
- Smaller than step titles, used for PREP, INGREDIENTS, TIPS headers
- Color: Muted Blue (#5D95C6) for headers, Dark Charcoal for notes

---

## Prompt Template

```
A hand-drawn process recipe card illustration on a warm cream (#F6F3EB) background
with a subtle paper texture, styled like a vintage recipe card.

Recipe title: [PROCESS NAME]
Subtitle: [One-line description of what this process achieves]

Prerequisites:
- [Prerequisite 1]
- [Prerequisite 2]

Inputs/Ingredients:
- [Input 1]
- [Input 2]

Steps (numbered, each with a small hand-drawn icon on the right):
1. [Step Title]: [Brief instruction] -- Icon: [icon description]
2. [Step Title]: [Brief instruction] -- Icon: [icon description]
3. [Step Title]: [Brief instruction] -- Icon: [icon description]
4. CRITICAL - [Step Title]: [Brief instruction] -- Icon: [icon description]
   (This step highlighted with Coral #D67056 accent)
5. [Step Title]: [Brief instruction] -- Icon: [icon description]

Output/Result: [Description of the final outcome]

Tips:
- [Tip 1]
- [Tip 2]

Visual style: Vintage recipe card aesthetic with hand-drawn elements. Slightly wobbly
borders, sketchy icons, warm and inviting. The card has a Dark Grey Blue (#2C313A)
outer border with soft drop shadow.

Color coding:
- Title banner: Coral (#D67056) horizontal bar at top
- Critical step numbers: Coral (#D67056) filled circles
- Regular step numbers: Teal (#70B8AD) filled circles
- Step separators: Tan (#E6CCAB) dotted lines
- Tips section: Mustard Yellow (#EAB64D) background
- All text: Dark Charcoal (#222222)
- Prerequisites/notes: Muted Blue (#5D95C6) text

Typography (JetBrainsMono Nerd Font):
- Title: ExtraBold, white on Coral banner
- Step titles: Bold, medium
- Instructions: Regular, standard body
- Section headers: Medium, Muted Blue

Hand-drawn icons are simple (3-5 strokes), positioned right-aligned per step,
using the same color as their step number circle.
```

---

## Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio 3:4 \
  --output ~/prj/art-skill/outputs/[name].png
```

### Recommended Aspect Ratios

| Card Type            | Aspect Ratio | Reason                              |
|----------------------|--------------|-------------------------------------|
| Short process (3-5)  | 4:3          | Compact, fits standard frames       |
| Medium process (5-8) | 3:4          | Vertical space for more steps       |
| Long process (8-12)  | 9:16         | Full vertical layout                |
| Side-by-side compare | 16:9         | Two recipe cards next to each other |
| Social media card    | 1:1          | Square format for sharing           |

---

## Validation Checklist

Before delivering, verify:

- [ ] Card background is Warm Cream (#F6F3EB) with paper texture
- [ ] Coral (#D67056) title banner is present at the top
- [ ] Each step has a unique number in a colored circle
- [ ] Critical/outcome steps use Coral (#D67056) highlighting
- [ ] Regular steps use Teal (#70B8AD) numbering
- [ ] Each step has exactly one primary action
- [ ] Every step has a hand-drawn icon on the right
- [ ] Icons are simple (3-5 strokes) and recognizable
- [ ] Step separators (dotted lines) use Tan (#E6CCAB)
- [ ] Prerequisites section is present (even if brief)
- [ ] Output/Result section describes the final outcome
- [ ] Tips section provides useful variations or warnings
- [ ] Typography follows the 4-tier hierarchy
- [ ] All text is legible against its background
- [ ] Card has Dark Grey Blue (#2C313A) outer border with shadow
- [ ] Total steps are between 3 and 12 (split into multiple cards if more)
- [ ] Process is scannable by reading step titles alone
- [ ] Output saved to ~/prj/art-skill/outputs/
- [ ] No voice notifications triggered

---

## Examples

### Example 1: Deploy to Production

**Steps:**
1. **Pull latest** -- Fetch and merge main branch -- Icon: down arrow
2. **Run tests** -- Execute full test suite locally -- Icon: flask
3. **Build artifact** -- Create production build -- Icon: package box
4. CRITICAL - **Review diff** -- Check all changes against staging -- Icon: magnifying glass
5. **Deploy** -- Push to production environment -- Icon: rocket
6. CRITICAL - **Verify** -- Confirm health checks pass -- Icon: checkmark

### Example 2: Design Review Process

**Steps:**
1. **Share designs** -- Post mockups in review channel -- Icon: speech bubble
2. **Collect feedback** -- Wait 24h for team input -- Icon: hourglass
3. **Categorize notes** -- Group feedback by theme -- Icon: folder
4. CRITICAL - **Prioritize** -- Rank changes by impact -- Icon: star
5. **Revise designs** -- Apply top-priority changes -- Icon: pencil
6. **Final check** -- Quick sync with stakeholders -- Icon: eye
7. **Approve** -- Mark designs as ready -- Icon: checkmark in circle

### Example 3: Incident Response Runbook

**Steps:**
1. CRITICAL - **Acknowledge** -- Claim the incident within 5 min -- Icon: bell
2. **Assess severity** -- Determine impact level (P1-P4) -- Icon: gauge
3. **Communicate** -- Post status in incident channel -- Icon: megaphone
4. **Investigate** -- Check logs, metrics, recent deploys -- Icon: magnifying glass
5. CRITICAL - **Mitigate** -- Apply fix or rollback -- Icon: wrench
6. **Verify resolution** -- Confirm services healthy -- Icon: heartbeat
7. **Post-mortem** -- Schedule review within 48h -- Icon: document

---

## Multi-Card Series

For processes with more than 12 steps, split into a series of cards:

1. **Card 1: Preparation** -- Steps 1-4 (setup and prerequisites)
2. **Card 2: Execution** -- Steps 5-8 (core actions)
3. **Card 3: Verification** -- Steps 9-12 (checks and completion)

Each card in a series should:
- Share the same title with a part number (e.g., "Deploy -- Part 1 of 3")
- Have a "Continued from..." note at the top referencing the previous card
- Have a "Continues in..." note at the bottom referencing the next card
- Maintain consistent visual style across all cards in the series
