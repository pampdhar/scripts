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
# all_sockets = [socket0_aids, socket1_aids, socket2_aids, socket3_aids, socket4_aids, socket5_aids, socket6_aids, socket7_aids]
all_sockets = []
if len(socket0_aids): all_sockets.append(socket0_aids) 
if len(socket1_aids): all_sockets.append(socket1_aids)
if len(socket2_aids): all_sockets.append(socket2_aids)
if len(socket3_aids): all_sockets.append(socket3_aids)
if len(socket4_aids): all_sockets.append(socket4_aids)
if len(socket5_aids): all_sockets.append(socket5_aids)
if len(socket6_aids): all_sockets.append(socket6_aids)
if len(socket7_aids): all_sockets.append(socket7_aids)
print(all_sockets)

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
    for a_soc in all_sockets:
        for aid in range(4):
            print(f'\n aid={aid}')
            a_soc[aid].mp1fw.poll('GfxDpm_MaxFreq')
            a_soc[aid].mp1fw.poll('GfxDpm_MaxAllowFreq')


#enable_pcc()
#check_dpm_counter()
for a_soc in all_sockets:
    a_soc[0].mp1fw.send_message('DRIVER', 'PPSMC_MSG_SetSoftMaxGfxClk', 1800)
get_gfx_fmax()

