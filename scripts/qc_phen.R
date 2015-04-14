# Load in the raw phenotype data.
# This data might have outliers, non-normal distributions etc
# We have to clean the data before running the GWAS

load("../data/phen.RData")

# These data have been simulated based on distributions estimated from a Danish general population study
# For details of the simulation see simulation "../../data/scripts/construct_phen.R" script


####################
# Look at the data #
####################

head(phen) # Data on each phenotype
head(covars) # Data on each covariate, including 10 principal components
nrow(phen) # How many individuals

# There is no missing data
sum(is.na(phen))
sum(is.na(covars))





########################
# Clean and adjust BMI #
########################



	# Plot the distribution of BMI
	hist(phen$bmi, breaks=100)

	# We can see the distribution better by restricting the x axis:
	hist(phen$bmi, breaks=100, xlim=c(10,60))

	# We can test for skewness by plotting against theoretical quantiles from the normal distribution:
	qqnorm(phen$bmi)

	# And again but Log transforming:
	qqnorm(log2(phen$bmi))


# Make a new variable which is log transformed BMI
phen$lbmi <- log2(phen$bmi)

# Next remove the outliers
# If a value is 4 sd above or below the mean then we'll call it an outlier
index <- phen$lbmi < (mean(phen$lbmi) - 4*sd(phen$lbmi)) | phen$lbmi > (mean(phen$lbmi) + 4*sd(phen$lbmi))
phen$lbmi[index] <- NA

# How does the data look now?

	hist(phen$lbmi, breaks=100)
	qqnorm(phen$lbmi)


# BMI is weight / height^2
# If there is a systematic difference in height between males and females then BMI will have a systematic difference in variance between males and females

tapply(phen$lbmi, covars$sex, function(x) mean(x, na.rm=T))
tapply(phen$lbmi, covars$sex, function(x) sd(x, na.rm=T))

# Adjusting only the mean of BMI for sex will not remove this variance heterogeneity
# We can adjust for the variance heterogeneity due to sex here

phen$bmi_adjusted <- phen$lbmi

# scale males
index <- covars$sex==1
phen$bmi_adjusted[index] <- scale(phen$bmi_adjusted[index])

# scale females
index <- covars$sex==2
phen$bmi_adjusted[index] <- scale(phen$bmi_adjusted[index])

# No more association of mean or variance with sex
tapply(phen$bmi_adjusted, covars$sex, function(x) mean(x, na.rm=T))
tapply(phen$bmi_adjusted, covars$sex, function(x) sd(x, na.rm=T))

# Still looks normal

	hist(phen$bmi_adjusted, breaks=100)
	qqnorm(phen$bmi_adjusted)


# Scale the phenotype to have mean and sd prior to adjusting for sex
phen$bmi_adjusted <- phen$bmi_adjusted * sd(phen$lbmi, na.rm=T) + mean(phen$lbmi, na.rm=T)

# Which other covariates are associated with BMI?
cov_ <- as.matrix(covars[,-c(1:2)])
summary(lm(phen$bmi_adjusted ~ cov_))






########################
# Clean and adjust CRP #
########################


# CRP distribution

	hist(phen$crp, breaks=100)
	qqnorm(phen$crp)


# log transform

	hist(log(phen$crp), breaks=100)
	qqnorm(log(phen$crp))


# Looks like there is one major outlier but log transformation does a good job of making the rest of the samples normally distributed

# Create a new variable of log transformed CRP
# note: logging zero values is to be avoided!
table(phen$crp == 0) # No zero values here
phen$lcrp <- log2(phen$crp)

# Remove outlier
phen$lcrp[phen$lcrp > 5] <- NA

# Associated with covariates
summary(lm(phen$lcrp ~ as.matrix(covars[,-c(1:2)])))






################
# Hypertension #
################

# This is a binary trait
table(phen$hypertension) # This is a population study, and hypertension has high prevalence

# Perform logistic regression to test for association with covariates
summary(glm(I(phen$hypertension-1) ~ as.matrix(covars[,-c(1:2)]), family="binomial"))





############################
# Save adjusted phenotypes #
############################

# Select only the variables we want to save
# Family ID, Individual ID, BMI, CRP, Hypertension
phen2 <- with(phen, data.frame(fid, iid, bmi_adjusted, lcrp, hypertension))

# Write the phenotype and covariate data to text files so that they can be read by plink
write.table(phen2, "../data/phen.txt", row=F, col=F, qu=F)
write.table(covars, "../data/covs.txt", row=F, col=F, qu=F)
