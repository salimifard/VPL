function  NewTeam=CreateNewTeam(Team,Param)
n=size(Team,1);
NumberOfFall=Param.NumberOfFall;
NewTeam.Formation=zeros(Param.nPlayer,1);
NewTeam.Subsititude=zeros(Param.nPlayer,1);
NewTeam.Cost=[];

for i=1:NumberOfFall
    
    NewTeam.Formation(i)=Team(randi([1 n])).Formation(i);
    NewTeam.Subsititude(i)=Team(randi([1 n])).Subsititude(i);
    NewTeam.Cost=Param.CostFunction(NewTeam.Formation);
end

end