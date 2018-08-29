### Library Call: ----
library(tidyverse)

### Load Source files: ----
file_nomenclature <- read_csv2("../list/nomenclature.csv", col_types = "ccccccccccccc")

### Data Frames To Work With: ----
df_data <- file_nomenclature

### Analysis: ----
colnames(df_data)
# [1] "goods_nomenclature_item_id"                "producline_suffix"                         "validity_start_date"                      
# [4] "validity_end_date"                         "productline_suffix"                        "description"                              
# [7] "number_indents"                            "goods_nomenclature_description_period_sid" "validity_start_date_1"                    
# [10] "validity_end_date_1"                       "nice_description"                          "chapter"                                  
# [13] "leaf"

## make new col from 'goods_nomenclature_item_id'
df_data$goods_nomenclature_item_id <- df_data$goods_nomenclature_item_id
## testing to see whether 'producline_suffix' and 'productline_suffix' are always true
df_data <- mutate(df_data, profixTest = producline_suffix == productline_suffix)
table(df_data$profixTest) # all 24,418 records are true
df_data$profixTest <- NULL # delete column

## make a text column to prep for curie field.
df_data$text_product_line <- "product_line"

## make a 'unique_identifier' field, by conatenating 'goods_nomenclature_item_id' and 'productline_suffix'
df_data<- mutate(df_data, commodity_code = str_c(df_data$goods_nomenclature_item_id,df_data$productline_suffix))

## make 'leaf_node' column
df_data$leaf_node <- df_data$leaf

## make 'indent_number' column
df_data$indent_number <- df_data$number_indents

## make 'name' (description field) column
df_data$name <- df_data$description

## make the date columns (change/start/end)
df_data$change_date <- NA
df_data$start_date <- df_data$validity_start_date
df_data$end_date <- df_data$validity_end_date

## Make product_line dataframe
vr_product_line <- unique(df_data$productline_suffix)
vr_product_line <- sort(vr_product_line)
length(vr_product_line) # 8 items
n_productline <- c(1:8)

df_product_line <- tibble(n_productline, vr_product_line)
df_product_line <- rename(df_product_line, product_line = n_productline)


## Join onto df_data
df_data <- left_join(df_data, df_product_line, by = c("productline_suffix" = "vr_product_line"))

## Add column 'product_line_curie'
df_data <- mutate(df_data, product_line_curie = str_c(df_data$text_product_line,":", df_data$product_line))

### Cut registers from the df_nomenclauter df_data

## Make 'Comodity-Code' register
reg_commodity_code <- df_data %>% select(
  commodity_code, 
  goods_nomenclature_item_id, 
  product_line_curie,
  leaf_node, 
  indent_number, 
  name, 
  change_date, 
  start_date, 
  end_date)
##rename the 'product_line_curie' to 'product_line'
reg_commodity_code <-  rename(reg_commodity_code, product_line = product_line_curie)


## Make 'Product_line' register
df_product_line <- rename(df_product_line, name = vr_product_line)
reg_product_line <- df_product_line
reg_product_line$start_date <- NA
reg_product_line$end_date <- NA

### Export Registers: ----
write_tsv(reg_commodity_code, path = "../data/commodity-code.tsv", na = "")
write_tsv(reg_product_line, path = "../data/product-line.tsv", na = "")
