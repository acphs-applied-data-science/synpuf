# import_outpatient_claims
# - Imports outpatient claims from CMS.
# - Saves them to disk.



# INIT =========================================================================
pacman::p_load(curl, janitor, lubridate, rio, tidyverse)

inpatient_claims_remote_file <- "https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/Downloads/DE1_0_2008_to_2010_Inpatient_Claims_Sample_2.zip"
inpatient_claims_local_file <- "data/DE1_0_2008_to_2010_Inpatient_Claims_Sample_2.zip"



# DOWNLOAD =====================================================================
if (!file.exists(inpatient_claims_local_file)) {
  curl_download(inpatient_claims_remote_file, inpatient_claims_local_file)
}



# IMPORT =======================================================================
inpatient_claims <-
  import(inpatient_claims_local_file) |>
  clean_names() |>
  mutate(
    clm_from_dt = ymd(clm_from_dt),
    clm_thru_dt = ymd(clm_thru_dt),
    clm_admsn_dt = ymd(clm_admsn_dt),
    clm_year = year(clm_thru_dt)
  )



# SAVE =========================================================================
write_rds(inpatient_claims, "data/inpatient_claims.rds")
