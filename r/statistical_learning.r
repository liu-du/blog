# ------------------------ generate univariate mixture gaussian ------------------------
library(dplyr)

N <- 10000

mixture <- 
  data.frame(
    class = 1:10,
    mean = seq(1, 2, length.out = 10),
    sd = seq(0.1, 1, length.out = 10)
  )
  
simulate_x <- 
  data.frame(
    class = sample(1:10, size = N, replace = TRUE, prob = rep(0.1, 10)) 
  ) %>% 
  left_join(
    mixture,
    by = "class"
  ) %>% 
  mutate(x1 = rnorm(N, mean = mean, sd = sd))
  
hist(simulate_x$x1, breaks = 30)

qqnorm(simulate_x$x1)
qqline(simulate_x$x1)

# ------------------------ generate multivariate mixture gaussian ------------------------
library(mvtnorm)
rmvnorm(10, sigma = matrix(c(1, 0.5, 0.5, 1), ncol = 2, nrow = 2))

# ------------------------ Chapter one ------------------------

I <- matrix(c(1, 0, 0, 1), ncol = 2, nrow = 2)

blue <- rmvnorm(10, sigma = I)
orange <- rmvnorm(10, sigma = I)


mixture <- 
  data.frame(
    class = 1:10,
    mean = seq(1, 2, length.out = 10),
    sd = seq(0.1, 1, length.out = 10)
  )

blue_points <- rmvnorm(N, mean = )


