library(data.table)
library(dplyr)
library(ggplot2)
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
    Months.diag.to.treat = ifelse(as.numeric(Months.from.diagnosis.to.treatment) == 0, "<1", "1+")
) %>% select(-c(3:12))
# The age and race/origin variables that were kept last assignment have now been removed, as we have better versions of the same information.
# After filtering by positive testicular cancer, the sex variable contains only male observations, but is being kept for now as a control variable.
# Months.diag.to.treat has an overwhelming amount of observations at 0, compared to every other number. Thus, we made it a binary variable.

summary(jhet_clean_vars)

# Because all of the variables are categorical now, statistics such as mean, median, and standard deviation are not applicable.
# Instead, we can see the frequency distributions above in count form, as well as visualized below.

#50522 rows
ggplot(jhet_clean_vars, aes(x=Scope.Reg.LN.Sur)) +
  geom_bar(aes(fill=Scope.Reg.LN.Sur)) +
  theme(axis.text.x=element_blank(),
        legend.text=element_text(size=6))
# This variable contains data relating to the scope of surgery done to regional lymph nodes. Most of the cases are "none", meaning no surgery was done.
# Besides NA, the next highest number of observations is in the 4+ lymph nodes removed category, followed by 1-3.
# From this we can discern that removal of lymph nodes is uncommon, but becomes more necessary the more positive nodes there are.

ggplot(jhet_clean_vars, aes(x=Surg.Oth.Reg.Dis)) +
  geom_bar(aes(fill=Surg.Oth.Reg.Dis)) +
  theme(axis.text.x=element_blank(),
        legend.text=element_text(size=6))

ggplot(jhet_clean_vars, aes(x=Surg.Rad.Seq)) +
  geom_bar(aes(fill=Surg.Rad.Seq)) +
  theme(axis.text.x=element_blank(),
        legend.text=element_text(size=6))

ggplot(jhet_clean_vars, aes(x=Systemic.Sur.Seq)) +
  geom_bar(aes(fill=Systemic.Sur.Seq)) +
  theme(axis.text.x=element_blank(),
        legend.text=element_text(size=6))

table(as.numeric(subset$Months.from.diagnosis.to.treatment))
ggplot(jhet_clean_vars, aes(x=Months.diag.to.treat)) +
  geom_bar(aes(fill=Months.diag.to.treat))
