#!/bin/bash
# Start App run


# Babelstream_fp64_1p
if [ "${APP_NAME}" = "babelstream_fp64" ]; then
    ${APP_DIR}/babelstream/doBabel_1p
fi

# rocblas_dgemm_4k_1p
if [ "${APP_NAME}" = "rocblas_dgemm_NT_7296x4864x4096_1000-iter" ]; then
    ${APP_DIR}/rocblas/doRocblas_1p
fi

# minihpl
if [ "${APP_NAME}" = "minihpl" ]; then
    ${APP_DIR}/minihpl/doMinihpl_1p
fi