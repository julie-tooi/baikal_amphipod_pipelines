#!/usr/bin/env Rscript

# Preparing: libraries check 
check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages<-c("ggplot2", "argparse", "dplyr", "reshape2", "tidyr", "tibble", "ggfortify", "Rtsne")
check.packages(packages)

parser <- ArgumentParser(description='Cluster analysis of input data')
parser$add_argument("-i", "--input", required=T, help="Path to file in tsv format")
parser$add_argument("-n", "--name", required=T,  help="Name of taxon or other description to name files")
parser$add_argument("-t", "--type", default="pavian", choices=c("pavian", "diamond"))
parser$add_argument("-o", "--output", help="Path to output directory")
parser$add_argument("-c", "--cluster", help="Number of clusters to k-means analysis")
args <- parser$parse_args()

input_data <- args$input
analysis_name <- args$name
type <- args$type
output_path <- args$output
number_of_clusters <- args$cluster

analysis_data <- read.table(file=input_data, sep = '\t', header = TRUE)

### PCA analysis ###

data_processing_to_long_format <- function(data){
  cols_check <- ncol(data)
  data[is.na(data)] <- 0
  data <- as_tibble(data) %>% select(!(cols_check-1):cols_check) %>% select(!2:5)
  data_mlt <- reshape2::melt(data, id.vars = "name")
  return(data_mlt)
}

preparing_to_pca <- function(long_data){
  pca_prep <- pivot_wider(long_data, 'variable')
  pca_prep$Place <- as.factor(ifelse(grepl("PB", pca_prep$variable), "Port Baikal", ifelse(grepl("UB", pca_prep$variable), "Ust-Barguzin", "Bolshiye Koty")))
  pca_prep$Species <- as.factor(ifelse(grepl("^Ecy", pca_prep$variable), "E.cyaneus", "E.verrucosus"))
  return(pca_prep)
}

filtering_data <- function(pca_prep){
  filtered_pca_prep <- pca_prep %>% filter(Place == "Port Baikal" | Place == "Bolshiye Koty") 
  filtered_pca_prep <- column_to_rownames(filtered_pca_prep, var = "variable")
  return(filtered_pca_prep)
}

pca_analysis <- function(filtered_pca_prep){
  cols_with_data <- ncol(filtered_pca_prep) - 2
  pca_result <- prcomp(filtered_pca_prep[2:cols_with_data], scale=TRUE)
  return(pca_result)
}

plot_pca <- function(pca_result, filtered_pca_prep, name){
  plot <- autoplot(pca_result, data = filtered_pca_prep, colour = 'Place', shape = 'Species', size = 4, frame = FALSE)+
    theme_bw()+
    labs(title = name, subtitle = 'PCA analysis')
  return(plot)
}

somedata <- plot_pca(pca_analysis(filtering_data(preparing_to_pca(data_processing_to_long_format(analysis_data)))), 
                     filtering_data(preparing_to_pca(data_processing_to_long_format(analysis_data))),
                     analysis_name)

ggsave(filename = "pca.png", path = output_path,
       plot = somedata,
       width = 250, height = 170, units = "mm")

### K-means clustering ###

kmeans_analysis <- function(pca_result, pca_prep, number_of_clusters){
  data_set <- pca_result$x
  fit_kmeans <- kmeans(data_set[,1:2], number_of_clusters)
  prep_analysis <- cbind(pca_prep, data_set)
  prep_analysis <- cbind(prep_analysis, fit_kmeans$cluster)
  prep_analysis$`fit_kmeans$cluster` <- as.factor(prep_analysis$`fit_kmeans$cluster`)
  prep_analysis <- prep_analysis %>% rename("Clusters" = `fit_kmeans$cluster`)
  return(prep_analysis)
}

plot_kmeans <- function(pca_result, prep_analysis, name){
  plot <- autoplot(pca_result, data = prep_analysis, colour = 'Place', shape = 'Species', size = 'Clusters', frame = FALSE)+
    theme_bw()+
    labs(title = name, subtitle = 'K-means clustering first two components after PCA analysis')
  return(plot)
}

somedata <- kmeans_analysis(pca_analysis(filtering_data(preparing_to_pca(data_processing_to_long_format(analysis_data)))), 
                     filtering_data(preparing_to_pca(data_processing_to_long_format(analysis_data))),
                     number_of_clusters)
somedata <- plot_kmeans(pca_analysis(filtering_data(preparing_to_pca(data_processing_to_long_format(analysis_data)))),
                        somedata, analysis_name)

ggsave(filename = "pca_kmeans.png", path = output_path,
       plot = somedata,
       width = 250, height = 170, units = "mm")

### tSNE analysis: all data ###

tsne_analysis <- function(filtered_pca_prep){
  cols_to_analysis <- ncol(filtered_pca_prep)-2
  matrix <- as.matrix(filtered_pca_prep[,1:cols_to_analysis])
  perplex <- floor((nrow(matrix)-1)/3)
  tsne <- Rtsne(matrix, check_duplicates = TRUE, pca = TRUE, perplexity=perplex, theta=0.5, dims=2)
  embedding <- as.data.frame(tsne$Y)
  embedding$Place <- as.factor(filtered_pca_prep$Place)
  embedding$Species <- as.factor(filtered_pca_prep$Species)
  return(embedding)
}

plot_tsne <- function(embedding, name){
  plot <- ggplot(embedding, aes(x=V1, y=V2, colour = Place, shape = Species))+
    geom_point(size=4)+
    theme_bw()+
    labs(title = name, subtitle = 'tSNE clustering with initial PCA analysis')+
    xlab("") + ylab("")
  return(plot)
}

somedata <- plot_tsne(tsne_analysis(filtering_data(preparing_to_pca(data_processing_to_long_format(analysis_data)))),
                      analysis_name)

ggsave(filename = "tsne.png", path = output_path,
       plot = somedata,
       width = 250, height = 170, units = "mm")
