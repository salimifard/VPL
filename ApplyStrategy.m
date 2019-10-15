function [x,y,BestTeam]=ApplyStrategy(x,y,Param,BestTeam)

x=Strategy1_kt(x,Param,BestTeam);
if x.Cost>y.Cost
    x=Strategy1_rp(x,Param,BestTeam);
    if x.Cost>y.Cost
        x=Strategy1_su(x,Param,BestTeam);
    end
end

for i=1:numel(y.Formation)
    y.Formation(i)=rand()*BestTeam.Formation(i)+y.Formation(i);
end
y.Cost=Param.CostFunction(y.Formation);
if x.Cost<BestTeam.Cost
    BestTeam=x;
end
if y.Cost<BestTeam.Cost
    BestTeam=y;
end


end