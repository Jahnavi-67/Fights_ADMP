# Create dim_airport table manually
airport_data <- data.frame(
  AIRPORT_ID = c("JFK", "LGA"),
  AIRPORT_NAME = c("John F. Kennedy International Airport", "LaGuardia Airport"),
  CITY = c("New York", "New York"),
  STATE = c("NY", "NY"),
  COUNTRY = c("USA", "USA")
)
View(airport_data)
# Save as CSV
write.csv(dim_airport, "C:/Users/student/Desktop/admp/Airport_data.csv", row.names = FALSE)
