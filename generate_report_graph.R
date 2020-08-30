#path_to = "/home/julie/study_IB/summer_baikal/total.txt"

#table_with_data <- read.table(file='/home/julie/study_IB/summer_baikal/total.txt', sep ='\t', header = TRUE)

library(ggplot2)
library(tidyr)
library(dplyr)
library(waffle)
library(reshape2)

data_euk <- read.table(file='/home/julie/study_IB/summer_baikal/DATA/kraken/EUKphylum_prefilter_perc-reads1000.tsv', sep = '\t', header = TRUE)

cols_check <- ncol(data_euk)
data_euk[is.na(data_euk)] <- 0

data_euk <- as_tibble(data_euk) %>% select(!(cols_check-1):cols_check) %>% select(!2:4) %>% rename("Ecy_2_PB" = "EcyPB.2.cladeReads..", 
                                                                            "Ecy_3_PB" = "EcyPB.3.cladeReads..",
                                                                            "Eve_male_PB" = "EvePB_male.cladeReads..",
                                                                            "Eve_2_PB" = "EvePB.2.cladeReads..",
                                                                            "Eve_4_PB" = "EvePB.4.cladeReads..",
                                                                            "Eve_2018_2_UB" = "EveUB_2018_2.cladeReads..",
                                                                            "Eve_2018_3_UB" = "EveUB_2018_3.cladeReads..")
                                                                            #"P102_14g_UB" = "P.102.UB.1.4g.cladeReads..")

df.mlt <- melt(data_euk, id.vars = "name") 
#%>% mutate(place = if_else(ends_with("PB") ))
df.mlt$place <- as.factor(ifelse(grepl("PB$", df.mlt$variable), "PB", "UB"))
df.mlt$amphypoda <- as.factor(ifelse(grepl("^Ecy", df.mlt$variable), "Ecy", "Eve"))

theme_set(theme_bw())

ggplot(df.mlt %>% filter(place == "PB"), aes(x = variable, y = value, fill = amphypoda)) + 
  geom_bar(stat = "identity") +
  #ylim(0, 0.5) +
  labs(title="Reads percent by sample (Eve, Ecy from PB)") +
  facet_wrap(.~name, scales="free_y") +
  theme(axis.text.x=element_text(angle=90))

ggplot(df.mlt %>% filter(amphypoda == "Eve"), aes(x = variable, y = value, fill = place)) + 
  geom_bar(stat = "identity") +
  #ylim(0, 0.5) +
  labs(title="Reads percent by sample (Eve from PB, UB)") +
  facet_wrap(.~name, scales="free_y") +
  theme(axis.text.x=element_text(angle=90))

#waffle(df.mlt)

#if (!require(remotes)) { install.packages("remotes") }
#remotes::install_github("fbreitwieser/pavian")

pavian::runApp(port=5000)

data_bac <- read.table(file='/home/julie/study_IB/summer_baikal/DATA/kraken/BACphylum_prefilter_perc-reads1000.tsv', sep = '\t', header = TRUE)

cols_check <- ncol(data_bac)
data_bac[is.na(data_bac)] <- 0

data_bac <- as_tibble(data_bac) %>% select(!(cols_check-1):cols_check) %>% select(!2:4) %>% rename("Ecy_2_PB" = "EcyPB.2.cladeReads..", 
                                                                                                   "Ecy_3_PB" = "EcyPB.3.cladeReads..",
                                                                                                   "Eve_male_PB" = "EvePB_male.cladeReads..",
                                                                                                   "Eve_2_PB" = "EvePB.2.cladeReads..",
                                                                                                   "Eve_4_PB" = "EvePB.4.cladeReads..",
                                                                                                   "Eve_2018_2_UB" = "EveUB_2018_2.cladeReads..",
                                                                                                   "Eve_2018_3_UB" = "EveUB_2018_3.cladeReads..")
#"P102_14g_UB" = "P.102.UB.1.4g.cladeReads..")

df.mlt <- melt(data_euk, id.vars = "name") 
#%>% mutate(place = if_else(ends_with("PB") ))
df.mlt$place <- as.factor(ifelse(grepl("PB$", df.mlt$variable), "PB", "UB"))
df.mlt$amphypoda <- as.factor(ifelse(grepl("^Ecy", df.mlt$variable), "Ecy", "Eve"))

theme_set(theme_bw())

ggplot(df.mlt %>% filter(place == "PB"), aes(x = variable, y = value, fill = amphypoda)) + 
  geom_bar(stat = "identity") +
  #ylim(0, 0.5) +
  labs(title="Reads percent by sample (Eve, Ecy from PB)", 
       subtitle="why holy cat this is bacteria") +
  facet_wrap(.~name, scales="free_y") +
  theme(axis.text.x=element_text(angle=90))

ggplot(df.mlt %>% filter(amphypoda == "Eve"), aes(x = variable, y = value, fill = place)) + 
  geom_bar(stat = "identity") +
  #ylim(0, 0.5) +
  labs(title="Reads percent by sample (Eve from PB, UB)", 
       subtitle="why holy cat this is bacteria") +
  facet_wrap(.~name, scales="free_y") +
  theme(axis.text.x=element_text(angle=90))


















data_bac <- read.table(file='/home/julie/study_IB/summer_baikal/DATA/kraken/BACphylum_prefilter_perc-reads1000.tsv', sep = '\t', header = TRUE)

cols_check <- ncol(data_bac)
data_bac[is.na(data_bac)] <- 0

data_bac <- as_tibble(data_bac) %>% select(!(cols_check-1):cols_check) %>% select(!2:4) %>% rename("Ecy_2_PB" = "EcyPB.2.cladeReads..", 
                                                                                                   "Ecy_3_PB" = "EcyPB.3.cladeReads..",
                                                                                                   "Eve_male_PB" = "EvePB_male.cladeReads..",
                                                                                                   "Eve_2_PB" = "EvePB.2.cladeReads..",
                                                                                                   "Eve_4_PB" = "EvePB.4.cladeReads..",
                                                                                                   "Eve_2018_2_UB" = "EveUB_2018_2.cladeReads..",
                                                                                                   "Eve_2018_3_UB" = "EveUB_2018_3.cladeReads..")
#"P102_14g_UB" = "P.102.UB.1.4g.cladeReads..")

df.mlt <- melt(data_euk, id.vars = "name") 
#%>% mutate(place = if_else(ends_with("PB") ))
df.mlt$place <- as.factor(ifelse(grepl("PB$", df.mlt$variable), "PB", "UB"))
df.mlt$amphypoda <- as.factor(ifelse(grepl("^Ecy", df.mlt$variable), "Ecy", "Eve"))

theme_set(theme_bw())

ggplot(df.mlt %>% filter(place == "PB"), aes(x = variable, y = value, fill = amphypoda)) + 
  geom_bar(stat = "identity") +
  #ylim(0, 0.5) +
  labs(title="Reads percent by sample (Eve, Ecy from PB)", 
       subtitle="why holy cat this is bacteria") +
  facet_wrap(.~name, scales="free_y") +
  theme(axis.text.x=element_text(angle=90))

ggplot(df.mlt %>% filter(amphypoda == "Eve"), aes(x = variable, y = value, fill = place)) + 
  geom_bar(stat = "identity") +
  #ylim(0, 0.5) +
  labs(title="Reads percent by sample (Eve from PB, UB)", 
       subtitle="why holy cat this is bacteria") +
  facet_wrap(.~name, scales="free_y") +
  theme(axis.text.x=element_text(angle=90))
