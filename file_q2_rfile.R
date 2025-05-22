# NOTE: To load data, you must download both the extract's data and the DDI
# and also set the working directory to the folder with these files (or change the path below).
library('dplyr')



if (!require("ipumsr")) stop("Reading IPUMS data into R requires the ipumsr package. It can be installed using the following command: install.packages('ipumsr')")

ddi <- read_ipums_ddi("q2_final_ddifile.xml")
raw_data <- read_ipums_micro(ddi)
industry_Data <- read.csv('indnames.csv')

main_data <- raw_data %>%
  select(-ASECWTH, -ASECWT , -CPSIDV, -WTFINL)%>%
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








