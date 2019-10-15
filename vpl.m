%  Volleyball Premier League 
%
%  Source codes demo version 1.0                                                                      
%                                                                                                     
%  Developed in MATLAB R2014b Mac Version                                                               
%                                                                                                     
%  Author and programmer: Reza Moghdani & Dr Khodakaram Salimifard                                                        
%                                                                                                     
%  Any suggestion or question, please let us know-->>e-Mail: reza.moghdani@gmail.com                                                               
%                                                            salimifard@pgu.ac.ir  
%                                                   Phone No:+989177778337 (Reza Moghdani)
%                                                            +989173783899 (Dr Khodakaram Salimifard)
%  Main paper:it is submitted recently to Apply Soft Computing,  title:   Volleyball Premier League Algorithm                                                                                        
% This code is an excerpt from vpl.m and implements the key parts
% of the algorithm. It is intendend to be used for READING and
% UNDERSTANDING the basic flow and all details of the proposed algorithm
% Computational efficiency is sometimes disregarded.
%_______________________________________________________________________________________________
% You can simply define your cost function in a seperate file and load its handle to MyCost 
% The initial parameters that you need are:
%__________________________________________
% MyCost = @YourCostFunction
% nvar = number of your variables
% maxit = maximum number of iterations
% Leaguesize = number of search agents
% All VPL parameters can be defined in CreateParam.m

%%
clc;
clear;
close all;

%% Define Parameters
Param=CreateParam();
lb=Param.lb;
ub=Param.ub;
fobj=@(x) MyCost(x);
Leaguesize=Param.Leaguesize;
nPlayer=Param.nPlayer;
NumberOfFall=Param.NumberOfFall;
NumberOfTransportationTeam=Param.NumberOfTransportationTeam;
maxit=100;
%% Define Parameters
Param.CostFunction=fobj;
% CostFunction=@(x) MyCost(x);
% Param.CostFunction=CostFunction;
%% Initialazation
Empty_Team=CreateEmptyTeam();
Team=repmat(Empty_Team,Leaguesize,1);
BestCost=zeros(maxit,1);

Team=Initialized(Team,Leaguesize,Param);
%% Main Loop
nfeN=zeros(maxit,1);
[~,so]=sort([Team.Cost]);
% Team=Team(so);
g=Param.g;
BestTeam=Team(so(1));
for ii=1:maxit
    a=g-ii*((g)/maxit);
    timetable=League_timetable(Leaguesize);
    FinalTimeTable=timetable(:,2:end);
    for i=1:Leaguesize-1
        k=FinalTimeTable(:,i);
        for j=1:Leaguesize
            A=k(j);
            B=j;
            [x,y,BestTeam]=Competition(A,B,Team,Param,BestTeam);
            Team(A)=x;
            Team(B)=y;
        end
%         Learning phase
        [~,so]=sort([Team.Cost]);
        rank1=Team(so(1));
        rank2=Team(so(2));
        rank3=Team(so(3));
        for l1=1:Leaguesize
            U=Team(l1);
            
            r1=rand();
            r2=rand();
            H1=g*a*r1-a;
            G1=g*r2;
            Dx1=abs(G1*rank1.Formation-U.Formation);
            x1=rank1.Formation-Dx1.*H1;
            
            
            r1=rand();
            r2=rand();
            H2=g*r1-a;
            G2=g*r2;
            Dx2=abs(G2*rank2.Formation-U.Formation);
            x2=rank2.Formation-Dx1.*H1;
            
            r1=rand();
            r2=rand();
            H3=g*r1-a;
            G3=g*r2;
            Dx3=abs(G3*rank3.Formation-U.Formation);
            x3=rank3.Formation-Dx1.*H1;
            U.Formation=(x1+x2+x3)/3;
            U=simplebound(U,Param);
            U.Cost=Param.CostFunction(U.Formation);
            if U.Cost<Team(l1).Cost
                Team(l1)=U;
            end
            if BestTeam.Cost>Team(l1).Cost
                BestTeam=Team(l1);
            end
            [~,so]=sort([Team.Cost]);
            if BestTeam.Cost>Team(so(1)).Cost
                BestTeam=Team(so(1));
            end
        end
    end
%     falldown
    [~,so]=sort([Team.Cost]);
    Team=Team(so);
    Team(Leaguesize+1-NumberOfFall:Leaguesize)=[];
    NewTeam=repmat(Empty_Team,NumberOfFall,1);
    for k=1:NumberOfFall
        NewTeam(k)=CreateNewTeam(Team,Param);
        
    end
    Team=[Team;NewTeam];
%         Transportation
    TransportationIndex=randperm(Leaguesize,NumberOfTransportationTeam);
    
    for t=TransportationIndex
        S=Team(t);
        NumberOfTransportedPlayer=ceil(rand()*nPlayer);
        NumberOfTransportedFormPlayer=ceil(rand()*NumberOfTransportedPlayer);
        NumberOfTransportedSubsititudePlayer=NumberOfTransportedPlayer-NumberOfTransportedFormPlayer;
        SelectedForm=randperm(nPlayer,NumberOfTransportedFormPlayer);
        for tt=SelectedForm
            a1=Team(t).Formation(tt);
            TeamIndex=randi(Leaguesize);
            FormIndex=randi(nPlayer);
            a2=Team(TeamIndex).Formation(FormIndex);
            Team(t).Formation(tt)=a2;
            Team(t).Cost=Param.CostFunction(Team(t).Formation);
            Team(TeamIndex).Formation(FormIndex)=a1;
            Team(TeamIndex).Cost=Param.CostFunction(Team(TeamIndex).Formation);
        end
        SelectedSubsititude=randperm(nPlayer,NumberOfTransportedSubsititudePlayer);
        for ss=SelectedSubsititude
            a1=Team(t).Subsititude(ss);
            TeamIndex=randi(Leaguesize);
            SubsititudeIndex=randi(nPlayer);
            a2=Team(TeamIndex).Subsititude(SubsititudeIndex);
            Team(t).Subsititude(ss)=a2;
            Team(TeamIndex).Subsititude(SubsititudeIndex)=a1;
        end
        if Team(t).Cost>S.Cost
            Team(t)=S;
        end
    end  
    [~,so]=sort([Team.Cost]);
    Team=Team(so);
    if Team(so(1)).Cost<BestTeam.Cost
        BestTeam=Team(so(1));
    end
    
    BestCost(ii,1)=BestTeam.Cost;

    disp(['BestCost of Iteration ' num2str(ii) ' Is:' num2str(BestTeam.Cost)]);
    
end
