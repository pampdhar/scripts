from papi2.core import *
# For importing features.py from other directory
import sys
import time

#papi = PAPI2.using_toollib(log_level=logging.DEBUG)
papi = PAPI2.using_toollib()

# Follow Yuri's recommendation for identifying dies.
def get_dies(papi):
    dev_aids = []      
    dev_ccds = [] 
    dev_xcds = []
    for d in papi.all_devices:
        if d.die_type.name == "AID":
            # Append to AID list, then iterate thru stacked dies (children)
            dev_aids.append(d)
            # print(f"name = {d.asic_name}, socket = {d.socket_id}, die = {d.die_id}")
            for stacked_die in d.children:
                # print("String "+stacked_die.die_type.name)
                if stacked_die.die_type.name == "CCD":
                    # print(stacked_die)
                    dev_ccds.append(stacked_die)
                elif stacked_die.die_type.name == "XCD":  
                    # print(stacked_die)
                    dev_xcds.append(stacked_die)
    return dev_aids, dev_ccds, dev_xcds
dev_aids, dev_ccds, dev_xcds = get_dies(papi)
print("DRAMLOG ADDRESSES: ")

for d in dev_aids:
    d.mp1fw.dramlog.add_fw_var("Data_Telemetry_Board_Voltage")
    d.mp1fw.dramlog.add_fw_var("Data_Telemetry_Board_Current")
    d.mp1fw.dramlog.add_fw_var("Data_Telemetry_Board_Power")
    d.mp1fw.dramlog.add_fw_var("Data_Socket_Socket_Power")
    d.mp1fw.dramlog.add_fw_var("Data_Socket_Telemetry_0_Voltage")
    d.mp1fw.dramlog.add_fw_var("Data_Socket_Telemetry_0_Current")
    d.mp1fw.dramlog.add_fw_var("Data_Socket_Telemetry_0_Power")
    d.mp1fw.dramlog.add_fw_var("Data_Socket_XcdPower")
    d.mp1fw.dramlog.add_fw_var("Data_Socket_AidPower")
    d.mp1fw.dramlog.add_fw_var("Data_Socket_HbmPower")
    d.mp1fw.dramlog.add_fw_var("PPT_Throttler_0_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("PPT_Throttler_0_Controller_value")
    d.mp1fw.dramlog.add_fw_var("PPT_Throttler_1_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("PPT_Throttler_1_Controller_value")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_0_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_0_Controller_value")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_1_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_1_Controller_value")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_2_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_3_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_3_Controller_value")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_4_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_4_Controller_value")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_5_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("TDC_Throttler_5_Controller_value")
    d.mp1fw.dramlog.add_fw_var("THM_Throttler_0_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("THM_Throttler_0_Controller_value")
    d.mp1fw.dramlog.add_fw_var("THM_Throttler_1_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("THM_Throttler_1_Controller_value")
    d.mp1fw.dramlog.add_fw_var("THM_Throttler_2_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("THM_Throttler_2_Controller_value")
    d.mp1fw.dramlog.add_fw_var("THM_Throttler_3_Controller_limit")
    d.mp1fw.dramlog.add_fw_var("THM_Throttler_3_Controller_value")

for d in dev_xcds:
    d.mp5fw.dramlog.add_fw_var("Data_XCD_Gfxclk_TargFreq")
    d.mp5fw.dramlog.add_fw_var("Data_XCD_Gfxclk_PreDsFreq")
    d.mp5fw.dramlog.add_fw_var("Data_XCD_Gfxclk_PostDsFreq")
    
print("\n: Start logging...")
dev_aids[0].mp1fw.dramlog.start_logging()

# input()

# print("\n: Stop logging...")
# dev_aids[0].mp1fw.dramlog.stop_logging()
