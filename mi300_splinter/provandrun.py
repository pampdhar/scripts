import os
import textwrap
import time
import subprocess
import sys
from orc_provisioning.apps.app_provisioning import *

def appendfile(filename, content):
    with open(filename, 'a') as file:
        file.write(content)
        time.sleep(3)

# create empty results file
file_name = "provandrunresults.txt"
with open(file_name, 'w') as file:
    pass

currdirectory = os.getcwd() + "/"
#provdirectory = "/home/netyakop/orc3/src/amdlibs/orc_provisioning/"
#os.chdir(provdirectory)
app_provisioner= ProvisionApp()

##### 1- BabelStream #####
def runBabelStream(app_provisioner, file_name, currdirectory):
    print("\n Provisioning BabelStream! \n")
    time.sleep(3)
    # If you want to force a rebuild use -> app_provisioner.main('babelstream_mi300', require_rebuild=True)
    app_provisioner.main('babelstream_mi300')
    babeldirectory = "/opt/amd-apps/BabelStream/"
    os.chdir(babeldirectory)
    print("\n Running BabelStream! \n")
    time.sleep(3)
    appendfile(currdirectory + file_name, "BabelStream: ")
    try:
        runresult = subprocess.run(["sudo", "./hip-stream", "-e", "-s", "268435456", "-n", "10"], check=True, stdout = subprocess.PIPE, universal_newlines=True)
        result = "PASS"
        print(runresult.stdout)
    except subprocess.CalledProcessError:
        result = "FAIL"
    appendfile(currdirectory + file_name, result + "\n")
    if result == "PASS":
        appendoutput = False
        appendfile(currdirectory + file_name, "Babelstream Output: " + "\n")
        for line in  runresult.stdout.splitlines():
            if line.startswith("Function"):
                appendoutput = True
            if appendoutput:
                appendfile(currdirectory + file_name, line + "\n")
    #appendfile(currdirectory + file_name, runresult.stdout + "\n")
    os.chdir(currdirectory)
    time.sleep(3)

# def runrocHPL(app_provisioner, file_name, currdirectory):
#     print("\n Provisioning rocHPL! \n")
#     time.sleep(3)
#     app_provisioner.main('rocHPL_mi300')
#     rochpldirectory = "/opt/amd-apps/rocHPL/"
#     os.chdir(rochpldirectory)
#     print("\n Running rocHPL! \n")
#     time.sleep(3)
#     appendfile(currdirectory + file_name, "rocHPL: ")
#     try:
#         subprocess.run("sudo chown amd:amd /opt/amd-apps/rocHPL/  ", shell=True)
#         subprocess.run(["sudo", "-u", "amd", "./build/mpirun_rochpl", "-P", "1", "-Q", "1", "-N", "64000", "--NB", "512"], check=True)
#         result = "PASS"
#     except subprocess.CalledProcessError:
#         result = "FAIL"
#     appendfile(currdirectory + file_name, result + "\n")
#     os.chdir(currdirectory)
#     time.sleep(3)
    
##### 3- Diamond #####
def runDiamond(file_name):
    # print("\n Installing firexs! \n")
    # time.sleep(3)
    # firexscommand = "echo 'deb [arch=amd64 trusted=yes] http://atlartifactory.amd.com/artifactory/HW-DCGPUExercisersDeb-REL-LOCAL  jammy main' > /etc/apt/sources.list.d/exerciser-apps.list"
    # subprocess.run(firexscommand, shell=True)
    # subprocess.run(["sudo", "apt", "update"])
    # subprocess.run(["sudo", "apt", "install", "firestorm"])
    # subprocess.run(["sudo", "apt", "install", "firexs"])
    print("\n Running Diamond! \n")
    time.sleep(3)
    appendfile(file_name, "Diamond: ")
    try:
        subprocess.run(["firexs", "diamond", "--num-loops=200"], check=True)
        result = "PASS"
    except subprocess.CalledProcessError:
        result = "FAIL"
    appendfile(file_name, result + "\n")
    time.sleep(3)
    
##### 4- Oblex #####
def runOblex(file_name):
    print("\n Installing firexs! \n")
    time.sleep(3)
    firexscommand = "echo 'deb [arch=amd64 trusted=yes] http://atlartifactory.amd.com/artifactory/HW-DCGPUExercisersDeb-REL-LOCAL  jammy main' > /etc/apt/sources.list.d/exerciser-apps.list"
    subprocess.run(firexscommand, shell=True)
    subprocess.run(["sudo", "apt", "update"])
    subprocess.run(["sudo", "apt", "install", "firestorm"])
    subprocess.run(["sudo", "apt", "install", "firexs"])
    print("\n Running Oblex! \n")
    time.sleep(3)
    appendfile(file_name, "Oblex: ")
    try:
        subprocess.run(["firexs", "oblex", "--iterations", "200", "--max-mem-percent=60", "all"], check=True)
        result = "PASS"
    except subprocess.CalledProcessError:
        result = "FAIL"
    appendfile(file_name, result + "\n")
    time.sleep(3)
    
##### 5- rocBLAS #####
def runrocBLAS(file_name, currdirectory):
    print("\n Installing rocBLAS! \n")
    time.sleep(3)
    os.chdir("/opt/amd-apps/")
    if os.path.exists("/opt/amd-apps/rocBLAS/build/"):
        print("rocBLAS is already installed!")
    else:
        # can alternatively make these user inputs
        gituser = "netyakop"
        # expires July 19th 2023
        gitpass = "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"
        rocblascommand1 = f"git clone https://{gituser}:{gitpass}@github.amd.com/ROCmSoftwarePlatform/rocBLAS.git -b gfx940"
        subprocess.run(rocblascommand1, shell=True)
        os.chdir("/opt/amd-apps/rocBLAS/")
        rocblascommand2 = "./install.sh -dc -a gfx940:xnack-"
        subprocess.run(rocblascommand2, shell=True)
    print("\n Running rocBLAS! \n")
    time.sleep(3)
    appendfile(currdirectory + file_name, "rocBLAS: ")
    try:
        rocblasdirectory = "/opt/amd-apps/rocBLAS/build/release/clients/staging/"
        os.chdir(rocblasdirectory)
        rocblasyaml = '- {rocblas_function: rocblas_dgemm, transA: N, transB: T, M: 4224, N: 3840, K: 4096, alpha: -1.0, lda: 4256, ldb: 3872, beta: 1.0, ldc: 4256, initialization: trig_float, iters: 1000, cold_iters: 10 }'
        subprocess.run(["./rocblas-bench", "--device", "0", "--yaml", "-"], input=rocblasyaml, text=True, check=True)
        result = "PASS"
    except (subprocess.CalledProcessError, FileNotFoundError):
        result = "FAIL"
    appendfile(currdirectory + file_name, result + "\n")
    os.chdir(currdirectory)
    time.sleep(3)

##### 6- CoralGEMM #####
def runCoralGEMM(file_name, currdirectory):
    print("\n Installing CoralGEMM! \n")
    time.sleep(3)
    os.chdir("/opt/amd-apps/")
    if os.path.exists("/opt/amd-apps/CoralGemm/"):
        print("CoralGEMM is already installed!")
    else:
        coralgemmcommand = "git clone https://github.com/AMD-HPC/CoralGemm"
        subprocess.run(coralgemmcommand, shell=True)
    print("\n Running CoralGEMM! \n")
    time.sleep(3)
    appendfile(currdirectory + file_name, "CoralGEMM: ")
    try:
        os.chdir("/opt/amd-apps/CoralGemm/src")
        subprocess.run(["make"])
        subprocess.run(["./gemm R_64F R_64F R_64F R_64F OP_N OP_T 8640 8640 8640 8640 8640 8640 36 100"], shell=True, check=True)
        result = "PASS"
    except subprocess.CalledProcessError:
        result = "FAIL"
    appendfile(currdirectory + file_name, result + "\n")
    os.chdir(currdirectory)
    time.sleep(3)

##### 7- PELE #####
def runPELE(file_name, currdirectory):
    print("\n Installing PELE! \n")   
    time.sleep(3)
    os.chdir("/opt/amd-apps/")
    if os.path.exists("/opt/amd-apps/PeleC/Exec/RegTests/PMF/"):
        print("PELE is already installed!")
    else:
        pelecommand = "git clone --recursive https://github.com/AMReX-Combustion/PeleC.git || true"
        subprocess.run(pelecommand, shell=True)
        replacementcode = '''
ifeq ($(USE_HIP),TRUE)
  AMD_ARCH=gfx940
endif

ifeq ($(USE_MPI),TRUE)

  INCLUDE_LOCATIONS += $(MPI_HOME)/include
  LIBRARY_LOCATIONS += $(MPI_HOME)/lib

  ifneq ($(findstring Open MPI, $(shell mpif90 -showme:version 2>&1)),)
    mpif90_link_flags := $(shell mpif90 -showme:link)
    LIBRARIES += $(mpif90_link_flags)
  else
    mpicxx_link_flags := $(shell mpicxx -link_info)
    LIBRARIES += $(filter -Wl%,$(mpicxx_link_flags))
    ifneq ($(BL_NO_FORT),TRUE)
      LIBRARIES += -lmpifort
    endif
    LIBRARIES += -lmpi
  endif

endif
         '''
        formattedcode = textwrap.dedent(replacementcode)
        with open("/opt/amd-apps/PeleC/Submodules/AMReX/Tools/GNUMake/sites/Make.unknown", 'w') as file:
            file.write(formattedcode)
    print("\n Running PELE! \n")
    time.sleep(3)
    appendfile(currdirectory + file_name, "PELE: ")
    try:
        os.chdir("/opt/amd-apps/PeleC/Exec/RegTests/PMF/")
        subprocess.run(["export AMD_ARCH=gfx940"], shell=True, check=True)
        subprocess.run(["export ROCM_PATH=/opt/rocm"], shell=True, check=True)
        subprocess.run(["export PATH=/opt/cmake-3.24.2/:/opt/ompi/bin/:$PATH"], shell=True, check=True)
        subprocess.run(["export MPI_HOME=/opt/ompi/"], shell=True, check=True)
        subprocess.run(["make -j 20 USE_HIP=TRUE USE_MPI=FALSE TINY_PROFILE=TRUE PELE_USE_MAGMA=FALSE USE_GPU_RDC=FALSE Chemistry_Model=drm19 TPLrealclean"], shell=True, check=True)
        subprocess.run(["make -j 20 USE_HIP=TRUE USE_MPI=FALSE TINY_PROFILE=TRUE PELE_USE_MAGMA=FALSE USE_GPU_RDC=FALSE Chemistry_Model=drm19 TPL"], shell=True, check=True)
        subprocess.run(["make -j 20 USE_HIP=TRUE USE_MPI=FALSE TINY_PROFILE=TRUE PELE_USE_MAGMA=FALSE USE_GPU_RDC=FALSE Chemistry_Model=drm19 realclean"], shell=True, check=True)
        subprocess.run(["make -j 20 USE_HIP=TRUE USE_MPI=FALSE TINY_PROFILE=TRUE PELE_USE_MAGMA=FALSE USE_GPU_RDC=FALSE Chemistry_Model=drm19"], shell=True, check=True)
        args = "example.inp geometry.prob_lo=0. 0. 0. geometry.prob_hi=.25 .25 .25 amr.n_cell=128 128 128 amr.max_level=2 prob.pamb=1013250.0 tagging.max_ftracerr_lev=4 tagging.ftracerr=1.e-4 prob.phi_in=-0.5 prob.pertmag=0.005 prob.pmf_datafile=PMF_CH4_1bar_300K_DRM_MixAvg.dat max_step=10 amr.plot_files_output=0 amr.plot_int=10 amr.checkpoint_files_output=0 amrex.abort_on_out_of_gpu_memory=1 pelec.cfl=0.1 pelec.init_shrink=1.0 pelec.change_max=1.0 amrex.the_arena_is_managed=0 pelec.chem_integrator=ReactorCvode cvode.solve_type=GMRES amr.blocking_factor=16 amr.max_grid_size=64 pelec.use_typ_vals_chem=1 ode.rtol=1e-4 ode.atol=1e-5 pelec.typical_rhoY_val_min=1e-6"
        subprocess.run(f"./PeleC3d.hip.TPROF.HIP.ex {args}", shell=True)
        result = "PASS"
    except subprocess.CalledProcessError:
        result = "FAIL"
    appendfile(currdirectory + file_name, result + "\n")
    os.chdir(currdirectory)
    time.sleep(3)  

##### 8- Oblex_SOC #####
def runOblex_SOC(file_name):
    print("\n Installing firexs! \n")
    time.sleep(3)
    firexscommand = "echo 'deb [arch=amd64 trusted=yes] http://atlartifactory.amd.com/artifactory/HW-DCGPUExercisersDeb-REL-LOCAL  jammy main' > /etc/apt/sources.list.d/exerciser-apps.list"
    subprocess.run(firexscommand, shell=True)
    subprocess.run(["sudo", "apt", "update"])
    subprocess.run(["sudo", "apt", "install", "firestorm"])
    subprocess.run(["sudo", "apt", "install", "firexs"])
    print("\n Running Oblex_SOC! \n")
    time.sleep(3)
    appendfile(file_name, "Oblex_SOC: ")
    try:
        subprocess.run(["firexs", "oblex", "--num-blocks", "10000000", "--read-loops", "10000", "--one-readback", "--nontemporal-disable", "--max-mem-percent=10", "--iterations", "1", "all"], check=True)
        result = "PASS"
    except subprocess.CalledProcessError:
        result = "FAIL"
    appendfile(file_name, result + "\n")
    time.sleep(3)
    
##### 9- gfx_players #####
def rungfx_players(file_name, currdirectory):
    print("\n Installing firexs! \n")
    time.sleep(3)
    firexscommand = "echo 'deb [arch=amd64 trusted=yes] http://atlartifactory.amd.com/artifactory/HW-DCGPUExercisersDeb-REL-LOCAL  jammy main' > /etc/apt/sources.list.d/exerciser-apps.list"
    subprocess.run(firexscommand, shell=True)
    subprocess.run(["sudo", "apt", "update"])
    subprocess.run(["sudo", "apt", "install", "firestorm"])
    subprocess.run(["sudo", "apt", "install", "firexs"])
    print("\n Installing rocm-edp-resumer! \n")
    time.sleep(3)
    os.chdir("/opt/amd-apps/")
    if os.path.exists("/opt/amd-apps/hbm_debug/"):
        print("rocm-edp-resumer is already installed!")
    else:
        gituser = "netyakop"
        gitpass = "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"
        rocmresumercommand = f"git clone https://{gituser}:{gitpass}@github.amd.com/dcgpu-validation/hbm_debug.git"
        subprocess.run(rocmresumercommand, shell=True)
    print("\n Running gfx_players! \n")
    time.sleep(3)
    appendfile(currdirectory + file_name, "gfx_players: ")
    try:
        os.chdir("/opt/amd-apps/hbm_debug/rocm_edp_helper_resumer/")
        resumerprocess = subprocess.Popen(["timeout", "3m", "./runit"])
        runprocess = subprocess.Popen(["timeout", "2.5m", "firexs", "gfx_players_mfma_8fmac64", "--num-loops", "1"])
        resumerprocess.wait()
        runprocess.wait()
        result = "PASS"
    except subprocess.CalledProcessError:
        result = "FAIL"
    appendfile(currdirectory + file_name, result + "\n")
    os.chdir(currdirectory)
    time.sleep(3)
    

#runBabelStream(app_provisioner, file_name, currdirectory)
#runrocHPL(app_provisioner, file_name, currdirectory)
#runDiamond(file_name)
runOblex(file_name)
# runrocBLAS(file_name, currdirectory)
#runCoralGEMM(file_name, currdirectory)
# runPELE(file_name, currdirectory)
# runOblex_SOC(file_name)
# rungfx_players(file_name, currdirectory)


print("\n The following is saved in a text file on your run directory: \n")
f = open(file_name, 'r')
content = f.read()
print(content)
f.close()

'''
##### HACC #####
print("\n Installing HACC! \n")
time.sleep(3)
app_provisioner.main('hacc_mi300')
haccdirectory = "/opt/amd-apps/HACC/"
os.chdir(haccdirectory)
'''