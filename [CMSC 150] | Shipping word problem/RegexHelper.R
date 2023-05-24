#
  # ** Name: Jonas R. Atienza
  # ** Lab Section: AB-3L
  # ** Program Description: This program is a modified version of the Exercise 3 code. It transforms a passed equation to a numerical vector.
#

library(stringr)

regexTransform <- function(inputStr, isMax){
    n <- str_count(inputStr, "x")

    procStr <- inputStr

    temp_vec <- c() # Initialize a temporary vector for coefficients of each term # nolint
    var_coeff_vec <- c() # Initialize a temporary vector for coefficients of each term # nolint
    var_vec <- c() # Initialize a temporary vector for variable order of each term # nolint
    # Executes while theres a match for ".+?(?=[* ]+x+[0-9])"
    while(grepl(".+?(?=[* ]+x+[0-9])", procStr, perl=TRUE) == TRUE) { # nolint
      # Extract anything before "* xn" and append it to temp_vec # nolint
      rx <- regexpr(".+?(?=[* ]+x+[0-9])", procStr, perl = TRUE)
      temp_vec <- append(temp_vec, as.numeric(regmatches(procStr, rx))) # nolint
      rx <- regexpr("x+[0-9]+", procStr, perl = TRUE)
      var_vec <- append(var_vec, (regmatches(procStr, rx))) # nolint

      orig <- procStr
      # Substitute "" to anything before and including the first "+" match
      procStr <- sub(".+?(?=[+])+[+]", procStr, replacement = "", perl = TRUE) # nolint

      if (orig == procStr){
        procStr <- sub(".+?(?=[<=])+[= ]+", procStr, replacement = "", perl = TRUE) # nolint
      }
      # Executes if next grepl would return FALSE; only RHS coefficient remain
      if (grepl(".+?(?=[* ]+x+[0-9])", procStr, perl = TRUE) == FALSE) {
        if (grepl("(?=[ ])+.*$|.*$", procStr, perl = TRUE) == TRUE) {
            for(x in var_vec) {
                var_coeff_vec <- append(var_coeff_vec, temp_vec[as.numeric(substring(x,2))]) # nolint
            }
          # Appends to coefficients_vec
          var_coeff_vec <- append(var_coeff_vec, as.numeric(procStr)) # nolint
        }
      }
    }

    if(isMax == FALSE && str_count(inputStr, "<=") == 1) var_coeff_vec <- var_coeff_vec * -1
    return(var_coeff_vec)
}