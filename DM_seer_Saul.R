
library(data.table)
library(dplyr)
set.seed(1479)

df <- fread("C:/data/export.txt")

# We should convert "Blank(s)" to "NA" at some point

a <- df[, 33:47] # Subsetting data
b <- a # For reference
rm(df)

colnames(a) <- gsub(" ", ".", colnames(a)) # replace spaces with periods
colnames(b) <- gsub(" ", ".", colnames(b))

# Three age variables... which do we want
table(a$`Age.recode.with.<1.year.olds.and.90+`) # looks clean

table(a$`Age.recode.with.single.ages.and.85+`) # if we decide we want this remove " years" and convert to numeric

table(a$`Age.recode.with.single.ages.and.90+`) # same as above

a$`Age.recode.with.single.ages.and.90+` <- gsub(" years", "",a$`Age.recode.with.single.ages.and.90+`) 

table(a$`Age.recode.with.single.ages.and.90+`)

a <- a %>% 
  mutate(
    `CS.Reg.Node.Eval.(2004-2015)` = as.numeric(`CS.Reg.Node.Eval.(2004-2015)`),
    `CS.Tumor.Size/Ext.Eval.(2004-2015)` = as.numeric(`CS.Tumor.Size/Ext.Eval.(2004-2015)`)
    )


table(a$`CS.Reg.Node.Eval.(2004-2015)`)
table(b$`CS.Reg.Node.Eval.(2004-2015)`) # Check recode

table(a$`CS.Tumor.Size/Ext.Eval.(2004-2015)`)
table(b$`CS.Tumor.Size/Ext.Eval.(2004-2015)`) # Check recode


table(a$Marital.status.at.diagnosis) # looks clean... Were non-answers replaced with 'Unknown'?
table(a$`Race.recode.(W,.B,.AI,.API)`) # Looks clean

table(a$`Race/ethnicity`) #Looks clean

a$Survival.months <- as.numeric(a$Survival.months)

table(a$Survival.months)
table(b$Survival.months) # Check recode

table(a$Survival.months.flag) # Looks clean

table(a$`Total.number.of.benign/borderline.tumors.for.patient`) # Looks clean, not sure if this variableis worth keeping due the distribution of responses

table(a$`Total.number.of.in.situ/malignant.tumors.for.patient`)

a$`Total.number.of.in.situ/malignant.tumors.for.patient` <- as.numeric(a$`Total.number.of.in.situ/malignant.tumors.for.patient`)

table(a$`Total.number.of.in.situ/malignant.tumors.for.patient`)
table(b$`Total.number.of.in.situ/malignant.tumors.for.patient`) # Checking recode

table(a$`Tumor.marker.1.(1990-2003)`) # Not sure how to treat these tumor marker variables, need a better understanding of what they are before deciding

table(a$`Tumor.marker.2.(1990-2003)`)

table(a$`Tumor.marker.3.(1998-2003)`)


## Changing names of variables we want to keep
a <- a %>% 
  mutate(
    age = `Age.recode.with.single.ages.and.90+`,
    cs.reg.node.eval.04.15 = `CS.Reg.Node.Eval.(2004-2015)`,
    cs.tumor.size.ext.eval.04.15 = `CS.Tumor.Size/Ext.Eval.(2004-2015)`,
    race.recode = `Race.recode.(W,.B,.AI,.API)`,
    race.ethnicity = `Race/ethnicity`,
    survival.months = Survival.months,
    survival.months.flag = Survival.months.flag,
    marital.status.at.diagnosis = Marital.status.at.diagnosis,
    benign.borderline.tumors = `Total.number.of.benign/borderline.tumors.for.patient`,
    situ.malignant.tumors = `Total.number.of.in.situ/malignant.tumors.for.patient`,
    tm.1.1990.2003 = `Tumor.marker.1.(1990-2003)`,
    tm.2.1990.2003 = `Tumor.marker.2.(1990-2003)`,
    tm.3.1998.2003 = `Tumor.marker.3.(1998-2003)`)

saul_semiclean_vars <- a %>% select(age, cs.reg.node.eval.04.15, cs.tumor.size.ext.eval.04.15,
                          race.recode, race.ethnicity, survival.months,
                          survival.months.flag, Marital.status.at.diagnosis, 
                          benign.borderline.tumors, situ.malignant.tumors,
                          tm.1.1990.2003, tm.2.1990.2003, tm.3.1998.2003)

