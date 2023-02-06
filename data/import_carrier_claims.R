# import_carrier_claims
# - Import carrier claims from CMS.
#   - These claims come in two files which we combine.
#   - clm_from_dt and clm_thru_dt are converted to DATE
# - Saves them to disk.


# INIT =========================================================================
pacman::p_load(curl, janitor, lubridate, rio, tidyverse)

carrier_claims_1_remote_file <- "http://downloads.cms.gov/files/DE1_0_2008_to_2010_Carrier_Claims_Sample_2A.zip"
carrier_claims_1_local_file <- "data/DE1_0_2008_to_2010_Carrier_Claims_Sample_2A.zip"

carrier_claims_2_remote_file <- "http://downloads.cms.gov/files/DE1_0_2008_to_2010_Carrier_Claims_Sample_2B.zip"
carrier_claims_2_local_file <- "data/DE1_0_2008_to_2010_Carrier_Claims_Sample_2B.zip"


# DOWNLOAD =====================================================================
if (!file.exists(carrier_claims_1_local_file)) {
  curl_download(carrier_claims_1_remote_file, carrier_claims_1_local_file)
}

if (!file.exists(carrier_claims_2_local_file)) {
  curl_download(carrier_claims_2_remote_file, carrier_claims_2_local_file)
}



# IMPORT =======================================================================
carrier_claims_1 <-
  import(carrier_claims_1_local_file) |>
  clean_names()

carrier_claims_2 <-
  import(carrier_claims_2_local_file) |>
  clean_names()

# Explore
min(names(carrier_claims_1) == names(carrier_claims_2))
# And look at the column names.
# See the obvious date columns

carrier_claims <-
  bind_rows(
    carrier_claims_1,
    carrier_claims_2
  ) |>
  mutate(
    clm_from_dt = ymd(clm_from_dt),
    clm_thru_dt = ymd(clm_thru_dt),
    clm_year = year(clm_thru_dt)
  )



# SAVE ========================================================================
write_rds(carrier_claims, "data/carrier_claims.rds")
