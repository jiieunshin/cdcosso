#' Load a matrix from a file
#'
#' The predict.cdcosso function is a function that receives the object and test data (testx) of the cdcosso package as input
#' and generates a predicted value for the test data.
#' This function uses the given test data to calculate predictions from the weights and biases generated by the model.
#'
#' @param n The number of observation of a example dataset.
#' @param p Dimension of a example dataset.
#' @param rho Correlation for first five significance variables.
#' @param response Type of response variable.
#'
#' @return a list containing the predicted value for the test data (f.new) and the transformed value of that predicted value (mu.new).
#' @export
data_generation = function(n, p, rho,
                           response = c("regression", "classification", "count", "survival", "interaction")){
  f1 = function(t) t - 0.5
  f2 = function(t) (2 * t - 1)^2 - 0.4
  f3 = function(t) sin(2 * pi * t) / (2 - sin(pi * t))
  f4 = function(t) 0.1*sin(2 * pi * t) + 0.2*cos(2 * pi * t) + 0.3*sin(2 * pi * t)^2 + 0.4*cos(2 * pi * t)^2 + 0.5*sin(2 * pi * t)^3 - 0.4
  f5 = function(t) sin(pi * t^4) + t^4 - 0.4

  # f1 = function(t) 5 * sin(3*t)
  # f2 = function(t) -4 * t^4 + 9.33 * t^3 + 5 * t^2 - 8.33 * t
  # f3 = function(t) t * (1-t^2) * exp(3 * t) - 4
  # f4 = function(t) 4 * t
  # f5 = function(t) 4 * sin(-5 * log(sqrt(t+3)))

  if(missing(response))
    type = "classification"
  response = match.arg(response)

  if(missing(n)) n = 200
  if(missing(p)) p = 10
  if(missing(rho)) rho = 0.8

  if(p <= 5) stop("dimension size should be larger than 5.")

  Sigma = matrix(rho, 5, 5)
  diag(Sigma) = 1

  x = pnorm(rmvnorm(n, sigma = Sigma))

  f = 5 * f1(x[,1]) + 2 * f2(x[,2]) + 3 * f3(x[,3]) + 6 * f4(x[,4]) + 4 * f5(x[,5])

  # f = f1(x[,1]) + f2(x[,2]) + f3(x[,3]) + f4(x[,4]) + f5(x[,5])

  SNR = sd(f) / sqrt((p-5) * .4)
  print(SNR)
  x_nois = pnorm(matrix(rnorm(n * (p-5), 0, SNR), n, (p-5)))
  x = cbind(x, x_nois)


  # Set the outer margins
  # par(oma = c(0, 0, 0, 0))
  # Set the inner margin
  # par(mar = c(4, 4, 3, 1))
  # par(mfrow = c(1,5))
  # plot(x[,1], f1(x[,1]), cex = .6, pch = 16, xlab = 'x1', ylab = 'f1')
  # plot(x[,2], f2(x[,2]), cex = .6, pch = 16, xlab = 'x2', ylab = 'f2')
  # plot(x[,3], f3(x[,3]), cex = .6, pch = 16, xlab = 'x3', ylab = 'f3')
  # plot(x[,4], f4(x[,4]), cex = .6, pch = 16, xlab = 'x4', ylab = 'f4')
  # plot(x[,5], f5(x[,5]), cex = .6, pch = 16, xlab = 'x5', ylab = 'f5')
  # par(mfrow = c(1,1))


  if(response == "regression"){
    # SNR = sqrt(.6*(p-5)) # SNR = 4일 때
    # print(SNR)
    # f = f + rnorm(n, 0, SNR)
    # f = f
    out = list(x = x, y = f)
  }

  if(response == "classification"){
    # SNR = sqrt(var(f) / 4)
    # SNR = sqrt(.6*(p-5)) # SNR = 4일 때
    # e = rnorm(n, 0, SNR)
    prob = exp(f)/(exp(f) + 1)
    y = rbinom(n, 1, prob)
    # plot(prob)
    # print(table(y))
    out = list(x = x, f = f, y = y)
  }

  if(response == "count"){
    mu = exp(f/sqrt(2)/p)

    # SNR = sqrt(var(f) / 4)
    # SNR = sqrt(.6*(p-5))
    # e = rnorm(n, 0, SNR)
    # mu = exp(f)
    y = rpois(n, mu)
    out = list(x = x, f = f, y = y)
  }

  if(response == 'survival'){
    # Sigma = matrix(1, 8, 8)
    # for(j in 1:8){
    #   for(k in 1:8){
    #     Sigma[j, k] = rho^abs(j-k)
    #   }
    # }
    #
    # x_sig = rtmvnorm(n, mean = rep(0, 8), sigma = Sigma, lower = rep(-2, 8), upper = rep(2, 8))
    # x_nois = rtmvnorm(n, mean = rep(0, p-8), sigma = diag(1, p-8, p-8), lower = rep(-2, p-8), upper = rep(2, p-8))
    # x = cbind(x_sig, x_nois)
    # x = apply(x, 2, rescale)

    # Sigma = matrix(1, 5, 5)
    # for(j in 1:5){
    #   for(k in 1:5){
    #     Sigma[j, k] = rho^abs(j-k)
    #   }
    # }
    #
    # x_sig = rtmvnorm(n, mean = rep(0, 5), sigma = Sigma, lower = rep(-2, 5), upper = rep(2, 5))
    # x_nois = rtmvnorm(n, mean = rep(0, p-5), sigma = diag(1, p-5, p-5), lower = rep(-2, p-5), upper = rep(2, p-5))
    # x = cbind(x_sig, x_nois)
    # x = apply(x, 2, rescale)
    #
    # f6 = function(t) cos(2 * pi * t) + sin(pi * t)

    # f = 3 * (3 * x[, 1] - 2)^2 +  7 * cos((3 * x[, 3] - 1.5) * pi / 5) + ifelse(x[, 5] < 0.5, 0, 1) + 1 * f6(x[, 2]) + 11 * (exp(x[, 4]) - 3)

    # f = 3 * (3 * x[, 1] - 2)^2 + 8 * cos((3 * x[, 3] - 1.5) * pi / 5) + ifelse(x[, 5] < 0.5, 0, 1) + 2 * f6(x[, 2]) + 11 * (exp(x[, 4]) - 2)
    # f = 3 * (3 * x[, 1] - 2)^2 + 8 * cos((3 * x[, 3] - 1.5) * pi / 5) + 9 * (exp(x[, 5]) - 2) + 1 * f6(x[, 2]) + 5 * f4(x[, 4])
    # SNR = sqrt(var(f) / 4)
    # f = f + rnorm(n, 0, SNR)

    surTime = rexp(n, exp(f))
    cenTime = rexp(n, exp(-f) * runif(1, 4, 6))
    y = cbind(time = apply(cbind(surTime, cenTime), 1, min), status = 1 * (surTime < cenTime))

    # 14.003
    # mean(tr_y[,"status"])

    out = list(x = x, f = f, y = y)
  }
  return(out)
}


# tr = data_generation(100, 50, response = "survival")
# tr_x = tr$x
# tr_y = tr$y
# try(cdcosso(tr_x, tr_y, family = 'Cox', gamma = 0.95, kernel = "spline", scale = T, algo = "CD",
#             lambda_theta = exp(seq(log(2^{-35}), log(2^{2}), length.out = 20))
# ), silent = TRUE)

# fit10 = try(cdcosso(tr_x, tr_y, family = 'Cox', gamma = 0.95, kernel = "spline", scale = T, algo = "CD"), silent = TRUE)
# print(fit10$theta_step$theta.new)
# par(mfrow = c(1, 5))
# for(i in 1:5)
#   plot(c(te_x[, i]), en1_pred$f.new, main = i)


# ff = function(t) 3*((3 * t - 2)^2 - 1)
# plot(te_x[,5], ff(te_x[,5]), cex = .6, pch = 16, xlab = 'x5', ylab = 'f5')
# fff = ff(te_x[,5])
# prob = exp(fff)/(exp(fff) + 1)
# y = rbinom(n, 1, prob)
# plot(prob)
# print(table(y))
# plot(tr$f)


