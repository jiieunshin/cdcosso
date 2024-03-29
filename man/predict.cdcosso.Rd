% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict.cdcosso.R
\name{predict.cdcosso}
\alias{predict.cdcosso}
\title{Load a matrix from a file}
\usage{
\method{predict}{cdcosso}(object, testx)
}
\arguments{
\item{object}{Model object fitted from the cdcosso package.}

\item{testx}{The test data you want to predict.}
}
\value{
a list containing the predicted value for the test data (f.new) and the transformed value of that predicted value (mu.new).
}
\description{
The predict.cdcosso function is a function that receives the object and test data (testx) of the cdcosso package as input
and generates a predicted value for the test data.
This function uses the given test data to calculate predictions from the weights and biases generated by the model.
}
