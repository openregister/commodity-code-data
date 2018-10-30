### Library Call: ----
library(tidyverse)


### Load Source files: ----
file_nomenclature <- read_csv2("../list/nomenclature.csv", col_types = "ccccccccccccc")


### Data Frames To Work With: ----
df_data <- file_nomenclature

### Cutting a Regsiter: ----
## make a text column to prep for curie field.
df_data$text_product_line <- "product_line"

## make a 'unique_identifier' field, by conatenating 'goods_nomenclature_item_id' and 'productline_suffix'
df_data<- mutate(df_data, commodity_code = str_c(df_data$goods_nomenclature_item_id,df_data$productline_suffix))

## make 'name' (description field) column
df_data$name <- df_data$description

## make the date columns (change/start/end)
df_data$change_date <- NA
df_data$start_date <- df_data$validity_start_date
df_data$end_date <- df_data$validity_end_date

## make 'parent' column
df_data$parent <- NA

## Rearrange columns for use in excel:
# This means rearranging columns by goods_nomenclature_item_id1,productline_suffix1.
# first make a copy of df_data
copy_of_df_data <- df_data
# now rearrange data
df_data <- df_data %>% arrange(goods_nomenclature_item_id, producline_suffix)

## Re-order Columns
df_data <- df_data %>% select(
  commodity_code,
  name,
  goods_nomenclature_item_id,
  producline_suffix,
  parent,
  start_date,
  end_date,
  change_date
)

### Export Registers: ----
write_tsv(df_data, path = "../data/commodity_code_data.tsv", na = "")
