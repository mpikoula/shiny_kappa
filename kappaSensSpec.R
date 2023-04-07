

sgfun = function(phi,K){
  if (phi==0.5) {
    return ((phi*(1-K)*(1-phi)-1)/(4*phi*(K-1)*(phi-1)+K-2))
  } 
  else if (K==1) { return (1)
  }
  
  else {
  
  alpha = (1-K)*(2*phi-1)^2
  beta = 4*phi*(K-1)*(phi-1)+K-2
  gamma = phi*(K-1)*(1-phi)+1
  desc = (beta^2)-4*alpha*gamma
  #s1 = (-beta + sqrt(desc))/(2*alpha)
  s2 = (-beta - sqrt(desc))/(2*alpha)
  
  return (s2)          
}
}

# for (i in c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1)) {
#   for (j in c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1)) {
#     print(paste("phi= ",i))
#     print(paste("K= ",j))
#     print (sg(i,j))
#   }
# }


# The first set of functions assumes that the true sensivity and specificity are 100%

sensitivityfun0 = function(phi,sg){ 
  if (phi==0) {
    return(0)
  }
  
  else {
  return(phi*sg/(phi*sg+(1-phi)*(1-sg)))
  }
}

specificityfun0 = function(phi,sg){ 
  if (phi==1) {
    return(0)
  }  
  
  else {
  return((1-phi)*sg/((1-phi)*sg+phi*(1-sg)))
  }
}

sensitivityfun = function(phi,sg,sens,spec){ 
  if (phi==0) {
    return(0)
  }
  
  else {
  return((phi*sg*sens+(1-phi)*(1-sg)*(1-spec))/(phi*sg+(1-phi)*(1-sg)))
  }
}

specificityfun = function(phi,sg,sens,spec){ 
  if (phi==1) {
    return(0)
  }  
  
  else {
  return(((1-phi)*sg*spec+phi*(1-sg)*(1-sens))/((1-phi)*sg+phi*(1-sg)))
  }
}

# Calculate maximum possible observed performance based on the kappa and observed values

maxperfun = function(phi,sg,ssob,spob) {
  # Set up two equation, two variables system matrices and solve:
  a = phi*sg
  b = (1-phi)*(1-sg)
  c = (1-phi)*sg
  d = (phi)*(1-sg)
  A <- rbind(c(a, -b),
            c(-d, c))
  B <- c((a+b)*ssob-b, (c+d)*spob-d)
  return(solve(A,B))
}