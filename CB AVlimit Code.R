# Simple AV manual limit calculation script
#
# Deniz Topcu
# Any questions: ditopcu at gmail.com

library(dplyr)


# all_results can be improted from csv or excel file

# Retrospective results must contain following fields:
#    sex
#    age (as days)
#    test name
#    result
#    department
#    other additional information 
#  E.g. Device type can be important for some tests

# Filter following results before calculating limits
#     Results obtained from HIL (+) samples
#     Results with invalid device / test flags
#     Results from departments that contains higher number of extreme results



agebreaks_new_day <- c(0, 30, 1 * 365, 4 * 365, 6 * 365, 12 * 365, 18 * 365, 66 * 365, 200 * 365)
agelabels_new_day <- c("0-30", "30-365", "1-3", "4-5", "6-11", "12-17", "18-65", ">65")


limits <- all_results %>%
  mutate(age_group_new = 
           cut(age_day, breaks = agebreaks_new_day, labels = agelabels_new_day, right = FALSE, ordered_result = TRUE, include.lowest = TRUE))
  group_by(sex, age_group_new, department,  test_name) %>% # if any other special condition used grouping must be extended
  summarise(n = n(), per_02 = quantile(result, probs = 0.02), per_98 = quantile(result, probs = 0.98))
  
  
write.csv(limits, "limits.csv")


  
