# Political Campaign Contribution Networks

This research began as a project for my Complex Network Science class (Math 168, UCLA, Spring 2018), which I have continued to study post-graduation. 

A network is a structure that comprises of entities and the relationships between them; if two entities in the network - two nodes of the network - are connected in some way, we say that there is an edge between those two nodes. An example of a social network is Facebook; each account is a node in the network, and friendships between accounts represent edges. Depending on how the network is defined, some edges may have more weight than other edges, thus representing the strength of those relationships.

In the project, I used data from the FEC (originally compiled by Andrew Waugh) to create committee-state bipartite networks in order to study senatorial general elections in 2008 and 2010. In this network, a node is a either a committee or a state, while an edge between a committee and a state signifies that the committee donated money to a senatorial general election candidate in that state, with the weight of the edge corresponding to the total sum of money that committee donated to candidates from that state. 

There's a class of metrics in network science called 'centrality measures', which try to identify the important nodes in a network; an example of such a metric is weighted PageRank. One of the most interesting results of this project is the relationship I found between weighted PageRank and states - states with contententious senetorial elections tended to have high weighted PageRank scores. This makes a lot of sense - interested parties tend to pour money into tossup races in an attempt to influence the outcome of the elections.

You can read the paper in it's entirety [here](https://github.com/leahbalter/political-campaign-networks/blob/master/Math%20168%20Project/utilizing-political-campaign%20(3).pdf), or see the slides for the associated presentation [here](https://github.com/leahbalter/political-campaign-networks/blob/master/Math%20168%20Project/Investigation%20of%20US%20Political%20Donation%20Data.pdf). 

I believe that the technique I used to study senatorial elections can be extended to other sorts of elections, including House races, presidential races, and primaries. I also believe that this research can probably be used to study the effects political campaign donations have on gerrymandering. 

The dataset for this project was obtained from the [FEC website](https://classic.fec.gov/finance/disclosure/ftpdet.shtml), using the 'Any Transaction from One Committee to Another,' 'Candidate Master', and 'Committee Master' files for 2000-2016. (Final dataset obtained 7/2/2018).

One of my main collaborators for this project is [Aviva Prins](https://avivaprins.github.io/). We both thank Professor Mason Porter for overseeing this project. 
