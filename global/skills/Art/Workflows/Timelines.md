# Timelines - Chronological Progression Visuals

## Purpose

Generate timeline and chronological progression visuals including horizontal
timelines, vertical scrolls, era-based layouts, milestone markers, and progress
tracks. All outputs use the brand palette with a hand-drawn aesthetic on warm
cream canvas.

---

## When to Use

- The user asks for a **timeline**, **chronology**, **roadmap**, **history**,
  or **progression** visual.
- Requests involving dates, milestones, eras, or sequential phases.
- Project plans, historical overviews, or evolution diagrams.

---

## Brand Palette Reference

| Token            | Hex       | Usage                                  |
|------------------|-----------|----------------------------------------|
| Background       | `#F6F3EB` | Canvas fill                            |
| Coral (accent)   | `#D67056` | **Major milestones**, key events       |
| Teal             | `#70B8AD` | **Minor milestones**, secondary events |
| Tan / Sand       | `#E6CCAB` | Era/phase backgrounds, timeline spine  |
| Mustard Yellow   | `#EAB64D` | Current moment / "you are here"        |
| Muted Blue       | `#5D95C6` | Future / planned milestones            |
| Dark Grey Blue   | `#2C313A` | Timeline spine (heavy), borders        |
| Text             | `#222222` | All labels and descriptions            |

**Font:** JetBrainsMono Nerd Font.

---

## Layout Styles

### 1. Horizontal Timeline

- Left-to-right progression along a central spine.
- Spine: `#2C313A` hand-drawn line, 3 px, slight wobble.
- Milestone markers alternate above and below the spine.
- Major milestones: large circles filled `#D67056`.
- Minor milestones: smaller circles filled `#70B8AD`.
- Date labels below each marker in 16 px.
- Event descriptions in speech-bubble callouts.
- Best for: 5-12 events, short time spans.

### 2. Vertical Timeline

- Top-to-bottom progression.
- Spine: vertical `#2C313A` hand-drawn line, centered.
- Events alternate left and right of the spine.
- Connector lines from spine to event cards: `#E6CCAB`, dashed.
- Event cards: white/cream fill, `#2C313A` border, rounded corners.
- Major events have a Coral `#D67056` left-border accent.
- Minor events have a Teal `#70B8AD` left-border accent.
- Best for: 8-20 events, detailed descriptions.

### 3. Era / Phase Timeline

- Timeline divided into colored bands representing eras.
- Each era has a distinct light tint background:
  - Era 1: light Coral tint
  - Era 2: light Teal tint
  - Era 3: light Mustard tint
  - Era 4: light Muted Blue tint
- Milestones placed within their era band.
- Era labels: 28 px bold, centered in the band.
- Best for: historical periods, project phases, roadmaps.

### 4. Winding Road / Path Timeline

- A hand-drawn winding path from bottom-left to top-right.
- Path color: `#E6CCAB` with `#2C313A` edges.
- Milestone pins along the path (map-pin style).
- Major pins: Coral `#D67056`.
- Minor pins: Teal `#70B8AD`.
- "You are here" pin: Mustard `#EAB64D`.
- Best for: journey metaphors, roadmaps, career paths.

---

## Typography Hierarchy

| Tier       | Size   | Weight   | Color     | Use                          |
|------------|--------|----------|-----------|------------------------------|
| Title      | 44 px  | Bold     | `#222222` | Timeline title               |
| Era Label  | 28 px  | Bold     | `#2C313A` | Phase / era names            |
| Event      | 20 px  | SemiBold | `#222222` | Milestone titles             |
| Date       | 16 px  | Regular  | `#2C313A` | Date / year labels           |
| Detail     | 14 px  | Regular  | `#222222` | Event descriptions           |

All text uses **JetBrainsMono Nerd Font**.

---

## Milestone Marker Specification

### Major Milestone (Coral)
- Circle: 24 px diameter, fill `#D67056`, border `#2C313A` 2 px.
- Connected to event card with solid `#2C313A` line.
- Event card has Coral left-border accent (4 px).

### Minor Milestone (Teal)
- Circle: 16 px diameter, fill `#70B8AD`, border `#2C313A` 1.5 px.
- Connected to event card with dashed `#E6CCAB` line.
- Event card has Teal left-border accent (3 px).

### Current / Highlight (Mustard)
- Circle: 28 px diameter, fill `#EAB64D`, border `#2C313A` 2.5 px.
- Pulsing glow effect described in prompt.
- Label: "NOW" or "Current" in bold.

### Future / Planned (Muted Blue)
- Circle: 16 px diameter, fill `#5D95C6`, border dashed `#2C313A`.
- Event card has dashed border to indicate tentative.

---

## Prompt Template

```
A hand-drawn [horizontal | vertical | era-based | winding path] timeline
on warm cream (#F6F3EB) background. NO grid dots.
Excalidraw sketch aesthetic with slightly imperfect lines.

Topic: [TOPIC]
Time span: [START] to [END]

Major milestones (coral #D67056 markers):
- [DATE]: [EVENT]
- [DATE]: [EVENT]

Minor milestones (teal #70B8AD markers):
- [DATE]: [EVENT]
- [DATE]: [EVENT]

[Optional] Current moment (mustard #EAB64D marker): [DATE]
[Optional] Future/planned (muted blue #5D95C6, dashed): [DATE]: [EVENT]

[Optional] Eras/Phases:
- [ERA NAME] ([START]-[END]): light coral tint background
- [ERA NAME] ([START]-[END]): light teal tint background

Timeline spine: dark grey blue #2C313A, hand-drawn, 3px.
Connectors: sand #E6CCAB, dashed.
Event cards: white/cream fill, rounded corners, dark border.

Typography (JetBrainsMono Nerd Font):
- Title: 44px bold, top
- Event titles: 20px semibold
- Dates: 16px regular
- Details: 14px regular

Clean, minimal, hand-drawn feel. 2K resolution.
```

---

## Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio [ratio] \
  --output ~/prj/art-skill/outputs/timeline-[slug].png
```

- **Horizontal timeline:** `16:9` or `21:9` for many events.
- **Vertical timeline:** `9:16` or `3:4`.
- **Era-based:** `16:9`.
- **Winding path:** `3:4` or `1:1`.
- Available models: `gemini-flash`, `gemini-pro`, `gpt-image-1`.

---

## Step-by-Step Workflow

1. **Gather timeline data.** Ask the user:
   - What events / milestones to include?
   - Which are major vs. minor?
   - Any eras / phases to group events?
   - Preferred layout (horizontal, vertical, etc.)?
   - Is there a "current moment" to highlight?

2. **Choose layout.** Match event count and detail level to a layout style.

3. **Classify milestones.** Assign each event:
   - Major (Coral) or Minor (Teal).
   - Current (Mustard) or Future (Muted Blue) if applicable.

4. **Build the prompt.** Use the template above.

5. **Generate the image.**

6. **Validate** against the checklist below.

7. **Iterate** if needed.

---

## Examples

### Example 1 - History of AI

**Events:**
- 1950: Turing Test proposed (Major)
- 1956: Dartmouth Conference (Major)
- 1966: ELIZA chatbot (Minor)
- 1997: Deep Blue beats Kasparov (Major)
- 2011: Watson wins Jeopardy (Minor)
- 2012: AlexNet / Deep Learning revolution (Major)
- 2017: Transformer paper (Major)
- 2022: ChatGPT launch (Major)
- 2024: Multimodal AI mainstream (Minor)

**Command:**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "A hand-drawn horizontal timeline of AI history on warm cream (#F6F3EB). NO grid. Major milestones in coral #D67056: 1950 Turing Test, 1956 Dartmouth, 1997 Deep Blue, 2012 AlexNet, 2017 Transformer, 2022 ChatGPT. Minor milestones in teal #70B8AD: 1966 ELIZA, 2011 Watson, 2024 Multimodal AI. Eras: Foundations (1950-1970) light coral, AI Winters (1970-1990) light sand, Revival (1990-2012) light teal, Deep Learning (2012-present) light mustard. Timeline spine dark grey blue #2C313A. JetBrainsMono Nerd Font. 2K." \
  --size 2K \
  --aspect-ratio 21:9 \
  --output ~/prj/art-skill/outputs/timeline-ai-history.png
```

### Example 2 - Project Roadmap

**Events:**
- Q1 2026: Research & Discovery (Major)
- Q2 2026: MVP Development (Major)
- Q3 2026: Beta Launch (Minor)
- Q4 2026: Public Launch (Major)
- Q1 2027: Scale & Optimize (Future)

**Command:**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "A hand-drawn vertical timeline project roadmap on warm cream (#F6F3EB). NO grid. Winding path from top to bottom. Major milestones coral #D67056: Q1 Research, Q2 MVP, Q4 Launch. Minor milestone teal #70B8AD: Q3 Beta. Future milestone muted blue #5D95C6 dashed: Q1 2027 Scale. Current marker mustard #EAB64D at Q1 2026. JetBrainsMono Nerd Font. 2K." \
  --size 2K \
  --aspect-ratio 3:4 \
  --output ~/prj/art-skill/outputs/timeline-project-roadmap.png
```

### Example 3 - Career Path

A winding-road style timeline showing a developer's career progression from
junior to senior to lead, with technology milestones along the path.

---

## Validation Checklist

Before delivering the image, verify every item:

- [ ] **Background** is warm cream `#F6F3EB` with NO grid dots.
- [ ] **Major milestones** use Coral `#D67056` markers.
- [ ] **Minor milestones** use Teal `#70B8AD` markers.
- [ ] **Current moment** uses Mustard `#EAB64D` if applicable.
- [ ] **Future items** use Muted Blue `#5D95C6` with dashed style.
- [ ] **Timeline spine** is `#2C313A`, hand-drawn, visible.
- [ ] **Era/phase bands** are present if specified, with correct tints.
- [ ] **Chronological order** is correct (no events out of sequence).
- [ ] **All events** requested by the user are present.
- [ ] **Typography** follows the hierarchy (Title, Era, Event, Date, Detail).
- [ ] **Font** is JetBrainsMono Nerd Font (specified in prompt).
- [ ] **Date labels** are legible and correctly placed.
- [ ] **Layout direction** is consistent throughout.
- [ ] **Aspect ratio** matches the layout style.
- [ ] **Output path** is `~/prj/art-skill/outputs/timeline-[slug].png`.
- [ ] **Hand-drawn style** is visible (not rigid vector art).
- [ ] **No voice notification** is triggered.

---

## Troubleshooting

| Issue                           | Fix                                             |
|---------------------------------|-------------------------------------------------|
| Events overlap / crowd          | Reduce events or switch to wider aspect ratio   |
| Dates unreadable                | Increase date font size, reduce event count     |
| Era colors too strong           | Specify "very light tint, 10-15% opacity"       |
| Timeline direction confusing    | Add arrow at the end indicating direction        |
| Major/minor look the same       | Emphasize size difference (24px vs 16px circles) |
| Spine not visible               | Increase spine width to 4px in prompt           |

---

## Notes

- For timelines with more than 20 events, consider an era-based layout that
  groups events, or split into multiple images.
- Always confirm chronological accuracy with the user before generating.
- The winding road style works best for narrative / storytelling timelines.
- Horizontal timelines are the default if the user does not specify.
- Always save outputs to `~/prj/art-skill/outputs/` with the `timeline-` prefix.
