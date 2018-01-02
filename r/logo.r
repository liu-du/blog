# simple logo with ggplot2
inv_logit <- function(x, base = exp(1)) (base^x)/(1 + base^x)

for (i in rownames(RColorBrewer::brewer.pal.info)) {
  print(
    
tibble(t = seq(0, 42 * pi * 2, 0.05)) %>%
  mutate(x = inv_logit(sin(t / 7)) - 0.5,
         y = inv_logit(cos(t / 6)) - 0.5,
         color = sin(7/6*t),
         alpha = (cos(t) + 1)/17) %>%
  ggplot(aes(x, y, color = color)) + 
  geom_jitter(aes(alpha = alpha), width = 0.007) + 
  scale_color_distiller(guide = FALSE, palette = i) + 
  scale_alpha_continuous(guide = FALSE) + 
  theme() + 
  theme_void()
    
  )
  
  ggsave(filename = paste0("../public/images/logo_", i, ".png"), width = 1, height = 1, dpi = 110, device = "png")
}
