# Longer color palette ---------------------------------------------------------

## There are a few cases where the palette in Rcolorbrewer is running out of colors
## I'm going to try and combine two of them to create a longer list of colors.

combined_color_palette <- unique(c(RColorBrewer::brewer.pal(name = 'Set1', n = 9),
                                   RColorBrewer::brewer.pal(name = 'Dark2', n = 8),
                                   RColorBrewer::brewer.pal(name = 'Set2', n = 8),
                                   RColorBrewer::brewer.pal(name = 'Set3', n = 12),
                                   RColorBrewer::brewer.pal(name = 'Pastel1', n = 9),
                                   RColorBrewer::brewer.pal(name = 'Pastel2', n = 8),
                                   RColorBrewer::brewer.pal(name = 'Accent', n = 7),
                                   RColorBrewer::brewer.pal(name = 'Spectral', n = 11),
                                   RColorBrewer::brewer.pal(name = 'PRGn', n = 11)))
