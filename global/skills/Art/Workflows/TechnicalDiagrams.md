# Technical Diagrams - Excalidraw-Style System Visuals

## Purpose

Generate clean, hand-drawn-style technical diagrams including system architectures,
process flows, data pipelines, network topologies, and component diagrams. The
aesthetic follows Excalidraw conventions: slightly imperfect lines on a clean
warm cream canvas with NO background grid.

---

## When to Use

- The user asks for a **system architecture**, **flow chart**, **pipeline**,
  **sequence diagram**, or **network diagram**.
- Any request involving boxes, arrows, and labeled connections.
- Technical documentation visuals.

---

## Brand Palette Reference

| Token            | Hex       | Usage                                    |
|------------------|-----------|------------------------------------------|
| Background       | `#F6F3EB` | Canvas fill - absolutely NO grid dots    |
| Coral (accent)   | `#D67056` | Key components, primary nodes, alerts    |
| Teal             | `#70B8AD` | Flow arrows, data paths, connections     |
| Tan / Sand       | `#E6CCAB` | Secondary containers, group backgrounds  |
| Mustard Yellow   | `#EAB64D` | Warnings, decision nodes, highlights     |
| Muted Blue       | `#5D95C6` | Databases, storage, external services    |
| Dark Grey Blue   | `#2C313A` | Primary borders, heavy connectors        |
| Text             | `#222222` | All labels and annotations               |

**Font:** JetBrainsMono Nerd Font (monospace, all text).

---

## Core Design Principles

1. **Clean Excalidraw aesthetic.** Lines are slightly wobbly, corners slightly
   rounded, fills use cross-hatch or solid pastels. Nothing photorealistic.

2. **NO background grid.** The canvas is a flat `#F6F3EB` warm cream. No dots,
   no graph paper, no ruled lines.

3. **White / cream primary.** Most shapes have `#F6F3EB` or white fills.
   Color is used **strategically** - only for elements that need emphasis.

4. **Sparse color accents.** A diagram with 20 boxes should have 2-4 colored
   ones. The rest are white/cream with `#2C313A` borders.

5. **Readable at a glance.** Labels are large enough to read without zooming.

---

## Typography Hierarchy

| Tier       | Size   | Weight   | Color     | Use                          |
|------------|--------|----------|-----------|------------------------------|
| Title      | 44 px  | Bold     | `#222222` | Diagram title (top)          |
| Component  | 24 px  | SemiBold | `#222222` | Box / node labels            |
| Annotation | 16 px  | Regular  | `#222222` | Arrow labels, notes, ports   |
| Caption    | 14 px  | Light    | `#2C313A` | Footnotes, version info      |

All text uses **JetBrainsMono Nerd Font**.

---

## Color Application Rules

### Nodes / Boxes

| Element Type          | Fill        | Border      | Text      |
|-----------------------|-------------|-------------|-----------|
| Primary / key service | `#D67056`   | `#2C313A`   | `#FFFFFF` |
| Secondary service     | `#F6F3EB`   | `#2C313A`   | `#222222` |
| Database / storage    | `#5D95C6`   | `#2C313A`   | `#FFFFFF` |
| External service      | `#E6CCAB`   | `#2C313A`   | `#222222` |
| Decision / gateway    | `#EAB64D`   | `#2C313A`   | `#222222` |
| Error / alert         | `#D67056`   | `#D67056`   | `#FFFFFF` |

### Arrows / Connectors

| Flow Type             | Color       | Style              |
|-----------------------|-------------|--------------------|
| Primary data flow     | `#70B8AD`   | Solid, 2 px        |
| Secondary flow        | `#E6CCAB`   | Dashed, 2 px       |
| Error / fallback path | `#D67056`   | Dotted, 2 px       |
| Bidirectional         | `#2C313A`   | Solid, double-head  |

---

## Diagram Type Templates

### System Architecture

```
A clean Excalidraw-style system architecture diagram on warm cream (#F6F3EB).
NO background grid or dots. Hand-drawn slightly imperfect lines.

System: [SYSTEM NAME]
Components: [LIST COMPONENTS]

Layout: [left-to-right | top-to-bottom | layered]

Key services (coral #D67056 fill): [PRIMARY COMPONENTS]
Data stores (muted blue #5D95C6 fill): [DATABASES]
External services (sand #E6CCAB fill): [EXTERNAL]
All other boxes: white/cream fill with dark grey blue (#2C313A) borders.

Flow arrows: teal #70B8AD, hand-drawn, slightly curved.
Arrow labels in 16px JetBrainsMono Nerd Font, dark charcoal #222222.

Title: "[TITLE]" in 44px bold at the top.
Component labels: 24px semibold inside each box.

Clean, minimal, professional. No photographic elements.
2K resolution.
```

### Process Flow / Flowchart

```
A clean Excalidraw-style flowchart on warm cream (#F6F3EB).
NO background grid. Hand-drawn sketch aesthetic.

Process: [PROCESS NAME]
Steps: [LIST STEPS]

Start/End nodes: rounded rectangles, coral #D67056 fill.
Process steps: rectangles, white/cream fill, #2C313A border.
Decision diamonds: mustard yellow #EAB64D fill.
Flow arrows: teal #70B8AD, hand-drawn.

Labels: JetBrainsMono Nerd Font, 24px for steps, 16px for conditions.
Title: "[TITLE]" at top, 44px bold.

Top-to-bottom layout. Clean and readable. 2K resolution.
```

### Data Pipeline

```
A clean Excalidraw-style data pipeline diagram on warm cream (#F6F3EB).
NO grid. Hand-drawn lines with slight imperfections.

Pipeline: [PIPELINE NAME]
Stages: [INGESTION] -> [PROCESSING] -> [STORAGE] -> [SERVING]

Left-to-right horizontal flow.
Stage boxes: white/cream with #2C313A borders.
Key stage (the bottleneck or main transform): coral #D67056 fill.
Data stores: muted blue #5D95C6 rounded rectangles.
Arrows: thick teal #70B8AD lines with arrowheads.
Data format labels on arrows in 16px.

Title at top, 44px bold. Stage labels 24px semibold.
JetBrainsMono Nerd Font throughout. 2K resolution.
```

---

## Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio [ratio] \
  --output ~/prj/art-skill/outputs/diagram-[slug].png
```

- **System architectures:** `16:9` (wide landscape).
- **Flowcharts:** `3:4` or `9:16` (tall portrait).
- **Pipelines:** `16:9` (wide horizontal flow).
- **Sequence diagrams:** `9:16` (tall vertical).
- Available models: `gemini-flash`, `gemini-pro`, `gpt-image-1`.

---

## Step-by-Step Workflow

1. **Understand the system.** Ask the user:
   - What components / services are involved?
   - What are the primary data flows?
   - Which component is the "star" (gets Coral highlight)?
   - Preferred layout direction?

2. **Choose diagram type.** Match to the closest template above.

3. **Apply color rules.** Follow the node/arrow color tables strictly.
   Most boxes should be white/cream - color only the important ones.

4. **Build the prompt.** Use the matching template, fill placeholders.

5. **Generate the image.**

6. **Validate** against the checklist below.

7. **Iterate** if needed. Common fix: emphasize "NO grid" if grid appears.

---

## Grouping and Containers

When a diagram has logical groups (e.g., "Frontend", "Backend", "Infrastructure"):

- Draw a large rounded rectangle around each group.
- Group fill: `#E6CCAB` at 10-15% opacity (very light sand).
- Group border: `#E6CCAB` dashed, 1.5 px.
- Group label: top-left corner, 20 px semibold, `#2C313A`.
- Components inside the group keep their individual styling.

---

## Examples

### Example 1 - Microservice Architecture

**Prompt excerpt:**
```
A clean Excalidraw-style microservice architecture on warm cream (#F6F3EB).
NO background grid. Components: API Gateway (coral #D67056), Auth Service,
User Service, Order Service, PostgreSQL (muted blue #5D95C6),
Redis Cache (muted blue #5D95C6), Message Queue.
Flow arrows in teal #70B8AD. Hand-drawn style. 16:9 landscape.
```

**Command:**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "A clean Excalidraw-style microservice architecture..." \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/diagram-microservice-arch.png
```

### Example 2 - CI/CD Pipeline

**Prompt excerpt:**
```
A clean Excalidraw-style CI/CD pipeline diagram on warm cream (#F6F3EB).
NO grid. Left-to-right flow: Code Push -> Build -> Test -> Stage -> Deploy.
Build stage highlighted in coral #D67056. Arrows in teal #70B8AD.
Decision diamond for "Tests Pass?" in mustard #EAB64D.
```

**Command:**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "A clean Excalidraw-style CI/CD pipeline diagram..." \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/diagram-cicd-pipeline.png
```

---

## Validation Checklist

Before delivering the image, verify every item:

- [ ] **Background** is flat warm cream `#F6F3EB` - absolutely NO grid dots.
- [ ] **Style** is Excalidraw / hand-drawn sketch, NOT rigid vector art.
- [ ] **Key components** use Coral `#D67056` fill.
- [ ] **Flow arrows** use Teal `#70B8AD`.
- [ ] **Most boxes** are white/cream - color is used sparingly.
- [ ] **Data stores** use Muted Blue `#5D95C6` if present.
- [ ] **Decision nodes** use Mustard Yellow `#EAB64D` if present.
- [ ] **Typography** follows the 4-tier hierarchy.
- [ ] **Font** is JetBrainsMono Nerd Font (specified in prompt).
- [ ] **Labels** are legible at output resolution.
- [ ] **Arrow labels** describe the data or action flowing.
- [ ] **Layout direction** is consistent (no random arrow directions).
- [ ] **Aspect ratio** matches the diagram type.
- [ ] **Output path** is `~/prj/art-skill/outputs/diagram-[slug].png`.
- [ ] **No photographic** elements are present.
- [ ] **No voice notification** is triggered.

---

## Troubleshooting

| Issue                          | Fix                                             |
|--------------------------------|-------------------------------------------------|
| Background grid appears        | Add "NO grid, NO dots, flat background" twice   |
| Lines too perfect / rigid      | Emphasize "hand-drawn, Excalidraw, sketch"      |
| Too many colored boxes         | Reduce to 2-3 colored, rest white/cream          |
| Text unreadable                | Increase font size in prompt, reduce components  |
| Arrows overlap / tangle        | Simplify layout or switch to layered arrangement |
| Wrong layout direction         | Explicitly state "left-to-right" or "top-down"   |

---

## Notes

- For diagrams with more than 15 components, consider splitting into
  sub-diagrams or using a layered architecture view.
- If the user provides a text-based diagram (ASCII, Mermaid, PlantUML),
  translate it faithfully into the Excalidraw visual style.
- Always save outputs to `~/prj/art-skill/outputs/` with the `diagram-` prefix.
- The Excalidraw aesthetic is the defining trait of this workflow. If the
  output looks like a polished vector diagram, regenerate with stronger
  sketch-style language in the prompt.
