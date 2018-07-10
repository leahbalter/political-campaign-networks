% RUN THIS FIRST
% THEN commGeo.m
% THEN compCom.m

% elGeo.m and commGeo.m should be run *once* on each network
% commGeo.m finds the commuity identifiers, which may change if you run it
% again
% as such, once you decide what community identifiers you will be working
% with
% run *all* comparisons for communities using the same identifiers
% ie don't rerun compGeo.m between running compCom on different nodes
% because you'll get different results

% this is specifically for the geographic networks
% you need to have the states.mat file in the same directory for this
% script will prompt you for the edgelist .txt file
% script will prompt you for the year

% creates a graph object for the entire network: gGeoXXXX.mat (XXXX being year)
% creates a table of the weights of the edges: weightXXXX.mat
% if you want to run anything involving weights, that would be the 'weight'
% paramater
% creates a table of the values calculated *just* for the states:
% statesXXXX.mat

% to extract the attribute, say, 'wPageRank' from the entire graph g, you
% type:
% wpr = g.Nodes.wPageRank
% and wpr is the table of just that data 

% it writes the tables of values for all nodes to the .csv file:
% nodesXXXX.csv

% and just for the states to the .csv file:
% stateNodesXXXX.csv

% AFTER YOU RUN THIS
% you can run commGeo.m on the graph object g to get the community
% identifiers

% AFTER YOU RUN THAT
% you can run compCom.m on two graph objects that have the community
% identifiers embedded within them

fileName = input('Please enter the .txt edgelist file ', 's')
year = input('Please enter the year ');
year = num2str(year);

gitFileName = input('Please enter the git file location: ', 's')

tdfread(fileName, ' ');

el = [sendID state amount];
sendID = cellstr(sendID);
state = cellstr(state);

g = graph(sendID, state, amount);
weight = g.Edges.Weight;

deg = centrality(g, 'degree', 'Importance', weight);
g.Nodes.wDeg = deg;
deg = centrality(g, 'degree');
g.Nodes.deg = deg;

pagerank = centrality(g, 'pagerank', 'importance', weight);
g.Nodes.wPageRank = pagerank;
pagerank = centrality(g, 'pagerank');
g.Nodes.pageRank = pagerank;

eig = centrality(g, 'eigenvector', 'importance', weight);
g.Nodes.wEig = eig;
eig = centrality(g, 'eigenvector');
g.Nodes.eig = eig;

load('states.mat')
rowNames = table2array(g.Nodes(:,1));
ind = find(ismember(rowNames, states)); % and this is an index of all rows that have state value
gState = g.Nodes(ind,:);

save(strcat('gGeo', year, '.mat'), 'g');
save(strcat('states', year, '.mat'), 'gState');

writetable(g.Nodes, strcat('nodes', year, '.csv'));
writetable(gState, strcat('stateNodes', year, '.csv'));
writetable(g.Nodes, strcat(gitFileName, '\nodes', year, '.csv'))
writetable(gState, strcat(gitFileName, '\stateNodes', year, '.csv'))
clear
