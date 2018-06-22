% RUN AFTER elGeo.m
% RUN BEFORE compCom.m

% passes in a graph and a year
% does community detection using two algorithms from the bct toolbox:
% louvain and modularity maximization
% it would probably be a good idea to look up the algorithms for the paper
% stores the results as node attributes and saves the graphs in the
% directory by overwriting the old graph
% also overwrites the .csv files 
% returns the modified graph object with the community identifiers stored
% as an attribute/column in the g.Nodes table

function g = commGeo(g, year)
    year = num2str(year);
    a = adjacency(g);
    
     [com Q] = modularity_und(a);
     g.Nodes.com = com;
    [lcom lQ] = community_louvain(a);
    g.Nodes.lCom = lcom;
    
    load('states.mat')
    rowNames = table2array(g.Nodes(:,1));
    ind = find(ismember(rowNames, states)); % and this is an index of all rows that have state value
    gState = g.Nodes(ind,:);
    
    c1 = ['gGeo' year '.mat'];
    c2 = ['states' year '.mat'];
    save(c1, 'g');
    save(c2, 'gState');
    
    writetable(g.Nodes, strcat('nodes', year, '.csv'));
    writetable(gState, strcat('stateNodes', year, '.csv'));
end 