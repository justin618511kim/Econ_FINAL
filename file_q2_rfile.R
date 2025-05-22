library('dplyr')
library('lubridate')
library('fixest')


if (!require("ipumsr")) stop("Reading IPUMS data into R requires the ipumsr package. It can be installed using the following command: install.packages('ipumsr')")

ddi <- read_ipums_ddi("q2_final_ddi_file.xml")
raw_data <- read_ipums_micro(ddi)
industry_Data <- read.csv('indnames.csv')

main_data <- raw_data %>%
  filter(IND != 0)

industry_Data <- industry_Data %>%
  mutate(industry_Data,IND= ind) %>%
  select(-ind)


main_data <- merge(main_data, industry_Data, by="IND")

##individual employment sets
main_data <- main_data %>%
  filter(EMPSTAT < 30)

NILF <- main_data %>%
  filter(EMPSTAT >= 30)

employed_data <- main_data %>%
  filter(EMPSTAT < 20)

unemployed_data <- main_data %>%
  filter(EMPSTAT >= 20)

## retail dataframes

employed_data_Retail <- employed_data %>%
  filter(between(IND, 4670,5790))

unemployed_data_Retail <- unemployed_data %>%
  filter(between(IND, 4670, 5790))

NonRetail_employed_data <- employed_data %>%
  filter(!between(IND, 4670,5790))

NonRetail_unemployed_data <- unemployed_data %>%
  filter(!between(IND, 4670, 5790))


precovid_retail_unemployed <- unemployed_data_Retail %>%
  filter(YEAR <= 2019)

post_covid_retail_unemployed <- unemployed_data_Retail %>%
  filter(YEAR >= 2021)

precovid_retail_employed <- employed_data_Retail %>%
  filter(YEAR <= 2019)

post_covid_retail_unemployed <- employed_data_Retail %>%
  filter(YEAR >= 2021)

cut_off <- ymd(c("2020-01-01", "2020-12-31"))

## Regression Model

regression_data <- main_data %>%
  filter(YEAR < 2022 | (YEAR == 2022 & MONTH <= 4))

regression_data <- main_data %>%
  mutate(employed = ifelse(EMPSTAT < 20, 1, 0), 
         retail = ifelse(between(IND, 4670, 5790), 1, 0),
         year_month = factor(paste0(YEAR, "-", sprintf("%02d", MONTH))),
         post_assesment_period = ifelse(YEAR >= 2021, 1, 0))

model_data <- regression_data %>%
  filter(YEAR <= 2019 | YEAR >= 2021)

main_model <- feols(employed~post_assesment_period * retail | year_month, data = model_data)

pre_covid_data <- subset(regression_data, YEAR <= 2019)

pre_covid_model <- feols(employed~retail | year_month, data = pre_covid_data)

post_covid_data <- subset(regression_data, YEAR >= 2021)

post_covid_model <- feols(employed~retail | year_month, data = post_covid_data)

etable(pre_covid_model, post_covid_model)









