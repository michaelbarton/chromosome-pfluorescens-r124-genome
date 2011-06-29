#!/usr/bin/env Rscript

library(ggplot2)

locations <- read.csv('validate/locations.csv')


p <- ggplot(data = locations,
            aes(x=(orig_start + orig_stop),y=(rlct_start + rlct_stop)))
p <- p + geom_point()


png("validate/locations.png",width=400,height=400)
print(p)
graphics.off()
