# Maps -- Conceptual Maps and Landscapes

> Generate illustrated cartographic maps that represent abstract territories,
> concept spaces, and knowledge domains as physical landscapes with brand colors.

---

## When to Use

- Mapping an abstract domain or knowledge area as explorable territory
- Showing relationships between concepts as geographic proximity
- Illustrating a journey or progression through a conceptual space
- Visualizing ecosystems, communities, or interconnected domains
- Making complex topic landscapes feel tangible and navigable

---

## Cartographic Metaphors

### Islands and Archipelagos
- Each island = a distinct concept, skill, or domain
- Island size reflects importance or scope
- Proximity between islands = conceptual relatedness
- Bridges or shipping routes = direct connections
- Surrounding sea = the unknown or unexplored

### Continents and Regions
- Large landmasses divided into named regions
- Mountain ranges = barriers or difficulty gradients
- Rivers = flows of information, resources, or dependencies
- Cities/towns = specific tools, practices, or milestones
- Roads and paths = common learning routes or workflows

### Rivers and Waterways
- River source = origin of an idea or process
- Tributaries = contributing factors or inputs
- River mouth / delta = outcomes or outputs
- Rapids = challenging transitions
- Calm stretches = stable, well-understood areas

### Mountains and Elevation
- Peaks = mastery, achievement, or high-value goals
- Foothills = prerequisites or early learning
- Valleys = rest points, consolidation phases
- Passes = shortcuts or key transitions
- Altitude = difficulty or abstraction level

### Forests and Vegetation
- Dense forest = complex, rich areas requiring deep exploration
- Clearings = well-documented, accessible areas
- Individual trees = specific concepts or resources
- Paths through forest = guided learning or documented processes

---

## Brand Color Territories

| Territory Type       | Color                | Hex       | Usage                                |
|----------------------|----------------------|-----------|--------------------------------------|
| Background / Sea     | Warm Cream           | #F6F3EB   | Ocean, empty space, parchment        |
| Primary Territory    | Coral/Orange         | #D67056   | Core concepts, main islands, capitals|
| Secondary Territory  | Teal                 | #70B8AD   | Supporting areas, secondary islands  |
| Neutral Land         | Tan/Sand             | #E6CCAB   | General terrain, beaches, plains     |
| Highlighted Feature  | Mustard Yellow       | #EAB64D   | Treasure markers, key landmarks      |
| Text / Borders       | Dark Charcoal        | #222222   | Labels, coastlines, borders          |
| Water Features       | Muted Blue           | #5D95C6   | Rivers, lakes, sea details           |
| Deep Zones           | Dark Grey Blue       | #2C313A   | Unexplored areas, deep ocean         |

---

## Cartographic Elements

### Required Elements
1. **Title Cartouche**: Ornate hand-drawn border containing the map title,
   positioned top-center or top-left. JetBrainsMono Nerd Font ExtraBold.
2. **Compass Rose**: Small decorative compass in a corner, using Coral and
   Dark Charcoal. Can be thematic (e.g., pointing toward "Mastery" instead of North).
3. **Legend / Key**: Small box explaining color coding and symbol meanings.
   JetBrainsMono Nerd Font Regular for legend text.
4. **Scale Indicator**: Optional but adds authenticity. Can be metaphorical
   (e.g., "1 inch = 1 month of learning").

### Terrain Features
- **Coastlines**: Wobbly hand-drawn lines with subtle shading
- **Mountains**: Small illustrated peaks with shading, arranged in ranges
- **Rivers**: Flowing curved lines in Muted Blue (#5D95C6)
- **Forests**: Clusters of tiny hand-drawn trees
- **Cities/Towns**: Small circles or building icons with labels
- **Paths/Roads**: Dashed or dotted lines connecting locations
- **Bridges**: Small architectural elements crossing rivers or gaps

### Decorative Elements
- **Sea monsters**: Small illustrated creatures in empty ocean areas
- **Ships**: Tiny vessels along trade/connection routes
- **Banners**: Ribbon banners for region names
- **Dotted borders**: Soft territorial boundaries between regions
- **Aged paper texture**: Subtle grain and slight yellowing on the background
- **Ink splatters**: Very subtle, adds to hand-drawn authenticity

---

## Typography System

All text uses JetBrainsMono Nerd Font:

### Tier 1 -- Map Title
- ExtraBold weight
- Largest size, inside the title cartouche
- Color: Dark Charcoal (#222222)

### Tier 2 -- Region / Island Names
- Bold weight
- Medium size, positioned on or near major landmasses
- Color: Dark Charcoal (#222222) or white on dark territories

### Tier 3 -- City / Feature Names
- Medium weight
- Smaller size, positioned next to specific landmarks
- Color: Dark Charcoal (#222222) at 80% opacity

### Tier 4 -- Annotations and Notes
- Regular or Light weight
- Smallest size, for sea labels, legend text, notes
- Color: Muted Blue (#5D95C6) or Dark Charcoal at 60% opacity

---

## Prompt Template

```
An illustrated hand-drawn conceptual map on aged parchment paper with a warm cream
(#F6F3EB) background and subtle paper texture.

Map topic: [TOPIC / DOMAIN / CONCEPT SPACE]

Territory layout:
- [ISLAND/REGION 1]: [Name] -- [Description, relative size, position]
- [ISLAND/REGION 2]: [Name] -- [Description, relative size, position]
- [ISLAND/REGION 3]: [Name] -- [Description, relative size, position]
- [Additional territories as needed]

Connections:
- [ROUTE/RIVER/BRIDGE 1]: Connects [A] to [B], representing [relationship]
- [ROUTE/RIVER/BRIDGE 2]: Connects [C] to [D], representing [relationship]

Key landmarks:
- [LANDMARK 1]: [Mountain/City/Forest] at [location], representing [concept]
- [LANDMARK 2]: [Mountain/City/Forest] at [location], representing [concept]

Visual style: Illustrated cartography in the style of fantasy/exploration maps.
Hand-drawn coastlines, sketchy mountain ranges, tiny illustrated trees for forests.
Warm, inviting, aged parchment aesthetic.

Color territories:
- Primary/core areas: Coral (#D67056) land tones
- Secondary areas: Teal (#70B8AD) land tones
- General terrain: Tan (#E6CCAB)
- Water features: Muted Blue (#5D95C6)
- Deep/unknown zones: Dark Grey Blue (#2C313A)
- Highlights and treasures: Mustard Yellow (#EAB64D)
- All text and lines: Dark Charcoal (#222222)

Required elements: Title cartouche with ornate border, compass rose, legend/key box.

Typography: JetBrainsMono Nerd Font -- ExtraBold for title, Bold for regions,
Medium for landmarks, Regular for annotations.
```

---

## Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio 4:3 \
  --output ~/prj/art-skill/outputs/[name].png
```

### Recommended Aspect Ratios

| Map Style            | Aspect Ratio | Reason                              |
|----------------------|--------------|-------------------------------------|
| Archipelago          | 16:9         | Wide sea with scattered islands     |
| Single Continent     | 4:3          | Balanced landscape view             |
| Vertical Journey     | 9:16         | Top-to-bottom progression           |
| Panoramic Landscape  | 21:9         | Wide scenic vista                   |
| Square Territory     | 1:1          | Social media friendly               |

---

## Validation Checklist

Before delivering, verify:

- [ ] Map metaphor fits the abstract concept being visualized
- [ ] Background is aged parchment Warm Cream (#F6F3EB)
- [ ] Coral (#D67056) marks primary/core territories only
- [ ] Teal (#70B8AD) marks secondary territories
- [ ] Water features use Muted Blue (#5D95C6)
- [ ] Title cartouche is present with ornate hand-drawn border
- [ ] Compass rose is visible in a corner
- [ ] Legend/key explains color coding and symbols
- [ ] All region and landmark names are legible
- [ ] Typography follows the 4-tier hierarchy
- [ ] Hand-drawn style is consistent (no rigid mechanical shapes)
- [ ] Connections between concepts are shown as routes/rivers/bridges
- [ ] Geographic proximity reflects conceptual relatedness
- [ ] No more than 7-10 major territories to avoid clutter
- [ ] Decorative elements add charm without overwhelming content
- [ ] Output saved to ~/prj/art-skill/outputs/
- [ ] No voice notifications triggered

---

## Examples

### Example 1: The Machine Learning Archipelago

**Territories:**
- **Supervised Island** (large, Coral): Ridge of algorithms running north-south,
  cities for "Classification" and "Regression" on opposite coasts
- **Unsupervised Isle** (medium, Teal): Dense forest of clustering algorithms,
  mountain peak labeled "Dimensionality Reduction"
- **Reinforcement Atoll** (small, Muted Blue): Ring island with "Agent" at center,
  "Environment" as the surrounding reef

**Connections:**
- Trade route between Supervised and Unsupervised: "Transfer Learning"
- River delta flowing from all islands: "Production Deployment"

**Landmarks:**
- Mount Transformer (tallest peak on Supervised Island)
- The GAN Strait (narrow water between Supervised and Unsupervised)
- Deep Learning Trench (dark area in the sea, Dark Grey Blue)

### Example 2: The Software Architecture Continent

**Regions:**
- **Frontend Plains** (western coast, Teal): Flat accessible terrain,
  cities for React, Vue, Angular
- **Backend Highlands** (central, Coral): Elevated terrain with API mountain passes,
  database lakes
- **DevOps Badlands** (eastern, Tan): Rugged terrain, pipeline rivers,
  container harbors
- **The Cloud** (northern sea, Muted Blue): Vast ocean with service islands

**Connections:**
- HTTP Highway connecting Frontend to Backend
- CI/CD River flowing from Backend through DevOps to The Cloud
- REST Bridge and GraphQL Ferry between territories

### Example 3: The Creative Process Journey Map

**Vertical journey (9:16):**
- **Inspiration Peaks** (top, Mustard Yellow): Mountain summit starting point
- **Ideation Forest** (upper-middle, Teal): Dense exploration area
- **Prototype Valley** (middle, Tan): Flat building ground with workshops
- **Critique Rapids** (lower-middle, Muted Blue): Turbulent river section
- **Refinement Plains** (lower, Coral): Polished, clear terrain
- **Launch Harbor** (bottom, Coral): Port city with ships departing

---

## Composition Tips

1. **Leave breathing room**: Empty sea/space between territories prevents
   visual clutter and suggests there is more to explore.
2. **Size encodes importance**: Larger islands or regions naturally draw
   attention first.
3. **Position encodes narrative**: Left-to-right or top-to-bottom can imply
   sequence, progression, or priority.
4. **Use the sea**: Empty water is not wasted space -- it provides contrast
   and makes the territories stand out.
5. **Layer detail**: Major features visible from afar, fine details reward
   closer inspection.
6. **Thematic compass**: Replace N/S/E/W with domain-relevant directions
   (e.g., "Toward Abstraction" / "Toward Implementation").
