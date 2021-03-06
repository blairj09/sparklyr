% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/spark_apply.R
\name{spark_apply}
\alias{spark_apply}
\title{Apply an R Function in Spark}
\usage{
spark_apply(
  x,
  f,
  columns = NULL,
  memory = !is.null(name),
  group_by = NULL,
  packages = NULL,
  context = NULL,
  name = NULL,
  barrier = NULL,
  ...
)
}
\arguments{
\item{x}{An object (usually a \code{spark_tbl}) coercable to a Spark DataFrame.}

\item{f}{A function that transforms a data frame partition into a data frame.
  The function \code{f} has signature \code{f(df, context, group1, group2, ...)} where
  \code{df} is a data frame with the data to be processed, \code{context}
  is an optional object passed as the \code{context} parameter and \code{group1} to
  \code{groupN} contain the values of the \code{group_by} values. When
  \code{group_by} is not specified, \code{f} takes only one argument.

  Can also be an \code{rlang} anonymous function. For example, as \code{~ .x + 1}
  to define an expression that adds one to the given \code{.x} data frame.}

\item{columns}{A vector of column names or a named vector of column types for
the transformed object. When not specified, a sample of 10 rows is taken to
infer out the output columns automatically, to avoid this performance penalty,
specify the column types. The sample size is configurable using the
\code{sparklyr.apply.schema.infer} configuration option.}

\item{memory}{Boolean; should the table be cached into memory?}

\item{group_by}{Column name used to group by data frame partitions.}

\item{packages}{Boolean to distribute \code{.libPaths()} packages to each node,
  a list of packages to distribute, or a package bundle created with
  \code{spark_apply_bundle()}.

  Defaults to \code{TRUE} or the \code{sparklyr.apply.packages} value set in
  \code{spark_config()}.

  For clusters using Yarn cluster mode, \code{packages} can point to a package
  bundle created using \code{spark_apply_bundle()} and made available as a Spark
  file using \code{config$sparklyr.shell.files}. For clusters using Livy, packages
  can be manually installed on the driver node.

  For offline clusters where \code{available.packages()} is not available,
  manually download the packages database from
 https://cran.r-project.org/web/packages/packages.rds and set
  \code{Sys.setenv(sparklyr.apply.packagesdb = "<pathl-to-rds>")}. Otherwise,
  all packages will be used by default.

  For clusters where R packages already installed in every worker node,
  the \code{spark.r.libpaths} config entry can be set in \code{spark_config()}
  to the local packages library. To specify multiple paths collapse them
  (without spaces) with a comma delimiter (e.g., \code{"/lib/path/one,/lib/path/two"}).}

\item{context}{Optional object to be serialized and passed back to \code{f()}.}

\item{name}{Optional table name while registering the resulting data frame.}

\item{barrier}{Optional to support Barrier Execution Mode in the scheduler.}

\item{...}{Optional arguments; currently unused.}
}
\description{
Applies an R function to a Spark object (typically, a Spark DataFrame).
}
\section{Configuration}{


\code{spark_config()} settings can be specified to change the workers
environment.

For instance, to set additional environment variables to each
worker node use the \code{sparklyr.apply.env.*} config, to launch workers
without \code{--vanilla} use \code{sparklyr.apply.options.vanilla} set to
\code{FALSE}, to run a custom script before launching Rscript use
\code{sparklyr.apply.options.rscript.before}.
}

\examples{
\dontrun{

library(sparklyr)
sc <- spark_connect(master = "local[3]")

# creates an Spark data frame with 10 elements then multiply times 10 in R
sdf_len(sc, 10) \%>\% spark_apply(function(df) df * 10)

# using barrier mode
sdf_len(sc, 3, repartition = 3) \%>\%
  spark_apply(nrow, barrier = TRUE, columns = c(id = "integer")) \%>\%
  collect()
}

}
