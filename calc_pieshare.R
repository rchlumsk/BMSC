
# determines the weights (N+1) from a vector of N random values
## note: this script is derived from the original materials located here:
## https://github.com/julemai/PieShareDistribution

calc_pieshare <- function(rr) {
  ## rr is a vector of N-1 weights
  # e.g. 
  # rr <- c(0,1)
  N <- length(rr)+1
  
  # initialize matrix of weights 
  ww<-array(NA,dim=c(1,N));
  ww[,]<-0; #initially zero
  
  # derive the first (N-1) weights
  for (i in (1:(N-1))) {
    if (i==1) {
      ss<-0     
    }
    else if (i==2) {
      # accounts for inability of rowSums to handle 0 or 1 row
      ss<-ww[,1]
    } 
    else {
      ss<-rowSums(ww[,1:i-1]);
    }
    
    ww[,i]<-( 1.0 - ss ) *( 1.0 - (1.0 - rr[i])^(1.0/(N-i)) )
    
  }
  ww[N] = 1.0-sum(ww[1:(N-1)]);
  
  return(ww)
}

# # examples
# calc_pieshare(c(0,1))
# calc_pieshare(c(5/9,0.5))
# calc_pieshare(c(5/9,1))


