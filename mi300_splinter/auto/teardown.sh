#!/bin/bash
# Post-script


# Response Time script

# Specify the file name you're looking for
# file_name="mi300X_resp_time_750W.yaml"
# # Search for the file within the current directory
# file_path=$(find "$(pwd)" -name "$file_name" -type f)
# if [ -z "$file_path" ]; then
#     echo "[ERROR] File ${file_name} not found in the current directory!"
# fi

if [ "${DRAMLOG}" = "True" ]; then
    python3 -m powerlens.response.resptime_calc "/home/pampdhar/scripts/tests/integration/mi300X_resp_time_750W.yaml" "${CURR_RES_DIR}" --output "${CURR_RES_DIR}" MI300
fi
###############################################################################
###############################################################################

# Bokeh Plotter script
if [ "${UNILOG}" = "True" ]; then
    python3 -m powerlens.response.bokeh_plotter "/home/pampdhar/scripts/tests/integration/MI300X_bokeh_unilog_template.yaml" "${CURR_RES_DIR}" --output "${CURR_RES_DIR}" unilog
fi

# if [ "${DRAMLOG}" = "True" ]; then
#     python3 -m powerlens.response.bokeh_plotter "/home/pampdhar/scripts/tests/integration/MI300X_bokeh_dramlog_template_ppt_aid0.yaml" "${CURR_RES_DIR}" --output "${CURR_RES_DIR}" dram_aid0
#     python3 -m powerlens.response.bokeh_plotter "/home/pampdhar/scripts/tests/integration/MI300X_bokeh_dramlog_template_ppt_aid1.yaml" "${CURR_RES_DIR}" --output "${CURR_RES_DIR}" dram_aid1
#     python3 -m powerlens.response.bokeh_plotter "/home/pampdhar/scripts/tests/integration/MI300X_bokeh_dramlog_template_ppt_aid2.yaml" "${CURR_RES_DIR}" --output "${CURR_RES_DIR}" dram_aid2
#     python3 -m powerlens.response.bokeh_plotter "/home/pampdhar/scripts/tests/integration/MI300X_bokeh_dramlog_template_ppt_aid3.yaml" "${CURR_RES_DIR}" --output "${CURR_RES_DIR}" dram_aid3
# fi    