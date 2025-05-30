%%% LECTURA DE LA RED DE ACTORES

load('ACTORES.MAT');
edges(:,1)=actores.actor_1_name;
edges(:,2)=actores.actor_2_name;



G = digraph(edges(:,1), edges(:,2)); 
G2 = graph(edges(:,1), edges(:,2));



[bins,binsizes] = conncomp(G2);
bins=bins';
binsizes=binsizes';
aux=max(binsizes);
nodeIDs_aux=find(binsizes(:)==aux);
nodeIDs=find(bins(:,1)==nodeIDs_aux);

H = subgraph(G,nodeIDs);
H=simplify(H);
%plot(H)

A= adjacency(H,'weighted') ;


%Obtención del flujo
n_aux=size(H.Nodes);
n=n_aux(1);
I=zeros(n,n);

for i=1:n
    for j=i+1:n
        I(i,j)=maxflow(H,i,j);
        I(j,i)=maxflow(H,j,i);
    end
end
