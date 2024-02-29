library(RSQLite) # install these
library(dplyr, warn.conflicts = FALSE)
library(data.table)

# df <- fread("C:/data/export.txt")
# 
# setwd("C:/485-TT2") # change this for your machine
# 
# db <- dbConnect(RSQLite::SQLite(), "db.sqlite") # create SQLite database file
# 
# dbWriteTable(db, "tcdf", df) # write into table named tcdf the DataFrame df
# 
# con <- DBI::dbConnect(RSQLite::SQLite(), "db.sqlite") # make connection to database
# 
# df <- tbl(con, "tcdf") # read table
# 
# summary <- df %>% # lazily perform query; don't materialize the result until you ask for it == lazy
#   group_by(cyl) %>% 
#   summarise(mpg = mean(mpg, na.rm = TRUE)) %>% 
#   arrange(desc(mpg))
# 
# summary %>% show_query() # show SQL code generated from query named summary
# 
# summary %>% collect() # materialize/collect results
# 
# dbDisconnect(db) # disconnect database
