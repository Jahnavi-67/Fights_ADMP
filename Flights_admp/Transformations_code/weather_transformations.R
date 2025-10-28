# Load necessary libraries
library(dplyr)
library(lubridate)
library(ggplot2)


#  Load Data
weather <- read.csv("C:/Users/student/Desktop/admp/weather_data.csv", stringsAsFactors = FALSE)

#  View structure and summary
str(weather)
summary(weather)

# Replacing null with NA and chaining the data types
weather <- weather %>%
  mutate(across(where(is.character), ~na_if(., "null"))) %>%
  mutate(valid = ymd_hm(valid),
         date = as.Date(valid),
         time = format(valid, "%H:%M")) %>%
  mutate(across(c(tmpc, dwpc, relh, feel, drct, sped, mslp, p01i, vsby, gust_mph),
                as.numeric))

# viewing the structure of the data again
str(weather)

# Check for duplicates
duplicate_count <- sum(duplicated(weather))
cat("Number of duplicate rows:", duplicate_count, "\n")

weather <- weather %>% distinct()

# Handle missing values
colSums(is.na(weather))


# Drop original 'valid' column
weather <- subset(weather, select = -valid)

# Fill missing temperature with mean
weather$tmpc[is.na(weather$tmpc)] <- mean(weather$tmpc, na.rm = TRUE)

# Fill gust_mph NA values with sped
weather$gust_mph[is.na(weather$gust_mph)] <- weather$sped[is.na(weather$gust_mph)]

# Fill wxcodes NA values with "No Weather Event"
weather$wxcodes[is.na(weather$wxcodes)] <- "No Weather Event"

# Convert categorical columns
weather$station <- as.factor(weather$station)
weather$wxcodes <- as.factor(weather$wxcodes)

# Date range check
range(weather$date, na.rm = TRUE)

# Check unique station count
length(unique(weather$station))

# Summary statistics
summary(weather)


# Visualize temperature distribution
ggplot(weather, aes(x = tmpc)) +
  geom_histogram(bins = 50, fill = "skyblue", color = "black") +
  theme_minimal() +
  ggtitle("Temperature Distribution")

# Visualize wind speed outliers
ggplot(weather, aes(x = sped)) +
  geom_boxplot(fill = "orange") +
  theme_minimal() +
  ggtitle("Wind Speed Outliers")

# Missing values per column

missing_counts <- colSums(is.na(weather))

weather_melt <- tibble(
  Column = names(missing_counts),
  MissingValues = as.integer(missing_counts)
)

# Plot
weather_melt %>%
  arrange(desc(MissingValues)) %>%
  ggplot(aes(x = reorder(Column, MissingValues), y = MissingValues)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Weather: Missing Values by Column",
       x = "Column", y = "Missing Count")


# Relative humidity distribution
ggplot(weather, aes(x = relh)) +
  geom_histogram(bins = 50, fill = "skyblue", color = "black") +
  labs(title = "Relative Humidity Distribution", x = "Humidity (%)", y = "Frequency")


weather <- weather %>%
  mutate(
    date = as.Date(date),
    WEATHER_ID = paste(date, station, sep = "_")
  )


#  Save cleaned data
write.csv(weather, "C:/Users/student/Desktop/admp/cleaned_weather_data.csv", row.names = FALSE)
