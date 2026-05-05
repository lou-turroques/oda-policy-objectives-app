# ODA by Policy Objectives — R Shiny App

An interactive Shiny app for exploring ODA (Official Development Assistance) 
data by policy objectives and markers.

## Requirements

Install the required R packages before running:

```r
install.packages(c("shiny", "plotly", "tidyverse", "data.table", 
                   "writexl", "officer", "DT", "shinyWidgets", 
                   "highcharter", "networkD3", "htmlwidgets", 
                   "shinydashboard", "shinyscreenshot"))

# For the 'capture' package (from GitHub):
install.packages("remotes")
remotes::install_github("dreamRs/capture")
```

## How to Run

1. Clone or download this repository
2. Place your data CSV files in the `www/data/` folder
3. Open `app.R` in RStudio and click **Run App**

## Data

The app expects the following CSV files in `www/data/`:
- `table1_markers.csv`
- `table2_markers.csv`
- *(list all your files)*

## Contributing

Suggestions and improvements are welcome! Feel free to open an **Issue** 
or submit a **Pull Request**.
