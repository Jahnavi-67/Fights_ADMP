
# Loading the file
carrier_data=read.csv("C:/Users/student/Desktop/admp/airlines.csv")
View(carrier_data)

carrier_data= carrier_data[c('CARRIER','CARRIERNAME')]

View(carrier_data)
#Saving the data
write.csv(carrier_data,'C:/Users/student/Desktop/admp/Dim_Carrier.csv',row.names = FALSE)
