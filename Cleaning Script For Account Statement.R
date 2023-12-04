# ==== steps to clean the raw csv file and make it easy to copy paste into the excel format ====
# 1. make sure to put this script file into the same folder as the csvs you want to clean
# 2. go to sessions > set working directory > to source file location
# 3. change name of csv file below at line 20 and 38 (until i find a way to make this interactive)
# 4. click run, starting from this line


install.packages('data.table')
library('data.table')
install.packages('tidyverse')
library('tidyverse')


# read csv file
unscrubbed_csv <- fread("INSERT CSV FILE NAME HERE WITHIN QUOTATIONS i.e. statement.csv")


# clean csv file
scrubbed_csv <- 
  ## separating transaction date into date and time
  separate(unscrubbed_csv, "Transaction Date", into = c("date", "time"), sep=" ") %>%
  ## format date and time as date and time 
  mutate(date = as.Date(date, format = "%d/%m/%y")) %>%
  ## sort date and time from earliest to latest
  arrange(date, time) %>%
  ## remove unwanted columns
  select(-Category, -User, -`Swift Charge Type`, -`Exchange Rate (1.00)`, -`Account Number`) %>%
  ## fits the csv into the format of the account statement
  select(1:3, 5, 4, everything()) %>%
  mutate(No. = row_number())


# writing out the csv
output_file <- paste0(tools::file_path_sans_ext("INSERT CSV FILE NAME HERE WITHIN QUOTATIONS i.e. statement.csv"), "_scrubbed.csv")
write.csv(scrubbed_csv, file = output_file, row.names = FALSE)

