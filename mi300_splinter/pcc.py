from papi2.core import *
import time
def get_dies(papi):
    dev_aids = []      
    dev_ccds = [] 
    dev_xcds = []
    for d in papi.all_devices:
        if d.die_type.name == "AID":
            # Append to AID list, then iterate thru stacked dies (children)
            dev_aids.append(d)
            # print(f"name = {d.;asic_name}, socket = {d.socket_id}, die = {d.die_id}")
            for stacked_die in d.children:
                # print("String "+stacked_die.die_type.name)
                if stacked_die.die_type.name == "CCD":
                    # print(stacked_die)
                    dev_ccds.append(stacked_die)
                elif stacked_die.die_type.name == "XCD":  
                    # print(stacked_die)
                    dev_xcds.append(stacked_die)
    return dev_aids, dev_ccds, dev_xcds

papi = PAPI2.using_toollib()

dev_aids,dev_ccds,dev_xcds = get_dies(papi)

print("INITIAL LIMIT SAVING...")
initial_limit_vdd = dev_aids[0].mp1fw.read_fw_state("PCC_Limit_0")
initial_limit_soc = dev_aids[0].mp1fw.read_fw_state("PCC_Limit_1")
breakpoint()
# Setting PCC limits

for d in dev_aids:
    print("New PCC limit setting: ")
    d.mp1fw.send_message("TEST2","TESTSMC_MSG_SetVddPccLimit", 600) # Change limit here
    d.mp1fw.send_message("TEST2","TESTSMC_MSG_SetSocPccLimit", 600)
    
print("Restoring initial limit! ")
for d in dev_aids:
    d.mp1fw.send_message("TEST2","TESTSMC_MSG_SetVddPccLimit",int(initial_limit_vdd))
    d.mp1fw.send_message("TEST2","TESTSMC_MSG_SetSocPccLimit",int(initial_limit_soc))
    