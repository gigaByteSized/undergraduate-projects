#
  # ** Name: Jonas R. Atienza
  # ** Lab Section: AB-3L
  # ** Program Description: 
#

source("LinearAlgebra.R")

poly.qsi <- function(inputData, inputX) { # nolint
    # Input error detection
    if (!(is.list(inputData))) return(NA) # nolint
    if(!((is.vector(inputData[[1]]) && !is.list(inputData[[1]]) && (is.vector(inputData[[2]]) && !is.list(inputData[[2]]))))) return(NA) # nolint
    if (length(inputData[1]) != length(inputData[2])) return(NA) # nolint
    if (length(inputData[1]) != length(inputData[2])) return(NA) # nolint

    # Unlist input into 2 vectors
    x <- unlist(inputData[1])
    fx <- unlist(inputData[2])

    # If inputX is outside x
    if (inputX < x[1] || inputX > x[length(x)]) return(NA) # nolint

    # Get n intervals
    n <- length(x)-1
    xn <- ((3*n)-1)

    # Setup initial variables
    polybases <- c()

    # Setup function signature
    # polystring would be function signature template
    polystring <- "function("
    for (i in 1:((3*n)-1)) {
        polystring <- paste(polystring, "x", i, sep = "") # nolint
        if (((3*n)-1) - i != 0) polystring <- paste(polystring, ", ", sep = "")
    }
    polystring <- paste(polystring, ") ", sep = "")

    # First condition
    for (i in 2:n) {
        temp <- polystring
        k <- 0

        if (i == 2) {
            temp <- paste(temp, x[2], " * x1", " + ", sep = "") # nolint
            temp <- paste(temp, 1, " * x2", " + ", sep = "") # nolint
            k <- k+2

            for (j in 3:((3 * n) - 1)){
                temp <- paste(temp, 0, " * x", j, " + ", sep = "")
                k <- k+1
            }

            temp <- paste(temp, fx[i], sep = "")

            polybases <- append(polybases, eval(parse(text = temp))) # nolint

            temp <- polystring
            k <- 0
            for (j in 1:2) {
                temp <- paste(temp, 0, " * x", j, " + ", sep = "")
                k <- k+1
            }

            temp <- paste(temp, x[2]**2, " * x3", " + ", sep = "") # nolint
            temp <- paste(temp, x[2], " * x4", " + ", sep = "") # nolint
            temp <- paste(temp, 1, " * x5", " + ", sep = "") # nolint

            k <- k+3

            for (j in (k+1):((3 * n) - 1)) temp <- paste(temp, 0, " * x", j, " + ", sep = "") # nolint

            temp <- paste(temp, fx[i], sep = "")

            polybases <- append(polybases, eval(parse(text = temp))) # nolint
        }

        if (i > 2) {
            for (j in 1:(2+(3*(i-3)))){
                temp <- paste(temp, 0, " * x", j, " + ", sep = "")
                k <- k+1
            }

            temp0 <- temp
            k0 <- k
            for (j in (k0+1):(k0+3)){
                temp0 <- paste(temp0, 0, " * x", j, " + ", sep = "")
                k0 <- k0+1
            }
            temp <- paste(temp, x[i]**2, " * x", k+1, " + ", sep = "") # nolint
            temp <- paste(temp, x[i], " * x", k + 2, " + ", sep = "") # nolint
            temp <- paste(temp, 1, " * x", k + 3, " + ", sep = "") # nolint
            k <- k+3
            for (j in (k+1):xn) {
                temp <- paste(temp, 0, " * x", k+1, " + ", sep = "")
                k <- k+1

            }

            temp <- paste(temp, fx[i], sep = "")
            polybases <- append(polybases, eval(parse(text = temp))) # nolint
            temp0 <- paste(temp0, x[i]**2, " * x", k0 + 1, " + ", sep = "") # nolint
            temp0 <- paste(temp0, x[i], " * x", k0 + 2, " + ", sep = "") # nolint
            temp0 <- paste(temp0, 1, " * x", k0 + 3, " + ", sep = "") # nolint
            k0 <- k0+3

            if(k0 < xn){
                for (j in (k0+1):xn) {
                    temp0 <- paste(temp0, 0, " * x", k0+1, " + ", sep = "")
                    k0 <- k0+1
                }
            }

            temp0 <- paste(temp0, fx[i], sep = "")
            polybases <- append(polybases, eval(parse(text = temp0))) # nolint
        }
    }

    # Second condition
    # x0
    temp <- polystring
    temp <- paste(temp, x[1], " * x1", " + ", sep = "") # nolint
    temp <- paste(temp, 1, " * x2", " + ", sep = "") # nolint
    for (i in 3:((3 * n) - 1)) temp <- paste(temp, 0, " * x", i, " + ", sep = "") # nolint
    temp <- paste(temp, fx[1], sep = "")
    polybases <- append(polybases, eval(parse(text = temp))) # nolint

    # x1
    temp <- polystring
    for (i in 1:((3 * n) - 4)) temp <- paste(temp, 0, " * x", i, " + ", sep = "") # nolint
    temp <- paste(temp, x[n+1]**2, " * x", ((3 * n)-3), " + ", sep = "") # nolint
    temp <- paste(temp, x[n+1], " * x", ((3 * n)-2), " + ", sep = "") # nolint
    temp <- paste(temp, 1, " * x", (3 * n)-1, " + ", sep = "") # nolint
    temp <- paste(temp, fx[n+1], sep = "")
    polybases <- append(polybases, eval(parse(text = temp))) # nolint

    # Third condition
    for (i in 2:n) {
        temp <- polystring
        k <- 0

        if (i == 2) {
            temp <- paste(temp, 1, " * x1", " + ", sep = "") # nolint
            temp <- paste(temp, 0, " * x2", " + ", sep = "")
            temp <- paste(temp, -(x[i]*2), " * x3", " + ", sep = "") # nolint
            temp <- paste(temp, -1, " * x4", " + ", sep = "") # nolint
            temp <- paste(temp, 0, " * x5", " + ", sep = "") # nolint
            k <- k+5

            for (j in (k+1):((3 * n) - 1)){
                temp <- paste(temp, 0, " * x", j, " + ", sep = "")
                k <- k+1
            }

            temp <- paste(temp, 0, sep = "")
            polybases <- append(polybases, eval(parse(text = temp))) # nolint
        }

        if (i > 2) {
            for (j in 1:(2+(3*(i-3)))){
                temp <- paste(temp, 0, " * x", j, " + ", sep = "")
                k <- k+1
            }

            temp <- paste(temp, (x[i]*2), " * x", (k+1), " + ", sep = "") # nolint
            k <- k+1
            temp <- paste(temp, 1, " * x", (k+1), " + ", sep = "") # nolint
            k <- k+1
            temp <- paste(temp, 0, " * x", (k+1), " + ", sep = "")
            k <- k+1
            temp <- paste(temp, -(x[i]*2), " * x", (k+1), " + ", sep = "") # nolint
            k <- k+1
            temp <- paste(temp, -1, " * x", (k+1), " + ", sep = "") # nolint
            k <- k+1
            temp <- paste(temp, 0, " * x", (k+1), " + ", sep = "") # nolint
            k <- k+1
            if(k < xn){
                for (j in (k+1):xn) {
                    temp <- paste(temp, 0, " * x", k+1, " + ", sep = "")
                    k <- k+1
                }
            }
            temp <- paste(temp, 0, sep = "")
            polybases <- append(polybases, eval(parse(text = temp))) # nolint
        }
    }

    solution_set <- c(0)
    solution_set <- append(solution_set, GaussJordanElimination(polybases)$solutionSet) # nolint

    qsi.fxns <- c()

    for(i in 1:n){
        temp <- "function(x) "
        temp <- paste(temp, solution_set[(i*3)-2], " * x**2 + ", solution_set[(i*3)-1], " * x + ", solution_set[(i*3)], sep = "") # nolint
        qsi.fxns <- append(qsi.fxns, temp)
    }

    for(i in 1:n) if(inputX >= x[i] && inputX <= x[i+1]) y = eval(parse(text = qsi.fxns[i]))(inputX) # nolint

    output <- list(baseMat = AugCoeffMatrix(polybases)$augcoeffmatrix, newMat = GaussJordanElimination(polybases)$matrix, solution.set = solution_set, qsi.fxns = qsi.fxns, y = y) # nolint

    return(output)
}