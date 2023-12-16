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
                print("String "+stacked_die.die_type.name)

                if stacked_die.die_type.name == "CCD":
                    # print(stacked_die)4
                    dev_ccds.append(stacked_die)

                elif stacked_die.die_type.name == "XCD":
                    # print(stacked_die)
                    dev_xcds.append(stacked_die)

    return dev_aids, dev_ccds, dev_xcds


from papi2.core import *
from time import sleep
from papi2.mp1fw.mp1fw import FW_STATE_ACCESS_MODE
import math
import time
papi = PAPI2.using_toollib()
dev_aids,dev_ccds,dev_xcds = get_dies(papi)

##################################################################################

# to manually enable gfx/soc PCC
def enable_pcc ():
    for aid_num in range (4):
        dev_aids[aid_num].mp1fw.write_fw_state("System_FeaturesEnabled", 0)
        dev_aids[aid_num].mp1fw.write_fw_state("PPTable_Features_17_value", 1) # gfx pcc
        dev_aids[aid_num].mp1fw.write_fw_state("PPTable_Features_26_value", 1) # soc pcc

    dev_aids[0].mp1fw.send_message("TEST2", "TESTSMC_MSG_EnableSmuFeatures")

# read the current PCC limits, as well as the enable bit and the warn_threshold
def read_pcc_limit (aid_num):
    print("**********\nreading PCC limit")
    dev_aids[aid_num].mp1fw.poll("PCC_Limit_") # PCC_Limit_0 = vdd, PCC_Limit_1 = soc
    dev_aids[aid_num].mp1fw.poll("PCC_Enabled_")
    dev_aids[aid_num].mp1fw.read_fw_state("PCC_OCP_WARN_THRESH_0")

# write the VDD PCC limit and read it back
def write_vdd_pcc_limit (aid_num, pcc_limit):
    print("**********\nwriting VDD PCC limit")
    dev_aids[aid_num].mp1fw.send_message("TEST2", "TESTSMC_MSG_SetVddPccLimit", pcc_limit)
    dev_aids[aid_num].mp1fw.read_fw_state("PCC_Limit_0")

# write the SOC PCC limit and read it back
def write_soc_pcc_limit (pcc_limit):
    print("**********\nwriting SoC PCC limit")
    dev_aids[1].mp1fw.send_message("TEST2", "TESTSMC_MSG_SetSocPccLimit", pcc_limit) # SOC is on AID1
    dev_aids[1].mp1fw.read_fw_state("PCC_Limit_1")

##################################################################################

# enable gfx/soc PCC
# only need to do this onces (after driver load)
#enable_pcc()

# Change VDD PCC Limit #
for aid_num in range(4):
  print(aid_num)
  vdd_pcc_limit = 372 # change the value to the desired limit
  write_vdd_pcc_limit(aid_num, vdd_pcc_limit)
  read_pcc_limit(aid_num)
  sleep(0.1)

# Change SOC PCC Limit #
soc_pcc_limit = 640 # change the value to the desired limit
write_soc_pcc_limit(soc_pcc_limit)
read_pcc_limit(1)
