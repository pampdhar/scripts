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


file_path = sys.argv[1]

print("\n: Stop logging...")
dev_aids[0].mp1fw.dramlog.stop()
dev_aids[0].mp1fw.dramlog.stop_logging(file_path)
