function [NS,WNSE,WNSE_LOW,KGE]=multiple_gofs(Qobs,Qsim,FIG)

% [NS,ANSE,KGE,RQ]
%[NS,WNSE,WNSE_LOW1,RQ]

%RMSE=nanmean((Qsim-Qobs).^2).^0.5;
% ANSE=1-nansum((Qobs+nanmean(Qobs)).*(Qsim-Qobs).^2)./...
% nansum((Qobs+nanmean(Qobs)).*(Qobs-nanmean(Qobs)).^2);
% % NS_radQ=1-nansum((sqrt(Qsim)-sqrt(Qobs)).^2)./nansum((sqrt(Qobs)-nanmean(sqrt(Qobs))).^2);
% % NS_lnQ=1-nansum((log(Qsim+0.00001)-log(Qobs+0.00001)).^2)...
% %     ./nansum((log(Qobs+0.00001)-nanmean(log(Qobs+0.00001))).^2);
% X=[Qsim,Qobs]; X(any(isnan(X)'),:) = [];
% RRQ=corrcoef(X); RQ=RRQ(2);

p=1; j=1; x=Qobs; y=Qsim;
for i=1:size(x,1)  
 if p<=0 
    x(x==0)= NaN; 
 end    
 if ~isnan(x(i,1)-y(i,1)) 
     Q1(j,1)=(x(i,1)-y(i,1)).^2;
     Q3(j,1)=x(i,1);
     j=j+1;
 else
     Q1(j,1)=NaN; Q3(j,1)=NaN;
 end
end

Q2=nansum(Q1); SUM=nansum(Q3.^p); w=(Q3.^p)./SUM;
Qm=w'*Q3; wmse=w'*Q1; wvar=w'*(Q3-Qm).^2;
WNSE=1-wmse/wvar;

p1=-1; j=1;
for i=1:size(x,1)  
 if p<=0 
     x(x==0)= NaN; 
 end    
 if ~isnan(x(i,1)-y(i,1)) 
     Q1(j,1)=(x(i,1)-y(i,1)).^2;
     Q3(j,1)=x(i,1);
     j=j+1;
 else
     Q1(j,1)=NaN; Q3(j,1)=NaN;
 end
end
Q2=nansum(Q1); SUM=nansum(Q3.^p1); w=(Q3.^p1)./SUM;
Qm=w'*Q3; wmse=w'*Q1; wvar=w'*(Q3-Qm).^2;
WNSE_LOW=1-(wmse)/wvar;  


p2=0; j=1;
for i=1:size(x,1)  
 if p<=0 
     x(x==0)= NaN; 
 end    
 if ~isnan(x(i,1)-y(i,1)) 
     Q1(j,1)=(x(i,1)-y(i,1)).^2;
     Q3(j,1)=x(i,1);
     j=j+1;
 else
     Q1(j,1)=NaN; Q3(j,1)=NaN;
 end
end
Q2=nansum(Q1); SUM=nansum(Q3.^p2); w=(Q3.^p2)./SUM;
Qm=w'*Q3; wmse=w'*Q1; wvar=w'*(Q3-Qm).^2;
NS=1-(wmse)/wvar;  

X=[Qsim,Qobs]; X(any(isnan(X)'),:) = [];
RRQ=corrcoef(X); RQ=RRQ(2);

%Kling & Gupta
kr=1; ka=1; kb=1; r=corrcoef(Qsim,Qobs,'rows','pairwise'); r1=r(1,2);
alpha=(nanstd(Qsim)/nanstd(Qobs)); beta=nanmean(Qsim)/nanmean(Qobs);
KGE=1-([kr*(r1-1)]^2+[ka*(alpha-1)]^2+[kb*(beta-1)]^2)^0.5;

S=[NS,WNSE,WNSE_LOW,KGE];


if FIG==1
altoizq=0.37; anchosup=0.4;
figure()
hAxis(1) = subplot(2,1,1);
pos = get( hAxis(1), 'Position' );
pos(1)=  0.08;                  
pos(2) = 0.59 ;                      
pos(3) = 0.49;   
pos(4) = altoizq ;                       
set( hAxis(1), 'Position', pos ) ;
hold on
l4=plot(Qobs,'LineWidth',1,'Color', '[1,0,0.25]');
hold on
l5=plot(Qsim,'LineWidth',0.4, 'Color', 'b'); 
title('Validation period');
ylabel('Streamflow (m^3/s)')
xlabel('Date')
tstart = datenum(2008,10,2,0,0,0);
tend = datenum(2013,10,1,0,0,0);
ylim([0 max(Qobs*1.2)]);
grid on; box on
hleg=legend( 'Observed discharge','Best fit model','Location',...
    'northwest','FontSize',7.5,'NumColumns',2);
hold off

hAxis(2) = subplot(2,1,2);
pos = get( hAxis(2), 'Position' );
pos(1)=  0.68;  %  IZQ o DER                   
pos(2) = 0.59 ;   % SUBIR o BAJA                      
pos(3) = 0.27;   % ancho
pos(4) = altoizq ;    % alto                    
set( hAxis(2), 'Position', pos ) ;
scatter(Qobs, Qsim,5,'filled','MarkerEdgeColor','[1,0,0.05]'...
    ,'MarkerFaceColor','[1,0,0.25]'); 
xlim([0 max(Qobs*1.2)]);
ylim([0 max(Qobs*1.2)]);
title('Validation period');
ylabel('Simulated streamflow (m^3/s)')
xlabel('Observed streamflow (m^3/s)')
get(gca,'fontname');  % shows you what you are using.
set(gca,'fontname','times');  % Set it to times
hold on
hline = refline([1 0]); hline.Color = 'k'  ; 
box on; grid on ; hold off


fig = gcf;
x0=10;
y0=10;
width=850;
height=500;
set(gcf,'position',[x0,y0,width,height]);
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];


end
 
end