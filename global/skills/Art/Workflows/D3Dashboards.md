# D3 Dashboards — Interactive Data Visualization Workflow

> Brand-colored interactive dashboards built with D3.js.
> Data becomes design. Every chart is an editorial statement.

---

## Brand Identity

| Token | Hex | CSS Variable | Role |
|---|---|---|---|
| Warm Cream | `#F6F3EB` | `--color-bg` | Dashboard background, chart area fill |
| Coral/Orange | `#D67056` | `--color-primary` | Primary data series, key metrics, alerts |
| Tan/Sand | `#E6CCAB` | `--color-secondary` | Grid lines, secondary fills, hover states |
| Teal | `#70B8AD` | `--color-accent` | Secondary data series, comparison values |
| Dark Charcoal | `#222222` | `--color-text` | Axis labels, titles, primary text |
| Muted Blue | `#5D95C6` | `--color-info` | Tertiary data series, informational elements |
| Dark Grey Blue | `#2C313A` | `--color-dark` | Tooltip backgrounds, card shadows |
| Mustard Yellow | `#EAB64D` | `--color-highlight` | Alerts, thresholds, attention markers |

**Font:** JetBrainsMono Nerd Font / `'JetBrains Mono', 'Fira Code', 'SF Mono', monospace`

---

## Overview

This workflow produces interactive D3.js dashboards styled with the brand palette. Every visualization follows the same color system, typography, and interaction patterns, creating a cohesive data experience.

Dashboards are output as self-contained HTML files with embedded CSS and JavaScript, ready to open in a browser or embed in a page.

---

## CSS Foundation

Every dashboard starts with this CSS foundation:

```css
:root {
  --color-bg: #F6F3EB;
  --color-primary: #D67056;
  --color-secondary: #E6CCAB;
  --color-accent: #70B8AD;
  --color-text: #222222;
  --color-info: #5D95C6;
  --color-dark: #2C313A;
  --color-highlight: #EAB64D;

  --font-mono: 'JetBrains Mono', 'Fira Code', 'SF Mono', 'Cascadia Code', monospace;
  --font-size-xs: 10px;
  --font-size-sm: 12px;
  --font-size-md: 14px;
  --font-size-lg: 18px;
  --font-size-xl: 24px;
  --font-size-xxl: 36px;

  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;

  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;

  --shadow-sm: 0 1px 3px rgba(44, 49, 58, 0.1);
  --shadow-md: 0 4px 12px rgba(44, 49, 58, 0.15);
  --shadow-lg: 0 8px 24px rgba(44, 49, 58, 0.2);

  --transition-fast: 150ms ease;
  --transition-normal: 300ms ease;
  --transition-slow: 500ms ease;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  background-color: var(--color-bg);
  color: var(--color-text);
  font-family: var(--font-mono);
  font-size: var(--font-size-md);
  line-height: 1.6;
  padding: var(--spacing-lg);
}

.dashboard {
  max-width: 1400px;
  margin: 0 auto;
  display: grid;
  gap: var(--spacing-lg);
}

.card {
  background: white;
  border-radius: var(--radius-md);
  padding: var(--spacing-lg);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--color-secondary);
}

.card:hover {
  box-shadow: var(--shadow-md);
  transition: box-shadow var(--transition-normal);
}

.card-title {
  font-size: var(--font-size-lg);
  font-weight: 700;
  color: var(--color-text);
  margin-bottom: var(--spacing-md);
  letter-spacing: -0.02em;
}

.metric-value {
  font-size: var(--font-size-xxl);
  font-weight: 700;
  color: var(--color-primary);
  letter-spacing: -0.03em;
}

.metric-label {
  font-size: var(--font-size-sm);
  color: var(--color-info);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* D3-specific styles */
.axis text {
  font-family: var(--font-mono);
  font-size: var(--font-size-xs);
  fill: var(--color-text);
}

.axis line,
.axis path {
  stroke: var(--color-secondary);
}

.grid line {
  stroke: var(--color-secondary);
  stroke-opacity: 0.5;
  stroke-dasharray: 2, 4;
}

.tooltip {
  position: absolute;
  background: var(--color-dark);
  color: var(--color-bg);
  padding: var(--spacing-sm) var(--spacing-md);
  border-radius: var(--radius-sm);
  font-family: var(--font-mono);
  font-size: var(--font-size-sm);
  pointer-events: none;
  box-shadow: var(--shadow-md);
  z-index: 1000;
  opacity: 0;
  transition: opacity var(--transition-fast);
}

.tooltip.visible {
  opacity: 1;
}
```

---

## Color Scales for Data

### Categorical Scale (up to 8 categories)

```javascript
const brandCategorical = [
  '#D67056', // Coral — primary
  '#70B8AD', // Teal — accent
  '#5D95C6', // Muted Blue — info
  '#EAB64D', // Mustard — highlight
  '#E6CCAB', // Tan — secondary
  '#2C313A', // Dark Grey Blue — dark
  '#222222', // Dark Charcoal — text
  '#F6F3EB', // Warm Cream — bg (use sparingly, only on dark backgrounds)
];

const colorScale = d3.scaleOrdinal()
  .range(brandCategorical);
```

### Sequential Scale (single hue progression)

```javascript
// Coral progression (warm data)
const coralSequential = d3.scaleLinear()
  .domain([0, 1])
  .range(['#F6F3EB', '#D67056'])
  .interpolate(d3.interpolateHcl);

// Teal progression (cool data)
const tealSequential = d3.scaleLinear()
  .domain([0, 1])
  .range(['#F6F3EB', '#70B8AD'])
  .interpolate(d3.interpolateHcl);
```

### Diverging Scale (two-sided data)

```javascript
// Coral ← Neutral → Teal
const diverging = d3.scaleDiverging()
  .domain([-1, 0, 1])
  .interpolator(d3.interpolateRgbBasis([
    '#D67056', // negative (coral)
    '#F6F3EB', // neutral (cream)
    '#70B8AD'  // positive (teal)
  ]));
```

### Alert Thresholds

```javascript
const alertScale = (value, thresholds) => {
  if (value >= thresholds.critical) return '#D67056'; // Coral = critical
  if (value >= thresholds.warning) return '#EAB64D';  // Mustard = warning
  return '#70B8AD';                                     // Teal = healthy
};
```

---

## Chart Patterns

### Pattern 1: Bar Chart

```javascript
function createBarChart(container, data, options = {}) {
  const {
    width = 600,
    height = 400,
    margin = { top: 40, right: 20, bottom: 60, left: 60 },
    xKey = 'label',
    yKey = 'value',
    color = '#D67056',
    title = ''
  } = options;

  const innerWidth = width - margin.left - margin.right;
  const innerHeight = height - margin.top - margin.bottom;

  const svg = d3.select(container)
    .append('svg')
    .attr('viewBox', `0 0 ${width} ${height}`)
    .attr('preserveAspectRatio', 'xMidYMid meet');

  const g = svg.append('g')
    .attr('transform', `translate(${margin.left},${margin.top})`);

  // Title
  if (title) {
    svg.append('text')
      .attr('x', width / 2)
      .attr('y', 24)
      .attr('text-anchor', 'middle')
      .attr('font-family', 'var(--font-mono)')
      .attr('font-size', '16px')
      .attr('font-weight', '700')
      .attr('fill', '#222222')
      .text(title);
  }

  // Scales
  const x = d3.scaleBand()
    .domain(data.map(d => d[xKey]))
    .range([0, innerWidth])
    .padding(0.3);

  const y = d3.scaleLinear()
    .domain([0, d3.max(data, d => d[yKey]) * 1.1])
    .range([innerHeight, 0]);

  // Grid lines
  g.append('g')
    .attr('class', 'grid')
    .call(d3.axisLeft(y)
      .tickSize(-innerWidth)
      .tickFormat('')
    );

  // Bars
  g.selectAll('.bar')
    .data(data)
    .join('rect')
    .attr('class', 'bar')
    .attr('x', d => x(d[xKey]))
    .attr('y', innerHeight) // start from bottom for animation
    .attr('width', x.bandwidth())
    .attr('height', 0)
    .attr('fill', color)
    .attr('rx', 3)
    .on('mouseenter', function(event, d) {
      d3.select(this).attr('fill', '#EAB64D'); // Mustard highlight
      showTooltip(event, `${d[xKey]}: ${d[yKey]}`);
    })
    .on('mouseleave', function() {
      d3.select(this).attr('fill', color);
      hideTooltip();
    })
    .transition()
    .duration(600)
    .delay((d, i) => i * 80)
    .attr('y', d => y(d[yKey]))
    .attr('height', d => innerHeight - y(d[yKey]));

  // Axes
  g.append('g')
    .attr('class', 'axis')
    .attr('transform', `translate(0,${innerHeight})`)
    .call(d3.axisBottom(x))
    .selectAll('text')
    .attr('transform', 'rotate(-35)')
    .attr('text-anchor', 'end');

  g.append('g')
    .attr('class', 'axis')
    .call(d3.axisLeft(y).ticks(6));
}
```

### Pattern 2: Line Chart

```javascript
function createLineChart(container, datasets, options = {}) {
  const {
    width = 600,
    height = 400,
    margin = { top: 40, right: 100, bottom: 60, left: 60 },
    xKey = 'date',
    yKey = 'value',
    colors = ['#D67056', '#70B8AD', '#5D95C6'],
    title = '',
    curve = d3.curveMonotoneX
  } = options;

  const innerWidth = width - margin.left - margin.right;
  const innerHeight = height - margin.top - margin.bottom;

  const svg = d3.select(container)
    .append('svg')
    .attr('viewBox', `0 0 ${width} ${height}`);

  const g = svg.append('g')
    .attr('transform', `translate(${margin.left},${margin.top})`);

  // Scales
  const allData = datasets.flat();
  const x = d3.scaleTime()
    .domain(d3.extent(allData, d => d[xKey]))
    .range([0, innerWidth]);

  const y = d3.scaleLinear()
    .domain([0, d3.max(allData, d => d[yKey]) * 1.1])
    .range([innerHeight, 0]);

  // Grid
  g.append('g').attr('class', 'grid')
    .call(d3.axisLeft(y).tickSize(-innerWidth).tickFormat(''));

  // Lines
  const line = d3.line()
    .x(d => x(d[xKey]))
    .y(d => y(d[yKey]))
    .curve(curve);

  datasets.forEach((dataset, i) => {
    const path = g.append('path')
      .datum(dataset)
      .attr('fill', 'none')
      .attr('stroke', colors[i % colors.length])
      .attr('stroke-width', 2.5)
      .attr('d', line);

    // Animate line drawing
    const totalLength = path.node().getTotalLength();
    path
      .attr('stroke-dasharray', `${totalLength} ${totalLength}`)
      .attr('stroke-dashoffset', totalLength)
      .transition()
      .duration(1500)
      .delay(i * 300)
      .attr('stroke-dashoffset', 0);

    // Data points
    g.selectAll(`.dot-${i}`)
      .data(dataset)
      .join('circle')
      .attr('class', `dot-${i}`)
      .attr('cx', d => x(d[xKey]))
      .attr('cy', d => y(d[yKey]))
      .attr('r', 0)
      .attr('fill', colors[i % colors.length])
      .attr('stroke', '#fff')
      .attr('stroke-width', 2)
      .on('mouseenter', function(event, d) {
        d3.select(this).transition().attr('r', 7);
        showTooltip(event, `${d3.timeFormat('%b %d')(d[xKey])}: ${d[yKey]}`);
      })
      .on('mouseleave', function() {
        d3.select(this).transition().attr('r', 4);
        hideTooltip();
      })
      .transition()
      .delay(1500 + i * 300)
      .duration(300)
      .attr('r', 4);
  });

  // Axes
  g.append('g').attr('class', 'axis')
    .attr('transform', `translate(0,${innerHeight})`)
    .call(d3.axisBottom(x).ticks(6));

  g.append('g').attr('class', 'axis')
    .call(d3.axisLeft(y).ticks(6));
}
```

### Pattern 3: Scatter Plot

```javascript
function createScatterPlot(container, data, options = {}) {
  const {
    width = 600,
    height = 500,
    margin = { top: 40, right: 40, bottom: 60, left: 60 },
    xKey = 'x',
    yKey = 'y',
    sizeKey = null,
    categoryKey = null,
    title = ''
  } = options;

  const innerWidth = width - margin.left - margin.right;
  const innerHeight = height - margin.top - margin.bottom;

  const svg = d3.select(container)
    .append('svg')
    .attr('viewBox', `0 0 ${width} ${height}`);

  const g = svg.append('g')
    .attr('transform', `translate(${margin.left},${margin.top})`);

  const colorScale = d3.scaleOrdinal()
    .range(['#D67056', '#70B8AD', '#5D95C6', '#EAB64D', '#2C313A']);

  const x = d3.scaleLinear()
    .domain(d3.extent(data, d => d[xKey])).nice()
    .range([0, innerWidth]);

  const y = d3.scaleLinear()
    .domain(d3.extent(data, d => d[yKey])).nice()
    .range([innerHeight, 0]);

  const size = sizeKey
    ? d3.scaleSqrt().domain(d3.extent(data, d => d[sizeKey])).range([3, 20])
    : () => 6;

  // Grid
  g.append('g').attr('class', 'grid')
    .call(d3.axisLeft(y).tickSize(-innerWidth).tickFormat(''));
  g.append('g').attr('class', 'grid')
    .attr('transform', `translate(0,${innerHeight})`)
    .call(d3.axisBottom(x).tickSize(-innerHeight).tickFormat(''));

  // Points
  g.selectAll('.point')
    .data(data)
    .join('circle')
    .attr('class', 'point')
    .attr('cx', d => x(d[xKey]))
    .attr('cy', d => y(d[yKey]))
    .attr('r', 0)
    .attr('fill', d => categoryKey ? colorScale(d[categoryKey]) : '#D67056')
    .attr('opacity', 0.75)
    .attr('stroke', '#fff')
    .attr('stroke-width', 1)
    .on('mouseenter', function(event, d) {
      d3.select(this)
        .transition().duration(150)
        .attr('opacity', 1)
        .attr('stroke-width', 2)
        .attr('r', (sizeKey ? size(d[sizeKey]) : 6) + 3);
      showTooltip(event, `(${d[xKey]}, ${d[yKey]})`);
    })
    .on('mouseleave', function(event, d) {
      d3.select(this)
        .transition().duration(150)
        .attr('opacity', 0.75)
        .attr('stroke-width', 1)
        .attr('r', sizeKey ? size(d[sizeKey]) : 6);
      hideTooltip();
    })
    .transition()
    .duration(800)
    .delay((d, i) => i * 20)
    .attr('r', d => sizeKey ? size(d[sizeKey]) : 6);

  // Axes
  g.append('g').attr('class', 'axis')
    .attr('transform', `translate(0,${innerHeight})`)
    .call(d3.axisBottom(x));

  g.append('g').attr('class', 'axis')
    .call(d3.axisLeft(y));
}
```

### Pattern 4: Force-Directed Graph

```javascript
function createForceGraph(container, nodes, links, options = {}) {
  const {
    width = 800,
    height = 600,
    nodeColor = d => {
      const colors = { primary: '#D67056', secondary: '#70B8AD', tertiary: '#5D95C6' };
      return colors[d.type] || '#E6CCAB';
    },
    linkColor = '#E6CCAB',
    title = ''
  } = options;

  const svg = d3.select(container)
    .append('svg')
    .attr('viewBox', `0 0 ${width} ${height}`);

  // Simulation
  const simulation = d3.forceSimulation(nodes)
    .force('link', d3.forceLink(links).id(d => d.id).distance(80))
    .force('charge', d3.forceManyBody().strength(-200))
    .force('center', d3.forceCenter(width / 2, height / 2))
    .force('collision', d3.forceCollide().radius(d => d.radius || 20));

  // Links
  const link = svg.append('g')
    .selectAll('line')
    .data(links)
    .join('line')
    .attr('stroke', linkColor)
    .attr('stroke-width', d => d.weight || 1.5)
    .attr('stroke-opacity', 0.6);

  // Nodes
  const node = svg.append('g')
    .selectAll('circle')
    .data(nodes)
    .join('circle')
    .attr('r', d => d.radius || 12)
    .attr('fill', nodeColor)
    .attr('stroke', '#fff')
    .attr('stroke-width', 2)
    .call(d3.drag()
      .on('start', dragStarted)
      .on('drag', dragged)
      .on('end', dragEnded));

  // Labels
  const label = svg.append('g')
    .selectAll('text')
    .data(nodes)
    .join('text')
    .text(d => d.label || d.id)
    .attr('font-family', 'var(--font-mono)')
    .attr('font-size', '10px')
    .attr('fill', '#222222')
    .attr('text-anchor', 'middle')
    .attr('dy', d => (d.radius || 12) + 14);

  // Hover interactions
  node.on('mouseenter', function(event, d) {
    d3.select(this)
      .transition().duration(150)
      .attr('r', (d.radius || 12) + 4)
      .attr('stroke', '#EAB64D')
      .attr('stroke-width', 3);

    // Highlight connected links
    link.attr('stroke', l =>
      (l.source.id === d.id || l.target.id === d.id) ? '#EAB64D' : linkColor
    ).attr('stroke-width', l =>
      (l.source.id === d.id || l.target.id === d.id) ? 3 : (l.weight || 1.5)
    );

    showTooltip(event, d.label || d.id);
  })
  .on('mouseleave', function(event, d) {
    d3.select(this)
      .transition().duration(150)
      .attr('r', d.radius || 12)
      .attr('stroke', '#fff')
      .attr('stroke-width', 2);

    link.attr('stroke', linkColor)
      .attr('stroke-width', l => l.weight || 1.5);

    hideTooltip();
  });

  simulation.on('tick', () => {
    link
      .attr('x1', d => d.source.x)
      .attr('y1', d => d.source.y)
      .attr('x2', d => d.target.x)
      .attr('y2', d => d.target.y);
    node.attr('cx', d => d.x).attr('cy', d => d.y);
    label.attr('x', d => d.x).attr('y', d => d.y);
  });

  function dragStarted(event, d) {
    if (!event.active) simulation.alphaTarget(0.3).restart();
    d.fx = d.x; d.fy = d.y;
  }
  function dragged(event, d) { d.fx = event.x; d.fy = event.y; }
  function dragEnded(event, d) {
    if (!event.active) simulation.alphaTarget(0);
    d.fx = null; d.fy = null;
  }
}
```

### Pattern 5: Donut/Pie Chart

```javascript
function createDonutChart(container, data, options = {}) {
  const {
    width = 400,
    height = 400,
    innerRadiusRatio = 0.6,
    colors = ['#D67056', '#70B8AD', '#5D95C6', '#EAB64D', '#E6CCAB', '#2C313A'],
    title = ''
  } = options;

  const radius = Math.min(width, height) / 2 - 20;
  const innerRadius = radius * innerRadiusRatio;

  const svg = d3.select(container)
    .append('svg')
    .attr('viewBox', `0 0 ${width} ${height}`)
    .append('g')
    .attr('transform', `translate(${width/2},${height/2})`);

  const colorScale = d3.scaleOrdinal().range(colors);

  const pie = d3.pie()
    .value(d => d.value)
    .sort(null)
    .padAngle(0.02);

  const arc = d3.arc()
    .innerRadius(innerRadius)
    .outerRadius(radius)
    .cornerRadius(4);

  const arcHover = d3.arc()
    .innerRadius(innerRadius)
    .outerRadius(radius + 8)
    .cornerRadius(4);

  const slices = svg.selectAll('.slice')
    .data(pie(data))
    .join('path')
    .attr('class', 'slice')
    .attr('fill', (d, i) => colorScale(i))
    .attr('stroke', '#F6F3EB')
    .attr('stroke-width', 2)
    .each(function(d) { this._current = { startAngle: 0, endAngle: 0 }; })
    .on('mouseenter', function(event, d) {
      d3.select(this).transition().duration(150).attr('d', arcHover);
      showTooltip(event, `${d.data.label}: ${d.data.value}`);
    })
    .on('mouseleave', function(event, d) {
      d3.select(this).transition().duration(150).attr('d', arc);
      hideTooltip();
    })
    .transition()
    .duration(1000)
    .attrTween('d', function(d) {
      const interpolate = d3.interpolate(this._current, d);
      this._current = interpolate(1);
      return t => arc(interpolate(t));
    });

  // Center label
  if (title) {
    svg.append('text')
      .attr('text-anchor', 'middle')
      .attr('dy', '-0.2em')
      .attr('font-family', 'var(--font-mono)')
      .attr('font-size', '24px')
      .attr('font-weight', '700')
      .attr('fill', '#222222')
      .text(title);
  }
}
```

---

## Shared Utilities

### Tooltip System

```javascript
// Create tooltip element once
const tooltip = d3.select('body')
  .append('div')
  .attr('class', 'tooltip');

function showTooltip(event, content) {
  tooltip
    .html(content)
    .style('left', `${event.pageX + 12}px`)
    .style('top', `${event.pageY - 28}px`)
    .classed('visible', true);
}

function hideTooltip() {
  tooltip.classed('visible', false);
}
```

### Zoom Behavior

```javascript
function addZoom(svg, g, width, height) {
  const zoom = d3.zoom()
    .scaleExtent([0.5, 5])
    .on('zoom', (event) => {
      g.attr('transform', event.transform);
    });

  svg.call(zoom);

  // Double-click to reset
  svg.on('dblclick.zoom', () => {
    svg.transition()
      .duration(500)
      .call(zoom.transform, d3.zoomIdentity);
  });
}
```

### Responsive Container

```javascript
function responsiveChart(container, renderFn) {
  const resizeObserver = new ResizeObserver(entries => {
    for (const entry of entries) {
      const { width } = entry.contentRect;
      d3.select(container).select('svg').remove();
      renderFn(container, width);
    }
  });

  resizeObserver.observe(document.querySelector(container));
}
```

### Number Formatting

```javascript
const formatters = {
  number: d3.format(',.0f'),
  decimal: d3.format(',.2f'),
  percent: d3.format('.1%'),
  compact: d3.format('.2s'),
  currency: d => `$${d3.format(',.0f')(d)}`,
};
```

---

## Dashboard Layout Patterns

### Pattern A: Metric Cards + Chart (Standard)

```
┌──────┬──────┬──────┬──────┐
│ KPI  │ KPI  │ KPI  │ KPI  │
│ Card │ Card │ Card │ Card │
├──────┴──────┴──────┴──────┤
│                            │
│       Main Chart           │
│                            │
├─────────────┬──────────────┤
│  Chart 2    │   Chart 3    │
└─────────────┴──────────────┘
```

```css
.dashboard-standard {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: var(--spacing-lg);
}

.dashboard-standard .kpi-card {
  grid-column: span 1;
}

.dashboard-standard .main-chart {
  grid-column: span 4;
}

.dashboard-standard .secondary-chart {
  grid-column: span 2;
}
```

### Pattern B: Sidebar + Content

```
┌────────┬───────────────────┐
│        │                   │
│ SIDEBAR│   Main Content    │
│ Filters│                   │
│ & KPIs │                   │
│        │                   │
│        ├─────────┬─────────┤
│        │ Chart 2 │ Chart 3 │
└────────┴─────────┴─────────┘
```

```css
.dashboard-sidebar {
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: var(--spacing-lg);
  min-height: 100vh;
}

.sidebar {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
}

.content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--spacing-lg);
  align-content: start;
}

.content .full-width {
  grid-column: span 2;
}
```

### Pattern C: Full Width Narrative (Scrollytelling)

```
┌─────────────────────────────┐
│        Hero Metric          │
├─────────────────────────────┤
│        Chart 1              │
├─────────────────────────────┤
│        Chart 2              │
├─────────────────────────────┤
│        Chart 3              │
└─────────────────────────────┘
```

```css
.dashboard-narrative {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xl);
  max-width: 900px;
  margin: 0 auto;
}
```

---

## Responsive Design

### Breakpoints

```css
/* Mobile first, then scale up */
@media (max-width: 768px) {
  .dashboard {
    grid-template-columns: 1fr;
  }

  .kpi-card { grid-column: span 1; }
  .main-chart { grid-column: span 1; }
  .secondary-chart { grid-column: span 1; }

  .dashboard-sidebar {
    grid-template-columns: 1fr;
  }

  .sidebar {
    flex-direction: row;
    overflow-x: auto;
    gap: var(--spacing-sm);
  }

  body { padding: var(--spacing-md); }
}

@media (min-width: 769px) and (max-width: 1200px) {
  .dashboard {
    grid-template-columns: repeat(2, 1fr);
  }

  .main-chart { grid-column: span 2; }
}
```

### SVG Responsiveness

All SVGs should use `viewBox` instead of fixed width/height:

```javascript
const svg = d3.select(container)
  .append('svg')
  .attr('viewBox', `0 0 ${width} ${height}`)
  .attr('preserveAspectRatio', 'xMidYMid meet')
  .style('width', '100%')
  .style('height', 'auto');
```

---

## Workflow Steps

### Step 1: DEFINE DATA AND INTENT

**Goal:** Understand what data is being visualized and what story it tells.

1. **What data?** — source, shape, key fields
2. **What story?** — trend, comparison, distribution, relationship, composition
3. **Who is the audience?** — technical, executive, public
4. **What actions should the dashboard support?** — monitor, explore, decide
5. **How many charts?** — typically 3-6 for a dashboard

---

### Step 2: SELECT CHART TYPES

**Goal:** Map data relationships to appropriate chart types.

| Data Relationship | Chart Type | Brand Color Usage |
|---|---|---|
| Trend over time | Line chart | Coral for primary series, Teal for comparison |
| Category comparison | Bar chart | Coral for main category, Teal for secondary |
| Distribution | Histogram / Box plot | Coral fill, Teal quartile markers |
| Part-to-whole | Donut chart | Full categorical palette |
| Correlation | Scatter plot | Coral/Teal by category, Mustard for outliers |
| Network/relationships | Force-directed graph | Coral for primary nodes, Teal for secondary |
| Geographic | Map/choropleth | Coral-to-Teal diverging scale |
| Ranked | Horizontal bar | Coral top items, gradient to Tan for rest |

---

### Step 3: BUILD THE DASHBOARD

**Goal:** Write the HTML/CSS/JS dashboard file.

#### HTML Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[DASHBOARD TITLE]</title>
  <script src="https://d3js.org/d3.v7.min.js"></script>
  <style>
    /* [INSERT CSS FOUNDATION FROM ABOVE] */
    /* [INSERT LAYOUT PATTERN CSS] */
    /* [INSERT RESPONSIVE CSS] */
  </style>
</head>
<body>
  <div class="dashboard [LAYOUT-CLASS]">
    <h1 class="dashboard-title">[TITLE]</h1>

    <!-- KPI Cards -->
    <div class="card kpi-card">
      <div class="metric-label">[LABEL]</div>
      <div class="metric-value">[VALUE]</div>
    </div>
    <!-- Repeat for each KPI -->

    <!-- Charts -->
    <div class="card main-chart" id="chart-1">
      <div class="card-title">[CHART TITLE]</div>
    </div>
    <!-- Repeat for each chart -->

    <div class="tooltip"></div>
  </div>

  <script>
    // [INSERT DATA]
    // [INSERT CHART FUNCTIONS]
    // [INSERT TOOLTIP UTILITIES]
    // [INSERT INITIALIZATION]
  </script>
</body>
</html>
```

Save to:
```bash
~/prj/art-skill/outputs/dashboard-[name].html
```

---

### Step 4: TEST INTERACTIVITY

**Goal:** Verify all interactive features work.

Open the dashboard:
```bash
open ~/prj/art-skill/outputs/dashboard-[name].html
```

Test:
- [ ] Tooltips appear on hover
- [ ] Transitions/animations play on load
- [ ] Zoom works (if implemented)
- [ ] Drag works (for force-directed graphs)
- [ ] Responsive: resize browser window
- [ ] No console errors

---

### Step 5: CAPTURE STATIC VERSION

**Goal:** Generate a static image of the dashboard for embedding where interactive isn't possible.

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "Data dashboard visualization on warm cream (#F6F3EB) background. [DESCRIBE THE DASHBOARD LAYOUT AND CHARTS]. Brand colors: coral (#D67056) for primary data, teal (#70B8AD) for secondary, mustard (#EAB64D) for highlights. Clean monospace technical font like JetBrains Mono. Professional, editorial quality data visualization." \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/dashboard-static.png
```

---

### Step 6: VALIDATE

**Goal:** Run the full validation checklist.

#### Validation Checklist

**Brand Compliance:**
- [ ] Background uses Warm Cream (#F6F3EB)
- [ ] Primary data series uses Coral (#D67056)
- [ ] Secondary data series uses Teal (#70B8AD)
- [ ] Alerts/thresholds use Mustard Yellow (#EAB64D)
- [ ] Text uses Dark Charcoal (#222222)
- [ ] Font is monospace (JetBrains Mono family)
- [ ] Card borders use Tan/Sand (#E6CCAB)
- [ ] Tooltips use Dark Grey Blue (#2C313A) background

**Interactivity:**
- [ ] Tooltips show on hover for all data points
- [ ] Hover states provide visual feedback (color change, size change)
- [ ] Transitions are smooth (150-600ms range)
- [ ] Zoom works (if implemented)
- [ ] Drag works (if force-directed graph)
- [ ] Double-click to reset (if zoom enabled)

**Data Integrity:**
- [ ] All data points are rendered
- [ ] Axes are labeled correctly
- [ ] Scales are appropriate (no misleading truncation)
- [ ] Numbers are formatted consistently
- [ ] Legend (if present) matches chart colors

**Responsive Design:**
- [ ] Charts render correctly at 1400px width
- [ ] Charts render correctly at 768px width
- [ ] Charts render correctly at 375px width (mobile)
- [ ] SVGs use viewBox (not fixed dimensions)
- [ ] Grid layout collapses appropriately
- [ ] Text remains readable at all sizes

**Code Quality:**
- [ ] D3 v7 used (via CDN or bundled)
- [ ] No external dependencies beyond D3
- [ ] Self-contained HTML file
- [ ] No console errors
- [ ] CSS variables used consistently
- [ ] Functions are reusable

**Technical Output:**
- [ ] HTML file saved to `~/prj/art-skill/outputs/`
- [ ] Static image version created (if needed)
- [ ] File opens correctly in browser

#### Failure Protocol

| Issue | Fix |
|---|---|
| Colors don't match brand | Check CSS variables, verify hex values |
| Chart not rendering | Check D3 version, verify data shape, check console |
| Tooltips mispositioned | Adjust offset in showTooltip function |
| Not responsive | Add viewBox to SVGs, check grid CSS breakpoints |
| Animations janky | Reduce data points or simplify transitions |
| Fonts not loading | Ensure web font fallback chain in CSS |

---

## Quick Reference

### Minimal Invocation
```
Create a D3 dashboard showing [DATA DESCRIPTION]
```

### Full Invocation
```
Create a D3 dashboard:
Title: "Engineering Velocity Q1 2026"
Layout: Standard (4 KPI cards + main chart + 2 secondary)

KPIs: Commits/day, PR merge time, Deploy frequency, Incident count
Main chart: Line chart of commits/day over 90 days
Secondary 1: Bar chart of PR merge time by team
Secondary 2: Donut chart of deploy targets (prod/staging/dev)

Data: [provide data or describe synthetic data to generate]
Interactivity: Tooltips, zoom on line chart, click-to-filter on donut
```

---

## Examples

### Example: Engineering Metrics Dashboard

A complete dashboard showing team velocity metrics with 4 KPI cards, a time-series line chart, a grouped bar chart, and a donut chart.

Key decisions:
- **Layout:** Pattern A (Metric Cards + Chart)
- **Main chart:** Multi-line chart (Coral for commits, Teal for deployments)
- **Bar chart:** Coral bars with Mustard threshold line
- **Donut:** Full categorical palette
- **Interactivity:** Tooltips on all, zoom on line chart
- **Responsive:** Collapses to single column on mobile
