%%% LECTURA DE LA RED 

load('RED.MAT');
edges(:,1)=red.nod_sal;
edges(:,2)=red.nod_ent;

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
