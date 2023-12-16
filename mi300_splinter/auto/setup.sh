#!/bin/bash
# Pre-script

# # PPT0/1 Throttler
# #python3 -m ppa_settings.ppa_settings read_ppt0limit
# python3 -m ppa_settings.ppa_settings write_ppt0limit 750
# python3 -m ppa_settings.ppa_settings write_ppt1limit 1031.25
# python3 -m ppa_settings.ppa_settings write_ppt0_parameters 0.2 0.3 2
# python3 -m ppa_settings.ppa_settings write_ppt1_parameters 1 2.3 0.1194

# # TDC Throttler
# python3 -m ppa_settings.ppa_settings write_tdcgfx_limit 195
# python3 -m ppa_settings.ppa_settings write_tdcsoc_limit 360
# python3 -m ppa_settings.ppa_settings write_tdchbm_limit 110
# python3 -m ppa_settings.ppa_settings write_tdcgfx_parameters 0.01 0.1667 10
# python3 -m ppa_settings.ppa_settings write_tdcsoc_parameters 0.01 0.1667 10
# python3 -m ppa_settings.ppa_settings write_tdchbm_b_parameters 0.01 0.1667 10
# python3 -m ppa_settings.ppa_settings write_tdchbm_d_parameters 0.01 0.1667 10

# # THM Throttler
# python3 -m ppa_settings.ppa_settings write_xcdthm_limit 100
# python3 -m ppa_settings.ppa_settings write_aidthm_limit 100
# python3 -m ppa_settings.ppa_settings write_hbmthm_limit 110
# python3 -m ppa_settings.ppa_settings write_xcdthm_parameters 0.2 0.01 1
# python3 -m ppa_settings.ppa_settings write_aidthm_parameters 0.2 10 10
# python3 -m ppa_settings.ppa_settings write_hbmthm_parameters 0.2 1 10

# #Changing the gfx thersholds to get fclk to higher p states
# python3 -m ppa_settings.ppa_settings write_gfxclk_threshold_dn_3 1800
# python3 -m ppa_settings.ppa_settings write_gfxclk_threshold_up_2 1750