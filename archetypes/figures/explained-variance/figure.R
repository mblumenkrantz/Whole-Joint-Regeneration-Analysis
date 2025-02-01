library(ggplot2)
library(grid)


rss_data <- read.csv("~/rss_data.csv")
rss_data$RSS_normalized <- ave(rss_data$RSS, rss_data$j, FUN = function(x) x / x[1])*100
mean_rss <- aggregate(RSS_normalized ~ k, data = rss_data, FUN = mean)
mean_rss$first_derivative <- c(NA, diff(mean_rss$RSS_normalized))


inset_plot <- ggplot(mean_rss, aes(x = k, y = first_derivative)) +
  geom_line(color = "blue") +
  geom_point(color = "blue", size = 2) +
  labs(x = "Number of archetypes (k)", y = "Δ(RSS)") +
  scale_x_continuous(breaks = c(0, 5, 10, 15, 20, 25, 30)) +  # Set custom x-axis breaks
  theme_bw() + 
  ggtitle("Rate of Change in Variance Explained (ΔRSS)\nby Number of Archetypes (k)") +
  theme(
    title = element_text(size = 8),
    axis.title = element_text(size = 8),
    axis.text = element_text(size = 8),
    plot.background = element_rect(colour = "black", fill = "white", size = 1)
  )

main_plot <- ggplot(rss_data, aes(x = k, y = RSS_normalized)) +
  geom_jitter(color = "darkgrey", size = 2, alpha = 0.5, width = 0.1) +  # Add jitter for individual points
  geom_point(data = mean_rss, aes(x = k, y = RSS_normalized), color = "red", size = 4, pch = "x") +  # Mean points in red
  scale_y_continuous(limits = c(0, NA)) +  
  labs(x = "Number of archetypes (k)", y = "(RSS[K] / RSS[1]) × 100") +
  scale_x_continuous(breaks = 1:30) + 
  ggtitle("Normalized Variance Explained by Archetypes (%) versus Number of Archetypes (k)") +
  theme_bw() + 
  theme(
    title = element_text(size = 8),
    axis.title = element_text(size = 8),
    axis.text = element_text(size = 8)
  )


combined_plot <- main_plot + 
  annotation_custom(
    grob = ggplotGrob(inset_plot), 
    xmin = 1, xmax = 23, ymin = 0.0, ymax = 45  
  )


