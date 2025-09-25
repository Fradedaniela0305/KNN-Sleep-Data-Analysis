
library(tidyverse)
sleep_data <- read_csv("data/Sleep_health_and_lifestyle_dataset.csv")
head(sleep_data)

sleep_data_clean <- sleep_data |>
  rename(Sleep_Disorder = `Sleep Disorder`)|>
  mutate(Sleep_Disorder = as_factor(Sleep_Disorder))

counts_graph <- ggplot(sleep_data_clean, aes(x = Sleep_Disorder, fill = Sleep_Disorder)) + 
  geom_bar() + 
  xlab("Sleep Disorder") +
  ylab("Count") + 
  ggtitle("Count of Observations per Sleep Disorder Class")+
  theme(
    axis.title = element_text(size = 20),   
    axis.text = element_text(size = 12),    
    plot.title = element_text(size = 16),  
    legend.title = element_text(size = 14),  
    legend.text = element_text(size = 12))
counts_graph


number_of_observations <- nrow(sleep_data_clean)
count <- sleep_data_clean |>
  group_by(Sleep_Disorder) |>
  summarise(count = n(), percentage = n() / number_of_observations * 100)
count
