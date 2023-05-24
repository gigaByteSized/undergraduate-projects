#
  # ** Name: Jonas R. Atienza
  # ** Lab Section: AB-3L
  # ** Program Description: 
#

simplex <- function(tableau, isMax, problem) { # nolint
    TR <- c()
    PE <- 0
    PR <- c()
    PC <- c()

    if(isMax == FALSE){
      tableau <- t(tableau)
      rownames(tableau)[nrow(tableau)] <- "Z"
      colnames(tableau)[ncol(tableau)] <- "solutions"
      solutions <- tableau[, "solutions"]
      tableau <- tableau[, -ncol(tableau)]
      tableau["Z", ] <- tableau["Z", ] * -1

      for(i in 1:(ncol(tableau))) colnames(tableau)[i] <- paste("s", i, sep = "") # nolint
      for(i in 1:(nrow(tableau)-1)) rownames(tableau)[i] <- paste("c", i, sep = "") # nolint

      for(i in 1:nrow(tableau)){
        x <- replicate(nrow(tableau), 0)
        x[i] <- 1
        tableau <- cbind(tableau, x)
        if (i == nrow(tableau)) colnames(tableau)[ncol(tableau)] <- paste("xZ", sep = "") # nolint
        else colnames(tableau)[ncol(tableau)] <- paste("x", i, sep = "")
      }
      tableau <- cbind(tableau, solutions)
    } else{
      solutions <- tableau[, "solutions"]
      tableau <- tableau[, -ncol(tableau)]
      tableau["Z", ] <- tableau["Z", ] * -1
      for(i in 1:nrow(tableau)){
        s <- replicate(nrow(tableau), 0)
        s[i] <- 1
        tableau <- cbind(tableau, s)
        if (i == nrow(tableau)) colnames(tableau)[ncol(tableau)] <- paste("sZ", sep = "") # nolint
        else colnames(tableau)[ncol(tableau)] <- paste("s", i, sep = "")
      }
      tableau <- cbind(tableau, solutions)
    }

    while(!(all(tableau["Z", ] >= 0))){
      PE <- NaN # Base case for PE
        # Obtain pivot row, column, and element
        zMax <- max(tableau["Z", ]*-1)*-1
        for(i in 1:ncol(tableau)){
          if(identical(tableau["Z", i], zMax)){
            colnamePC <- colnames(tableau)[i]
            break()
          }
        }

        PC <- tableau[,colnamePC]
        TR <- tableau[,"solutions"]/PC
        TR <- TR[-length(TR)] # Remove Z
        toComp <- c()

        for(i in TR){
          if(is.nan(i)){
          } else if (!is.infinite(i) && i > 0) toComp <- append(toComp, i)
        }
        if(is.nan(PE) && is.null(toComp)){
          return("No feasible solution!")
        }
        minTR <- min(toComp)
        for(i in 1:length(TR)){
          if(is.nan(TR[i])){
          } else if (minTR == TR[i]){
            rowNamePR <- names(TR)[i]
            break()
          }
        }

        PR <- tableau[rowNamePR, ]
        PE <- tableau[rowNamePR, colnamePC]

        # Normalize pivot row
        nPR <- PR/PE # Use round( , 4) if needed
        tableau[rowNamePR, ] <- nPR
        for(i in 1:nrow(tableau)){
          if(!identical(tableau[i, ], tableau[rowNamePR, ])){
            rowCoeff <- tableau[i, colnamePC]
            tableau[i, ] <- tableau[i, ] - (nPR * rowCoeff) # Use round( , 4) if needed #nolint
          }
        }
        if(isMax == TRUE){
          basicSolution <- replicate(nrow(tableau), 0)
          for(i in 1:(ncol(tableau)-1)){
            count <- 0
            for(j in 1:nrow(tableau)){
              if(tableau[j, i] > 0 || tableau[j, i] < 0){
                count <- count+1
                sol <- j
              }
            }
            if(count == 1){
              basicSolution[i] <- tableau[sol, "solutions"]
            }
          }
        } else {
          basicSolution <- tableau["Z", -(ncol(tableau)-1)]
          names(basicSolution)[length(basicSolution)] <- "Z"
        }
    }
    
  if(problem == TRUE){
    shippingColNames <- c("SAC","SL","ALB","CHI","NYC")
    shippingRowNames <- c("DEN", "PHO", "DAL")
    shippingMat <- matrix(data = 0, nrow = 3, ncol = 5, dimnames = list(shippingRowNames,shippingColNames))

    count <- 0
    index <- 0
    shipping_row_vec <- c()
    cNames <- names(basicSolution)
    for(i in 1:(length(basicSolution)-1)){
      if(grepl("x", cNames[i])){
        shipping_row_vec <- append(shipping_row_vec, basicSolution[cNames[i]])
        count <- count + 1
        if(count == 5){
          index <- index + 1
          shippingMat[index, ] <- shipping_row_vec
          shipping_row_vec <- c()
          count <- 0
        }
      }
    }
      
    output <- list(final.tableau = tableau, basic.solution = basicSolution, opt.val = basicSolution[length(basicSolution)], shipping.num = shippingMat)
  } else output <- list(final.tableau = tableau, basic.solution = basicSolution, opt.val = basicSolution[length(basicSolution)])
  
  return(output)
}
