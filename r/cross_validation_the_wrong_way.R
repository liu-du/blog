# Cross Validation the wrong way
library(dplyr)
library(purrr)
set.seed(123)

N <- 100
n_feature <- 1000
top_features <- 5
K <- 5

data <- 
  data.frame(
    y = sample(c(0, 1), size = N, replace = TRUE),
    setNames(lapply(rep(N, n_feature), rnorm), paste0("x", 1:n_feature))
  ) 

# Cross Validation the wrong way
# 1. select top 10 predictors base on their corrlation with the target

formula <- 
  data[, -1] %>% 
  map_dbl(~ abs(cor(., data$y))) %>% 
  sort %>% 
  tail(top_features) %>%
  print %>%
  names %>% 
  paste(collapse = " + ") %>% 
  paste0("y ~ ", .) %>% 
  print

# 2. do a K fold cross validataion using these 10 predictors using a logistic regression
data <- 
  data %>% 
  mutate(fold = sample(1:K, size = N, replace = TRUE))

wrong_error_rate <- numeric(K)

for (i in 1:K) {
  mod <- glm(formula, data = data[data$fold != i, ], family = binomial())
  pred <- predict(mod, newdata = data[data$fold == i, ], type = "response")
  pred <- ifelse(pred > 0.5, 1, 0)
  wrong_error_rate[i] <- mean(pred != data[['y']][data$fold == i])
}
summary(wrong_error_rate)

# Cross Validation the right way

# 2. do a K fold cross validataion using these 10 predictors using a logistic regression
correct_error_rate <- numeric(K)
for (i in 1:K) {
  
  formula <- 
    data %>% 
    filter(fold != i) %>% 
    select(-fold, -y) %>% 
    map_dbl(~ abs(cor(., data$y[data$fold != i]))) %>% 
    sort %>% 
    tail(top_features) %>%
    names %>% 
    paste(collapse = " + ") %>% 
    paste0("y ~ ", .)
  

  mod <- glm(formula, data = data[data$fold != i, ], family = binomial())
  pred <- predict(mod, newdata = data[data$fold == i, ], type = "response")
  pred <- ifelse(pred > 0.5, 1, 0)
  correct_error_rate[i] <- mean(pred != data[['y']][data$fold == i])
}

summary(correct_error_rate)

## Look at how N, n_feature, top_features, K affect the error rate

N <- 100
n_feature <- 1000
top_features <- 5
K <- 5

data <- 
  data.frame(
    y = sample(c(0, 1), size = N, replace = TRUE),
    setNames(lapply(rep(N, n_feature), rnorm), paste0("x", 1:n_feature))
  ) 

data <- 
  data %>% 
  mutate(fold = sample(1:K, size = N, replace = TRUE))

wrong_cv <- function(top_features, K) {
  
  # Cross Validation the wrong way
  # 1. select top 10 predictors base on their corrlation with the target
  
  formula <- 
    data[, -1] %>% 
    map_dbl(~ abs(cor(., data$y))) %>% 
    sort %>% 
    tail(top_features) %>%
    names %>% 
    paste(collapse = " + ") %>% 
    paste0("y ~ ", .) 
  
  # 2. do a K fold cross validataion using these 10 predictors using a logistic regression
  
  wrong_error_rate <- numeric(K)
  
  for (i in 1:K) {
    mod <- glm(formula, data = data[data$fold != i, ], family = binomial())
    pred <- predict(mod, newdata = data[data$fold == i, ], type = "response")
    pred <- ifelse(pred > 0.5, 1, 0)
    wrong_error_rate[i] <- mean(pred != data[['y']][data$fold == i])
  }
  
  list(formula = formula, error_rate = wrong_error_rate)
  
}

