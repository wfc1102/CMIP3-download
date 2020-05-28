#!/bin/bash
#----------------------------------------------------------------------------------------------------
#   WCRP CMIP3 multi-model dataset: https://esgf-node.llnl.gov/projects/cmip3/
#----------------------------------------------------------------------------------------------------
#   The ESGF Search RESTful API:    https://earthsystemcog.org/projects/cog/esgf_search_restful_api
#   USEAGE:     http://<base_search_URL>/wget?[keyword parameters as (name, value) pairs][facet parameters as (name,value) pairs]
#   Example:    Download all obs4MIPs files from the JPL node with variable "hus" : 
#               http://esgf-node.jpl.nasa.gov/esg-search/wget?variable=hus&project=obs4MIPs&distrib=false
#----------------------------------------------------------------------------------------------------
#   View page source of https://esgf-node.llnl.gov/search/cmip6/ to find the keywords 
#   <!-- create hidden facet fields, set value to search constraint if available -->
#           <input type="hidden" name="variable" value=""/>         thetao so tos ...
#           <input type="hidden" name="model" value=""/>            ncar ccsm3 0 ...
#           <input type="hidden" name="experiment" value=""/>       piControl amip historical sresa1b sresa2 sresb1 ...
#           <input type="hidden" name="realm" value=""/>            ocean atmos ice land 
#           <input type="hidden" name="institute" value=""/>        
#           <input type="hidden" name="time_frequency" value=""/>   yr mon day 3hr fx
#           <input type="hidden" name="ensemble" value=""/>         run1 ... run10
#----------------------------------------------------------------------------------------------------
#   After setting those 6 variables above
#----------------------------------------------------------------------------------------------------
#experiment=(historical piControl ssp126 ssp245 ssp370 ssp585)
experiments=(historical)
variables=(tos psl)

models=(bccr_bcm2_0 cccma_cgcm3_1 cccma_cgcm3_1_t63 cnrm_cm3 csiro_mk3_0 csiro_mk3_5 gfdl_cm2_0 giss_aom giss_model_e_h giss_model_e_r iap_fgoals1_0_g ingv_echam4 inmcm3_0 ipsl_cm4 miroc3_2_hires miroc3_2_medres miub_echo_g mpi_echam5 mri_cgcm2_3_2a ncar_ccsm3_0 ncar_pcm1 ukmo_hadcm3 ukmo_hadgem1)
insts=(BCCR         CCCMA         CCCMA             CRNM     CSIRO-QCCCE CSIRO-QCCCE NOAA-GFDL  NASA-GISS NASA-GISS     NASA-GISS      LASG-IAP        INGV        INM      IPSL     MIROC          MIRO            MIUB        MPI-M      MRI            NCAR         NCAR      MOHC         MOHC)

time_frequencys=(mon)
ensembles=(run1)
realms=(atmos ocean)
realms=(ocean atmos)

#   https://esgf-node.llnl.gov/esg-search/wget/?distrib=false&dataset_id=cmip3.INM.inmcm3_0.historical.mon.ocean.run1.vo.v1|aims3.llnl.gov
base="https://esgf-node.llnl.gov/esg-search/wget?distrib=false"

for     experiment in     ${experiments[*]};do
for       variable in       ${variables[*]};do
for          realm in          ${realms[*]};do
for time_frequency in ${time_frequencys[*]};do
for       ensemble in       ${ensembles[*]};do
mm=0
for          model in          ${models[*]};do
    inst=${insts[${mm}]}
    ((mm++))
    url="${base}&dataset_id=cmip3.${inst}.${model}.${experiment}.${time_frequency}.${realm}.${ensemble}.${variable}.v1|aims3.llnl.gov"
    echo $url
    tim=`date "+%Y%m%d%H%M%S"`
    file="wgets/wget-${variable}-${model}-${experiment}-${ensemble}-${tim}.sh"
    echo "processing ... ${file}"
    wget -O - "$url" | grep -P "^(?!'(?!${variable}_)|'.*\.nc4)" 1>$file
    nwords=$(cat "$file" | wc -l)
    [ $nwords -le 1 ] && echo "No files found." && rm "$file"
    exit
    sleep 1
done
done
done
done
done
done
