# PCA Bi-plot Coustomization
In a BiPlot both the variables (as arrows representing the contribution of a particular vairiable towards the total variation) and the indiduals (as points) are plotted.
For this graph, we required to label few individuals marking a circle (those falling in x>0 and y>0 ) and few other as a rectangle (those falling in x<0 and y<0). This was achieved using `ggforce` package.
Moreover all quadrants were required to be labled. This was achieved simply using `geom_text()` function in `ggplot` package.
