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
    Surg.Rad.Seq = as.factor(ifelse(RX.Summ..Surg.Rad.Seq == "No radiation and/or cancer-directed surgery", "None", "Surg and or rad")),
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
# Surg.Oth.Reg.Dis stands for "surgery to other distant regions", and over ~42,000 out of 50,000 observations are in the "none/diagnosed at autopsy" category.
# Another 6000 of the remaining 8000 are NA's, meaning the variable contains little meaningful data for our investigations.

table(subset$RX.Summ..Surg.Rad.Seq)
ggplot(jhet_clean_vars, aes(x=Surg.Rad.Seq)) +
  geom_bar(aes(fill=Surg.Rad.Seq)) +
  theme(axis.text.x=element_blank(),
        legend.text=element_text(size=6))
# The categories in this variable originally contained the order of surgery and or radiation. However, ~40,000 were again contained in the No surgery category.
# Thus, the variable is collapsed into just two levels, one in which no surgery or radiation was used, and another where one or both were used.

ggplot(jhet_clean_vars, aes(x=Systemic.Sur.Seq)) +
  geom_bar(aes(fill=Systemic.Sur.Seq)) +
  theme(axis.text.x=element_blank(),
        legend.text=element_text(size=6))
# Similar to the previous variable, this one contains data involving the sequence of systemic surgery and therapy.
# Most of the observations are in the none level, another large portion are patients that got systemic therapy after surgery, and another large chunk is NA's.
# The presence of two substantial categories makes this a useful variable for our treatment related data science question.

table(as.numeric(subset$Months.from.diagnosis.to.treatment))
ggplot(jhet_clean_vars, aes(x=Months.diag.to.treat)) +
  geom_bar(aes(fill=Months.diag.to.treat))
# Just like the Surg.Rad.Seq variable, almost all of the patients recieved treatment within 1 month of their diagnosis.
# Thus, the only way for the variable to be of any use is to make it binary, where one category is treatment within a month, and the other is one month or more.
