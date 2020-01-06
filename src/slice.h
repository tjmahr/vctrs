#ifndef VCTRS_SLICE_H
#define VCTRS_SLICE_H


struct vec_as_location_options {
  bool convert_negative;
};

SEXP vec_as_location(SEXP i, R_len_t n, SEXP names);
SEXP vec_as_location_opts(SEXP i, R_len_t n, SEXP names, struct vec_as_location_options* opts);


#endif
