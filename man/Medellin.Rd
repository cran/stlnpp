\name{Medellin}
\alias{Medellin}
\docType{data}
\title{
Medellin traffic accident data
}
\description{
This dataset represents the spatio-temporal locations of traffic accidents in an area near the pontifical bolivarian university in Medellin (Colombia) during 2016. The entire data were published in the OpenData portal of Medellin Town Hall at https://www.medellin.gov.co/geomedellin/index.hyg.

The dataset \code{\link{Medellin}} is an object of class \code{\link{stlpp}}.
}
\usage{
data(Medellin)
}

\source{
This data is a part of enitre data which is selected and converted to this format by Mehdi Moradi.
}

\references{
Moradi, M., & Mateu, J. (2020). First-and second-order characteristics of spatio-temporal point processes on linear networks. Journal of Computational and Graphical Statistics, 29(3), 432-443.
}
\author{
Mehdi Moradi <m2.moradi@yahoo.com>
}
\seealso{
\code{\link{stlpp}}
}
\examples{
data(Medellin)
plot(Medellin)
}