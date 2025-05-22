# NOTE: To load data, you must download both the extract's data and the DDI
# and also set the working directory to the folder with these files (or change the path below).
library('dplyr')
library('lubridate')


if (!require("ipumsr")) stop("Reading IPUMS data into R requires the ipumsr package. It can be installed using the following command: install.packages('ipumsr')")

ddi <- read_ipums_ddi("q2_final_ddifile.xml")
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

## Regression Model(Employment ~ Time)

predict_treatment <- feols()









