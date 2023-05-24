#
  # ** Name: Jonas R. Atienza
  # ** Lab Section: AB-3L
  # ** Program Description: This function accepts a list and creates the augmented coefficient matrix for the functions and return it in a single list variable. # nolint
#

AugCoeffMatrix <- function(listArg) { # nolint
  # Declare and initialize variables and counters
  functions <- c()
  raw_terms <- c()
  coefficients_vec <- c()
  variables_list <- list()
  temp_list <- list()
  count <- 0

  # Declare empty vectors for col and row names
  cols <- c()
  rows <- c()

  for (x in listArg){ # Iterate over listArg
    # Deparse and assign functions and terms
    functions <- append(functions, deparse(x, width.cutoff = 500L)[1])
    raw_terms <- append(raw_terms, deparse(x, width.cutoff = 500L)[2])
    count <- count + 1 # Increment count
  }
  
  #print(raw_terms)
  for (i in 1:count) { # Iterate over number of elements in the list
    # Extract "function (" from each element of functions[] and get number of chars from "f" to "(" # nolint
    rx <- regexpr("function\\s+\\(|function\\(", functions[i], perl = TRUE) # nolint
    n <- nchar(regmatches(functions[i], rx))
    # Get substring immediately after "(" and before ")"
    # Split temp_vars and assign to variables_list[]
    temp_vars <- substring(functions[i], n + 1, nchar(functions[i]) - 2)
    variables_list[i] <- strsplit(temp_vars, ",\\s+|,")

    if (i > 1 && length(variables_list[[i]]) != length(variables_list[[1]])) { # Returns NA  if number of the unknown variables of the mathematical functions are not equal to each other # nolint
      return(NA)
    }

    temp_vec <- c() # Initialize a temporary vector for coefficients of each term # nolint
    var_coeff_vec <- c() # Initialize a temporary vector for coefficients of each term # nolint
    var_vec <- c() # Initialize a temporary vector for variable order of each term # nolint
    # Executes while theres a match for ".+?(?=[* ]+x+[0-9])"
    while(grepl(".+?(?=[* ]+x+[0-9])", raw_terms[i], perl=TRUE) == TRUE) { # nolint
      # Extract anything before "* xn" and append it to temp_vec # nolint
      rx <- regexpr(".+?(?=[* ]+x+[0-9])", raw_terms[i], perl = TRUE)
      temp_vec <- append(temp_vec, as.numeric(regmatches(raw_terms[i], rx))) # nolint
      rx <- regexpr("x+[0-9]+", raw_terms[i], perl = TRUE)
      var_vec <- append(var_vec, (regmatches(raw_terms[i], rx))) # nolint

      # Substitute "" to anything before and including the first "+" match
      raw_terms[i] <- sub(".+?(?=[+])+[+]", raw_terms[i], replacement = "", perl = TRUE) # nolint
      # Executes if next grepl would return FALSE; only RHS coefficient remain
      if (grepl(".+?(?=[* ]+x+[0-9])", raw_terms[i], perl = TRUE) == FALSE) {
        if (grepl("(?=[ ])+.*$|.*$", raw_terms[i], perl = TRUE) == TRUE) {
            for(x in var_vec) {
                var_coeff_vec <- append(var_coeff_vec, temp_vec[as.numeric(substring(x,2))]) # nolint
            }
          # Appends to coefficients_vec
          coefficients_vec <- append(coefficients_vec, as.numeric(raw_terms[i]))
        }
      }
    }

    # Append the temp list
    temp_list <- append(temp_list, list(var_coeff_vec))

    # Col/row name update
    cols <- append(cols, paste("x", i, sep = ""))
    rows <- append(rows, i)
    if (i == count) {
      cols <- append(cols, "RHS")
    }
  }

  # Prepare augcoeffmatrix
  augcoeffmatrix <- matrix(unlist(temp_list), ncol = count, nrow = count, byrow = TRUE) # nolint
  augcoeffmatrix <- cbind(augcoeffmatrix, coefficients_vec)
  rownames(augcoeffmatrix) <- rows
  colnames(augcoeffmatrix) <- cols

  # Create labelled list and return the created labelled list
  output <- list(variables=variables_list[[1]], augcoeffmatrix=augcoeffmatrix)
  return(output)
}