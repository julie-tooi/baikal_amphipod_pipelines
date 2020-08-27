#path_to = "/home/julie/study_IB/summer_baikal/total.txt"

#table_with_data <- read.table(file='/home/julie/study_IB/summer_baikal/total.txt', sep ='\t', header = FALSE)

library(ggplot2)
library(tidyr)
library(dplyr)

table_with_data <- read.table(file='/home/julie/study_IB/summer_baikal/total.tsv', header = FALSE)

data <- as_tibble(table_with_data)

data <- data %>% rename(
  reads = V1,
  biotype = V2,
  name = V3,
  sample = V4
) %>% mutate(percent = reads/all_reads_count)


data$biotype <- as.character(data$biotype)
data$sample <- as.character(data$sample)
data$name <- as.character(data$name)
