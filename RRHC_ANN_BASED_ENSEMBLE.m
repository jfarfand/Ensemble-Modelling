%% Random-Restar Hill Climbing
clear Samp_Pars Best_Sample Final_Cal Final_Val QsimFinal_Cal QsimFinal_Val
tic

%Choose sample: uncomment to select

%Gofs = sortrows(Gofs,1,{'descend'}); %For NSE sample
Gofs = sortrows(Gofs,4,{'descend'}); %For Pearson sample
%Gofs = sortrows(Gofs,5,{'ascend'}); %For Random sample

Lim_Sup=50; %Number of individual models to choose for combinnations 
Num_Elem=15; %Number of inputs to the ANN
Num_Comb=50; %Number of ensembles

 
for i=1:Num_Comb
Samp_Pars(i,1:Num_Elem)=randperm(Lim_Sup,Num_Elem);  
end
ii=1;
k=1; Tested(1,1:Num_Elem)=Samp_Pars(ii,1:Num_Elem);

for ii=1:size(Samp_Pars,1)
 j=0; 
 aux=[-9999, -9999, -9999, -9999];
while j<5
   if j>=1  
               Samp_Pars(i,1:Num_Elem)=randperm(Lim_Sup,Num_Elem);  
               Samp_Pars(ii,1:Num_Elem)=sort(Samp_Pars(ii,1:Num_Elem));
               Tested(k,1:Num_Elem)=Samp_Pars(ii,1:Num_Elem);              
               k=k+1;   
   end 
   vec1(ii,1:Num_Elem)= Gofs(Samp_Pars(ii,1:Num_Elem),5); 
   %create training set.                                
   Qsim=(Result_Cal(:,vec1(ii,1:Num_Elem))); 
   Qsim_Val=(Result_Val(:,vec1(ii,1:Num_Elem)));                         
 
%Train ANN
fold=2; %Number of trainings
Neurons=3; %Number of neurons
ANN_Ensemble([Qsim],[Qobs],fold,Neurons);

for count = 1:fold 
  function_names{count} = sprintf('ANN_Ensemble_%d',count);
  function_handles{count} = str2func( function_names{count} );
end

for i=1:fold 
 Y(:,i) =  function_handles{i}(Qsim');
end

for i=1:size(Y,1) 
Ym(i,:)=mean([Y(i,1:fold)]);
end
 
%Calculate goodness of fit
[NS1,WNSE1,WNSE_LOW1,RQ1]=multiple_gofs(Qobs,Ym,0);
CAL(ii,1:4)=[NS1,WNSE1,WNSE_LOW1,RQ1];
CAL(ii,5)=ii;


%Test Model
for i=1:fold
 Y_Val(:,i) =  function_handles{i}(Qsim_Val');
end
clear Ym_Val
for i=1:size(Y_Val,1) 
Ym_Val(i,:)=mean([Y_Val(i,1:fold)]);
end

%Calculate goodness of fit
[NS2,WNSE2,WNSE_LOW2,RQ2]=multiple_gofs(Qobs_Val(2:end),Ym_Val(2:end),0);
 VAL(ii,1:4)=[NS2,WNSE2,WNSE_LOW2,RQ2];
 VAL(ii,5)=ii; 
 
P=0;
    for i=1:4
        if VAL(ii,i)>aux(1,i)
            P=P+1 ;   
        end
    end

if P>=3
    aux(1,1:4)=VAL(ii,1:4);
    Best_Sample(ii,1:Num_Elem)=vec1(ii,1:Num_Elem);
    Final_Cal(ii,1:4)=CAL(ii,1:4);
    Final_Val(ii,1:4)=VAL(ii,1:4);
    QsimFinal_Cal(:,ii)=Ym;
    QsimFinal_Val(:,ii)=Ym_Val;
    
    j=0;
else
    j=j+1;  
end
    [ii,j];
end

end
toc
