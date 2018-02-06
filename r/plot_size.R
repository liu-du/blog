# width in pixel
for (i in c(18, 36, 72, 144)) {
  png(paste0("px_", i,".png"), res = i)
  plot(1:10, main = "Main", type = "b")
  dev.off()
}

# As res increase, pixel per inch increase:
#   1. plot area becomes smaller in inches (plot area = 480/res)
#   1. text, ticks, symbols become larger relative to the plot area. (seems text, ticks and symbols are actually in inches)
#   1. the quality with high resolution have better quality although they have the same number of pixels. But the symbols are too big.

# adjust pointsize
for (i in c(18, 36, 72, 144)) {
  png(paste0("adj_ptsize_px_", i,".png"), res = i, pointsize = 12*72/i)
  plot(1:10, main = "Main", type = "b")
  dev.off()
}

# As res increase, pixel per inch increase:
#   1. plot area becomes smaller in inches (plot area = 480/res)
#   1. But pointsize decreases: the size of the text, ticks and symbols decreases in inches.
#   1. so can't see the relative change
#   1. But actually the plot area in inches is decreasing
#   1. But all four plots have the same quality in terms of pixels

# inches
for (i in c(18, 36, 72, 144, 288, 72*8, 72*16)) {
  png(paste0("in_", i,".png"), res = i, width = 7, height = 5, units = "in")
  plot(1:10, main = "Main", type = "b", xlab = "XXXXX")
  dev.off()
}

# As res increase, pixel per inch increase:
#   1. plot area does not change in inches (always 7 inches wide and 5 inches tall)
#   1. unfortunately on windows, the graphical device does not show true inches, it scales the pic somehow
#   1. size of the text, ticks and symbols does not change, as they scale with pointsize, which is in inches. 
#   1. it seems that lines become thinner, but I guess it's because they are less pixelated.


# To conclude, the easiest way and perhaps the only way to increase the quality of a graph is to specify width and height in inches and increase res.