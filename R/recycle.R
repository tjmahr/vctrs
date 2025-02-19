#' Recycling rules used by r-lib and the tidyverse
#'
#' @description
#' Recycling describes the concept of repeating elements of one vector to match
#' the size of another. There are two rules that underlie the "tidyverse"
#' recycling rules:
#'
#' - Vectors of size 1 will be recycled to the size of any other vector
#'
#' - Otherwise, all vectors must have the same size
#'
#' @section Examples:
#'
#' ```{r, warning = FALSE, message = FALSE, include = FALSE}
#' library(tibble)
#' ```
#'
#' Vectors of size 1 are recycled to the size of any other vector:
#'
#' ```{r, comment = "#>"}
#' tibble(x = 1:3, y = 1L)
#' ```
#'
#' This includes vectors of size 0:
#'
#' ```{r, comment = "#>"}
#' tibble(x = integer(), y = 1L)
#' ```
#'
#' If vectors aren't size 1, they must all be the same size. Otherwise, an error
#' is thrown:
#'
#' ```{r, comment = "#>", error = TRUE}
#' tibble(x = 1:3, y = 4:7)
#' ```
#'
#' @section vctrs backend:
#'
#' Packages in r-lib and the tidyverse generally use [vec_size_common()] and
#' [vec_recycle_common()] as the backends for handling recycling rules.
#'
#' - `vec_size_common()` returns the common size of multiple vectors, after
#'   applying the recycling rules
#'
#' - `vec_recycle_common()` goes one step further, and actually recycles the
#'   vectors to their common size
#'
#' ```{r, comment = "#>", error = TRUE}
#' vec_size_common(1:3, "x")
#'
#' vec_recycle_common(1:3, "x")
#'
#' vec_size_common(1:3, c("x", "y"))
#' ```
#'
#' @section Base R recycling rules:
#'
#' The recycling rules described here are stricter than the ones generally used
#' by base R, which are:
#'
#' - If any vector is length 0, the output will be length 0
#'
#' - Otherwise, the output will be length `max(length_x, length_y)`, and a
#'   warning will be thrown if the length of the longer vector is not an integer
#'   multiple of the length of the shorter vector.
#'
#' We explore the base R rules in detail in `vignette("type-size")`.
#'
#' @name vector_recycling_rules
#' @keywords internal
NULL

#' Vector recycling
#'
#' `vec_recycle(x, size)` recycles a single vector to a given size.
#' `vec_recycle_common(...)` recycles multiple vectors to their common size. All
#' functions obey the [vctrs recycling rules][vector_recycling_rules], and will
#' throw an error if recycling is not possible. See [vec_size()] for the precise
#' definition of size.
#'
#' @inheritParams rlang::args_error_context
#'
#' @param x A vector to recycle.
#' @param ... Depending on the function used:
#'   * For `vec_recycle_common()`, vectors to recycle.
#'   * For `vec_recycle()`, these dots should be empty.
#' @param size Desired output size.
#' @param .size Desired output size. If omitted,
#'   will use the common size from [vec_size_common()].
#' @param x_arg Argument name for `x`. These are used in error
#'   messages to inform the user about which argument has an
#'   incompatible size.
#'
#' @section Dependencies:
#' - [vec_slice()]
#'
#' @export
#' @examples
#' # Inputs with 1 observation are recycled
#' vec_recycle_common(1:5, 5)
#' vec_recycle_common(integer(), 5)
#' \dontrun{
#' vec_recycle_common(1:5, 1:2)
#' }
#'
#' # Data frames and matrices are recycled along their rows
#' vec_recycle_common(data.frame(x = 1), 1:5)
#' vec_recycle_common(array(1:2, c(1, 2)), 1:5)
#' vec_recycle_common(array(1:3, c(1, 3, 1)), 1:5)
vec_recycle <- function(x, size, ..., x_arg = "", call = caller_env()) {
  check_dots_empty0(...)
  .Call(ffi_recycle, x, size, environment())
}

#' @export
#' @rdname vec_recycle
vec_recycle_common <- function(...,
                               .size = NULL,
                               .arg = "",
                               .call = caller_env()) {
  .External2(ffi_recycle_common, .size)
}
