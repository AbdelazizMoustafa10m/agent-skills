# Canonical Consumer Behaviour Models

This file is the curated reference for the most-tested CB models. When the user asks for one of these by name, use the structure here as the scaffold — definition, attribution, Mermaid diagram, key constructs, criticism, exam-style questions. Do not paraphrase the citations away; "Howard and Sheth (1969)" is what graders recognise.

If a chapter introduces a model not in this file, derive it from the source and tell the user no curated reference exists yet.

## Table of contents

1. [Howard-Sheth Model (1969)](#howard-sheth-model-1969)
2. [Engel-Kollat-Blackwell / EKB / EBM Model (1968)](#engel-kollat-blackwell--ekb--ebm-model-1968)
3. [Nicosia Model (1966)](#nicosia-model-1966)
4. [Black Box / Stimulus-Response Model](#black-box--stimulus-response-model)
5. [Bettman Information Processing Model (1979)](#bettman-information-processing-model-1979)
6. [Maslow's Hierarchy of Needs (1943)](#maslows-hierarchy-of-needs-1943)
7. [Pavlov — Classical Conditioning](#pavlov--classical-conditioning)
8. [Skinner — Operant / Instrumental Conditioning](#skinner--operant--instrumental-conditioning)
9. [Theory of Planned Behavior (Ajzen, 1991)](#theory-of-planned-behavior-ajzen-1991)
10. [Hawkins Stern — Impulse Buying](#hawkins-stern--impulse-buying)
11. [Webster & Wind — Organisational Buying](#webster--wind--organisational-buying)

---

## Howard-Sheth Model (1969)

**Originators**: John A. Howard & Jagdish N. Sheth.
**One-line claim**: Consumer decisions are problem-solving; consumers move from extensive → limited → routinized problem-solving as they learn about a product class.
**Best applied to**: Frequently-purchased branded goods; learning over repeat purchases.

### Four variable groups

1. **Inputs (stimuli)** — significative (price, quality, distinctiveness, service, availability), symbolic (the same attributes communicated via ads), social (family, reference groups, social class).
2. **Perceptual constructs** — attention, stimulus ambiguity, perceptual bias.
3. **Learning constructs** — motive, choice criteria, brand comprehension, attitude, intention, confidence, satisfaction.
4. **Outputs** — attention, comprehension, attitude, intention, purchase.
5. **Exogenous variables** — importance of purchase, personality, social class, culture, financial status, time pressure.

### Mermaid template

```
flowchart TD
  subgraph IN["Inputs (Stimuli)"]
    SIG["Significative<br/>price, quality, service"]
    SYM["Symbolic<br/>ads, communications"]
    SOC["Social<br/>family, ref groups, class"]
  end
  subgraph PERC["Perceptual Constructs"]
    ATT1["Attention"]
    AMB["Stimulus ambiguity"]
    BIAS["Perceptual bias"]
  end
  subgraph LEARN["Learning Constructs"]
    MOT["Motive"]
    CRIT["Choice criteria"]
    BC["Brand comprehension"]
    ATT2["Attitude"]
    INT["Intention"]
    CONF["Confidence"]
    SAT["Satisfaction"]
  end
  subgraph OUT["Outputs"]
    O_ATT["Attention"]
    O_COMP["Comprehension"]
    O_ATTITUDE["Attitude"]
    O_INT["Intention"]
    O_PURCH["Purchase"]
  end
  EXO["Exogenous variables<br/>importance, personality, class, culture,<br/>finances, time pressure"]
  IN --> PERC --> LEARN --> OUT
  EXO -.-> LEARN
  SAT -.feedback.-> LEARN
```

### Three problem-solving levels

- **Extensive** — new product class, no brand comprehension, heavy info search
- **Limited** — known class, comparing brands
- **Routinized** — habitual repurchase, low search

### Standard criticisms

- Too many variables, hard to operationalise empirically
- Treats consumers as too rational
- Underweights emotion and impulse

### Exam-ready questions

- Define the three levels of problem-solving in the Howard-Sheth model.
- What distinguishes "perceptual constructs" from "learning constructs" in Howard-Sheth?
- A consumer buys the same toothpaste every month without thinking. Which level applies?
- Compare Howard-Sheth's input categories to the Black Box model's stimuli.

---

## Engel-Kollat-Blackwell / EKB / EBM Model (1968)

**Originators**: James F. Engel, David T. Kollat, Roger D. Blackwell (1968); revised with Paul Miniard as the Engel-Blackwell-Miniard (EBM) model in the 1990s.
**One-line claim**: Consumers proceed through a sequence of decision stages that can be expanded for high-involvement purchases and skipped for routine ones.
**Best applied to**: Mapping the customer journey for high-involvement decisions.

### Five-stage decision process (EBM extends to 7 by adding info processing and divestment)

1. Problem / need recognition
2. Information search (internal then external)
3. Evaluation of alternatives (beliefs → attitudes → intentions)
4. Purchase
5. Post-purchase evaluation (satisfaction or dissonance)
   *(EBM extension)* 6. Divestment / disposal

### Mermaid template

```
flowchart TD
  PR["1. Problem recognition"]
  IS["2. Information search<br/>internal · external"]
  EV["3. Evaluation of alternatives<br/>beliefs → attitudes → intentions"]
  PU["4. Purchase"]
  PP["5. Post-purchase evaluation<br/>satisfaction · dissonance"]
  DIV["6. Divestment (EBM extension)"]
  PR --> IS --> EV --> PU --> PP --> DIV
  PP -.dissatisfaction loop.-> IS

  subgraph INF["Influences (apply at every stage)"]
    IND["Individual<br/>motives · values · lifestyle · personality"]
    SOC["Social<br/>culture · reference groups · family"]
    SIT["Situational<br/>finances · time · context"]
  end
  INF -.-> PR
  INF -.-> IS
  INF -.-> EV
  INF -.-> PU
  INF -.-> PP
```

### Standard criticisms

- Vague variable definitions and overly complex
- Empirical validity questioned
- Sequential framing oversimplifies real decision messiness

### Exam-ready questions

- List the five core EKB stages and one consumer behaviour at each.
- What's the difference between internal and external information search?
- How does EBM extend EKB?
- Why does post-purchase evaluation matter for marketers?

---

## Nicosia Model (1966)

**Originator**: Francesco M. Nicosia (1966).
**One-line claim**: Consumer behaviour is a circular flow of communication between firm and consumer, organised into four sequential "fields".
**Best applied to**: New product adoption when the consumer has no prior brand experience.

### Four fields

1. From the firm's attributes to consumer attitudes (firm message → consumer perception)
2. Search and evaluation (consumer evaluates the firm's offering vs alternatives)
3. The act of purchase (motivation crystallises into a buying act at a specific retailer)
4. Feedback (consumption experience flows back to both firm and consumer's predispositions)

### Mermaid template

```
flowchart LR
  F1["Field 1<br/>Firm attributes →<br/>consumer attitude"]
  F2["Field 2<br/>Search & evaluation"]
  F3["Field 3<br/>Act of purchase"]
  F4["Field 4<br/>Feedback<br/>(experience)"]
  F1 --> F2 --> F3 --> F4
  F4 -.consumer's storage.-> F1
  F4 -.firm's experience.-> F1
```

### Standard criticisms

- Assumes consumer has no prior experience with the firm
- Not validated empirically
- Linear flow oversimplifies real interactions

---

## Black Box / Stimulus-Response Model

**One-line claim**: Marketing and environmental stimuli enter the consumer's "black box" (mind), interact with buyer characteristics and decision processes, and produce buyer responses.
**Best applied to**: Foundational framing; first model in many CB courses.

### Mermaid template

```
flowchart LR
  subgraph STIM["Stimuli"]
    MARK["Marketing<br/>4Ps"]
    ENV["Environmental<br/>economic, tech, political,<br/>cultural"]
  end
  subgraph BBOX["Buyer's Black Box"]
    CHAR["Buyer characteristics<br/>cultural, social, personal, psychological"]
    DEC["Decision process<br/>recognition → search → eval →<br/>purchase → post-purchase"]
  end
  subgraph RESP["Buyer Responses"]
    PROD["Product choice"]
    BR["Brand choice"]
    DEAL["Dealer choice"]
    TIM["Purchase timing"]
    AMT["Purchase amount"]
  end
  STIM --> BBOX --> RESP
```

### Standard criticisms

- "Black box" framing is a confession of ignorance — newer models (Bettman, Howard-Sheth) try to open the box.

---

## Bettman Information Processing Model (1979)

**Originator**: James R. Bettman (1979).
**One-line claim**: The consumer is an information processor with limited capacity who uses heuristics and decision rules that vary by personal and situational factors.
**Best applied to**: Cognitive-load-heavy decisions; explaining why consumers satisfice instead of optimise.

### Seven components

Processing capacity · motivation · attention & perceptual encoding · information acquisition & evaluation · memory · decision processes · consumption & learning processes

### Standard criticisms

- Heavy cognitive framing; downplays affect
- Assumes deliberate processing more than is realistic for routine purchases

---

## Maslow's Hierarchy of Needs (1943)

**Originator**: Abraham Maslow (1943, "A Theory of Human Motivation").
**One-line claim**: Human needs are arranged in a hierarchy; lower needs must be satisfied before higher needs become motivating.
**Best applied to**: Motivation analysis, positioning that targets a specific need level.

### Hierarchy (bottom to top)

1. Physiological — food, water, shelter, sleep
2. Safety — security, stability, protection
3. Love & belongingness — friendship, family, intimacy
4. Esteem — achievement, status, recognition
5. Self-actualisation — realising potential

### Mermaid template

```
flowchart TD
  SA["5. Self-actualisation"]
  ES["4. Esteem"]
  LB["3. Love & belongingness"]
  SF["2. Safety"]
  PH["1. Physiological"]
  SA --- ES --- LB --- SF --- PH
```

(Or render as a CSS pyramid — Mermaid struggles to render the classic triangle.)

### Standard criticisms

- Strict hierarchy oversimplified — empirical evidence for skipping levels
- Western individualist bias
- Self-actualisation hard to operationalise

### Exam-ready questions

- Place each of these products at the appropriate level: life insurance, luxury watch, bottled water, online dating app, MasterClass subscription.
- What's the marketing implication of targeting esteem needs vs belongingness needs?

---

## Pavlov — Classical Conditioning

**Originator**: Ivan Pavlov (early 1900s).
**One-line claim**: A neutral stimulus, repeatedly paired with an unconditioned stimulus that produces an unconditioned response, eventually elicits the response on its own (now a conditioned response).
**Marketing relevance**: Repetition, brand associations with positive feelings, jingles, package recognition.

### Core constructs

- **Unconditioned stimulus (UCS)** → unconditioned response (UCR)
- **Conditioned stimulus (CS)** + UCS → CR
- **Stimulus generalisation** (similar stimuli evoke the response — basis for me-too brands)
- **Stimulus discrimination** (selecting one stimulus from similar — basis for positioning)
- **Extinction** (CR fades when CS no longer paired with UCS)

### Mermaid template

```
flowchart LR
  UCS[UCS<br/>e.g. food] -->|reflex| UCR[UCR<br/>salivation]
  CS[CS<br/>bell] -.pair repeatedly.-> UCS
  CS ==>|after conditioning| CR[CR<br/>salivation]
```

---

## Skinner — Operant / Instrumental Conditioning

**Originator**: B.F. Skinner.
**One-line claim**: Behaviour is shaped by consequences; behaviours followed by reinforcement are repeated, behaviours followed by punishment fade.
**Marketing relevance**: Loyalty programs, free samples, satisfaction-driven repeat purchase.

### Core constructs

- **Positive reinforcement** — adding a reward strengthens behaviour
- **Negative reinforcement** — removing an unpleasant stimulus strengthens behaviour
- **Punishment** — adding an unpleasant stimulus weakens behaviour
- **Extinction** — withdrawing reinforcement; behaviour fades

### Mermaid template

```
flowchart LR
  STIM[Stimulus<br/>store visit] --> RESP[Response<br/>purchase]
  RESP --> OUT{Outcome}
  OUT -->|positive reinforcement| REPEAT[Behaviour repeated]
  OUT -->|punishment / no reward| EXT[Behaviour extinguished]
  REPEAT -.->|over time| HABIT[Habit / loyalty]
```

---

## Theory of Planned Behavior (Ajzen, 1991)

**Originator**: Icek Ajzen (1991), extending the Theory of Reasoned Action (Fishbein & Ajzen, 1975).
**One-line claim**: Behavioural intentions — and thus behaviour — are determined by attitudes toward the behaviour, subjective norms, and perceived behavioural control.
**Best applied to**: Predicting deliberate behaviours like ethical/sustainable consumption, dieting, voting.

### Mermaid template

```
flowchart LR
  BB[Behavioural beliefs] --> AT[Attitude toward behaviour]
  NB[Normative beliefs] --> SN[Subjective norm]
  CB[Control beliefs] --> PBC[Perceived behavioural control]
  AT --> INT[Intention]
  SN --> INT
  PBC --> INT
  PBC -.direct.-> BEH[Behaviour]
  INT --> BEH
```

### Standard criticisms

- Intention-behaviour gap is large in practice
- Underweights emotion, habit, and unconscious processes

---

## Hawkins Stern — Impulse Buying

**Originator**: Hawkins Stern (1962).
**One-line claim**: Not all consumer behaviour is rational deliberation; impulse buying is a distinct mode triggered by stimuli at point of purchase.
**Four types**: pure impulse · reminder impulse · suggestion impulse · planned impulse.

---

## Webster & Wind — Organisational Buying

**Originators**: Frederick Webster & Yoram Wind (1972).
**One-line claim**: Organisational buying is a group decision influenced by environmental, organisational, interpersonal (the buying centre), and individual factors.
**Best applied to**: B2B contexts, the buying centre concept (initiator, influencer, decider, buyer, user, gatekeeper).

---

## How to extend this file

When the user works through a chapter that introduces a CB model not listed here, append it using the structure:

1. Originator(s) and year
2. One-line claim
3. Best applied to
4. Key constructs / stages
5. Mermaid template
6. Standard criticisms
7. Exam-ready questions

Keeping the structure uniform is what lets every command in the skill consume the file consistently.
