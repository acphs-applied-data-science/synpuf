# import_prescription_drug_events
# - Imports Rx events from CMS.
# - Saves them to disk.



# INIT =========================================================================
pacman::p_load(curl, janitor, lubridate, rio, tidyverse)

prescription_drug_events_remote_file <- "http://downloads.cms.gov/files/DE1_0_2008_to_2010_Prescription_Drug_Events_Sample_2.zip"
prescription_drug_events_local_file <- "data/DE1_0_2008_to_2010_Prescription_Drug_Events_Sample_2.zip"




# DOWNLOAD =====================================================================
if (!file.exists(prescription_drug_events_local_file)) {
  curl_download(prescription_drug_events_remote_file, prescription_drug_events_local_file)
}

# IMPORT =======================================================================
prescription_drug_events <-
  import(prescription_drug_events_local_file) |>
  clean_names() |>
  mutate(
    srvc_dt = ymd(srvc_dt),
    clm_year = year(srvc_dt)
  )



# SAVE =========================================================================
write_rds(prescription_drug_events, "data/prescription_drug_events.rds")
