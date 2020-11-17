#' Download the MTBLS242 dataset
#' 
#' The function downloads the NMR dataset from Gralka et al., 2015. 
#' DOI: 10.3945/ajcn.115.110536.
#'
#' MTBLS242: Metabolomic fingerprint of severe obesity is dynamically
#' affected by bariatric surgery in a procedure-dependent manner.
#' https://www.ebi.ac.uk/metabolights/MTBLS242/descriptors
#' 
#' The dataset is public available in metaoligth repository 
#' (EBI-supported repository ) at:
#' ftp://ftp.ebi.ac.uk/pub/databases/metabolights/studies/public/MTBLS242/
#'
#' @param to A directory
#' 
#' @return A folder with demo samples
#' @export
#' @references \url{https://doi.org/10.3945/ajcn.115.110536}
#' 
#' @examples 
#' \dontrun{
#' library(AlpsNMR)
#' download_demo(to = "C:/Users/")
#' }
#' 
download_demo <- function(to = "./MTBLS242/") {
  if (!dir.exists(to)) {
    dir.create(to, recursive = TRUE)
  }
  url = "ftp://ftp.ebi.ac.uk/pub/databases/metabolights/studies/public/MTBLS242/"

  #We get the names of the files in the folder
  filenames <- RCurl::getURL(url, dirlistonly = TRUE) #ftp.use.epsv = FALSE
  destnames <- strsplit(filenames, "\r*\n")[[1]]
  # We only use a portion of the files, the first two timepoints, obs0 and obs1
  destnames_sel <- destnames[1:394] #Obs0..3
  destnames_sel <- destnames_sel[-36] #Remove Obs0_0110s.zip, only have 1 timepoint
  destnames_sel <- destnames_sel[-165] #Remove Obs1_0256s.zip, only have 1 timepoint
  destnames_sel <- destnames_sel[-263] #Remove Obs2_0242s.zip, only have 1 timepoint
  
  urls <- paste0(url, destnames_sel)
  fls <- paste0(to, destnames_sel)
  # Download files
  message("Downloading files, it will take some time")
  purrr::map2(urls, fls, function(urls, fls) 
      utils::download.file(urls, destfile = fls, method = "auto", mode="wb"))

  # Download metadata file s_mtbls242.txt
  meta_file <- destnames[length(destnames)]
  meta_url <- paste0(url, meta_file)
  meta_dst <- paste0(to, meta_file)
  utils::download.file(meta_url, method = "auto", destfile = meta_dst, mode = "wb")
  
  # Unzip files
  # We use only the CPMG sequence, folder 3
  fnames <- tools::file_path_sans_ext(destnames_sel)
  fls_3 <- paste0(fnames, "/3/*")
  message("Uncompressing files, it will take some time")
  purrr::map2(fls, fls_3, function(fls, fls_3){
      zip_files <- utils::unzip(zipfile = fls, list=TRUE)
      folder_3 <- zip_files$Name[stringr::str_detect(zip_files$Name, fls_3)]
      zip::unzip(zipfile = fls, exdir = to, files = folder_3)
      
      # We move files out of folder 3
      fname <- tools::file_path_sans_ext(basename(fls))
      old_folder <- paste0(to, fname, "/3")
      new_folder <- paste0(to, fname)
      R.utils::copyDirectory(old_folder, new_folder, recursive=TRUE)
      unlink(old_folder, recursive = TRUE)
  })
}