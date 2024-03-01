library(data.table)
library(dplyr)
# seer <- fread("C:/Users/cjhet/Documents/export.txt", header=TRUE)
# 
# testis <- seer %>% filter(`Primary Site` == 620 | `Primary Site` == 621 | `Primary Site` == 629)
# write.csv(testis, "C:/Users/cjhet/Documents/testis.csv")
testis <- read.csv("C:/Users/cjhet/Documents/testis.csv", header = TRUE)
subset <- testis %>% select(1:12)

# NA's are recorded as "blank(s)", which isn't automatically detected
subset[subset == "Blank(s)"] <- NA

# change vars to factor or numeric where appropriate
jhet_clean_vars <- subset %>% 
    mutate(
    Sex = as.factor(Sex),
    Scope.Reg.LN.Sur = as.factor(RX.Summ..Scope.Reg.LN.Sur..2003..),
    Surg.Oth.Reg.Dis = as.factor(RX.Summ..Surg.Oth.Reg.Dis..2003..),
    Surg.Rad.Seq = as.factor(RX.Summ..Surg.Rad.Seq),
    Systemic.Sur.Seq = as.factor(RX.Summ..Systemic.Sur.Seq..2007..),
    Months.diag.to.treat = as.numeric(Months.from.diagnosis.to.treatment)
) %>% select(-c(3:12))
