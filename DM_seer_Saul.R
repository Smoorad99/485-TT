library(dplyr)
library(ggplot2)

df <- read.csv("C:/data/testis.csv")

df[df == "Blank(s)"] <- NA

# We should convert "Blank(s)" to "NA" at some point

a <- df %>% select(1, 34:48) # Subsetting data
b <- a # For reference
rm(df)


# Three age variables... which do we want
table(a$`Age.recode.with..1.year.olds.and.90.`) # looks clean

table(a$`Age.recode.with.single.ages.and.85.`) # if we decide we want this remove " years" and convert to numeric

table(a$`Age.recode.with.single.ages.and.90.`) # same as above

a$`Age.recode.with.single.ages.and.90.` <- gsub(" years", "",a$`Age.recode.with.single.ages.and.90.`) 

table(a$`Age.recode.with.single.ages.and.90.`)

a <- a %>% 
  mutate(
    `CS.Reg.Node.Eval..2004.2015.` = as.numeric(`CS.Reg.Node.Eval..2004.2015.`),
    `CS.Tumor.Size.Ext.Eval..2004.2015.` = as.numeric(`CS.Tumor.Size.Ext.Eval..2004.2015.`)
    )


table(a$`CS.Reg.Node.Eval..2004.2015.`)
table(b$`CS.Reg.Node.Eval..2004.2015.`) # Check recode

table(a$`CS.Tumor.Size.Ext.Eval..2004.2015.`)
table(b$`CS.Tumor.Size.Ext.Eval..2004.2015.`) # Check recode


table(a$Marital.status.at.diagnosis) # looks clean... Were non-answers replaced with 'Unknown'?
table(a$`Race.recode..W..B..AI..API.`) # Looks clean

table(a$`Race.ethnicity`) #Looks clean

a$Survival.months <- as.numeric(a$Survival.months)

table(a$Survival.months)
table(b$Survival.months) # Check recode

table(a$Survival.months.flag) # Looks clean

table(a$`Total.number.of.in.situ.malignant.tumors.for.patient`)

a$`Total.number.of.in.situ.malignant.tumors.for.patient` <- as.numeric(a$`Total.number.of.in.situ.malignant.tumors.for.patient`)

table(a$`Total.number.of.in.situ.malignant.tumors.for.patient`)
table(b$`Total.number.of.in.situ.malignant.tumors.for.patient`) # Checking recode
 
# Not sure how to treat these tumor marker variables, need a better understanding of what they are before deciding
table(a$`Tumor.marker.3..1998.2003.`)


## Changing names of variables we want to keep
a <- a %>% 
  mutate(
    age = as.numeric(`Age.recode.with.single.ages.and.90.`),
    cs.reg.node.eval.04.15 = `CS.Reg.Node.Eval..2004.2015.`,
    cs.tumor.size.ext.eval.04.15 = `CS.Tumor.Size.Ext.Eval..2004.2015.`,
    race = `Race.recode..W..B..AI..API.`,
    race.ethnicity = `Race.ethnicity`,
    survival.months = Survival.months,
    survival.months.flag = Survival.months.flag,
    marital.status.at.diagnosis = Marital.status.at.diagnosis,
    situ.malignant.tumors = `Total.number.of.in.situ.malignant.tumors.for.patient`,
    tm.3.1998.2003 = `Tumor.marker.3..1998.2003.`)

# Other recodes
a <- a %>% mutate(
  situ.malignant.tumors = ifelse(situ.malignant.tumors == 1, "One tumor", ifelse(situ.malignant.tumors > 1, "More than one tumor", NA)),
  tm.3.1998.2003 = recode(tm.3.1998.2003, 
                          "0" = "None Done (SX)",
                          "2" = "Within normal limits (S0)",
                          "4" = "Range 1 (S1) <1.5 x upper limit of normal for LDH assay",
                          "5" = "Range 2 (S2) 1.5 – 10 x upper limit of normal for LDH assay",
                          "6" = "Range 3 (S3) >10 x upper limit of normal for LDH assay",
                          "8" = "Ordered, results not in chart",
                          "9" = "Unknown or no information",
                          "14" = " Blank")
)

saul_semiclean <- a %>% select(X, age,
                          race, survival.months,
                          marital.status.at.diagnosis, 
                          situ.malignant.tumors,
                          tm.3.1998.2003)
rm(a, b)

# EDA
summary(saul_semiclean)

# Checking distributions for variables
ggplot(saul_semiclean) +
  geom_histogram(aes(x = age))


ggplot(saul_semiclean) +
  geom_bar(aes(x = race))
# The vast majority of individuals with a tumor in their testis are white. 
# We checkecked the overall demographics of the seer data and found it was primarily white. 
# Because we do not have access to the counties in which the individuals reported from, it is difficult to gauge whether this is an issue or not.


ggplot(saul_semiclean) +
  geom_histogram(aes(x = survival.months))


ggplot(saul_semiclean) +
  geom_bar(aes(x = marital.status.at.diagnosis))

# Most patients were either married, or single (never married)

ggplot(saul_semiclean) +
  geom_bar(aes(x = situ.malignant.tumors))
# Changed to binary (One tumor or More than one tumor)


ggplot(saul_semiclean) +
  geom_bar(aes(x = tm.3.1998.2003))

# Tons of 'NA' values in tumor marker variables, probably in part do them not spanning all years.



## Checking if the gender of these codes are all male (they izz), this makes me more confident these are the right codes
# testis <- df %>% 
#   select(`Primary Site`, Sex) %>% 
#   filter(`Primary Site` == 620 | `Primary Site` == 621 | `Primary Site` == 629)