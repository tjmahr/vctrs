#ifndef VCTRS_POLY_OP
#define VCTRS_POLY_OP

#include "vctrs.h"

typedef int (*poly_binary_int_fn_ptr)(const void* x, r_ssize i, const void* y, r_ssize j);
poly_binary_int_fn_ptr new_poly_p_equal_na_equal(enum vctrs_type type);

typedef bool (*poly_unary_bool_fn_ptr)(const void* x, r_ssize i);
poly_unary_bool_fn_ptr new_poly_p_is_incomplete(enum vctrs_type type);

struct poly_df_data {
  enum vctrs_type* v_col_type;
  const void** v_col_ptr;
  r_ssize n_col;
};

struct poly_vec {
  SEXP vec;
  const void* p_vec;
  SEXP self;
};

struct poly_vec* new_poly_vec(SEXP proxy, enum vctrs_type type);

#define PROTECT_POLY_VEC(p_poly_vec, p_n) do { \
  PROTECT((p_poly_vec)->vec);                  \
  PROTECT((p_poly_vec)->self);                 \
  *(p_n) += 2;                                 \
} while(0)

#endif
