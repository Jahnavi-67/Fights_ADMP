
# ✈️ Flight Delay Analysis using R, Hive, Hadoop, and Tableau


## 🧩 Step 1: Project Overview

This MSc project focuses on **analyzing flight delays** using **R programming**, **Hive queries**, and **Hadoop data handling**, with insights visualized through **Tableau dashboards**.  
The goal is to identify delay patterns, uncover major influencing factors, and provide **data-driven insights** to improve airline operational performance.

### 🎯 Objectives
- Analyze large-scale flight datasets to detect key delay trends.
- Use **Hive** and **Hadoop** for efficient big data storage and querying.
- Perform data cleaning and analysis using **R**.
- Visualize findings through **Tableau** for actionable insights.

### 🧠 Key Features
- Integration of **Big Data technologies** (Hadoop, Hive, R, Tableau).  
- Large dataset processing and visualization of delay trends.  
- Scalable data handling pipeline.  
- Focused on uncovering insights that support data-driven decisions.



## ⚙️ Step 2: Implementation Process

### 1️⃣ Data Ingestion
- Flight datasets (2015–2024) uploaded into **HDFS** for distributed storage.
- Data format: `.csv` and `.orc` for Hive compatibility.

### 2️⃣ Data Processing using Hive
sql
CREATE EXTERNAL TABLE flight_delays (
  flight_id STRING,
  carrier STRING,
  origin STRING,
  destination STRING,
  delay INT,
  weather STRING,
  date STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

SELECT carrier, AVG(delay) AS avg_delay
FROM flight_delays
GROUP BY carrier
ORDER BY avg_delay DESC;


* Hive used for SQL-like querying and summarizing flight delay trends.

### 3️⃣ Data Analysis in R


library(RODBC)
conn <- odbcConnect("HiveDSN")
data <- sqlQuery(conn, "SELECT * FROM flight_delays")
summary(data)

# Visualization
hist(data$delay, main = "Flight Delay Distribution", col = "skyblue", xlab = "Delay (minutes)")

* R used for **data cleaning**, **statistical analysis**, and **exploratory data visualization**.

### 4️⃣ Visualization using Tableau

* Tableau connected to processed Hive/R outputs.
* Created dashboards for:

  * Airline-wise delay trends
  * Weather vs delay correlation
  * Airport-level delay frequency
  * Monthly and yearly delay trends



## 📊 Step 3: Results and Insights

### 🔍 Key Findings

* Certain airlines and routes show consistently higher delays.
* Weather conditions (fog, rain, snow) have a significant impact on delays.
* Peak delay hours are between **4 PM – 8 PM** during high-traffic seasons.
* Data-driven insights enable airlines to **improve on-time performance**.

### 📈 Tableau Dashboard Highlights

* **Airline Delay Trends:** Average and peak delay times by carrier.
* **Airport Performance:** Comparison of delay frequencies.
* **Weather Impact:** Relation between weather events and delay time.
* **Seasonal Trends:** Month-wise visualization of delays across years.

### 🚀 Technologies Used

| Category      | Tools/Technologies        |
| ------------- | ------------------------- |
| Programming   | R, RStudio                |
| Big Data      | Hadoop, Hive              |
| Visualization | Tableau                   |
| Storage       | HDFS                      |
| Data Format   | CSV, ORC                  |
| Dataset       | Flight Delays (2015–2024) |



## 👩‍💻 Step 4: Author Information

**Author:** Jhanavi K
**Program:** MSc Big Data Analytics
**Institution:** Sheffield Hallam University
**Location:** Sheffield, United Kingdom
**Email:** [[your.email@shu.ac.uk](mailto:your.email@shu.ac.uk)]
**Year:** 2025



### 📚 Future Scope

* Add **Machine Learning models** for delay prediction using R.
* Automate data pipelines with **Apache Oozie** or **Airflow**.
* Incorporate **real-time analytics** using **Apache Spark** and **Kafka**.
* Extend Tableau dashboards with **geospatial visualizations**.


