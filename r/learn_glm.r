library(dplyr)
library(ggplot2)
library(gains)
library(purrr)
library(tidyr)


# --------------- simulate data ---------------
N <- 10000
set.seed(123)
data <- 
  data_frame(
    x = rnorm(N, mean = 0, sd = 1),
    data_cut = sample(c("M", "T"), size = N, prob = c(0.7, 0.3), replace = TRUE)
  ) %>% 
  mutate(
    mu = exp(1 + 1.5 * x),
    y_gamma = rgamma(N, shape = 1/5, scale = 5 * mu), # gamma with log link
    y_gaussian = rnorm(N, mean = mu, sd = 3) # gamma with log link
  )

data_m <- data %>% filter(data_cut == "M")
data_t <- data %>% filter(data_cut == "T")

# --------------- gamma model ---------------
data %>% 
  ggplot(aes(x, y_gamma)) + 
  geom_point()

data %>% 
  ggplot(aes(x, y_gamma)) + 
  geom_point() +
  scale_y_log10()

data %>% 
  ggplot(aes(mu, y_gamma)) + 
  geom_point()

data %>% 
  ggplot(aes(mu, y_gamma)) + 
  geom_point() + 
  scale_y_log10() + 
  scale_x_log10()

mod_gamma <- glm(y_gamma ~ 1 + x, data = data_m, family = Gamma(link = "log"), start = c(0.1, 1))
mod_gamma
summary(mod_gamma)

plot(mod_gamma)

data_m$mod_gamma <- predict(mod_gamma, newdata = data_m, type = "response")
data_t$mod_gamma <- predict(mod_gamma, newdata = data_t, type = "response")

lm_gamma <- lm(y_gamma ~ 1 + x, data = data_m)

data_m$lm_gamma <- predict(lm_gamma, newdata = data_m, type = "response")
data_t$lm_gamma <- predict(lm_gamma, newdata = data_t, type = "response")

data_m$log_y_gamma <- log(data_m$y_gamma)
data_t$log_y_gamma <- log(data_t$y_gamma)

lm2_gamma <- lm(log_y_gamma ~ 1 + x, data = data_m)

data_m$lm2_gamma <- exp(predict(lm2_gamma, newdata = data_m, type = "response"))
data_t$lm2_gamma <- exp(predict(lm2_gamma, newdata = data_t, type = "response"))


CalculateGains(data_m, "y_gamma", "mod_gamma", plot = T)
CalculateGains(data_t, "y_gamma", "mod_gamma", plot = T)

CalculateGains(data_m, "y_gamma", "lm_gamma", plot = T)
CalculateGains(data_t, "y_gamma", "lm_gamma", plot = T)

CalculateGains(data_m, "y_gamma", "lm2_gamma", plot = T)
CalculateGains(data_t, "y_gamma", "lm2_gamma", plot = T)

data_m %>% 
  arrange(desc(y_gamma)) %>% 
  mutate(cum_response = cumsum(y_gamma)/sum(y_gamma)) %>% 
  pull(cum_response) %>% 
  approxfun(x = seq(0, 1, length.out = length(.))) %>% 
  integrate(0, 1)

data_m %>% 
  arrange(desc(mod_gamma)) %>% 
  mutate(cum_response_by_score = cumsum(y_gamma)/sum(y_gamma)) %>% 
  pull(cum_response_by_score) %>% 
  approxfun(x = seq(0, 1, length.out = length(.))) %>% 
  integrate(0, 1)

data_t %>% 
  arrange(desc(y_gamma)) %>% 
  mutate(cum_response = cumsum(y_gamma)/sum(y_gamma)) %>% 
  pull(cum_response) %>% 
  approxfun(x = seq(0, 1, length.out = length(.))) %>% 
  integrate(0, 1)

data_t %>% 
  arrange(desc(mod_gamma)) %>% 
  mutate(cum_response_by_score = cumsum(y_gamma)/sum(y_gamma)) %>% 
  pull(cum_response_by_score) %>% 
  approxfun(x = seq(0, 1, length.out = length(.))) %>% 
  integrate(0, 1)

gains(data_m$y_gamma, data_m$mod_gamma)
gains(data_m$y_gamma, data_m$mod_gamma) %>% plot

# --------------- gaussian model ---------------
data %>% 
  ggplot(aes(x, y_gaussian)) + 
  geom_point()

data %>% 
  ggplot(aes(x, y_gaussian)) + 
  geom_point() +
  scale_y_log10()

mod_gaussian <- glm(y_gaussian ~ 1 + x, data = model_data, family = gaussian(link = "log"))
mod_gaussian
summary(mod_gaussian)

plot(mod_gaussian)
