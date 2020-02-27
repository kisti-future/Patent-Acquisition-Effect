###
par(mar = c(20,4,2,2))

barplot(t(as.matrix(TechAll[,c('ACQ1','ACQ11','ACQ101')])),
        main = "Re-assigned patent counts by Technology fields (EPO)",
        names = TechAll$TECHN_FIELD,
        ylab = "patent count",
        las=2)
legend("topright",c('Group1','Group11','Group101'),fill=c('Dim Gray','Dark Gray','Light Gray'))
par(new=TRUE)
plot(TechAll$AbsR, type='b',axes=FALSE, ann = FALSE)

axis(side=4)
mtext("patent utilization rate", side = 4, line = -1)




### lmtechCPP_desc --> 최종 논문에 들어간 desc 추출용.
### AppltTech3 --> G1 G2는 이거??


tmp<-lmtechCPP_desc[,c('STD_NAME','TECHN_NR')]
tmp$cnt <- 1
tmp$TECHN_NR<-factor(tmp$TECHN_NR, levels = c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35"))
tech_stat_2019 <- aggregate(cnt ~ TECHN_NR, tmp, sum)

barplot(tech_stat_2019$cnt,
        main = "the number of buyers by Technology fields (EPO)",
        names = TechAll$TECHN_FIELD,
        ylab = "buyer count",
        las=2)

tmp<-lmtechCPP_desc[lmtechCPP_desc$Aty1 == 'ACQ1', c('STD_NAME','TECHN_NR')]
tmp$buyer <- 1
tmp$TECHN_NR<-factor(tmp$TECHN_NR, levels = c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35"))
tech_stat_2019$buyer <- aggregate(buyer ~ TECHN_NR, tmp, sum)$buyer

tech_stat_2019$nbyr <- tech_stat_2019$cnt - tech_stat_2019$buyer
tech_stat_2019$byrrat <- tech_stat_2019$buyer / tech_stat_2019$cnt * 100

### AppltTech3 --> G1 G2는 이거??
tech_stat_2019$ACQ_INC <- aggregate(ACQ_INC~TECHN_NR, AppltTech3, mean)$ACQ_INC
tech_stat_2019$ACQ_QRAT <- aggregate(ACQ_QRAT~TECHN_NR, lmtechCPP_desc, mean)$ACQ_QRAT

tech_stat_2019$GR_INC <- aggregate(GR_INC~TECHN_NR, AppltTech3, mean)$GR_INC
tech_stat_2019$Q_INC <- aggregate(Q_INC~TECHN_NR, lmtechCPP_desc, mean)$Q_INC

tech_stat_2019$TECHN_NR_FIELD <- with(tech_stat_2019,paste(TECHN_NR,TECHN_FIELD,sep = "."))

#### 논문 삽입 fig_new1 2019-4-1
par(mar = c(18,6,2,6))
barplot(t(as.matrix(tech_stat_2019[,c('buyer','nbyr')])),
#        main = "The ratio of buyers by technology fields (EPO)",
        names = tech_stat_2019$TECHN_NR_FIELD,
#        ylab = "The number of applicants",
        las=2, ylim = c(0,20000))
legend(33,18000,c('Buyer','Non-buyer'),fill=c('Dim Gray','Light Gray'),bty = "n")
legend(33.3,15000,c('Ratio'), pch = c(1,8),bty = "n")
par(new=TRUE)
plot(tech_stat_2019$byrrat, type='b',axes=FALSE, ann = FALSE, ylim=c(10,30))
axis(side=4)
mtext("Buyer ratio (%)", side = 4, line = -1.5)
mtext("The number of applicants", side = 2, line = -1.2)

tech_stat_2019$TECHN_FIELD <- data.frame(X2018R1_techn_list)$TECHN_FIELD
tech_stat_2019$TECHN_SECTOR <- data.frame(X2018R1_techn_list)$TECHN_SECTOR

lmtechCPP_desc$TECHN_NR<-factor(lmtechCPP_desc$TECHN_NR, levels = c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35"))


#### 논문 삽입 fig_new2
# Scatter Plot with Label 1 (ACQ) fig_new2 2019-4-1
ggplot(data=tech_stat_2019, aes(x=ACQ_INC, y=ACQ_QRAT, shape=TECH_SECTOR_WIPO)) + geom_point(size=3) +  geom_text(aes(label=TECHN_NR, size=1, vjust=-1, hjust=0.5)) + theme_light() + guides(size=FALSE)
TECH_SECTOR_WIPO<-factor(tech_stat_2019$TECHN_SECTOR)

# Scatter Plot with Label 2 (GR)  xxxxx
ggplot(data=tech_stat_2019, aes(x=GR_INC, y=Q_INC,shape=TECHN_SECTOR)) + geom_point(size=2) +  geom_text(aes(label=TECHN_NR, size=1, vjust=-1, hjust=0)) + theme_light()
