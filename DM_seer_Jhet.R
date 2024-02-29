library(data.table)
library(dplyr)
seer <- fread("C:/Users/cjhet/Documents/export.txt", header=TRUE)

subset <- seer %>% select(1:11)

# NA's are recorded as "blank(s)", which isn't automatically detected
subset[subset == "Blank(s)"] <- NA

# change vars to factor or numeric where appropriate
subset <- subset %>% mutate(
  Sex = as.factor(Sex),
  Race.origin = as.factor(`Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)`),
  #Age = as.factor(`Age recode with <1 year olds`),
  Scope.Reg.LN.Sur = as.factor(`RX Summ--Scope Reg LN Sur (2003+)`),
  Surg.Oth.Reg.Dis = as.factor(`RX Summ--Surg Oth Reg/Dis (2003+)`),
  Surg.Rad.Seq = as.factor(`RX Summ--Surg/Rad Seq`),
  Reg.LN.exam = as.numeric(`RX Summ--Reg LN Examined (1998-2002)`),
  Systemic.Sur.Seq = as.factor(`RX Summ--Systemic/Sur Seq (2007+)`),
  Months.diag.to.treat = as.numeric(`Months from diagnosis to treatment`)
)