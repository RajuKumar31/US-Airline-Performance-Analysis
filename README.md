# U.S. Airline Performance & Delay Analysis

## Project Overview

This is an end-to-end data analytics project analysing 1,048,575 U.S. domestic flights to identify delay patterns, cancellation trends, airline performance rankings, and airport congestion hotspots.

The project was built using PostgreSQL for data storage, cleaning, exploratory analysis, and KPI creation, while Power BI was used for interactive dashboard reporting and business storytelling.

---

## Business Problem

The U.S. airline industry continues to operate below the industry standard 80% on-time performance benchmark. Frequent delays, cancellations, and airport congestion negatively impact customer experience and operational efficiency.

This project analyses airline operational performance across 14 major carriers to identify:

* Delay trends
* Root causes of disruptions
* Airport congestion patterns
* Cancellation behaviour
* Best and worst performing airlines

The goal is to provide actionable business recommendations that can help improve operational reliability and overall customer satisfaction.

---

## Tools Used

| Tool       | Purpose                                          |
| ---------- | ------------------------------------------------ |
| PostgreSQL | Data storage, cleaning, EDA, KPI development     |
| SQL        | Exploratory analysis, KPI queries, view creation |
| Power BI   | Dashboard development and reporting              |
| DAX        | Calculated measures and KPI calculations         |

---

## Dataset

* Source: U.S. Department of Transportation (2015)
* Total Records Analysed: 1,048,575 flights
* Airlines: 14 carriers
* Airports: 322 airports

Note:
The original dataset contains approximately 5.8 million records. A sample dataset was used due to Excel row limitations and system performance considerations.

---

## Key Findings

* Industry on-time performance is 78.08%, below the 80% benchmark
* Alaska Airlines recorded the highest OTP at 86.51%
* Frontier Airlines recorded the lowest OTP at 63.28%
* Late aircraft propagation contributes 38% of all delay minutes
* Carrier delays account for 31% of delays and are largely operational
* Weather contributes only 5.44% of total delays
* American Eagle shows an 11.79% cancellation rate
* Chicago O’Hare and New York airports are major congestion hotspots
* BWI to DFW is the most delayed route with an average delay of 71.91 minutes

---

## Dashboard Screenshots

### Executive Overview
![Executive Overview](reports/screenshots/executive_overview.png)

### Airline Performance
![Airline Performance](reports/screenshots/airline_performance.png)

### Airport and Route Analysis
![Airport Route Analysis](reports/screenshots/airport_route_analysis.png)

## Dashboard Pages

### 1. Executive Overview

* Industry KPIs
* OTP analysis
* Delay trends
* Airline rankings

### 2. Airline Performance Deep Dive

* Executive scorecard
* Delay cause analysis
* Cancellation analysis
* Airline comparisons

### 3. Airport & Route Analysis

* Airport congestion analysis
* Route delay analysis
* Taxi-out performance
* Operational bottlenecks

---

## SQL Highlights

* Performed data quality audit across 6 validation dimensions
* Created cleaned views filtering cancelled and diverted flights
* Built KPI views using aggregations and window functions
* Used SQL concepts such as:

  * CASE WHEN
  * COALESCE()
  * NULLIF()
  * RANK() OVER()
  * CTEs
  * Aggregations and joins

---

## Project Structure

```text
us-airline-performance-analysis/
│
├── data/
│   └── raw/                  Raw CSV files
│
├── sql/                      SQL scripts
│   ├── 01_database_setup.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_eda_analysis.sql
│   └── 04_kpi_views.sql
│
├── powerbi/
│   └── US_Airline_Performance_Analysis.pbix
│
├── reports/
│   └── Business_Insights_Report.docx
│
└── README.md
```

---

## How to Run the Project

1. Install PostgreSQL and pgAdmin
2. Create a database named:
   `airline_performance`
3. Import the CSV datasets
4. Run SQL scripts in sequence:

   * 01_database_setup.sql
   * 02_data_cleaning.sql
   * 03_eda_analysis.sql
   * 04_kpi_views.sql
5. Open Power BI Desktop
6. Connect Power BI to PostgreSQL
7. Load all required tables and views
8. Open the `.pbix` dashboard file

---

## Business Recommendations

Based on the analysis, the following recommendations were identified:

* Improve schedule buffers for high-risk routes
* Reduce carrier-related operational delays
* Redistribute peak-hour traffic at congested airports
* Improve maintenance and crew scheduling processes
* Strengthen operational planning during high-demand days

These actions could significantly improve OTP performance and reduce operational disruptions.

---

## Author

Raju Kumar S
Data Analyst | Bengaluru, India

GitHub: github.com/RajuKumar31
LinkedIn: linkedin.com/in/rajukumarsahani
Tableau: public.tableau.com/app/profile/raju.kumar.s1115