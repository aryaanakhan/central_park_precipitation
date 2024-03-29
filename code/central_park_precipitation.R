nyc_precipitation <- read.table("data/nyc_precipitation.txt",
             header = TRUE, sep = "\t", stringsAsFactors = FALSE)
head(nyc_precipitation)

str(nyc_precipitation)

## max
nyc_precipitation[, "max_precipitation"] <- apply(nyc_precipitation[, 2:13], 1, max)
## min
nyc_precipitation[, "min_precipitation"] <- apply(nyc_precipitation[, 2:13], 1, min)
## standard deviation
nyc_precipitation[, "sd_precipitation"] <- apply(nyc_precipitation[, 2:13], 1, sd)
head(nyc_precipitation)

## precipitation plot with sd, min, & max values
nyc_precipitation_plot <- ggplot(nyc_precipitation, aes(x = YEAR, y = ANNUAL)) +
                 geom_ribbon(aes(ymin = ANNUAL - sd_precipitation, ymax = ANNUAL + sd_precipitation), alpha = 0.2) +
                 geom_line(aes(x = YEAR, y = max_precipitation), colour = "red", linetype = "dotted") +
                 geom_line(aes(x = YEAR, y = min_precipitation), colour = "blue", linetype = "dotted") +
                 geom_line() +
                 labs(title="Central Park Precipitation Between 1860 to 2022", x="Year", y="Precipitation (Inches)") +
                 ylim(0, 90) +
                 theme_minimal()

nyc_precipitation_plot

## NYC precipitation plot and fit line loess
## geom_smooth() is used without specifying a method, so it defaults to the LOESS (Locally Estimated Scatterplot Smoothing) method
nyc_precipitation_plot_smooth <- ggplot(nyc_precipitation, aes(x = YEAR, y = ANNUAL)) +
                        geom_point(alpha = 0.7, size = 4) +
                        geom_smooth() +
                        labs(title="Central Park Precipitation Between 1860 to 2022", x="Year", y="Precipitation (Inches)") +
                        ylim(35, 65) +
                        theme_minimal()
nyc_precipitation_plot_smooth
#`geom_smooth()` using method = 'loess' and formula 'y ~ x'



## geom_smooth() is explicitly set to use the linear regression method (method=lm), which fits a straight line to the data
nyc_precipitation_plot_smooth_lm <- ggplot(nyc_precipitation, aes(x = YEAR, y = ANNUAL)) +
                        geom_point(alpha = 0.7, size = 4) +
                        geom_smooth(method=lm, se=FALSE) +
                        labs(title="Central Park Precipitation Between 1860 to 2022 - lm line and without se", x="Year", y="Precipitation (Inches)") +
                        ylim(35, 65) +
                        theme_minimal()
## I removed the confidence line change by setting in geom_smooth() --> se=FALSE
nyc_precipitation_plot_smooth_lm
#`geom_smooth()` using formula 'y ~ x'

# Create subsets and rename columns for multiple groupings
nyc_average <- subset(nyc_precipitation, select = c("YEAR", "ANNUAL"))
names(nyc_average) <- c("YEAR", "Precipitation (Inches)")
nyc_average$group <- "Average"

nyc_max <- subset(nyc_precipitation, select = c("YEAR", "max_precipitation"))
names(nyc_max) <- c("YEAR", "Precipitation (Inches)")
nyc_max$group <- "Maximum"

nyc_min <- subset(nyc_precipitation, select = c("YEAR", "min_precipitation"))
names(nyc_min) <- c("YEAR", "Precipitation (Inches)")
nyc_min$group <- "Minimum"

# Combine all data together
nyc_all <- rbind(nyc_average, nyc_max, nyc_min)

# Plotting
nyc_precipitation_plot_smooth_3 <- ggplot(nyc_all, aes(x = YEAR, y = `Precipitation (Inches)`, color = group)) +
                         geom_point(aes(color = group), alpha = 0.7, size = 4) +
                         geom_smooth(aes(color = group), alpha = 0.5) +
                         labs(title="Central Park Precipitation Between 1860 to 2022", x="Year", y="Precipitation (Inches)") +
                         ylim(15, 90) +
                         scale_color_manual(values = c("Maximum" = "red", "Minimum" = "green", "Average" = "lightblue")) +  # Set colors
                         theme_minimal()

nyc_precipitation_plot_smooth_3
#`geom_smooth()` using formula 'y ~ x'