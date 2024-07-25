##Chatroom Task Timing Errors 
##Author: Nina Kougan (ninakougan@northwestern.edu)
##Last Updated: 07/24/24

library(purrr)
library(psych)
library(writexl)
library(readxl)
library(dplyr)

# Set root for where you have the behavioral csvs
root_dir <- "/Users/ninakougan/Documents/acnl/rise_crest/chatroom"

# Will delete and overwrite previously generated output
overwrite <- 1
modified_data_frames <- list()

output_folder <- file.path(root_dir, "timing_errors")
if (overwrite == 1) {
  if (dir.exists(output_folder)) {
    file.remove(list.files(output_folder, full.names = TRUE))
  } else {
    dir.create(output_folder)
  }
} else if (!dir.exists(output_folder)) {
  dir.create(output_folder)
}

csv_files <- list.files(path = root_dir, pattern = "\\.csv$", full.names = TRUE, recursive = TRUE)
runtime_summary <- data.frame(subjectID = character(), session = numeric(), scan_date = character(), total_runtime = numeric(),
                              Dly1 = numeric(), ITIj1 = numeric(),
                              Dly2 = numeric(), ITIj2 = numeric(),
                              Dly3 = numeric(), ITIj3 = numeric(), 
                              stringsAsFactors = FALSE)

extract_session <- function(file_path) {
  # Use regular expressions to extract session number
  session <- as.numeric(sub(".*ses-([0-9]+).*", "\\1", file_path))
  return(session)
}

extract_scan_date <- function(file_name) {
  # Use regular expressions to extract the date in the format MM.DD.YY from the file name
  date_str <- sub(".*_(\\d{2})\\.(\\d{2})\\.(\\d{2})-.*", "\\1/\\2/\\3", file_name)
  return(date_str)
}

# Loop through each file, read the data, add the new column, and calculate total runtime
for (file in csv_files) {
  # Read the CSV file
  data <- read.csv(file)
  
  # Extract session number and scan date
  session <- extract_session(file)
  subjectID <- as.character(data[1, 1])
  file_name <- basename(file)
  scan_date <- extract_scan_date(file_name)
  
  if (nrow(data) > 1) {
    # Create the new column 'time_between_trials' by subtracting current row's trialFeedbackOffset from the next row's trialOnset
    data$time_between_trials <- c(
      data$trialOnset[-1] - data$trialFeedbackOffset[-nrow(data)],
      0  # Set the last row's value to 0 or another appropriate value
    )
    total_runtime <- data$trialFeedbackOffset[nrow(data)] - data$trialOnset[1]
    
    # Find instances where time_between_trials > 1.6
    delays <- data$time_between_trials[data$time_between_trials > 1.6]
    ITIj_values <- data$trialITIj[data$time_between_trials > 1.6]
    
    # Ensure the length of delays and ITIj_values are no more than 3
    delays <- delays[1:3]
    ITIj_values <- ITIj_values[1:3]
    
    # Prepare columns
    Dly_columns <- rep(NA, 3)
    ITIj_columns <- rep(NA, 3)
    Dly_columns[1:length(delays)] <- delays
    ITIj_columns[1:length(ITIj_values)] <- ITIj_values
    
    # Add or update the row in runtime_summary
    runtime_summary <- rbind(runtime_summary, data.frame(
      subjectID = subjectID,
      session = session,
      scan_date = scan_date,
      total_runtime = total_runtime,
      Dly1 = Dly_columns[1],
      ITIj1 = ITIj_columns[1],
      Dly2 = Dly_columns[2],
      ITIj2 = ITIj_columns[2],
      Dly3 = Dly_columns[3],
      ITIj3 = ITIj_columns[3],
      stringsAsFactors = FALSE
    ))
  } else {
    # If there is only one row, set the new column to 0
    data$time_between_trials <- 0
    total_runtime <- NA  # or another appropriate value for total_runtime if only one row
  }
  
  # Store the modified data frame in the list if total_runtime is greater than 802
  if (!is.na(total_runtime) && total_runtime > 802) {
    modified_data_frames[[file]] <- data
  }
}

# Filter runtime_summary for total_runtime > 802
runtime_summary_filtered <- runtime_summary %>%
  filter(total_runtime > 802)

# Write out only those modified data frames where total_runtime is greater than 802
for (file in names(modified_data_frames)) {
  # Extract base name of the file (e.g., 'file.csv')
  base_name <- basename(file)
  
  # Create the output path for each CSV
  output_path <- file.path(output_folder, paste0("modified_", base_name))
  
  # Check if file exists and handle overwriting based on the 'overwrite' parameter
  if (file.exists(output_path) && overwrite == 1) {
    # Overwrite the existing file
    write.csv(modified_data_frames[[file]], output_path, row.names = FALSE)
  } else if (!file.exists(output_path)) {
    # If file does not exist, write the new file
    write.csv(modified_data_frames[[file]], output_path, row.names = FALSE)
  }
}

runtime_summary_path <- file.path(output_folder, "runtime_summary.csv")
filtered_runtime_summary_path <- file.path(output_folder, "filtered_runtime_summary.csv")

# Export runtime_summary as CSV
write.csv(runtime_summary, runtime_summary_path, row.names = FALSE)

# Export filtered runtime_summary as CSV
write.csv(runtime_summary_filtered, filtered_runtime_summary_path, row.names = FALSE)
