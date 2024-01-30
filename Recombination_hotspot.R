
# Hotspot using recombination rates

B97_recomb <- read.table("B97_mareyout.txt", sep = " " , header = TRUE )

# manipulation of data
str(B97_recomb)
colnames(B97_recomb)[2] <- "chr" 
B97_recomb$chr <- sub("Chromosome ", "", B97_recomb$chr)

B97_recomb$chr <- as.integer(B97_recomb$chr)

B97F_recomb <- subset(B97_recomb, set == "B97F")[,c(2,4,7)]


# hotspot using recombination rates (adjust window size!) 

# Group the breakpoints by chromosome and window (0.2Mb)
B97F_phys_grouped <- B97F_recomb %>%
  group_by(chr) %>%
  mutate(window = ceiling(phys / 200000)) %>%
  group_by(window, .add = TRUE)


# First, remove the NA values from the "loess" column.
B97F_phys_grouped <- B97F_phys_grouped[!is.na(B97F_phys_grouped$loess), ]

# Group by "chr" and "window", and calculate the average loess per group.
B97F_mean_recomb_perwin <- B97F_phys_grouped %>%
  group_by(chr, window) %>%
  summarize(mean_recomb = mean(loess))



##############

### hotspot using genome average

# Calculate mean genome average recombination rates and the cutoff for hotspot detection
B97F_genome_recomb_rate <- mean(B97_recomb$loess, na.rm = T )
B97F_genome_recomb_rate

B97F_recombhotspot_cutoff <- 5 * B97F_genome_recomb_rate  #5-fold higher than genome average
B97F_recombhotspot_cutoff

# Identify the hotspots with mean recomnination rates 
B97F_recomb_hot_genome <- B97F_mean_recomb_perwin %>%
  ungroup() %>%
  group_by(chr, window) %>%
  filter(mean_recomb >= B97F_recombhotspot_cutoff)

B97F_recomb_hot_genome$chr_Window <- paste(B97F_recomb_hot_genome$chr, B97F_recomb_hot_genome$window, sep = "_")

dim(B97F_recomb_hot_genome)

#write.csv(B97F_recomb_hot_genome, "hotspot/B97F_recomb_hot_genome_0.2mb_5fold.csv", row.names = F )

