# import_documentation
# - Downloads SynPUF documentation from CMS.



# INIT =========================================================================
pacman::p_load(curl, janitor, lubridate, rio, tidyverse)

user_manual_remote_file <- "https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/Downloads/SynPUF_DUG.pdf"
user_manual_local_file <- "data/user_manual.pdf"

codebook_remote_file <- "https://www.cms.gov/files/document/de-10-codebook.pdf-0"
codebook_local_file <- "data/codebook.pdf"

faq_remote_file <- "https://www.cms.gov/files/document/de-10-frequently-asked-questions.pdf"
faq_local_file <- "data/faq.pdf"



# DOWNLOAD =====================================================================
if (!file.exists(user_manual_local_file)) {
  curl_download(user_manual_remote_file, user_manual_local_file)
}

if (!file.exists(codebook_local_file)) {
  curl_download(codebook_remote_file, codebook_local_file)
}

if (!file.exists(faq_local_file)) {
  curl_download(faq_remote_file, faq_local_file)
}
