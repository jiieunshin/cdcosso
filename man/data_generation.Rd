% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_generation.R
\name{data_generation}
\alias{data_generation}
\title{Load a matrix from a file}
\usage{
data_generation(
  n,
  p,
  rho,
  a,
  type = c("indep", "group-effect", "additive", "interaction", "survival"),
  response = c("regression", "classification", "count")
)
}
\arguments{
\item{n}{Model object fitted from the cdcosso package.}

\item{p}{The test data you want to predict.}

\item{rho}{The test data you want to predict.}

\item{a}{The test data you want to predict.}

\item{type}{The test data you want to predict.}

\item{response}{The test data you want to predict.}
}
\value{
a list containing the predicted value for the test data (f.new) and the transformed value of that predicted value (mu.new).
}
\description{
The predict.cdcosso function is a function that receives the object and test data (testx) of the cdcosso package as input
and generates a predicted value for the test data.
This function uses the given test data to calculate predictions from the weights and biases generated by the model.
}
