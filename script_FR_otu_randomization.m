clear;
%% load data
load HMP_Stool.mat;% taxonomic abundance and gcn
load HMP_ref_gcn.mat;% HMP reference gcn

ab_table_real=ab_table_Stool_real;
ko_table_real=ko_table_Stool_real;

%% Taxonomic diversity, Functional diversity, and Functional redundancy calculation
% filtering
ab_table_real=ab_table_real(:,sum(ab_table_real>0,1)>5);

% Real taxonomic profile
dij_real=pdist(ko_table_real,@distfun_WeightedJaccard);
[SD_real, FD_real, FR_real]=FDFR_Rao_q (ab_table_real, dij_real, 1);

% NULL-composition-1
Num_strain=size(ab_table_real,1);
ko_table_relabel=HMP_GCN_table(randperm(length(HMP_IMGid),Num_strain),:);
ko_table_relabel=ko_table_relabel(:,sum(ko_table_relabel,1)>0);
dij_relabel=pdist(ko_table_relabel,@distfun_WeightedJaccard);
[SD_NULL_relabel, FD_NULL_relabel, FR_NULL_relabel]=FDFR_Rao_q (ab_table_real, dij_relabel, 1);

% NULL-composition-2
ab_table_NULL_OTU1=OTU_table_random( ab_table_real, 4 );
[SD_NULL_OTU1, FD_NULL_OTU1, FR_NULL_OTU1]=FDFR_Rao_q (ab_table_NULL_OTU1, dij_real, 1);

% NULL-composition-3
ab_table_NULL_OTU2=OTU_table_random( ab_table_real, 5 );
[SD_NULL_OTU2, FD_NULL_OTU2, FR_NULL_OTU2]=FDFR_Rao_q (ab_table_NULL_OTU2, dij_real, 1);

%% Mann-Whitney U test
p_values_1=signrank( FR_real./ SD_real, FR_NULL_relabel./ SD_NULL_relabel);
p_values_2=signrank( FR_real./ SD_real, FR_NULL_OTU1./ SD_NULL_OTU1);
p_values_3=signrank( FR_real./ SD_real, FR_NULL_OTU2./ SD_NULL_OTU2);

q_values=mafdr([p_values_1,p_values_2,p_values_3],'BHFDR', true);

%% Figure
real_posi=1;
NULL_relabel_posi=2;
NULL_OTU1_posi=3;
NULL_OTU2_posi=4;

FR_real=[ FR_real./ SD_real];
g_FR_real=[ones(1,length( FR_real))*real_posi(1)];

FR_NULL_relabel=[ FR_NULL_relabel./ SD_NULL_relabel];
g_FR_NULL_relabel=[ones(1,length( FR_NULL_relabel))*NULL_relabel_posi(1)];

FR_NULL_OTU1=[ FR_NULL_OTU1./ SD_NULL_OTU1];
g_FR_NULL_OTU1=[ones(1,length( FR_NULL_OTU1))*NULL_OTU1_posi(1)];

FR_NULL_OTU2=[ FR_NULL_OTU2./ SD_NULL_OTU2];
g_FR_NULL_OTU2=[ones(1,length( FR_NULL_OTU2))*NULL_OTU2_posi(1)];

real_color=[59/255,59/255,59/255];
NULL_relabel_color=[0,0.45,0.74];
NULL_OTU1_color=[0.85,0.33,0.1];
NULL_OTU2_color=[0.47,0.67,0.19];

figure('position',[537 713 977/5*3/4 420*2/3]);
hold on;
boxplot(FR_real,g_FR_real,'color',real_color,'positions',real_posi,'width',0.35,'Symbol','.','OutlierSize',0.5);
boxplot(FR_NULL_relabel,g_FR_NULL_relabel,'color',NULL_relabel_color,'positions',NULL_relabel_posi,'width',0.35,'Symbol','.','OutlierSize',0.5);
boxplot(FR_NULL_OTU1,g_FR_NULL_OTU1,'color',NULL_OTU1_color,'positions',NULL_OTU1_posi,'width',0.35,'Symbol','.','OutlierSize',0.5);
boxplot(FR_NULL_OTU2,g_FR_NULL_OTU2,'color',NULL_OTU2_color,'positions',NULL_OTU2_posi,'width',0.35,'Symbol','.','OutlierSize',0.5);


set(gca,'fontsize',10)
set(gca,'XTickLabel',{' '});
set(gca,'ylim',[0.1,0.8]);
set(gca,'xlim',[-1,6]);
set(gca,'xtick',[]);










