#
  # ** Name: Jonas R. Atienza
  # ** Lab Section: AB-3L
  # ** Program Description: This function accepts a list and creates the augmented coefficient matrix for the functions and return it in a single list variable. # nolint
#

source("./AugCoeffMatrix.R")

GaussianElimination <- function(listArg) { # nolint
  mat <- AugCoeffMatrix(listArg)
  a <- mat$augcoeffmatrix
  n <- length(mat$variables)

  # Phase 1: Forward Elimination
  order_vec <- c()
  for (i in 1:(n - 1)) {
    # Employ pivoting
    coeffMat <- a[ , -(n + 1)]
    
    if(i==1){
      temp_pivot <- which.max(abs(coeffMat[, i]))
    } else {
      temp_pivot <- which.max(abs(coeffMat[-c(1:(i - 1)), i]))
      temp_pivot <- temp_pivot + (i - 1)
    }
    
    if (coeffMat[temp_pivot, i] == 0) {
      print("No unique solution exist!")
      return(NA)
      # No unique solution exists
      # STOP
    }

    # Swap rows
    if(temp_pivot != i) a[c(i, temp_pivot), ] <- a[c(temp_pivot, i), ]
    
    coeffMat <- a[ , -(n + 1)] # Remove RHS column

    # Elimination
    for(j in (i+1):n){
      pivotElement <- a[i, i]
      pivotRow <- a[i, ]
      originalRow <- a[j, ]
      multiplier <- (a[j, i]) / (pivotElement)
      
      temp_vec <- pivotRow*multiplier
      resultingVector <- originalRow - temp_vec
      
      a[j, ] <- resultingVector
    }
  }

  solution_set <- rep(0,(n+1))

  # Backward substitution
  for(k in (n:1)) solution_set[k] <- (a[k, (n+1)] - sum(a[k, (k+1):n] * solution_set[(k+1):n])) / a[k,k]
  solution_set <- solution_set[-(n+1)]
  output <- list(solutionSet = solution_set, Variables = mat$variables, matrix = a) # nolint
  return(output)
}

GaussJordanElimination <- function(listArg) { # nolint
  mat <- AugCoeffMatrix(listArg)
  a <- mat$augcoeffmatrix
  n <- length(mat$variables)
  a <- a

  # Phase 1: Forward Elimination
  order_vec <- c()
  for (i in 1:n) {
    # Employ pivoting
    if(i != n) {
      coeffMat <- a[,-(n+1)] # coefficient matrix
      
      if(i==1){
        temp_pivot <- which.max(abs(coeffMat[,i]))
      } else {
        temp_pivot <- which.max(abs(coeffMat[-c(1:(i-1)),i]))
        temp_pivot <- temp_pivot + (i-1)
      }

      if (coeffMat[temp_pivot, i] == 0) {
      print("No unique solution exist!")
      return(NA)
      # No unique solution exists
      # STOP
      }
      
      if(temp_pivot!=i) a[c(i,temp_pivot), ] <- a[c(temp_pivot,i), ] # nolint

      coeffMat <- a[,-(n+1)] # remove the RHS column
    }
    
    pivotElement <- a[i,i]
    pivotRow <- a[i,]
    
    pivotRow <- pivotRow/pivotElement 
    a[i, ] <- pivotRow

    for(j in 1:n){
      if(i == j) next
      normRow <- a[j, i] * a[i, ]
      multiplier <- a[j, i]
      originalRow <- a[j, ]

      temp_vec <- pivotRow * multiplier

      res_vec <- originalRow - temp_vec

      a[j, ] <- res_vec
    }
  }


  solution_set <- a[, n + 1]
  names(solution_set) <- NULL
  output <- list(solutionSet = solution_set, Variables = mat$variables, matrix = a) # nolint
  return(output)
}