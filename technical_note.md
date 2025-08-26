---
tags: "workflow"
---

# Technical Note

By “technical” we refer to notes which require a certain amount of technical knowledge to work through and then understand, as opposed to notes which are merely quotes and comments. Technical notes are often written by hand first and then typeset, while shallower notes are often typed in the first place. For subjects like physics and mathematics almost all notes are technical.

---

Technical notes investigate a topic in detail. This can be re-framed into “asking relevant questions concerning a topic, and then answering them in detail”. There could be multiple iterations of this Q&A process within a single piece of note. 

I usually start a technical note with motivation paragraphs, establishing the context against which the question to be considered is set. 

Then I would go on to discuss the question raised in the motivation paragraph in detail. In mathematics this is often organized in a “claim-proof” structure, but in other fields it is hard to categorize everything in the discussions as “proof” because qualitative arguments (which are not formally rigorous) and analogies are often invoked.

Therefore I do not like to write down the word “proof” explicitly before starting the discussion. After the motivation paragraph I simply let my inner dialogue run riot.

When the discussion yields some result I would explicitly write down a result paragraph. For math notes it is typically a theorem; for physics this paragraph is simply the summary of a result, which _could_ include qualitative descriptions.

After arriving at a result I take time to reflect on the Q&A session and make remarks. Remarks can also be qualitative arguments which, without understanding technical details, are hard to appreciate.

---

To sum up, a typical technical note consists of

1. motivation,
2. discussion,
3. results, and
4. remarks

In the context of Q&A, the motivation paragraph raises a question, the discussion and result sections answer it, and then the remark section reflects upon this Q&A process. 

In this knowledge garden, technical notes are usually structured as above, but the different parts may not be marked explicitly by a title (e.g. `## Motivation`). Instead, horizontal rules are inserted between different stages of narration, while titles indicate topics.

## Physics notes

A physical formalism (i.e. a “theory”) and its applications are often written in the same chapter in textbooks. This prevents the reader from separating the specifics from general considerations and postulates, so in my notes a formalism is often separated from its applications. 

Actually, it is often the case that a theory is elaborated _exclusively within the context of an example_. While one would always appreciate a good motivational part, that this part limits the scope of the whole note can be annoying, e.g. a chapter on the addition of angular momentum usually starts with the spin-1/2 example, but some books dwell on this particular case and provide nothing else.

My approach is to 

* take notes on the formalism without relying on its applications, and
* when only knowing about a specific case, take notes on this case only and refrain from naming the note as “some theory”.

## Computer science notes

In computer science, especially the less “theoretical” parts of it, logical reasoning is not usually the key. Instead the various concepts are often intertwined, one depending on another without having an overall pre-determined logical order.

My approach is to try my best in finding a good motivation, for a software cannot take shape without a solid motivation. The motivation is often that a tedious task can be automated with code in computer science. 

Anyway, I start with this motivation and bring up new concepts that it produces. But there are always cases where earlier concepts require later ones to elaborate, in such cases I don’t hesitate at all to mention the later ones (in wiki-links), since arranging them in a perfectly logical order is against the very nature of programs. Functionalities are developed with each other in mind, not in a rigid logical sequence.

A helpful way to make CS notes clearer is providing a glossary of technical terms. Besides, providing a [[minimum_working_example]] is also essential.