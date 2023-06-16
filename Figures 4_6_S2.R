#Project: Crisis and Uncertainty: Did the Great Recession Reduce the Diversity of New Faculty?
#Code author: Kwan Woo Kim (kwanwookim@g.harvard.edu)
#Updated: June 15, 2023 (additional annotations)
#This script plots Figures 4, 6, and S2 based on the linear combination estimates 
#stored in lincom.xlsx after the main analysis ("main analysis.do")



library("dplyr")
library("ggplot2")
library("readxl")
library("wesanderson")
setwd("~/Recession and Diversity/Post acceptance/Replication_Github/Tables and Figures")

#Figure 4 (By Institutional Control)
lincom_ctrl<-read_excel("lincom.xlsx",sheet="TableS4")
lincom_ctrl$Period<-recode_factor(lincom_ctrl$period,"year_pre"="Pre","year_in"="Crisis","year_post"="Post")
lincom_ctrl$group<-recode_factor(lincom_ctrl$group,"White Women"="White women","White Men" = "White men", "Black Women" = "Black women", "Black Men" = "Black men", "Hispanic Women" = "Hispanic women", "Hispanic Men" = "Hispanic men", "Asian-American Men" = "Asian American men", "Asian-American Women" = "Asian American women")
lincom_ctrl$control<-factor(as.character(lincom_ctrl$type),ordered=TRUE,levels=c(1,2),labels=c("Public","Private"))
lincom_ctrl$group<-factor(lincom_ctrl$group,levels=unique(lincom_ctrl$group))
lincom_ctrl$order<-factor(lincom_ctrl$group, levels=c("White men", "White women", "Black men", "Black women", "Hispanic men", "Hispanic women", "Asian American men", "Asian American women"))

Fig4<-ggplot(data=lincom_ctrl, size=)+
  geom_hline(yintercept = 0, linetype=8, color="gray") +
  geom_pointrange(mapping=aes(x=Period, y=coefficient, ymin=lb, ymax=ub, group=control, color=control, shape=control), size=0.7, fatten=2.3, position = position_dodge2(width = 0.5, padding = 1)) + 
  facet_wrap(control~order , nrow=2, labeller = label_wrap_gen(width=17)) +
  scale_color_manual(values=c("blue", "red"))+
  ylab("Annual change in group share (odds)")+
  theme_bw() + theme(strip.text = element_text(size = 8, margin=margin(0.04, 0, 0.04, 0, "cm")), axis.text = element_text(size = 8), legend.title = element_blank(), legend.position = "bottom", legend.margin=margin(t = -0.3, unit='cm'), plot.margin=grid::unit(c(3,0,0,0), "mm"))+
  coord_fixed(ratio=25)
ggsave(
  filename="Figure4.png",
  plot = Fig4,
  device = NULL,
  path = NULL,
  width = 7.7,
  height = 3,
  scale = 1.3,
  units = c("in"),
  dpi = 300,
)

#Figure 6 (By Carnegie Group)
lincom_carn <- read_excel("lincom.xlsx", sheet="TableS5")
lincom_carn$Period<-recode_factor(lincom_carn$period, "year_pre"="Pre", "year_in"="Crisis", "year_post"="Post")
lincom_carn$group<-recode_factor(lincom_carn$group,"White Women"="White women","White Men" = "White men", "Black Women" = "Black women", "Black Men" = "Black men", "Hispanic Women" = "Hispanic women", "Hispanic Men" = "Hispanic men", "Asian-American Men" = "Asian American men", "Asian-American Women" ="Asian American women")
lincom_carn$Carnegie <- factor(lincom_carn$type, ordered=TRUE, levels = c(1, 2, 3), labels = c("R1", "R2/MA", "BA"))
lincom_carn$group <- factor(lincom_carn$group,levels=unique(lincom_carn$group))
lincom_carn$order = factor(lincom_carn$group, levels=c("White men", "White women", "Black men", "Black women", "Hispanic men", "Hispanic women", "Asian American men", "Asian American women"))

Fig6<-ggplot(data=lincom_carn, show.legend = FALSE)+
  geom_hline(yintercept=0, linetype=8, color="gray") +
  geom_pointrange(mapping=aes(x=Period, y=coefficient, ymin=lb, ymax=ub, group=Carnegie, color=Carnegie, shape=Carnegie), size=0.7, fatten=2.3, position = position_dodge2(width = 0.6)) + 
  facet_wrap(Carnegie~order, nrow=3, labeller = label_wrap_gen(width=17)) + 
  theme_bw() + 
  theme(strip.text = element_text(size = 9, margin=margin(0.04, 0, 0.04, 0, "cm")), axis.text.x = element_text(size = 9), axis.text.y = element_text(size = 9), legend.title = element_blank(), legend.position = "bottom", legend.margin=margin(t = -0.3, unit='cm'), plot.margin=grid::unit(c(3,0,0,0), "mm"))+
  scale_color_manual(values=c("blue", "red", "darkgoldenrod1"))+
  scale_shape_manual(values=c(16, 17, 15))+
  ylab("Annual change in group share (odds)")+
  coord_fixed(ratio=15)

ggsave(
  filename="Figure6.png",
  plot = Fig6,
  device = NULL,
  path = NULL,
  width = 7.5,
  height = 4,
  scale = 1.4,
  units = c("in"),
  dpi = 300,
)

#Figure S2 (CarnegieXControl)
lincom_cc <- read_excel("lincom.xlsx", sheet="TableS6")
lincom_cc$Period<-recode_factor(lincom_cc$period, "year_pre"="Pre", "year_in"="Crisis", "year_post"="Post")
lincom_cc$group<-recode_factor(lincom_cc$group,"White Women"="White women","White Men" = "White men", "Black Women" = "Black women", "Black Men" = "Black men", "Hispanic Women" = "Hispanic women", "Hispanic Men" = "Hispanic men", "Asian-American Men"="Asian American men", "Asian-American Women"="Asian American women")
lincom_cc$cc <- factor(lincom_cc$type, ordered=TRUE, levels = c(1, 2, 3, 4, 5, 6), labels = c("R1-Public", "R1-Private", "R2/MA-Public", "R2/MA-Private", "BA-Public", "BA-Private"))
lincom_cc$group <- factor(lincom_cc$group,levels=unique(lincom_cc$group))
lincom_cc$order <- factor(lincom_cc$group, levels=c("White men", "White women", "Black men", "Black women", "Hispanic men", "Hispanic women", "Asian-American men", "Asian-American women"))

Fig_cc<-ggplot(data=lincom_cc, show.legend = FALSE)+
  geom_hline(yintercept = 0, linetype=8, color="gray") +
  geom_pointrange(mapping=aes(x=Period, y=coefficient, ymin=lb, ymax=ub, group=cc, color=cc, shape=cc), size=0.5, position = position_dodge2(width = 0.6)) + 
  facet_wrap(cc~order, nrow=6) +
  scale_color_manual(values=c("blue", "#D32F2F", "#00AEBE", "#E65100", "green", "darkgoldenrod1"))+
  #scale_shape_manual(values=c(17, 16, 15))+
  ylab("Annual change in log ddds")+
  theme_bw()+theme(legend.position = "none")+
  coord_fixed(ratio=7)

ggsave(
  filename="FigureS2.png",
  plot = Fig_cc,
  device = NULL,
  path = NULL,
  width = 10,
  height = 6.5,
  scale = 1.3,
  units = c("in"),
  dpi = 300
)