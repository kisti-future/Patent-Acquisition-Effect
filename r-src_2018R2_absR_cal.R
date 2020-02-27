### STI2018 - anova test예정
### Applts_finalm + Ind_selfcit2 ###

# APplts_finalm에서 Abs_Rate 만들기 위함 

Applts_final_STI<-merge(x=Applts_finalm, y=Ind_selfcit2,
                        by = 'STD_NAME', all.x = TRUE)
Applts_final_STI<-Applts_final_STI[order(-Applts_final_STI$GRANTS0711),]
View(Applts_final_STI)
# Bundle size 분리
--X2018R2도입

# 전체 AbsR
Applts_final_STI$AbsR<-Applts_final_STI$CC/Applts_final_STI$ACQ
Applts_final_STI$AbsR1<-Applts_final_STI$CC1/Applts_final_STI$ACQ1
Applts_final_STI$AbsR11<-Applts_final_STI$CC11D/Applts_final_STI$ACQ11D
Applts_final_STI$AbsR101<-Applts_final_STI$CC101D/Applts_final_STI$ACQ101D
Applts_final_STI[is.na(Applts_final_STI)]<-0

# Abs 유무
Applts_final_STI$Absyn<-"N"
Applts_final_STI[Applts_final_STI$CC>0,c('Absyn')]<-"Y"


### Box Plot for Abs ###

library(ggpubr)
library(ggplot2)
summary(Applts_final_STI)
levels(Applts_final_STI$SEC_SIZE) <- c( "COM.Large" , "COM.Medium" ,"COM.Small" , "Gov./Non-Prof.", "Hospital"    ,   "Individual"   ,  "Multiple"    ,   "University" ,    "Unknown")
### 현재 이거 ### (ACQ101로 바꿔서 다시 하자.)
ggplot(Applts_final_STI[Applts_final_STI$Aty1=="ACQ1",], aes(x=Absyn,y=GRANTS1216/(GRANTS0711+GRANTS1216)))+geom_boxplot(aes(fill = Absyn))+facet_grid(.~SEC_SIZE)+ theme_bw()+xlab("Self-citation or Not")+ylab("GR_INC")+theme(axis.text.x = element_text(size=16),text=element_text(size=20, family="serif"))+scale_fill_manual(values=c("white", "darkgrey"))+theme(legend.position="none")+stat_summary(fun.y="mean", geom="point", shape=8, size=3)

## size
boxplot(AbsR ~ APPLT_SIZE, data = AppTech_STI, main = "Absorption rate by applicant size", xlab = "Applicant size", ylab = "Absorption rate")
par(new=TRUE)
plot(Agg_tech_STI$AbsR, type='b',axes=FALSE, ann = FALSE, ylim=c(0,0.5))
sd(AppTech_STI$AbsR[AppTech_STI$APPLT_SIZE=='Small'])
par(new=TRUE)
plot(aggregate(AbsR~APPLT_SIZE, data=AppTech_STI, mean), type='b',axes=FALSE, ann = FALSE, ylim=c(0,1))

aggregate(AbsR~APPLT_SIZE, data=AppTech_STI, median)

## anova
library(DescTools)
# anova for applt_size
aov_sti_abs_asize<-aov(AbsR~APPLT_SIZE, data=AppTech_STI)
summary(aov_sti_abs_asize)
PostHocTest(aov_sti_abs_asize, method = "scheffe")

# anova for atype
aov_sti_abs_atype<-aov(AbsR~SEC_SIZE, data=Applts_final_STI[Applts_final_STI$Aty101=="ACQ101",])
summary(aov_sti_abs_atype)
PostHocTest(aov_sti_abs_atype, method = "scheffe")

aov_sti_abs_atype<-aob(AbsR~SEC_SIZE, data = AppTech_STI[])
# tech data로?
aov_sti_abs_atype2<-aov(AbsR~SEC_SIZE, data=AppTech_STI)
summary(aov_sti_abs_atype2)
PostHocTest(aov_sti_abs_atype2, method = "scheffe")

# 2,3-way of anova
aov_sti_abs_a<-aov(AbsR~APPLT_SIZE+SECTOR, data = AppTech_STI)
summary(aov_sti_abs_a)
PostHocTest(aov_sti_abs_a, method = "scheffe")
aov_sti_abs_a_t<-aov(AbsR~APPLT_SIZE+SECTOR+TECHN_NR, data = AppTech_STI)
summary(aov_sti_abs_a_t)
PostHocTest(aov_sti_abs_a_t, method = "scheffe")
aov_sti_abs_a_int<-aov(AbsR~APPLT_SIZE*SECTOR, data = AppTech_STI)
summary(aov_sti_abs_a_int)
PostHocTest(aov_sti_abs_a_int, method = "scheffe")
aov_sti_abs_a_t_int<-aov(AbsR~APPLT_SIZE*SECTOR*TECHN_NR, data = AppTech_STI)
summary(aov_sti_abs_a_t_int)
PostHocTest(aov_sti_abs_a_t_int, method = "scheffe")

## 결론적으로
aov_sti_abs_full<-aov(AbsR~APPLT_SIZE*SECTOR+TECHN_NR, data = AppTech_STI)
summary(aov_sti_abs_full)
PostHocTest(aov_sti_abs_full, method = "scheffe")

lm_sti_abs_full<-lm(AbsR~APPLT_SIZE*SECTOR+TECHN_NR, data = AppTech_STI)
summary(lm_sti_abs_full)

## atype-size -> SEC_SIZE2
aov_sti_abs_a2<-aov(AbsR~SEC_SIZE2, data = AppTech_STI)
summary(aov_sti_abs_a2)
PostHocTest(aov_sti_abs_a2, method = "scheffe")

## atype-size + techn
aov_sti_abs_full2<-aov(AbsR~SEC_SIZE2+TECHN_NR, data = AppTech_STI)
summary(aov_sti_abs_full2)
PostHocTest(aov_sti_abs_full2, method = "scheffe")
## anova는 는는 는는 는는....... 는는 는는 는는.

# aov tech
aov_sti_abs_techf<-aov(AbsR~TECHN_NR, data=AppTech_STI)
summary(aov_sti_abs_techf)
STI_tech_scheffe<-PostHocTest(aov_sti_abs_techf, method = "scheffe") ## 확실히 다른 분야가 몇 있는 정도.
## 기술별 특성 탐색 중 ##
STI_tech_scheffe$TECHN_NR[STI_tech_scheffe$TECHN_NR[,4]<0.05,]    # 몇군데만 다르고
aggregate(AbsR~TECHN_NR, data=AppTech_STI, mean)[c(2,3,4,5,6,13,16,35),]   # communications vs. medical !
# 혹시 외부 의존 특성은?
aov_sti_ext_techf<-aov(ExtR~TECHN_NR, data=AppTech_STI)
summary(aov_sti_ext_techf)
STI_tech_scheffe_ext<-PostHocTest(aov_sti_ext_techf, method = "scheffe") ## 확실히 다른 분야가 몇 있는 정도.
## 기술별 특성 탐색 중 ##
STI_tech_scheffe_ext$TECHN_NR[STI_tech_scheffe_ext$TECHN_NR[,4]<0.05,]    # 몇군데만 다르고
aggregate(ExtR~TECHN_NR, data=AppTech_STI, mean)[c(1,4,6,7,8,10,13,14,15,16),]   # communications vs. medical !

# anova for bundle size -> not significant!! 그래서... 지금부터는 ACQ101 기준으로. (즉, 전체 20193으로)

# anova for techn_field
   # start with AppltTech3

nrow(AppltTech3[AppltTech3$GR1216>0&AppltTech3$ACQ101>0,]) #30857
                          Selfcit_tech_a<-Selfcit_tech[,c(1,2,7)]
                          colnames(Selfcit_tech_a)<-c("STD_NAME","TECHN_NR","SCit")
AppTech_STI<-merge(x=AppltTech3[AppltTech3$GR1216>0&AppltTech3$ACQ101>0,c("STD_NAME","TECHN_NR","GR0711","GR1216","ACQ101","SEC_SIZE","APPLT_SIZE","GR_INC","ACQ_INC")],
                   y=Selfcit_tech_a,
                   by = c("STD_NAME","TECHN_NR"), all.x = TRUE)
summary(AppTech_STI)
AppTech_STI<-AppTech_STI[order(-AppTech_STI$GR0711),]
AppTech_STI[is.na(AppTech_STI)]<-0
AppTech_STI$AbsR<-AppTech_STI$SCit/AppTech_STI$ACQ101
AppTech_STI$ExtR<-AppTech_STI$ACQ101/(AppTech_STI$ACQ101+AppTech_STI$GR0711)


### 여기 중요! individual, multiple, unknown 삭제
AppTech_STI_all<-AppTech_STI
AppTech_STI<-AppTech_STI_all[AppTech_STI_all$SEC_SIZE!="Individual"&AppTech_STI_all$SEC_SIZE!="Multiple"&AppTech_STI_all$SEC_SIZE!="Unknown",]
length(unique(AppTech_STI$STD_NAME)) #10375
unique(AppTech_STI$SEC_SIZE)
nrow(AppTech_STI) #30686



plot(AbsR~ExtR, data = AppTech_STI) # 전반적으로 균일 분포.

STI_tech_means<-aggregate(AbsR~TECHN_NR, data=AppTech_STI, mean)
STI_tech_means$ExtR<-aggregate(ExtR~TECHN_NR, data=AppTech_STI, mean)$ExtR
STI_tech_means[34,2]
AppTech_STI$group<-0
## 4 groups 나누기 ##
for(i in 1:nrow(AppTech_STI)){
  TECHN_NR<-AppTech_STI[i,2] # TECHN_NR
  AbsRmean<-STI_tech_means[TECHN_NR,2]
  ExtRmean<-STI_tech_means[TECHN_NR,3]
  if(AppTech_STI[i,11]>=AbsRmean && AppTech_STI[i,12]>=ExtRmean) {AppTech_STI[i,13]<-1}
  else if(AppTech_STI[i,11]<AbsRmean && AppTech_STI[i,12]>=ExtRmean) {AppTech_STI[i,13]<-2}
  else if(AppTech_STI[i,11]<AbsRmean && AppTech_STI[i,12]<ExtRmean) {AppTech_STI[i,13]<-3}
  else if(AppTech_STI[i,11]>=AbsRmean && AppTech_STI[i,12]<ExtRmean) {AppTech_STI[i,13]<-4}
}
AppTech_STI$group<-factor(AppTech_STI$group)
summary(AppTech_STI)
## AbsG
AppTech_STI$AbsG<-0
AppTech_STI[AppTech_STI$group==1|AppTech_STI$group==4,"AbsG"]<-1
AppTech_STI$AbsG<-factor(AppTech_STI$AbsG)
# group별 gr_inc?
boxplot(GR_INC~group, data=AppTech_STI, main = "Grants increases by GROUPS",
        xlab = "GROUPS", ylab = "Ratio of Grants increases")
points(gr_means$group, gr_means$GR_INC, cex = 1.2, pch = 8)
gr_means<-aggregate(GR_INC~group, data=AppTech_STI, mean)
boxplot(GR_INC~AbsG, data=AppTech_STI, main = "Grants increases by Abs-GROUPS",
        xlab = "Abs-GROUPS", ylab = "Ratio of Grants increases")
gr_absg_means<-aggregate(GR_INC~AbsG, data=AppTech_STI, mean)
points(gr_absg_means$AbsG, gr_absg_means$GR_INC, cex = 1.2, pch = 8)
t.test(GR_INC~AbsG, data=AppTech_STI, var.equal=FALSE)


# anova for groups
aov_sti_gri_group<-aov(GR_INC~group, data=AppTech_STI)
summary(aov_sti_gri_group)
PostHocTest(aov_sti_gri_group, method = "scheffe")

# anova of gri for atype * tech * groups
aov_sti_gri_all<-aov(GR_INC~(SEC_SIZE+TECHN_NR)*AbsG, data=AppTech_STI)
summary(aov_sti_gri_all)
STI_all3_scheffe<-PostHocTest(aov_sti_gri_all, method = "scheffe")
View(STI_all3_scheffe)
STI_all3_scheffe$group

aov_sti_gri_all3<-aov(GR_INC~SEC_SIZE*AbsG+TECHN_NR, data=AppTech_STI)
summary(aov_sti_gri_all3)
aov_sti_gri_all2<-aov(GR_INC~(SEC_SIZE*TECHN_NR)*AbsG, data=AppTech_STI)
summary(aov_sti_gri_all2)

summary(anova(aov_sti_gri_all, aov_sti_gri_all3))

# plot for absr vs. grinc
plot(GR_INC~AbsR, data=AppTech_STI)


## atype * absG
ggplot(AppTech_STI[AppTech_STI$SEC_SIZE!="Individual"&AppTech_STI$SEC_SIZE!="Multiple"&AppTech_STI$SEC_SIZE!="Unknown",]
       , aes(x=AbsG,y=GR_INC))+geom_boxplot(aes(fill = AbsG))+facet_grid(.~SEC_SIZE)+ theme_bw()+xlab("Self-citation High-Low")+ylab("GR_INC")+theme(axis.text.x = element_text(size=16),text=element_text(size=20, family="serif"))+scale_fill_manual(values=c("white", "darkgrey"))+theme(legend.position="none")+stat_summary(fun.y="mean", geom="point", shape=8, size=3)
levels(AppTech_STI$SEC_SIZE) <- c( "COM.Large" , "COM.Medium" ,"COM.Small" , "Gov./Non-Prof.", "Hospital"    ,   "Individual"   ,  "Multiple"    ,   "University" ,    "Unknown")

## techf [c(2,3,4,5,6,13,16,35),]* absG 

ggplot(AppTech_STI[AppTech_STI$TECHN_NR=="2"|AppTech_STI$TECHN_NR=="2"|AppTech_STI$TECHN_NR=="3"|AppTech_STI$TECHN_NR=="4"|AppTech_STI$TECHN_NR=="5"|AppTech_STI$TECHN_NR=="6"|AppTech_STI$TECHN_NR=="13"|AppTech_STI$TECHN_NR=="16",]       , aes(x=AbsG,y=GR_INC))+geom_boxplot(aes(fill = AbsG))+facet_grid(.~TECHN_NR)+ theme_bw()+xlab("Self-citation High-Low")+ylab("GR_INC")+theme(axis.text.x = element_text(size=16),text=element_text(size=20, family="serif"))+scale_fill_manual(values=c("white", "darkgrey"))+theme(legend.position="none")+stat_summary(fun.y="mean", geom="point", shape=8, size=3)

## techf all * absG 
ggplot(AppTech_STI
       , aes(x=AbsG,y=GR_INC))+geom_boxplot(aes(fill = AbsG))+facet_grid(.~TECHN_NR)+ theme_bw()+xlab("Self-citation High-Low")+ylab("GR_INC")+theme(axis.text.x = element_text(size=16),text=element_text(size=20, family="serif"))+scale_fill_manual(values=c("white", "darkgrey"))+theme(legend.position="none")+stat_summary(fun.y="mean", geom="point", shape=8, size=3)

## SEC_SIZE2 * absG
ggplot(AppTech_STI, aes(x=AbsG,y=GR_INC))+geom_boxplot(aes(fill = AbsG))+facet_grid(.~SEC_SIZE2)+ theme_bw()+xlab("Self-citation rate: higher or lower than the average in the technology field")+ylab("GR_INC")+theme(axis.text.x = element_text(size=16),text=element_text(size=20, family="serif"))+scale_fill_manual(values=c("white", "darkgrey"))+theme(legend.position="none")+stat_summary(fun.y="mean", geom="point", shape=8, size=3)
levels(AppTech_STI$SEC_SIZE2) <- c( "COM.L***" , "COM.M***" ,"COM.S***" , "Gov/NP.L*", "Gov/NP.M*", "Gov/NP.S", "Hosp.M*", "Hosp.S","Univ.L" ,"Univ.M*","Univ.S**")

## SEC_SIZE2 그룹 내에서 t.test
sig<-rep(1,11)
for(i in c(1:11)){
ans<-t.test(GR_INC~AbsG, data=AppTech_STI[AppTech_STI$SEC_SIZE2==levels(AppTech_STI$SEC_SIZE2)[i],])
sig[i]<-ans$p.value
}
sig<0.5


levels(AppTech_STI$TECHN_NR)<-  Agg_tech_STI$TECHN_FIELD
levels(AppTech_STI$TECHN_NR)<-c(1:35)
levels(AppTech_STI$AbsG)<-c("L","H")

unique(unclass(AppTech_STI$TECHN_NR))
levels(AppTech_STI$TECHN_NR)

AppTech_STI[unclass(AppTech_STI$TECHN_NR)==2,]
factor
###########실패. archive #########


## 예전 boxplot 2개 ##
boxplot(temp_acq_group[,c("AbsR1","AbsR11D","AbsR101D")],main="Absorption rate by Assignment size", ylab = "Absorption rate", xlab="Assignment size(1:10, 11:100, 101:)")
boxplot(AbsR101 ~ SEC_SIZE, data = Applts_6gr[Applts_6gr$ACQ101>0,], main = "Absorption rate by applicant type (at least 1 acquisition) & large assign", xlab = "Applicant type", ylab = "Absorption rate")



# anova for bundle size
nrow(Applts_final_STI[Applts_final_STI$SEC_SIZE!="Individual"&Applts_final_STI$SEC_SIZE!="Multiple"&Applts_final_STI$SEC_SIZE!="Unknown"&Applts_final_STI$GRANTS0711>25&Applts_final_STI$ACQ1>0,]) # 18839
nrow(Applts_final_STI[Applts_final_STI$SEC_SIZE!="Individual"&Applts_final_STI$SEC_SIZE!="Multiple"&Applts_final_STI$SEC_SIZE!="Unknown"&Applts_final_STI$GRANTS0711>25&Applts_final_STI$ACQ11D>0,]) # 2512
nrow(Applts_final_STI[Applts_final_STI$SEC_SIZE!="Individual"&Applts_final_STI$SEC_SIZE!="Multiple"&Applts_final_STI$SEC_SIZE!="Unknown"&Applts_final_STI$GRANTS0711>25&Applts_final_STI$ACQ101D>0,]) # 294
    # group small bundle
y1<-Applts_final_STI[Applts_final_STI$SEC_SIZE!="Individual"&Applts_final_STI$SEC_SIZE!="Multiple"&Applts_final_STI$SEC_SIZE!="Unknown"&Applts_final_STI$GRANTS0711>25&Applts_final_STI$ACQ1>0,c('AbsR1')]
y2<-Applts_final_STI[Applts_final_STI$SEC_SIZE!="Individual"&Applts_final_STI$SEC_SIZE!="Multiple"&Applts_final_STI$SEC_SIZE!="Unknown"&Applts_final_STI$GRANTS0711>25&Applts_final_STI$ACQ11D>0,c('AbsR11')]
y3<-Applts_final_STI[Applts_final_STI$SEC_SIZE!="Individual"&Applts_final_STI$SEC_SIZE!="Multiple"&Applts_final_STI$SEC_SIZE!="Unknown"&Applts_final_STI$GRANTS0711>25&Applts_final_STI$ACQ101D>0,c('AbsR101')]
y<-c(y1,y2,y3)
n<-c(2570, 714,187)
group<-rep(1:3,n)
# combining into data.frame
group_df <- data.frame(y, group)
group_df <- transform(group_df, group = factor(group))
boxplot(y ~ group, 
        main = "Absorption rate by assignment bundle size", 
        xlab = "Assignment bundle size : 10, 100, ~", 
        ylab = "Absorption rate")
summary(cbind(y1,y2,y3))
## 결과 좋지 않음. indi. unknown, multiple 등 빼고 하자.
## 그래도 생각하던 것과 다름.
summary(temp_acq_group)
Applts_final_STIa<-Applts_final_STI[Applts_final_STI$ACQ>0,]
nrow(Applts_final_STIa) #20193
summary(Applts_final_STIa)

aov_sti_abs_bsize<-aov(y~group, data=group_df)
PostHocTest(aov_sti_abs_bsize, method = "scheffe")
