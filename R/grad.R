# gradiente
X <- matrix(1:12, ncol = 3)
my <- matrix(c(-1 / 2, 0, 1 / 2), nrow = 3)
my
as.matrix(focal(raster(X), my))
mx <- matrix(c(-1 / 2, 0, 1 / 2), ncol = 3)
mx
as.matrix(focal(raster(X), mx))
