# import_outpatient_claims
# - Imports outpatient claims from CMS.
# - Saves them to disk.



# INIT =========================================================================
pacman::p_load(curl, janitor, lubridate, rio, tidyverse)

outpatient_claims_remote_file <- "https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/Downloads/DE1_0_2008_to_2010_Outpatient_Claims_Sample_2.zip"
outpatient_claims_local_file <- "data/DE1_0_2008_to_2010_Outpatient_Claims_Sample_2.zip"



# DOWNLOAD =====================================================================
if (!file.exists(outpatient_claims_local_file)) {
  curl_download(outpatient_claims_remote_file, outpatient_claims_local_file)
}


# IMPORT =======================================================================
outpatient_claims <-
  import(outpatient_claims_local_file) |>
  clean_names() |>
  mutate(
    clm_from_dt = ymd(clm_from_dt),
    clm_thru_dt = ymd(clm_thru_dt),
    clm_year = ymd(clm_thru_dt)
  )



# SAVE =========================================================================
write_rds(outpatient_claims, "data/outpatient_claims.rds")
