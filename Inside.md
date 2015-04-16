# Inside the Box

The following guidelines have been followed to build the models and implement algorithms (main reference: [Speech and Language Processing.][1]:

1- **Divide corpus** (en_US.blogs.txt, en_US.news.txt and en_US.twitter.txt) into 2 disjoint and randomized sets:

  - Training set
  - Test set
  
2- **Training**

  - Add **seudowords** for 2 and 3-wordgrams at the extremes of sentences.
  - Deal with **zeros** (things that don't occur in the training set but do occur in the testing set, i.e., **unknown** words or **out of vocabulary (OOV) words**.) **Open vocabulary** system strategy where we model these potential unknown words in the test set by adding a pseudo-word called `<unk>`. 
  - **Backoff** strategy
  
3- **Predict**

A - *Simple back off algorithm*

From N-wordgrams Term Document Matrices we can build N-wordgrams count tables. They will be very sparse (many of the cells will be zero, i.e., not seen N-wordrams). We can transform these N-wordgrams count tables to N-wordgrams probability tables.

The algorithm is as follows:

- Take as input N-1 words
- Use them to:
    + Return the most frequent word (or sample one if 2 or more have the same frequency). This is the default mode.
    + Or sample 1 word from the N-1 bigram row in the N-wordgram probability table taking the probabilities in this row as weigths:

Next word = sample(colnames, 
                   size = 1, prob = probabilities in the row of N-1 bigram)
                   
This is the finalSample mode.
                   
Back off: If the N-1 bigram is not found  in the  N-wordgram probability table, repeat the process with the  N-2 wordgram probability table and with the N-2 last input words (and so on).

If we arrive to the unigram probability table and no result is found, return "Next word probably not in my training dictionary" (i.e., `<unk>`).


B - *Back off + Interpolation algorithm*

Till now, predictions are made with a simple backoff algorithm:

- We have a model with 4 tables (1,2,3 and 4 Grams). Each N-Gram has an asociated conditional probability. For example, the probability associated to the 4-gram WG1, WG2, WG3, WG4 is the probability to find the token WG4 once the trigram WG1, WG2,WG3 has appeared.
- When trying to predict the next word following  the trigram WG1, WG2, WG3, the algorithm first searches the 4-Gram Table. If one or more matches are found, we restringe the possible next word to one of the WG4s found. One is selected according to the associated conditonal probabilities (or sampled, if more than one word have the same maximum conditional probability). 
- If no 3gram matches are found in the 4gram table, we back off to the 3gram table and repeat the process just with a bigram (WG2,WG3). An so on.

Now we wanna use interpolation. We begin as before, searching the 4gram table. Suppose we have the trigram WG1, WG2, WG3 and some matches are found in the 4gram table: WG1,WG2,WG3,X, WG1,WG2,WG3,Y and WG1,WG2,WG3,Z. Now we'll calculate the probabilities as

P(X) = l4 * F4(X/WG1,WG2,WG3) + l3 * F3(X/WG2, WG3) + l2 * F2(X/WG2) + l1 * F1(X)

We have to look for F4(X/WG1,WG2,WG3) in the conditional probabilities of the 4gram table, F3(X/WG2, WG3) in the trigrams table, F2(X/WG2) in the bigrams table and F1(X) in the unigrams table.

And need to give values to l1, l2, l3 and l4.

To do that, we have optimized them in order to minimize perplexity in an statistically significant sample of the text.


4- **Test** and **Evaluate model**

In order to test the accuracy of our different models, we have generated a 4-gram Table Frequency List from samples of our *testing* files. We used the first three tokens of each 4-gram in the testing TFL as input to our models, get a prediction and check if it's the same as the fourth token in the testing TFL.

These are the accuracy results for Back Off without interpolation (95% confidence interval):

```
    Model Final.Sample Inf.Conf.Int      Mean Sup.Conf.Int
1   Blogs        FALSE   0.15538223 0.1700844    0.1847865
2    News        FALSE   0.17186188 0.1930233    0.2141848
3 Twitter        FALSE   0.20711630 0.2417489    0.2763814
4   Total        FALSE   0.18014464 0.1935198    0.2068949
```

And these are the results for Back Off with interpolation (95% confidence interval):

```
    Model Final.Sample Inf.Conf.Int      Mean Sup.Conf.Int
1   Blogs        FALSE    0.1670763 0.1765033    0.1859303
2    News        FALSE    0.1761051 0.1962604    0.2164157
3 Twitter        FALSE    0.2287575 0.2615932    0.2944289
4   Total        FALSE    0.1994341 0.2239056    0.2483770
```

## R code
You can find the R code used for this work in GitHub:

- [Modelling][2]
- [Shiny app][3]



[1]:https://lagunita.stanford.edu/c4x/Engineering/CS-224N/asset/slp4.pdf
[2]:https://github.com/miguel-conde/DSC_Models
[3]:https://github.com/miguel-conde/DSC_Project
