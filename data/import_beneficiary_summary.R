# import_beneficiary_summary
# - Imports beneficiary summaries from CMS.
#   - These come in yearly files.
#   - This script combines them into a single beneficiary_summary table.
#   - Adds column "year" to differentiate.
# - Saves them to disk.



# INIT =========================================================================
pacman::p_load(curl, janitor, lubridate, rio, tidyverse)

beneficiary_summary_2008_remote_file <- "https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/Downloads/DE1_0_2008_Beneficiary_Summary_File_Sample_2.zip"
beneficiary_summary_2008_local_file <- "data/DE1_0_2008_Beneficiary_Summary_File_Sample_2.zip"

beneficiary_summary_2009_remote_file <- "https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/Downloads/DE1_0_2009_Beneficiary_Summary_File_Sample_2.zip"
beneficiary_summary_2009_local_file <- "data/DE1_0_2009_Beneficiary_Summary_File_Sample_2.zip"

beneficiary_summary_2010_remote_file <- "https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/Downloads/DE1_0_2010_Beneficiary_Summary_File_Sample_2.zip"
beneficiary_summary_2010_local_file <- "data/DE1_0_2010_Beneficiary_Summary_File_Sample_2.zip"


# DOWNLOAD =====================================================================
if (!file.exists(beneficiary_summary_2008_local_file)) {
  curl_download(beneficiary_summary_2008_remote_file, beneficiary_summary_2008_local_file)
}

if (!file.exists(beneficiary_summary_2009_local_file)) {
  curl_download(beneficiary_summary_2009_remote_file, beneficiary_summary_2009_local_file)
}

if (!file.exists(beneficiary_summary_2010_local_file)) {
  curl_download(beneficiary_summary_2010_remote_file, beneficiary_summary_2010_local_file)
}



# IMPORT =======================================================================
beneficiary_summary_2008 <-
  import(beneficiary_summary_2008_local_file) |>
  clean_names()

beneficiary_summary_2009 <-
  import(beneficiary_summary_2009_local_file) |>
  clean_names()

beneficiary_summary_2010 <-
  import(beneficiary_summary_2010_local_file) |>
  clean_names()

# Check to see that the number of rows don't match.
stopifnot(
  nrow(beneficiary_summary_2008) != nrow(beneficiary_summary_2009),
  nrow(beneficiary_summary_2008) != nrow(beneficiary_summary_2010)
)

# But we should have consistent column names.
stopifnot(
  min(names(beneficiary_summary_2008) == names(beneficiary_summary_2009)) == 1,
  min(names(beneficiary_summary_2008) == names(beneficiary_summary_2010)) == 1
)

# Add a column for year.
beneficiary_summary_2008 <- beneficiary_summary_2008 |> mutate(year = 2008)
beneficiary_summary_2009 <- beneficiary_summary_2009 |> mutate(year = 2009)
beneficiary_summary_2010 <- beneficiary_summary_2010 |> mutate(year = 2010)

# Combine all three together into a single table.
# Turn the birt_dt and death_dt columns into actual dates.
# They come in as straight numbers.
beneficiary_summary <-
  bind_rows(
    beneficiary_summary_2008 |> select(year, desynpuf_id:pppymt_car),
    beneficiary_summary_2009 |> select(year, desynpuf_id:pppymt_car),
    beneficiary_summary_2010 |> select(year, desynpuf_id:pppymt_car)
  ) |>
  mutate(
    bene_birth_dt = ymd(bene_birth_dt),
    bene_death_dt = ymd(bene_death_dt)
  )



# SAVE =========================================================================
write_rds(beneficiary_summary, "data/beneficiary_summary.rds")
