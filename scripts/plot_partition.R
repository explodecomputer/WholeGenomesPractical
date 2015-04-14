library(ggplot2)

bmi <- read.table("../results/bmi_partition.hsq", skip=25, nrows=22)
crp <- read.table("../results/crp_partition.hsq", skip=25, nrows=22)
hypertension <- read.table("../results/hypertension_partition.hsq", skip=49, nrows=22)

bmi$trait <- "BMI"
bmi$chr <- 1:22
crp$trait <- "CRP"
crp$chr <- 1:22
hypertension$trait <- "Hypertension"
hypertension$chr <- 1:22

dat <- rbind(bmi, crp, hypertension)

ggplot(dat, aes(y = V2, x = chr)) +
geom_point() +
facet_grid(. ~ trait) +
stat_smooth(method="lm", se=FALSE) +
labs(y = "Var explained", x="Chromosome")

