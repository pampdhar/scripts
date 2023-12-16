from sre_constants import CATEGORY_WORD
import sys 
import os
import shutil
import zipfile
import logging
import time
import importlib

from papi2.core import *
from papi2.mp1fw.mp1fw import FW_STATE_ACCESS_MODE

papi = PAPI2.using_toollib()

socket0_aids = [x for x in papi.all_devices if x.socket_id == 0 and x.die_type == x.DieType.AID]
socket1_aids = [x for x in papi.all_devices if x.socket_id == 1 and x.die_type == x.DieType.AID]
socket2_aids = [x for x in papi.all_devices if x.socket_id == 2 and x.die_type == x.DieType.AID]
socket3_aids = [x for x in papi.all_devices if x.socket_id == 3 and x.die_type == x.DieType.AID]
socket4_aids = [x for x in papi.all_devices if x.socket_id == 4 and x.die_type == x.DieType.AID]
socket5_aids = [x for x in papi.all_devices if x.socket_id == 5 and x.die_type == x.DieType.AID]
socket6_aids = [x for x in papi.all_devices if x.socket_id == 6 and x.die_type == x.DieType.AID]
socket7_aids = [x for x in papi.all_devices if x.socket_id == 7 and x.die_type == x.DieType.AID]

#print pmfw version
version = socket0_aids[0].reg.read('mp1_pub_scratch0')
print(f'PMFW version = {((version>>16) & 0xFF)}.{((version>>8) & 0xFF)}.{((version>>0) & 0xFF)}')

def check_dpm_counter():
    for i in range(3):
        socket0_aids[0].mp1fw.poll('DpmManager_ExecutionCount_Low')
        time.sleep(0.01)

def enable_pcc():
    for aid in range(4):
        socket0_aids[aid].reg.write('MP1_PUB_SCRATCH1', 1800)
        socket0_aids[aid].mp1fw.write_fw_state('PPTable_Features_17_value', 1) #apcc dfll
        socket0_aids[aid].mp1fw.write_fw_state('PPTable_Features_26_value', 1) #soc pcc

def get_board_type():
    socket0_aids[0].mp1fw.poll('System_MI300XBoardType')
    socket0_aids[1].mp1fw.poll('System_MI300XBoardType')

def get_gfx_fmax():
    for aid in range(4):
        print(f'\n aid={aid}')
        socket0_aids[aid].mp1fw.poll('GfxDpm_MaxFreq')
        socket0_aids[aid].mp1fw.poll('GfxDpm_MaxAllowFreq')


enable_pcc()
#check_dpm_counter()
#socket0_aids[0].mp1fw.send_message('DRIVER', 'PPSMC_MSG_SetSoftMaxGfxClk', 1000)
#get_gfx_fmax()

