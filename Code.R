set.seed(123)

library(tidyverse)
library(repr)
library(tidymodels)
library(themis)

sleep_data <- read_csv("data/Sleep_health_and_lifestyle_dataset.csv")

sleep_data_clean <- sleep_data |>
  select(-`Person ID`, -`Heart Rate`, -`Occupation`)|>
  
  rename(Sleep_Disorder = `Sleep Disorder`)|>
  rename(Gender = `Gender`)|>
  rename(Age = `Age`)|>
  rename(Sleep_Duration = `Sleep Duration`)|>
  rename(Quality_of_Sleep = `Quality of Sleep`)|>
  rename(Physical_Activity_Level = `Physical Activity Level`)|>
  rename(Stress_Level = `Stress Level`)|>
  rename(BMI_Category = `BMI Category`)|>
  rename(Blood_Pressure = `Blood Pressure`)|>
  rename(Daily_Steps = `Daily Steps`)|>
  separate(Blood_Pressure, into = c("Systolic", "Diastolic"), sep = "/") |>
  mutate(Systolic = as.numeric(Systolic), Diastolic = as.numeric(Diastolic)) |>
  mutate(BMI_num = case_when(BMI_Category == "Underweight" ~ 1, 
                             BMI_Category == "Normal"~ 2,
                             BMI_Category == "Overweight"  ~ 3, 
                             BMI_Category == "Obese" ~ 4))|>
  
  mutate(Gender_num = case_when(Gender == "Male" ~ 1, 
                                Gender == "Female"~ 2,))|>
  select(-BMI_Category, -Gender) |>
  
  mutate(Sleep_Disorder = as_factor(Sleep_Disorder)) |>
  drop_na()



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
    legend.text = element_text(size = 12)) +
  scale_fill_manual(values = c("darkorange", "darkblue", "darkred"))


sleep_split <- initial_split(sleep_data_clean, prop = 0.75, strata = Sleep_Disorder)
sleep_training <- training(sleep_split)
sleep_testing <- testing(sleep_split)

knn_tune <- nearest_neighbor(weight_func = "rectangular", neighbors = tune()) |>
  set_engine("kknn") |>
  set_mode("classification")

k_vals <- tibble(neighbors = seq(from = 1, to = 10, by = 1))

num_vfold <- vfold_cv(sleep_training, v = 5, strata = Sleep_Disorder)

sleep_recipe <- recipe(Sleep_Disorder ~ ., data = sleep_training) |>
  step_upsample(Sleep_Disorder, over_ratio = 1, skip = TRUE) |>
  step_scale(all_predictors()) |>
  step_center(all_predictors())

knn_results <- workflow() |>
  add_recipe(sleep_recipe) |> 
  add_model(knn_tune) |>
  tune_grid(resamples = num_vfold, grid = k_vals) |>
  collect_metrics()

accuracies <- knn_results |> 
  filter(.metric == "accuracy")

k_plot <- accuracies |>
  ggplot(aes(x = neighbors, y = mean)) +
  geom_point() +
  geom_line() +
  labs(title = "Accuracy vs K", x = "Neighbors", y = "Accuracy Estimate") +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +  # adjusting the x-axis
  scale_y_continuous(limits = c(0.4, 1.0)) # adjusting the y-axis
k_plot

best_k <- accuracies |>
  arrange(desc(mean)) |>
  head(1) |>
  pull(neighbors)
best_k


knn_model_with_best_k <- nearest_neighbor(weight_func = "rectangular", neighbors = best_k) |>
  set_engine("kknn") |>
  set_mode("classification")

knn_fit <- workflow() |>
  add_recipe(sleep_recipe) |>
  add_model(knn_model_with_best_k) |>
  fit(data = sleep_training)

sleep_test_pred <- predict(knn_fit, sleep_testing) |>
  bind_cols(sleep_testing) 
