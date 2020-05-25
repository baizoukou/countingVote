# countingVote  -- input from the user will include both the votes ---

1. Your own choice.. You will need to discuss this with me and could be, for
instance, part of your final year project. (If you choose to do this, and
this work is evaluated towards this module, this will be mentioned in your
Final Year Project final report as the work cannot be double marked)


2. The (default) assignment as specified in the remainder of this document.

2 Single Transferable Vote
The single transferable vote (STV) is a voting system designed to achieve proportional representation through ranked voting in multi-seat constituencies.
You can see a good video here. You can look up lots on STV but from the
point of view of the assignment, we are interested in the preparation and counting of the votes.


2.1 Rules for counting votes
Specifically the rules for counting the votes for our election are:

1. All valid papers are grouped by first preference votes and candidates are
ordered in descending order of first preferences. Each vote is given a weight
of 1000.

2. The quota is calculated
quota = (number of valid votes
number of seats + 1 ) + 1

3. If, at the end of any count, a candidate has a total weight of votes greater
than the quota, then this candidate should be elected.
4. Calculate the total weight of transferable votes. If the total weight of
transferable votes is greater than the surplus, then transfer each of the
votes (to the continuing candidate indicated as the next available preference) with a reduced weight,
newweight = old weight ∗ (surplus total weight of transferable papers )

If the total weigh of transferable votes is less than or equal to the surplus,
transfer all votes in the bundle, leaving the weights unchanged.

5. If, at the end of any count, no candidate has reached the quota and
there are more continuing candidates than vacancies, a candidate must
be eliminated. Working backwards from the candidates with the lowest
weight, distribute the (eliminated) candidate’s votes, leaving the weights unchanged.

6. STOP when the number of elected candidates + then number of candidates remaining (uneliminated) = the number of seats. At this point
the remaining (unelected and uneliminated) candidates are deemed to be
elected ‘without reaching the quota‘.

2.2 Dealing with Invalid or Partially Invalid votes
A valid vote is a ordered list of preferences, starting at one, with each preference
contiguous and with no duplicates. So the following are not allowed:

1. Two candidates with the same preference (e,g vote → 1,2,3,3,4 - this should
be reduced to 1,2)

2. A break in preferences, e.g. vote → 1,2,4,5 (this should be reduced to 1,2)
Note that a ’cleaned’ vote using these rules may result in a reduction to an
empty vote. A fully empty vote is called a ’spoiled vote’

    TASK 
    
1. Take in data of the form as per this file (votes.csv) and clean and rearrange
the data ”as necessary”.

2. Write a Haskell program to count votes in an election (e.g. the sample
data) using

• Alternative Vote (as per Hutton). The output should be, (at least),
the winning candidate.

• Single Transferable Vote (as per Section 2). The output should be,
(at least), the list of elected candidates.

• As we introduce new concepts, these may be included, but the main
bulk of the work is defined in this document.

