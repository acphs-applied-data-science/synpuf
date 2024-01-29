# import.R
# Downloads useful documentation from CMS if not already on disk.
# Imports data by sourcing data-specific scripts.
# Removes unneeded ZIP files when done.



# IMPORT =======================================================================

source("data/import_documentation.R")
rm(list = ls())

source("data/import_beneficiary_summary.R")
rm(list = ls())

## This one is by far the slowest.
## The code works, but if it gives you a hard time, skip it.
source("data/import_carrier_claims.R")
rm(list = ls())

source("data/import_inpatient_claims.R")
rm(list = ls())

source("data/import_outpatient_claims.R")
rm(list = ls())

source("data/import_prescription_drug_events.R")
rm(list = ls())



# CLEAN UP =====================================================================
# Set this to TRUE/FALSE in order to make it run/not run.
# I am setting to FALSE because if we need to change any of our import scripts,
# it is easier if we DON'T have to download the data again.
if (FALSE) {
  local_zip_files <-
    list.files(path = "data", pattern = "zip", full.names = TRUE)
  unlink(local_zip_files)
}