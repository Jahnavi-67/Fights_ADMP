flights=read.csv('C:/Users/student/Desktop/admp/cleaned_flights.csv')


View(flights)
dim_date=flights[c('YEAR','QUARTER','MONTH','DAY_OF_MONTH','FL_DATE')]

View(dim_date)
str(flights)

str(dim_date)

dim_date$FL_DATE=as.Date(dim_date$FL_DATE)

write.csv(dim_date,'C:/Users/student/Desktop/admp/dimDate.csv',row.names = FALSE)