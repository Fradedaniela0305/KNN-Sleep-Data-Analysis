# Sleep Disorder Classification with KNN

This project analyzes the **Sleep Health and Lifestyle Dataset** and builds a **K-Nearest Neighbors (KNN)** classification model to predict sleep disorders based on lifestyle and health-related features.

The target variable, **Sleep_Disorder**, classifies individuals into:
- None
- Sleep Apnea
- Insomnia

## Dataset
- **Source:** Kaggle – *Lifestyle and Sleep Patterns*  
- **Observations:** 374 individuals  
- **Features:** Demographic, lifestyle, and health metrics

## Predictors Used
- Age  
- Sleep Duration  
- Quality of Sleep  
- Physical Activity Level  
- Stress Level  
- Daily Steps  
- Systolic Blood Pressure  
- Diastolic Blood Pressure  
- BMI (numerically encoded)  
- Gender (numerically encoded)

## Methods Overview
The analysis follows a standard supervised learning pipeline:

1. **Data Cleaning & Preprocessing**
   - Renamed columns for clarity
   - Removed irrelevant variables (ID, occupation, heart rate)
   - Split blood pressure into systolic and diastolic values
   - Encoded categorical variables numerically
   - Removed missing values

2. **Exploratory Data Analysis**
   - Visualized class distribution of sleep disorders
   - Identified class imbalance (majority class: *None*)

3. **Modeling**
   - Used **K-Nearest Neighbors (KNN)** for multiclass classification
   - Applied **upsampling** to address class imbalance
   - Standardized predictors (centering and scaling)

4. **Hyperparameter Tuning**
   - Tuned number of neighbors (`k`) using **5-fold cross-validation**
   - Evaluated accuracy across values of `k`
   - Selected optimal value: **k = 7**

5. **Model Evaluation**
   - Accuracy
   - Precision 
   - Recall 
   - Confusion matrix


## Results

**Test Set Performance**
- **Accuracy:**  84.27%  
- **Precision:** 80.95%  
- **Recall:**    83.14%

### Confusion Matrix
| Prediction \ Truth | None | Sleep Apnea | Insomnia |
|-------------------|------|-------------|----------|
| None              | 44   | 2           | 2        |
| Sleep Apnea       | 3    | 16          | 2        |
| Insomnia          | 4    | 1           | 15       |

### Interpretation
- The model performs well across all three classes.
- Recall is reasonably high, indicating good identification of individuals with sleep disorders.
- Some confusion remains between *None* and the disorder classes, suggesting room for improvement in reducing false negatives.

## Key Takeaways
- Lifestyle and health variables are informative predictors of sleep disorders.
- Addressing class imbalance is critical when using distance-based models like KNN.
- Cross-validated tuning significantly improves model performance.

## Next Steps
- Optimize the model to **prioritize recall**, reducing false negatives.
- Experiment with alternative models (logistic regression, random forest).
- Explore feature importance and dimensionality reduction.
- Evaluate performance using ROC curves and class-specific metrics.

## Reproducibility
- Random seed set to ensure reproducibility.
- Implemented using `tidyverse`, `tidymodels`, and `themis`.

## Reports

- 📄 [Full report](Full%20report.html)
- 🧾 [Full report with code](Full%20report%20with%20code.html)

## References
- Kaggle. (2025). *Lifestyle and Sleep Patterns* [Dataset].  
  https://www.kaggle.com/datasets/minahilfatima12328/lifestyle-and-sleep-patterns

- Timbers, T., Campbell, T., & Lee, M. (2024). *Data Science: A First Introduction*.
  
