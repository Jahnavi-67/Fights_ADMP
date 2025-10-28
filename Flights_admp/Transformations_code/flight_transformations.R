
# Install necessary packages 

# Load libraries
library(tidyverse)
library(data.table)
library(lubridate)
library(janitor)
library(stringr)
library(ggplot2)
library(dplyr)
library(tidyr)



# Path to  CSV files
data_path <- "C:/Users/student/Desktop/admp"

# Reading all CSV files and merge
all_files <- list.files(path = data_path, pattern = "*.csv", full.names = TRUE)

# Load and combine data
flights_raw <- all_files %>%
  lapply(fread) %>%
  bind_rows()

# Initial check
glimpse(flights_raw)

# Removing Unnecessary Columns 
cols_to_remove <- c(
  "ORIGIN_AIRPORT_ID","ORIGIN_AIRPORT_SEQ_ID",
  "ORIGIN_CITY_MARKET_ID","DEST_AIRPORT_ID",
  "OP_CARRIER_AIRLINE_ID", "OP_CARRIER_FL_NUM",
  "DEST_AIRPORT_SEQ_ID","DEST_CITY_MARKET_ID",
  "CANCELLED", "CANCELLATION_CODE",
  "CRS_ELAPSED_TIME", "ACTUAL_ELAPSED_TIME",
  "AIR_TIME", "FLIGHTS", "WEATHER_DELAY","CARRIER_DELAY",
  "NAS_DELAY","SECURITY_DELAY","LATE_AIRCRAFT_DELAY"
)


flights <- flights_raw %>%
  select(-any_of(cols_to_remove))

# Convert 'flight_date' with time to Date type
flights <- flights %>%
  mutate(
    # Parsing the date with time, but keep only date
    FL_DATE = dmy_hm(FL_DATE),
    FL_DATE = as.Date(FL_DATE))


# Checking missing values
missing_summary <- flights %>%
  summarise_all(~ sum(is.na(.))) %>%
  pivot_longer(everything(), names_to = "column", values_to = "missing_count") %>%
  arrange(desc(missing_count))

print(n=25,missing_summary)

# handling missing FL_DATE column

flights <- flights %>%
  mutate(
    
    FL_DATE = if_else(
      is.na(FL_DATE) & !is.na(YEAR) & !is.na(MONTH) & !is.na(DAY_OF_MONTH),
      make_date(YEAR, MONTH, DAY_OF_MONTH),
      FL_DATE
    )
  )

# Check for duplicates
duplicate_count <- flights %>%
  duplicated() %>%
  sum()


# Remove exact duplicate rows
flights <- flights %>%
  distinct()


# Checking after dropping duplicates
duplicate_count <- flights %>%
  duplicated() %>%
  sum()

cat("Number of duplicate rows:", duplicate_count, "\n")



# Check date ranges

date_range <- range(flights$FL_DATE, na.rm = TRUE)
cat("Date range in data:", format(date_range[1]), "to", format(date_range[2]), "\n")


# Check numeric columns for negative or impossible values
numeric_check <- flights %>%
  summarise(across(where(is.numeric), ~ sum(. < 0, na.rm = TRUE)))

print(numeric_check)


# another checking
glimpse(flights)


# plots

# plot for missing values by column
missing_data <- flights %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "Column", values_to = "Missing_Count") %>%
  arrange(desc(Missing_Count))

ggplot(missing_data, aes(x = reorder(Column, Missing_Count), y = Missing_Count)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Missing Values by Column",
       x = "Column", y = "Missing Count")


# Duplicate records check
duplicate_count <- flights %>%
  duplicated() %>%
  sum()

ggplot(data.frame(Duplicates = c("Duplicates", "Unique"),
                  Count = c(duplicate_count, nrow(flights) - duplicate_count)),
       aes(x = "", y = Count, fill = Duplicates)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Duplicate vs Unique Records") +
  theme_void()

# Flight date range coverage
ggplot(flights, aes(x = FL_DATE)) +
  geom_histogram(binwidth = 30, fill = "skyblue", color = "black") +
  labs(title = "Flight Data Coverage (2015–2024)",
       x = "Date", y = "Number of Flights")

# Flights by year
flights %>%
  mutate(Year = format(FL_DATE, "%Y")) %>%
  group_by(Year) %>%
  summarise(Flights = n()) %>%
  ggplot(aes(x = Year, y = Flights, fill = Year)) +
  geom_col() +
  labs(title = "Flights per Year", x = "Year", y = "Number of Flights") +
  theme_minimal()


# Outlier detection for Distance
ggplot(flights, aes(y = DISTANCE)) +
  geom_boxplot(fill = "tomato", alpha = 0.7) +
  labs(title = "Outlier Detection for Flight Distance",
       y = "Distance (Miles)")




# Check valid ranges

range_checks <- list(
  arr_delay = range(flights$ARR_DELAY, na.rm = TRUE),
  dep_delay = range(flights$DEP_DELAY, na.rm = TRUE),
  distance = range(flights$DISTANCE, na.rm = TRUE)
)


print(range_checks)

#  Validation Checks
# Ensure year range is 2015–2024
valid_years <- all(flights$YEAR %in% 2015:2024)

# Ensure month values are valid
valid_months <- all(flights$MONTH >= 1 & flights$MONTH <= 12)

# Ensure distances are positive

valid_distance <- all(flights$DISTANCE > 0)

# Print validation results
cat("Valid Years:", valid_years, "\n")
cat("Valid Months:", valid_months, "\n")
cat("Valid Distance:", valid_distance, "\n")
cat(" Missing Values:\n")
print(missing_summary)
cat(" Duplicate Rows:", duplicate_count, "\n")



flights <- flights %>%
  mutate(
    FL_DATE = as.Date(FL_DATE),
    FLIGHT_ID = paste(FL_DATE, ORIGIN, sep = "_")
  )

#  Save Cleaned Dataset

write_csv(flights, "C:/Users/student/Desktop/admp/nyc_flights_clean_2015_2024.csv")