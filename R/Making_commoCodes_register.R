### Library Call: ----
library(tidyverse)


### Load Source files: ----
file_nomenclature <- read_csv2("../list/nomenclature.csv", col_types = "ccccccccccccc")


### Data Frames To Work With: ----
df_data <- file_nomenclature

## adding an 'index' column as the index field:
df_data$index <- seq.int(nrow(df_data))

# columns i will be keeping in df_data:
# "goods_nomenclature_item_id", "producline_suffix", "validity_start_date", "validity_end_date", "description", "number_indents", "index"

# columns in this sequence:
column_order <- c("index", "description", "goods_nomenclature_item_id", "producline_suffix", "number_indents","validity_start_date", "validity_end_date")

## reorder columns in df_data using column_order:
df_data <- df_data[ ,column_order]

## adding 'change-date' column:
df_data$`change-date` <- NA

## analysis: any variation in timestamp
# split the timecompont from start_date:
df_data <- df_data %>% mutate(time = str_sub(df_data$validity_start_date, 12))
table(df_data$time) # 00:00:00 = 24418 -- proof that their is no variation in timestamps

# remove timestamps from 'validity_start_date'
df_data <- df_data %>% mutate(start_date = str_sub(df_data$validity_start_date, 0, 10))

## convert 'index' to 'char' field
df_data$index <- as.character(df_data$index)

## convert 'chnage-date' to 'char' field
df_data$`change-date` <- as.character(df_data$`change-date`)

## rename columns
df_data <- rename(df_data, `commodity-code` = index)
df_data <- rename(df_data, name = description)
df_data <- rename(df_data, `goods-nomenclature-item-id` = goods_nomenclature_item_id)
df_data <- rename(df_data, `productline-suffix` = producline_suffix)
df_data <- rename(df_data, `number-indents` = number_indents)
df_data <- rename(df_data, `end-date` = validity_end_date)
df_data <- rename(df_data, `start-date` = start_date)

## re-order columns
df_data <- df_data %>% select(`commodity-code`, 
                              name, 
                              `goods-nomenclature-item-id`,
                              `productline-suffix`,
                              `number-indents`,
                              `start-date`,
                              `end-date`,
                              `change-date`)

## export
write_tsv(df_data, path = "../data/commodity-code.tsv", na = "")