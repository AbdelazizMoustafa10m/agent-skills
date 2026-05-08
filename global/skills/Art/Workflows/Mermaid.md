# Mermaid -- Technical Diagrams with Excalidraw Aesthetic

> Generate Mermaid-style technical diagrams rendered in a hand-drawn Excalidraw
> whiteboard aesthetic. Supports flowcharts, sequence diagrams, state machines,
> class diagrams, ER diagrams, Gantt charts, and git graphs.

---

## When to Use

- Visualizing system architecture, data flows, or process logic
- Creating technical documentation diagrams with visual warmth
- Explaining complex sequences or state transitions
- Documenting entity relationships or class hierarchies
- Illustrating project timelines or git branching strategies
- Any scenario where a Mermaid diagram would be appropriate but you want
  it to look hand-crafted rather than sterile

---

## Supported Diagram Types

### Flowcharts
- Process flows, decision trees, algorithm visualization
- Nodes: rectangles, rounded rectangles, diamonds, circles, parallelograms
- Connections: arrows, dotted lines, thick lines
- Subgraphs for grouping related nodes
- **Recommended aspect ratio: 16:9 (horizontal) or 9:16 (vertical)**

### Sequence Diagrams
- Actor-to-actor communication over time
- Messages: synchronous, asynchronous, return
- Activation boxes, loops, alternatives, notes
- Participant ordering left-to-right
- **Recommended aspect ratio: 9:16 or 3:4 (vertical flow)**

### State Diagrams
- States, transitions, guards, actions
- Start/end markers, composite states, forks/joins
- History states, choice pseudostates
- **Recommended aspect ratio: 16:9 or 1:1**

### Class Diagrams
- Classes with attributes and methods
- Relationships: inheritance, composition, aggregation, association
- Visibility markers, stereotypes
- **Recommended aspect ratio: 4:3 or 1:1**

### ER (Entity Relationship) Diagrams
- Entities with attributes
- Relationships with cardinality (one-to-one, one-to-many, many-to-many)
- Primary keys, foreign keys highlighted
- **Recommended aspect ratio: 16:9 or 4:3**

### Gantt Charts
- Tasks with start dates, durations, dependencies
- Milestones, sections, active/done/critical status
- Timeline axis
- **Recommended aspect ratio: 16:9 or 21:9 (wide)**

### Git Graphs
- Branches, commits, merges, cherry-picks
- Branch labels, commit messages
- Main/feature/release branch patterns
- **Recommended aspect ratio: 16:9**

---

## Excalidraw Hand-Drawn Style

The defining characteristic of these diagrams is the Excalidraw whiteboard
aesthetic. Every element should feel hand-drawn:

### Shape Treatment
- **Wobbly borders**: Rectangle and circle edges have subtle hand-tremor wobble
- **Sketchy lines**: Connector lines are slightly imperfect, not laser-straight
- **Rounded corners**: All sharp corners softened, feels friendly
- **Imperfect fills**: Color fills have slight variation, like marker on paper
- **Double-stroke effect**: Some borders appear as if drawn twice, slightly offset

### Arrow Treatment
- **Sketchy arrows**: Arrow lines have gentle curves and wobble
- **Hand-drawn arrowheads**: Slightly asymmetric, organic arrowheads
- **Varied line weight**: Subtle thickness variation along arrow paths
- **Dotted lines**: Uneven dot spacing, like hand-stamped dots

### Shadow and Depth
- **Soft shadows**: Very subtle, warm-toned shadows beneath shapes
- **No harsh borders**: Edges blend slightly with background
- **Layered feel**: Shapes appear to sit on top of each other naturally

---

## Built-In Content Analysis

### 24-Point Narrative Analysis

Before generating any diagram, analyze the source content using this framework.
This analysis is performed internally -- no external tools or CSE required.

1. **Primary entities**: What are the main actors/components?
2. **Relationships**: How do entities connect or depend on each other?
3. **Flow direction**: Is there a natural sequence or hierarchy?
4. **Decision points**: Where do paths diverge?
5. **Loops/cycles**: Are there recurring patterns or feedback loops?
6. **Entry points**: Where does the process/system begin?
7. **Exit points**: Where does it end or output?
8. **Critical path**: What is the most important flow?
9. **Error paths**: What happens when things go wrong?
10. **Parallel paths**: What can happen simultaneously?
11. **Dependencies**: What must happen before what?
12. **Data transformations**: Where does data change form?
13. **External interfaces**: What connects to outside systems?
14. **State changes**: Where do entities change status?
15. **Aggregation points**: Where do multiple paths converge?
16. **Bottlenecks**: Where are potential constraints?
17. **Feedback mechanisms**: Where does output influence input?
18. **Hierarchy levels**: How many layers of abstraction exist?
19. **Cardinality**: One-to-one, one-to-many, or many-to-many?
20. **Temporal ordering**: What is the time sequence?
21. **Conditional logic**: What conditions gate transitions?
22. **Resource flow**: What resources move through the system?
23. **Boundary crossings**: Where do things cross domain boundaries?
24. **Symmetry/asymmetry**: Are relationships balanced or directional?

Use this analysis to determine optimal diagram type, layout, and emphasis.

---

## Brand Color System

| Role                 | Color              | Hex       | Diagram Usage                        |
|----------------------|--------------------|-----------|--------------------------------------|
| Background           | Warm Cream         | #F6F3EB   | Canvas background                    |
| Critical Path        | Coral/Orange       | #D67056   | Critical nodes, primary flow arrows  |
| Secondary Flow       | Teal               | #70B8AD   | Secondary paths, optional flows      |
| Neutral Elements     | Tan/Sand           | #E6CCAB   | Default node fill, backgrounds       |
| Warning / Highlight  | Mustard Yellow     | #EAB64D   | Decision diamonds, important notes   |
| Text / Lines         | Dark Charcoal      | #222222   | All text, default connector lines    |
| Info / Data          | Muted Blue         | #5D95C6   | Data stores, external systems, notes |
| Dark Sections        | Dark Grey Blue     | #2C313A   | Subgraph backgrounds, dark nodes     |

### Color Application Rules

1. **Critical path nodes and arrows**: Coral (#D67056) fill or stroke
2. **Secondary/alternative paths**: Teal (#70B8AD) fill or stroke
3. **Decision nodes**: Mustard Yellow (#EAB64D) fill with Dark Charcoal border
4. **Default nodes**: Tan (#E6CCAB) fill with Dark Charcoal border
5. **Data stores / databases**: Muted Blue (#5D95C6) fill
6. **External systems**: Dark Grey Blue (#2C313A) fill with white text
7. **Error paths**: Coral (#D67056) with dashed lines
8. **Notes / annotations**: Light Mustard Yellow background

---

## 4-Tier Typography Hierarchy

All text uses JetBrainsMono Nerd Font:

### Tier 1 -- Diagram Title
- ExtraBold weight, largest size
- Positioned above the diagram
- Color: Dark Charcoal (#222222)

### Tier 2 -- Node Labels
- Bold weight, medium size
- Centered inside nodes/shapes
- Color: Dark Charcoal (#222222) or white on dark fills

### Tier 3 -- Edge Labels / Annotations
- Medium weight, smaller size
- Positioned along arrows or in note boxes
- Color: Dark Charcoal (#222222) at 80% opacity

### Tier 4 -- Fine Details
- Regular weight, smallest size
- For cardinality markers, timestamps, attribute lists
- Color: Muted Blue (#5D95C6) or Dark Charcoal at 60% opacity

---

## Prompt Template

```
A hand-drawn technical diagram in the Excalidraw whiteboard aesthetic on a warm cream
(#F6F3EB) background with subtle paper texture.

Diagram type: [flowchart | sequence | state | class | ER | gantt | git graph]
Topic: [SYSTEM/PROCESS DESCRIPTION]

Elements:
- [NODE/ENTITY 1]: [Name] -- [Description, type (rectangle/diamond/circle)]
- [NODE/ENTITY 2]: [Name] -- [Description, type]
- [NODE/ENTITY 3]: [Name] -- [Description, type]
- [Additional nodes as needed]

Connections:
- [NODE A] --[label]--> [NODE B]: [Description of relationship]
- [NODE B] --[label]--> [NODE C]: [Description of relationship]
- [Additional connections as needed]

Critical path: [List the nodes/edges that form the critical path]
Secondary flows: [List alternative or optional paths]

Visual style: Excalidraw hand-drawn whiteboard aesthetic. Wobbly shape borders,
sketchy slightly-curved arrows, imperfect color fills like marker on paper.
Double-stroke effect on some borders. Shapes feel hand-drawn, not mechanical.

Color mapping:
- Critical path nodes/arrows: Coral (#D67056)
- Secondary flow nodes/arrows: Teal (#70B8AD)
- Decision points: Mustard Yellow (#EAB64D) fill
- Default nodes: Tan (#E6CCAB) fill
- Data stores: Muted Blue (#5D95C6) fill
- External systems: Dark Grey Blue (#2C313A) fill, white text
- All text and default lines: Dark Charcoal (#222222)

Typography (JetBrainsMono Nerd Font):
- Title: ExtraBold, large, above diagram
- Node labels: Bold, medium, centered in shapes
- Edge labels: Medium, small, along arrows
- Fine details: Regular, smallest, for metadata

Subtle warm-toned shadows beneath shapes. No harsh mechanical lines anywhere.
```

---

## Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio [ratio] \
  --output ~/prj/art-skill/outputs/[name].png
```

Refer to the aspect ratio guidance under each diagram type above.

---

## Validation Checklist

Before delivering, verify:

- [ ] Diagram type is appropriate for the content (per 24-point analysis)
- [ ] Background is Warm Cream (#F6F3EB) with subtle texture
- [ ] Excalidraw hand-drawn aesthetic is consistent throughout
- [ ] All shapes have wobbly borders (no rigid mechanical shapes)
- [ ] Arrows are sketchy and slightly curved
- [ ] Coral (#D67056) marks the critical path only
- [ ] Teal (#70B8AD) marks secondary flows
- [ ] Decision points use Mustard Yellow (#EAB64D)
- [ ] Color application follows the documented rules
- [ ] Typography follows the 4-tier hierarchy
- [ ] All node labels and edge labels are legible
- [ ] Diagram flows in a clear direction (top-to-bottom or left-to-right)
- [ ] No more than 15-20 nodes to prevent overwhelming complexity
- [ ] Aspect ratio matches the diagram type recommendation
- [ ] Critical path is visually dominant
- [ ] External systems and data stores are visually distinct
- [ ] Soft shadows present, no harsh borders
- [ ] Output saved to ~/prj/art-skill/outputs/
- [ ] No voice notifications triggered

---

## Examples

### Example 1: Authentication Flowchart

**Type:** Flowchart (16:9)
**Critical path:** User -> Login Form -> Validate -> Success -> Dashboard
**Secondary:** Validate -> Failure -> Error Message -> Login Form
**Decision:** "Valid credentials?" in Mustard Yellow diamond
**External:** "Auth Provider" in Dark Grey Blue
**Data store:** "User DB" in Muted Blue cylinder

### Example 2: API Request Sequence

**Type:** Sequence Diagram (9:16)
**Participants:** Client, API Gateway, Auth Service, Backend, Database
**Critical messages (Coral):** Client->Gateway, Gateway->Backend, Backend->Database
**Secondary (Teal):** Gateway->Auth (validation side-channel)
**Notes:** Rate limiting note in Mustard Yellow

### Example 3: Order State Machine

**Type:** State Diagram (16:9)
**States:** Created, Confirmed, Processing, Shipped, Delivered, Cancelled
**Critical path (Coral):** Created -> Confirmed -> Processing -> Shipped -> Delivered
**Error path (Coral dashed):** Any -> Cancelled
**Transitions:** Payment received, Items picked, Carrier accepted, Proof of delivery

### Example 4: Microservices ER Diagram

**Type:** ER Diagram (16:9)
**Entities:** User, Order, Product, Payment, Shipping
**Relationships:** User 1--* Order, Order *--* Product, Order 1--1 Payment
**Primary keys:** Coral highlighted
**Foreign keys:** Teal highlighted

---

## Advanced Techniques

### Subgraph Grouping
When a diagram has logical sections, use subtle background rectangles with
rounded corners and light Tan (#E6CCAB) fill to group related nodes.
Label each group with Tier 3 typography.

### Layered Complexity
For complex systems, consider generating multiple diagrams at different
zoom levels:
1. **Overview**: High-level with major components only (5-8 nodes)
2. **Detail**: Zoomed into one section with full detail (10-15 nodes)
3. **Interaction**: Sequence diagram showing runtime behavior

### Annotation Callouts
Use small speech-bubble or note shapes in Mustard Yellow to add
explanatory annotations. Position them near the relevant element
without overlapping connectors.
