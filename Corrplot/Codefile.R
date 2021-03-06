## tHE CODE GOES LIKE THIS
library(ggplot2)
library(corrplot)
CORRPLOT_Data <- read_excel("C:/Users/Saurav Singla/Downloads/CORRPLOT.xlsx")
corr11=(CORRPLOT_Data[,-1])
# convert the names in expession form assigning colnames(corr11) as below
ddmd <- c(expression(Y,S^(1),S^(2), S^(3),
                     S[(6)], NP^(1), NP^(2), NP^(3), NP^(4),W[i]^2,
                     sigma[i]^2,s^(2)*d[i],b[i], CV[i],theta[(i)], theta[i],
                     KR, ASV))
colnames(corr11) <- paste0(":",ddmd)

corrplot(cor(corr11))
