##Chatroom Task Timing Errors 

install.packages("purrr")
library(purrr)
library(psych)
library(writexl)
library(readxl)
library(dplyr)

root_dir <- "/Users/ninakougan/Documents/acnl/rise_crest/chatroom"
csv_files <- list.files(path = root_dir, pattern = "\\.csv$", full.names = TRUE, recursive = TRUE)

modified_data_frames <- list()
runtime_summary <- data.frame(subjectID = character(), total_runtime = numeric(), stringsAsFactors = FALSE)
subjects_with_long_trials <- data.frame(subjectID = character(), stringsAsFactors = FALSE)

# Loop through each file, read the data, add the new column, and calculate total runtime
for (file in csv_files) {
  data <- read.csv(file)
  subjectID <- as.character(data[1, 1])
  
  if (nrow(data) > 1) {
    # Create the new column 'time_between_trials' by subtracting trialFeedbackOffset from the next row's trialOnset
    data$time_between_trials <- c(NA, data$trialOnset[-1] - data$trialFeedbackOffset[-nrow(data)])
    
    # Calculate total runtime
    total_runtime <- data$trialFeedbackOffset[nrow(data)] - data$trialOnset[1]
    
    # Append to the runtime_summary data frame
    runtime_summary <- rbind(runtime_summary, data.frame(subjectID = subjectID, total_runtime = total_runtime, stringsAsFactors = FALSE))
    
    # Check if any value in 'time_between_trials' is greater than 2.0
    if (any(data$time_between_trials > 2.0, na.rm = TRUE)) {
      # Append subjectID to subjects_with_long_trials data frame
      subjects_with_long_trials <- rbind(subjects_with_long_trials, data.frame(subjectID = subjectID, stringsAsFactors = FALSE))
    }
  } else {
    # If there is only one row, set the new column to NA
    data$time_between_trials <- NA
  }
  
  # Store the modified data frame in the list
  modified_data_frames[[file]] <- data
}

# View the runtime summary
print(runtime_summary)

# View the list of subjectIDs with time_between_trials > 2.0
print(subjects_with_long_trials)
