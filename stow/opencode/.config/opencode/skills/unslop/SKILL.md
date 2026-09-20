---
name: unslop
description: Remove AI writing patterns from prose. Applies automatically to all writing, editing, and review tasks involving AI-generated or edited text. Also triggers on requests to humanize, de-slop, or fix AI-sounding text.
license: GPL-3.0
---

# Unslop

Edit text to remove AI patterns. Preserve meaning, match intended tone. Never
substitute one AI pattern for another.

## Process

1. Scan for the patterns below.
2. Rewrite. Smallest possible edit per fix. Leave unchanged text byte-for-byte.
3. Self-audit after rewriting: "What makes this still sound AI-generated?"
   Fix remaining tells before returning.

## Preserve absolutely

These must survive unchanged: numbers, dates, prices, percentages, measurements,
proper nouns (names, companies, products, places), direct quotes, code, URLs,
citations, and technical identifiers. Do not weaken causal claims, negations,
scope qualifiers, or comparisons. Do not add claims, certainty, or conclusions.

---

## Content

### Vague attributions
"Experts believe," "industry reports suggest," "some critics argue," "research
shows," "studies indicate," "it is widely regarded." Name the source or cut the
claim.

### Superficial -ing clauses
Participial tails that pretend to analyze: ", highlighting…", ", showcasing…",
", underscoring…", ", fostering…", ", demonstrating…", ", reflecting…",
", signaling…", ", paving the way for…". Delete the clause. If the analysis
matters, give it its own sentence with actual reasoning.

### Throat-clearing openers
"Here's the thing:", "It turns out", "Let me be clear", "The truth is,",
"The uncomfortable truth is", "Let's dive in", "Let's unpack", "Let's explore",
"Let's break this down", "Here's what nobody tells you:", "It's no secret that".
State the point directly. Cut the opener entirely.

### Generic positive conclusions
"The future looks bright," "exciting times lie ahead," "only time will tell,"
"one thing is certain," "continues to evolve," "remains to be seen,"
"poised for growth." Replace with specific facts or cut.

### Numbered list inflation
Artificial list counts: "three key takeaways," "five things to know,"
"here are 7 reasons." Use a list only when the count itself communicates
something. Otherwise write the point directly.

---

## Language

### AI vocabulary (hard — always replace)
Word|Replace with
---|---
additionally|also, and
aforementioned|this, that
burgeoning|growing
crucial|important, key (or cut)
deep dive|analysis, detail
delve|examine, explain, look at
enhance|improve
fostering|building, encouraging
garner|get, earn
henceforth|from now on
interplay|(name the interaction directly)
intricate|detailed, complex
landscape (abstract)|situation, field
leverage|use
multifaceted|complex
myriad|many (or a specific number)
notwithstanding|despite, even with
nuanced|subtle, detailed
paramount|important, central
pertaining to|about, regarding
plethora|many, too many
pivotal|important, key
resonates/with|matters to
robust|strong, solid
showcase|show, demonstrate
spearhead|lead, start
streamline|simplify
tapestry (abstract)|(cut — it's never the right word)
testament (to)|proof, evidence, sign
therein|(restructure the sentence)
ubiquitous|common, everywhere
underscore|show, emphasize
utilize|use
whereby|(restructure the sentence)
vibrant|(cut or use a concrete adjective)

### Soft AI vocabulary (flag when clustered)
burgeoning, enduring, intricate, meticulous/ly, moreover, furthermore,
nevertheless, notable, noteworthy, paradigm, realm (of), robust, seamless,
sheds light, substrate (metaphorical), tapestry, underscoring, valuable,
vibrant, wedge (metaphorical)

### "Say is" — copula avoidance
"serves as," "stands as," "represents a," "constitutes a," "functions as a,"
"operates as a," "acts as a," "features a." Just say "is" or "has."

### "Not just X, but Y"
State Y directly. Drop the contrast scaffolding.

### Elegant variation (synonym cycling)
"The company… the firm… the organization… the enterprise." Pick one word,
repeat it. English expects repetition of key terms — forced variation is
more distracting than repetition.

### False ranges
"From X to Y, from A to B," "spanning everything from X to Y,"
"ranging from X to Y." Pick the most relevant items. If the range matters,
state the endpoints with actual data.

---

## Style

### Em dash ban
Zero em dashes. Use periods or commas. No en dashes or hyphen-as-dash
substitutes either.

### Colon restraint
Colons are fine before lists or examples. Not as mid-sentence connectors
for dramatic reveals. "The answer is: X" becomes "X."

### Boldface restraint
Do not bold every key term. Reserve bold for items that truly need visual
prominence, one or two per section at most.

### Inline header lists
A bold label + colon that restates the line: "**Performance:** performance
improved…" Convert to prose or a real heading. A bold lead-in ending in a
period, naming something, followed by genuinely new detail is fine.

### Title case headings
Use sentence case in body text. Proper nouns keep their caps.

### Decorative emojis
Remove from headings and bullets.

### Curly quotes
Replace with straight quotes.

---

## Tone

### Chatbot phrases
"I hope this helps!", "Let me know if…", "Of course!", "Certainly!",
"Great question!", "Happy to help," "I'd be happy to," "Sure thing!",
"as an AI assistant." Remove. These are artifacts of chatbot interaction,
not content.

### Sycophantic tone
"Great question! You're absolutely right!" Respond directly. Do not
compliment the prompt.

### Emphasis crutches
"Full stop." "Period." "Let that sink in." "Make no mistake."
"Read that again." "Trust me." "I promise." The content should stand on
its own.

### Novelty inflation
"A concept nobody's naming," "a problem nobody talks about," "the insight
everyone's missing," "what nobody tells you about." Describe the actual
concept. Do not claim novelty unless you can prove it.

---

## Structure

### Binary contrasts (false drama)
"It feels like X. It's actually Y." "X isn't the problem. Y is."
"Not because X. Because Y." State Y directly. Drop the foil.

### Dramatic fragmentation
"[Noun]. That's it. That's the [thing]." "X. And Y. And Z."
"This unlocks something. [Word]." Write complete sentences.

### Rule of three
Forcing ideas into groups of three. Use the natural number — two, one,
four, or whatever fits.

### Rhetorical question openers
"What does this mean for…?" "Why should you care?" Just make the point.

### Meta-commentary
"Hint:" "Plot twist:" "Spoiler:" "In this section we'll…"
"As we'll see…" "Let me walk you through…" Trust the text to speak
without announcing itself.

### Knowledge-cutoff disclaimers
"as of my last update," "based on my training data," "as of my
knowledge cutoff." These betray AI origin directly. Cut them.

### Acknowledgment loops
"You're asking about…" "To answer your question…" Just answer.

---

## Diction

### Active voice
Prefer active. Catch "is/are/was/were + past participle" and name the
actor. "Queries are validated" becomes "the compiler validates queries."
Passive is fine only when the actor is unknown or genuinely irrelevant.

### False agency
Do not give inanimate things human verbs. "The data tells us" becomes
"the data shows" or "from the data, we found." "The decision emerges"
becomes "someone decided." "The market rewards" becomes "buyers pay for."
Name the real actor or mechanism.

### Prefer the plain word
"utilize" → "use", "facilitate" → "help", "numerous" → "many",
"in the event that" → "if", "in order to" → "to",
"due to the fact that" → "because", "prior to" → "before",
"subsequent to" → "after", "the vast majority of" → "most",
"is able to" → "can", "at this point in time" → "now".

### Cut filler phrases
"it is important to note that," "it is worth noting," "it goes without
saying," "needless to say," "at the end of the day," "when it comes to,"
"in today's [X]," "in a world where," "with that said," "that being said,"
"all things considered," "by and large," "for the most part," "to be fair,"
"to be honest." Delete the phrase. The sentence works without it.

### Cut empty adverbs
"really," "very," "literally," "genuinely," "honestly," "simply,"
"actually," "deeply," "truly," "fundamentally," "inherently,"
"essentially," "absolutely," "extremely," "incredibly,"
"completely," "totally." Delete or use a stronger verb.

### Mannered prose
Aphorisms ("wire it or delete it"), rhetorical fragments for effect,
personified code ("the plan holds it"), stock framing phrases. Say what
you mean plainly.

### Over-compression
Dropped articles, verbless fragments, symbol-speak that makes the reader
decode instead of read. "Parser rejects bad date → exit 2, no write"
becomes "The parser rejects a bad date, exits with code 2, and writes
nothing." Write whole sentences with their articles and verbs.

### Excessive hedging
"could potentially possibly be argued that it might" becomes "may."
Pick a level of certainty and commit.

### Abstract metaphor nouns
Substrate, wedge, vector, locus, vantage, nexus, bedrock, scaffolding
(metaphorical), flywheel, north star, endgame, modality, harness (as
metaphor), surface (as in "API surface"). These read as technical but
almost always have plainer concrete words. "Substrate" becomes "base."
"Wedge in" becomes "add." "Vector" becomes "way" or "method."
"Harness" becomes "use." "Endgame" becomes "the last phase."
Pick the concrete word.