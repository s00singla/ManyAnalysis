library(readxl)
library(tidyverse)
res_pca <- read_excel("D:\\ANALYSIS\\.....\\PCABiplot_R.xlsx")

finaldata=res_pca %>% 
        select( -rep, -env) %>%
        group_by(geno) %>% 
        summarise_all(.funs = list(x=mean)) %>% 
        rename_with(~gsub('_x',"",.x)) %>% 
        column_to_rownames('geno')

library(factoextra)
library(FactoMineR)

library(corrplot)
library(ggforce)

#PCA
new.pca=PCA(finaldata)

# Define variable for ellipse
ellipse_var <- ifelse(new.pca$ind$coord[,1]>0 & new.pca$ind$coord[,2]>0, 'TOL', 
       ifelse(new.pca$ind$coord[,1]<0 & new.pca$ind$coord[,2]<0, 'SUS',
              ifelse(new.pca$ind$coord[,1]<0 & new.pca$ind$coord[,2]>0, 'INT','INT ')))

# Define variable for rectangle
rect_d <- data.frame(new.pca$ind$coord[,1:2], var=factor(ellipse_var))

# Define custom lables for x and y axis)
x_lab <- paste0('PC1 (',round(new.pca$eig[1,1]/sum(new.pca$eig[,1])*100,1), '%)')
y_lab <- paste0('PC2 (',round(new.pca$eig[2,1]/sum(new.pca$eig[,1])*100,1), '%)')

# Text labels and positions
text_d <- data.frame(loc_x = c(3,3,-5,-5),
                     loc_y = c(-4.3,4.5,4.5,-4.3),
                     text_col=c('INTERMEDIATE','TOLERANT', 'INTERMEDIATE','SUSEPTIBLE'))
                     
# Final plot
fviz_pca_biplot(new.pca,  col.ind = as_factor(rownames(finaldata)),
                col.var = "darkslategray",
                label = c('ind','var'), pointsize=2, pointshape=19, alpha=0.5,
                geom.ind = c('point','text'),
                repel = TRUE # Avoid text overlapping (slow if many points)
                )+ 
        ylim(c(-5,5))+xlim(c(-8,8))+ #change accordingly
        geom_text(data=text_d, aes(x=loc_x,y=loc_y, label=text_col),
                  family='serif', color='red', size=5)+ #text for tol susp etc
        geom_mark_ellipse(data=rect_d %>%  filter(var=='TOL'),label.colour = NA,
                         alpha=1, show.legend = F, con.colour = NA, label.fill = NA,
                         aes(x = Dim.1, y=Dim.2, label=var))+   #for ellipse
        geom_mark_rect(data=rect_d %>%  filter(var=='SUS'),label.colour = NA, 
                       alpha=1, show.legend = F, con.colour = NA, label.fill = NA,
                       aes(x = Dim.1, y=Dim.2, label=var))+  # rectangle
        guides(shape='none')+theme_bw()+
        theme(text = element_text(face='bold'))+
        labs(color='Genotype', x=x_lab,y=y_lab)
