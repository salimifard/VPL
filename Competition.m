function [x,y,BestTeam]=Competition(A,B,Team,Param,BestTeam)

[~,so]=sort([Team.Cost]);
mincost=Team(so(1)).Cost;
maxcost=Team(so(end)).Cost;
m=zeros(1,size((Team),1));
for i=1:size((Team),1)
    m(i)=(Team(i).Cost-maxcost)./(mincost-maxcost);
end
MA=m(A)/sum(m);
MB=m(B)/sum(m);
x=Team(A);
y=Team(B);

d=(MA)/(MA+MB);
r=rand();
if d>r
    [X,Y,BestTeam]=ApplyStrategy(x,y,Param,BestTeam);
    if X.Cost<x.Cost
        x=X;
    end
    if Y.Cost<y.Cost
        y=Y;
    end
else
    [Y,X,BestTeam]=ApplyStrategy(y,x,Param,BestTeam);
    if Y.Cost<y.Cost
        y=Y;
    end
    if X.Cost<x.Cost
        x=X;
    end
end

end