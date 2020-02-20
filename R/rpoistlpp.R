#' @export
rpoistlpp <-  function(lambda,a,b,L,check=FALSE,lmax=NULL,nsim=1){

  if (!inherits(L,"linnet"))   stop("L should be a linear network")

  if (a >= b)  stop("lower bound must be smaller than upper bound")

  if (!is.numeric(lambda) & !is.function(lambda))
    stop(" lambda should be a number or a function")

 if(nsim > 1) {
   out <- list()
   for (i in 1:nsim) {
     out[[i]] <- rpoislpp(lambda,a=a,b=b,L=L,nsim=1)
   }
   return(out)
 }

  if (is.numeric(lambda)){
    n <- rpois(1,lambda*volume(L)*(b-a))
    X <- runiflpp(n,L)
    t <- runif(npoints(X),a,b)
    stlpp <- data.frame(x=X$data$x,y=X$data$y,t)

  }



  else {

    if(is.null(lmax)){
      Llines <- as.psp(L)
      linemask <- as.mask.psp(Llines)
      lineimage <- as.im(linemask)
      xx <- raster.x(linemask)
      yy <- raster.y(linemask)
      mm <- linemask$m
      xx <- as.vector(xx[mm])
      yy <- as.vector(yy[mm])
      pixelcentres <- ppp(xx, yy, window=as.rectangle(linemask), check=check)
      pixelcentres <- unique.ppp(pixelcentres)
      pixdf <- data.frame(xc=xx, yc=yy)
      p2s <- project2segment(pixelcentres, Llines)
      projloc <- as.data.frame(p2s$Xproj)
      projmap <- as.data.frame(p2s[c("mapXY", "tp")])
      projdata <- cbind(pixdf, projloc, projmap)
      gridx <- p2s$Xproj$x
      gridy <- p2s$Xproj$y
      df <- data.frame(gridx,gridy)
      df <- df[!duplicated(df), ]
      grid <- lpp(df,L)
      grid <- unique(grid)
      t0 <- runif(npoints(grid),a,b)

      lmax=max(lambda(grid$data$x,grid$data$y,t0))
    }


    mean <- lmax*volume(L)*(b-a)

    n <- rpois(1,mean)

    unipoint <- runiflpp(n,L)

    hlpp <- cbind(unipoint$data$x,unipoint$data$y,runif(n,a,b))

    prob <- lambda(hlpp[,1],hlpp[,2],hlpp[,3])/lmax

    if(check) {
      if(any(prob < 0))
        warning("Negative values of lambda obtained")
      if(any(prob > 1))
        warning("lmax is not an upper bound for lambda")
    }

    u <- runif(length(hlpp[,1]))

    retain <-  (u <= prob)

    stlpp <- hlpp[retain,]
    stlpp <- data.frame(x=stlpp[,1],y=stlpp[,2],t=stlpp[,3])

  }
  out <- ppx(data=stlpp,domain = L,coord.type = c("s","s","t"))
  class(out) <- c("stlpp","ppx")
  out$time <- c(a,b)
  return(out)
}