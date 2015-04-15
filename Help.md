---
title: "Help"
output: 
  html_document:
    mathjax: default
    self_contained: false
runtime: shiny
---

## Quick Start

When you start this tool you will find yourself in the *Predicting* option of the Menu Bar, composed by the **Change Settings** side bar and the **prediction main area**.

Type or paste some words in the text box (*Enter your text*) and you will obtain a prediction below (*Main Prediction*). 

This prediction is the most likely one, but normally is not the only prediction obtained. You can check it in the drop down list (*Select next word*). In this list you'll find first the most likely words and, after, other possible words (if any).

You can select any word in this list and it will be added to your text, followed by a new automatic prediction. This operational mode is intended to resemble the way keyboards in portable devices present options for what the next word might be.

The menu Bar has another two options:

- *Help*: this help.
- *About*: a brief description of the context in which this work was done.


## Settings

When you check the box *Acces to settings* in the side bar *Change settings*, the available options will be showed:

- *Choose model:* four customized models are available.The first ones ('Blogs', 'News' and 'Twitter') were generated specifically for each corresponding text file provided in the Capstone. The fourth one ('Global') was built from a mix of the previous three and aims to provide a 'general' model.
- *Options:*
    + *Use interpolation?*: select which prediction algorithm to use, *back off + interpolation* or *simple back off*. 
    + *Final Sample?*: when checked, the word predicted is not the most likely, but the result of a sample using frequencies as weigths. This option is just for fun, as it allows to get (more) bizarre phrases.
    + *Detailed results?*: when checked, the results Table Frequency List is showed.
- *Max. Predictions:*: choose the maximum number of posible next words to show.


You can learn more about these options in Help -> Inside the Box

## Tags

Soon you'll notice some strange "words" are employed: `<stx>`, `<etx>`, `<unk>`, `<num>`, `<hashtag>`,...

They are labels or seudowords introduced when processing texts:

- `<stx>`, `<etx>` (Start of TeXt and End of TeXt) are added at the beginning and the end of lines to normalize the construction of N-grams.
- `<unk>` stands for unknown words, i.e., out of vocabulary words not included in the model dictionary.
- `<num>` and `<hashtag>` are labels to substitute classes of words as numbers and hashtags.

More info on tags in Help -> Inside the Box


