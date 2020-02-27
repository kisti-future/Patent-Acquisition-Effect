par(mar = c(20,4,2,2))

barplot(t(as.matrix(TechAll[,c('ACQ1','ACQ11','ACQ101')])),beside=T,
        main = "Re-assigned patent counts by Technology fields (EPO)",
        names = TechAll$TECHN_FIELD,
        ylab = "patent count",
        las=2)
legend("topright",c('Group1','Group11','Group101'),fill=c('Dim Gray','Dark Gray','Light Gray'))
par(new=TRUE)
plot(TechAll$AbsR, type='b',axes=FALSE, ann = FALSE)

axis(side=4)
mtext("patent utilization rate", side = 4, line = -1)
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

### Figure 2

par(mar = c(16,4,2,4))

barplot(t(as.matrix(Agg_tech_STI[,c('GR0711','ACQ101')])),
        main = "",
        names = Agg_tech_STI$TECHN_FIELD,
        ylab = "patent count",
        las=2)
legend(31,110,c('Granted','Acquired'),fill=c('Dim Gray','Light Gray'),bty = "n")
legend(38,110,c('AbsR','ExtR'), pch = c(1,8),bty = "n")
par(new=TRUE)
plot(Agg_tech_STI$AbsR, type='b',axes=FALSE, ann = FALSE, ylim=c(0,0.6))

axis(side=4, pos = 36.5)
par(new=TRUE)
plot(Agg_tech_STI$ExtR, type='b', lty=2, pch = 8, axes=FALSE, ann = FALSE, ylim=c(0,0.6))

mtext("share of acquired/utilized patents", side = 4, line = -1)


### tech별로 aggregate
Agg_tech_STI<-aggregate(GR0711~TECHN_NR, data=AppTech_STI, mean)
Agg_tech_STI$ACQ101<-aggregate(ACQ101~TECHN_NR, data=AppTech_STI, mean)[,2]
Agg_tech_STI$ACQ_INC<-aggregate(ACQ_INC~TECHN_NR, data=AppTech_STI, mean)[,2]
Agg_tech_STI$AbsR<-aggregate(AbsR~TECHN_NR, data=AppTech_STI, mean)[,2]
Agg_tech_STI$ExtR<-aggregate(ExtR~TECHN_NR, data=AppTech_STI, mean)[,2]
Agg_tech_STI$TECHN_FIELD<-X2018R1_techn_list$TECHN_FIELD
Agg_tech_STI
plot(Agg_tech_STI$ExtR, Agg_tech_STI$AbsR)

Agg_tech_STI


### sec_size별로 aggregate
Agg_secsize_STI<-aggregate(GR0711~SEC_SIZE2, data=AppTech_STI, mean)
Agg_secsize_STI$ACQ101<-aggregate(ACQ101~SEC_SIZE2, data=AppTech_STI, mean)[,2]
Agg_secsize_STI$ACQ_INC<-aggregate(ACQ_INC~SEC_SIZE2, data=AppTech_STI, mean)[,2]
Agg_secsize_STI$AbsR<-aggregate(AbsR~SEC_SIZE2, data=AppTech_STI, mean)[,2]
Agg_secsize_STI$ExtR<-aggregate(ExtR~SEC_SIZE2, data=AppTech_STI, mean)[,2]
Agg_secsize_STI
plot(Agg_secsize_STI$ExtR, Agg_secsize_STI$AbsR)


### Figure 1

par(mar = c(10,4,2,4))

barplot(t(as.matrix(Agg_secsize_STI[,c('GR0711','ACQ101')])),
        main = "",
        names = Agg_secsize_STI$SEC_SIZE2,
        ylab = "patent count",
        las=2)
legend(9,240,c('Granted','Acquired'),fill=c('Dim Gray','Light Gray'),bty = "n")
legend(11,240,c('AbsR','ExtR'), pch = c(1,8),bty = "n")
par(new=TRUE)
plot(Agg_secsize_STI$AbsR, type='b',axes=FALSE, ann = FALSE, ylim=c(0,0.6))

axis(side=4, pos = 11.5)
par(new=TRUE)
plot(Agg_secsize_STI$ExtR, type='b', lty=2, pch = 8, axes=FALSE, ann = FALSE, ylim=c(0,0.6))

mtext("share of acquired/utilized patents", side = 4, line = -1)
