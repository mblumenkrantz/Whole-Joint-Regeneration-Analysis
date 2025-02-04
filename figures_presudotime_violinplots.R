library(Seurat)

cds <- readRDS("~/cds.RDS")
subset_cds <- readRDS("~/subset_cds.RDS")

str(cds)

library(ggplot2)
library(dplyr)

# Extract pseudotime and dataset from `cds`
data <- data.frame(
  pseudotime = cds@principal_graph_aux$UMAP$pseudotime,
  dataset = cds@colData$dataset,
  seurat_clusters = cds@colData$seurat_clusters
)

ggplot(data, aes(x = dataset, y = pseudotime)) +
  geom_violin(fill = "lightgray", color = "black") +
  geom_boxplot(width = 0.1, outlier.shape = NA) +
  labs(
    title = "Pseudotime Distribution Across Datasets",
    x = "Dataset",
    y = "Pseudotime"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


####################################################################


filtered_data <- data %>%
  filter(pseudotime < 5, dataset == "3 dpjr")


ggplot(filtered_data, aes(x = factor(seurat_clusters))) +
  geom_bar(fill = "lightgray", color = "black") +
  labs(
    title = "Dataset '3 dpjr: pseudotime between 5 and 10'",
    x = "Seurat Clusters",
    y = "Count"
  ) + coord_flip() +
  theme_minimal()


filtered_data <- data %>%
  filter(pseudotime > 5 & pseudotime <10, dataset == "3 dpjr")

ggplot(filtered_data, aes(x = factor(seurat_clusters))) +
  geom_bar(fill = "lightgray", color = "black") +
  labs(
    title = "Dataset '3 dpjr: pseudotime between 5 and 10'",
    x = "Seurat Clusters",
    y = "Count"
  ) + coord_flip() +
  theme_minimal()


filtered_data <- data %>%
  filter(pseudotime > 5 & pseudotime <10, dataset == "7 dpjr")

ggplot(filtered_data, aes(x = factor(seurat_clusters))) +
  geom_bar(fill = "lightgray", color = "black") +
  labs(
    title = "Dataset '3 dpjr'",
    x = "Seurat Clusters",
    y = "Count"
  ) + coord_flip() +
  theme_minimal()


##################### subset_cds

data <- data.frame(
  pseudotime = subset_cds@principal_graph_aux$UMAP$pseudotime,
  dataset = subset_cds@colData$dataset,
  seurat_clusters = subset_cds@colData$seurat_clusters
)


ggplot(data, aes(x = dataset, y = pseudotime)) +
  geom_violin(fill = "lightgray", color = "black") +
  geom_boxplot(width = 0.1, outlier.shape = NA) +
  labs(
    title = "Pseudotime Distribution Across Datasets",
    x = "Dataset",
    y = "Pseudotime"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


####################################################################

filtered_data <- data %>%
  filter(pseudotime < 5, dataset == "3 dpjr")

# Create the bar plot
ggplot(filtered_data, aes(x = factor(seurat_clusters))) +
  geom_bar(fill = "lightgray", color = "black") +
  labs(
    title = "Dataset '3 dpjr'",
    x = "Seurat Clusters",
    y = "Count"
  ) + coord_flip() +
  theme_minimal()

