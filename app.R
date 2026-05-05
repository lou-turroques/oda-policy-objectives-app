

library(shiny)
library(plotly)
library(dplyr)
library(tidyverse)
library(tidyr)
library(ggplot2)
library(openxlsx)
library(writexl)
library(data.table)
library(officer)
library(DT)
library(rsconnect)
library(shinyWidgets)
library(highcharter)
library(networkD3)
library(htmlwidgets)
library(shinydashboard)
library(shinyscreenshot)
library(capture)
# install.packages("remotes")
# remotes::install_github("dreamRs/capture")

options(rsconnect.http.timeout = 300)


# Import your datasets (one dataset per chart/table) - example for CSOs at a glance --------

dataset_table1_markers <- fread("www/data/table1_markers.csv", header = TRUE)
dataset_table2_markers <- fread("www/data/table2_markers.csv", header = TRUE)
dataset_chart1_markers <- fread("www/data/chart1_markers.csv", header = TRUE)
dataset_chart2_markers <- fread("www/data/chart2_markers.csv", header = TRUE)
dataset_chart3_markers <- fread("www/data/chart3_markers.csv", header = TRUE)
dataset_summary_tables_markers <- fread("www/data/summary_tables_markers.csv", header = TRUE)

## Table coverage 2023-24
dataset_cov <- fread("www/data/table_cov.csv", header = TRUE)
dataset_policy_markers_names <- fread("www/data/policy_markers_names.csv", header = TRUE)

## Additional info on policy markers (descriptions, names, color mapping)
source("./Import_additional_information_on_policy_markers.R")

## /!\ TO BE UPDATED ONLY HERE 
## Set values for current_year, previous_year and defl_year and two_year
current_year <- as.character(2024)
previous_year <- as.character(as.numeric(current_year) - 1)
defl_year <- as.character(2024)
two_year <- paste0(previous_year, "-", substr(current_year, 3, 4))  # e.g., "2023-24"
last_period <- paste0(previous_year,"-",current_year) # e.g., "2023-2024"

## Correct format
dataset_table1_markers <- dataset_table1_markers |>
  mutate(
    !!two_year := round((.data[[previous_year]] + .data[[current_year]]) / 2, 0),
    !!previous_year := case_when(
      variable == "as % of screened aid" ~ paste0(round(.data[[previous_year]], 0), "%"),
      TRUE ~ format(round(.data[[previous_year]], 0), big.mark = " ", scientific = FALSE)
    ),
    !!current_year := case_when(
      variable == "as % of screened aid" ~ paste0(round(.data[[current_year]], 0), "%"),
      TRUE ~ format(round(.data[[current_year]], 0), big.mark = " ", scientific = FALSE)
    ),
    !!two_year := case_when(
      variable == "as % of screened aid" ~ paste0(.data[[two_year]], "%"),
      TRUE ~ format(.data[[two_year]], big.mark = " ", scientific = FALSE)
    )
  )|>
  rename(!!paste0(two_year, " (avg)") := !!two_year) |>
  select(
    donor_name_e,
    variable,
    all_of(c(previous_year, current_year, paste0(two_year, " (avg)"))),
    marker
  )


dataset_table2_markers <- dataset_table2_markers |>
  mutate(
    `Total bilateral allocable aid` = format(
      `Total bilateral allocable aid`,
      big.mark = " ",
      scientific = FALSE
    ),
    `Aid focused on policy objective - volume` = format(
      `Aid focused on policy objective - volume`,
      big.mark = " ",
      scientific = FALSE
    ),
    recipient_name_e = iconv(recipient_name_e, from = "latin1", to = "UTF-8"),
    recipient_name_e = case_when(
      recipient_name_e == "TÃ¼rkiye" ~ "Türkiye",
      recipient_name_e == "CÃ´te d'Ivoire" ~ "Côte d'Ivoire",
      TRUE ~ recipient_name_e)
  )

dataset_chart1_markers <- dataset_chart1_markers |>
  mutate(
    # value = as.numeric(gsub(" ", "", value)),
    #      percent = as.numeric(gsub(" ", "", percent)),
    order = case_when(
      category== "Education"~ 1,
      category=="Health and Population" ~ 2,
      category=="Other Social Infrastructure" ~ 3,
      category=="Economic Infrastructure"~ 4,
      category=="Production" ~ 5,
      category== "Multisector"~ 7,
      TRUE ~ 8
    )) |>
  arrange(order)

dataset_chart2_markers <- dataset_chart2_markers |>
  filter(!((two_year == "2015-2016" & marker == "disability")|(two_year == "2016-2017" & marker == "disability")))|>
  mutate(vx = as.numeric(gsub(" ", "", vx)),
         vx = round(vx,2))|>
  filter(!(year<=2023 & donor_name_e=="Slovenia" & marker %in% c("biodiversity","rmnch")))

dataset_chart3_markers <- dataset_chart3_markers |>
  mutate(value = as.numeric(gsub(" ", "", value)),
         recipient_name_e = iconv(recipient_name_e, from = "latin1", to = "UTF-8"),
         recipient_name_e = case_when(
           recipient_name_e == "TÃ¼rkiye" ~ "Türkiye",
           recipient_name_e == "CÃ´te d'Ivoire" ~ "Côte d'Ivoire",
           TRUE ~ recipient_name_e))


# Hyperlinks 
OECD_ODA_web_page <- "http://data-explorer.oecd.org/s/52"
CRS_link <- "https://data-explorer.oecd.org/vis?lc=en&pg=0&fs[0]=Topic%2C1%7CDevelopment%23DEV%23%7COfficial%20Development%20Assistance%20%28ODA%29%23DEV_ODA%23&fc=Topic&bp=true&snb=27&df[ds]=dsDisseminateFinalCloud&df[id]=DSD_CRS%40DF_CRS&df[ag]=OECD.DCD.FSD&dq=DAC..1000.100._T._T.D.Q._T..&lom=LASTNPERIODS&lo=5&to[TIME_PERIOD]=false"
ffsd_link <-  "https://www.oecd.org/en/topics/finance-for-sustainable-development.html" 
faq_link<- "https://www.oecd.org/en/data/insights/data-explainers/2024/07/frequently-asked-questions-on-official-development-assistance-oda.html"
resources_reporting_link <- "https://www.oecd.org/content/oecd/en/data/insights/data-explainers/2024/10/resources-for-reporting-development-finance-statistics.html"
reporting_directives_link <-"https://one.oecd.org/document/DCD/DAC(2024)40/FINAL/en/pdf"
dac_countries_link <-"https://data-explorer.oecd.org/vis?fs[0]=Topic%2C1%7CDevelopment%23DEV%23%7COfficial%20Development%20Assistance%20%28ODA%29%23DEV_ODA%23&pg=0&fc=Topic&bp=true&snb=26&vw=tb&df[ds]=dsDisseminateFinalCloud&df[id]=DSD_CRS%40DF_CRS&df[ag]=OECD.DCD.FSD&dq=AUS%2BAUT%2BBEL%2BCAN%2BCZE%2BDNK%2BEST%2BFIN%2BFRA%2BDEU%2BGRC%2BHUN%2BISL%2BIRL%2BITA%2BJPN%2BKOR%2BLTU%2BLUX%2BNLD%2BNZL%2BNOR%2BPOL%2BPRT%2BSVK%2BSVN%2BESP%2BSWE%2BCHE%2BGBR%2BUSA%2BLVA.DPGC.1000.100._T._T.D.Q._T..&lom=LASTNPERIODS&lo=5&to[TIME_PERIOD]=false"
non_dac_link <- "https://data-explorer.oecd.org/vis?fs[0]=Topic%2C1%7CDevelopment%23DEV%23%7COfficial%20Development%20Assistance%20%28ODA%29%23DEV_ODA%23&pg=0&fc=Topic&bp=true&snb=26&vw=tb&df[ds]=dsDisseminateFinalCloud&df[id]=DSD_CRS%40DF_CRS&df[ag]=OECD.DCD.FSD&dq=AZE%2BBGR%2BTWN%2BHRV%2BCYP%2BISR%2BKAZ%2BKWT%2BLIE%2BMLT%2BMCO%2BQAT%2BROU%2BSAU%2BTHA%2BTLS%2BTUR%2BARE.DPGC.1000.100._T._T.D.Q._T..&lom=LASTNPERIODS&lo=5&to[TIME_PERIOD]=false"
multi_organisation_link <- "https://data-explorer.oecd.org/vis?fs[0]=Topic%2C1%7CDevelopment%23DEV%23%7COfficial%20Development%20Assistance%20%28ODA%29%23DEV_ODA%23&pg=0&fc=Topic&bp=true&snb=26&vw=tb&df[ds]=dsDisseminateFinalCloud&df[id]=DSD_CRS%40DF_CRS&df[ag]=OECD.DCD.FSD&dq=4EU001%2B5IMF0%2B5IMF02%2B5IMF03%2B5RDB0%2B5AFDB0%2B5AFDB001%2B5AFDB002%2B5ASDB0%2B5ASDB01%2B5IDB0%2B5IDB001%2B5IDB003%2B9OTH002%2B5RDB001%2B5RDB002%2B5RDB003%2B5RDB004%2B5RDB005%2B5RDB006%2B5RDB007%2B5RDB008%2B5RDB009%2B5RDB011%2B1UN0%2B1UN001%2B1UN002%2B1UN003%2B1UN004%2B1UN005%2B1UN006%2B1UN007%2B1UN008%2B1UN030%2B1UN031%2B1UN010%2B1UN032%2B1UN011%2B1UN012%2B1UN013%2B1UN014%2B1UN015%2B1UN016%2B1UN017%2B1UN018%2B1UN019%2B1UN020%2B1UN021%2B1UN022%2B1UN024%2B1UN025%2B1UN026%2B1UN027%2B1UN028%2B1UN029%2B5WBG0%2B5WB0%2B5WB001%2B5WB002%2B5WBG002%2B9OTH0%2B9OTH001%2B9OTH003%2B9OTH005%2B9OTH024%2B9OTH006%2B9OTH009%2B9OTH011%2B9OTH012%2B9OTH013%2B9OTH015%2B9OTH016%2B9OTH017%2B9OTH018%2B9OTH019%2B9OTH020%2B9OTH021%2B9OTH022%2B9OTH023.DPGC.1000.100._T._T.D.Q._T..&lom=LASTNPERIODS&lo=5&to[TIME_PERIOD]=false"
recipient_list_link <-"https://www.oecd.org/en/topics/oda-eligibility-and-conditions/dac-list-of-oda-recipients.html"
glossary_purpose_code_link <-"https://www.oecd.org/en/topics/sub-issues/oda-standards/glossary-of-statistical-terms-and-concepts-of-development-finance.html#Purpose_Code"
glossary_aid_activity_link <-"https://www.oecd.org/en/topics/sub-issues/oda-standards/glossary-of-statistical-terms-and-concepts-of-development-finance.html#Aid_Activity"
glossary_DAC_link <-"https://www.oecd.org/en/topics/sub-issues/oda-standards/glossary-of-statistical-terms-and-concepts-of-development-finance.html#DAC"
code_list_link <-"https://development-finance-codelists.oecd.org/CodesList.aspx"
dac_contact_link  <-"mailto:DAC.contact@oecd.org"
dac_web_page <- "https://www.oecd.org/en/about/committees/development-assistance-committee.html"
gender_database_link <- "http://data-explorer.oecd.org/s/a9"
rio_database_link <- "http://data-explorer.oecd.org/s/1tj"
others_database_link <- "http://data-explorer.oecd.org/s/1tf"

# Working Directory -------------------------------------------------------

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  p(strong("Last updated: April 9, 2026")), #Change the date manually to match with DE (We don't automatize since we will probably make several few changes during the comming month)
  
  
  # p(
  #   "Explore key trends and insights on the policy objectives of ",
  #   a(
  #     "official development assistance (ODA)",
  #     href = "https://www.oecd.org/en/topics/official-development-assistance-oda.html",
  #     target = "_blank"
  #   ),
  #   " of members of the OECD's Development Assistance Committee (DAC), using the OECD's policy marker system. For more information on definitions and methods, please refer to ",
  #   HTML("<i>Methodological notes</i>"),
  #   "."
  # ),
  
  sidebarLayout(
    sidebarPanel(
      style = "position:fixed;
              width:25%;",
      tags$style(HTML("
                      .btn {font-size: 12px;}")),
      div("Start by selecting a policy objective and a provider to refresh the dashboard."),
      br(),
      selectInput(
        inputId = "marker",
        label = HTML("<b>Select your policy objective here:</b>"),
        choices = c(
          "Biodiversity" = "biodiversity",
          "Climate adaptation" = "climate_adaptation",
          "Climate mitigation" = "climate_mitigation",
          "Desertification" = "desertification",
          "DIG" = "dig",
          "Disability" = "disability",
          "DRR" = "drr",
          "Environment" = "environment",
          "Gender equality" = "gender",
          "Nutrition" = "nutrition",
          "RMNCH" = "rmnch"
        )
      ),
      selectInput(
        inputId = "donor_name_marker",
        label = HTML("<b>Select your provider of interest:</b>"),
        choices = sort(unique(dataset_table1_markers$donor_name_e)),
        selected = "All DAC members",
        multiple = FALSE
      ),
      br(),
      helpText(
        strong(
          "More on the policy objectives of official development assistance:"
        ),
        align = "left"
      ),
      p(
        "- Aid (ODA) activities targeting gender equality and women's empowerment:",
        a("Gender Markers - database", 
          href = gender_database_link, target = "_blank")
      ),
      p(
        "- Aid (ODA) activities targeting global environment objectives:",
        a("Rio Markers - database", 
          href = rio_database_link, target = "_blank")
      ),
      p(
        "- Aid (ODA) activities targeting other policy objectives:",
        a("Other Markers - database", 
          href = others_database_link, target = "_blank")
      ),
      br(),
      downloadButton('downloadResults', 'Download filtered dataset'),
      capture::capture_pdf(
        selector = "body",  
        filename = "ODA policy objectives dashboard.pdf",  
        icon("camera"),   
        "PDF",
        format = "a4",
        orientation = "portrait" 
      )
      #,
      # p(
      #   "- ",
      #   a(
      #     "Development Co-operation Profiles",
      #     href = "https://www.oecd.org/en/publications/development-co-operation-profiles_2dcf1367-en.html",
      #     target = "_blank"
      #   ),
      #   "(Geographic, sectoral and thematic focus of ODA section)"
      # )
    ),
    
    mainPanel(
      style = "margin-left:28%;",
      tabsetPanel(
        ## Tab 1: Dashboard Overview -----------------------------------
        tabPanel("Dashboard overview", 
                 fluidRow(
                   
                   column(
                     width = 12,
                     br(), 
                     uiOutput("text_content_donor_profile_markers"),
                     br(),
                     tabsetPanel(
                       ### Sub-tab - Provider Profile -----------------------------------
                       tabPanel(
                         "Overview",
                         br(),
                         fluidRow(
                           column(6, 
                                  uiOutput("title_table1_bis_markers"),
                                  dataTableOutput("results_table1_bis_markers")), 
                           column(6, plotlyOutput("plot2_bis_markers"))
                         ),
                         br(),
                         fluidRow(
                           column(6, 
                                  br(),
                                  plotlyOutput("plot1_bis_markers")),
                           column(6, 
                                  br(), 
                                  uiOutput("title_table2_bis_markers"),
                                  dataTableOutput("results_table2_bis_markers")),
                           
                           br()
                         ),
                         br(),
                         br(),
                         br(),
                         fluidRow(
                           column(12,uiOutput("footnote_markers"))),
                         br()
                       ),
                       ### Sub-tab - Table 1 -----------------------------------
                       tabPanel(
                         "Main indicators",
                         br(),
                         uiOutput("title_table1_markers"),
                         br(),
                         downloadButton('downloadResults_table1_markers', 'Download filtered dataset'),
                         br(),
                         dataTableOutput("results_table1_markers"),
                         br(),
                         uiOutput("footnote_table1_markers")
                       ),
                       ### Sub-tab - Chart 2 ---------------------------------------------------------
                       tabPanel(
                         "Trends over time",
                         br(),
                         plotlyOutput("plot2_markers", height = "600px", width =
                                        "1200px"),
                         br(),
                         downloadButton('downloadResults_chart2_markers', 'Download filtered dataset'),
                         #downloadButton(outputId = "downloadPlot2_markers", label = "Download Plot"),
                         br(),
                         dataTableOutput("results_chart2_markers"),
                         br(),
                         uiOutput("footnote_chart2_markers")
                       ),
                       ### Sub-tab - Chart 1 ---------------------------------------------------------
                       tabPanel(
                         "Sector categories",
                         br(),
                         plotlyOutput("plot1_markers", height = "600px", width =
                                        "1200px"),
                         br(),
                         downloadButton('downloadResults_chart1_markers', 'Download filtered dataset'),
                         br(),
                         dataTableOutput("results_chart1_markers"),
                         br(),
                         uiOutput("footnote_chart1_markers")
                       ),
                       ### Sub-tab - Table 2 / Chart 3 -----------------------------------
                       tabPanel(
                         "Top ten recipients",
                         br(),
                         plotlyOutput("plot3_markers", height = "600px", width =
                                        "1200px"),
                         br(),
                         downloadButton('downloadResults_table2_markers', 'Download filtered dataset'),
                         br(),
                         dataTableOutput("results_table2_markers"),
                         br(),
                         uiOutput("footnote_chart3_markers")
                       )
                       
                     )
                   ))),
        
        ## Tab 2: Data Summary -----------------------------------
        tabPanel(
          "All providers’ summary tables",
          br(),
          uiOutput("text_content_cross_provider_summary_table_markers"),
          br(),
          tabPanel(
            "Table",
            br(),
            downloadButton(
              'downloadResults_summary_tables_markers',
              'Download filtered dataset'
            ),
            br(),
            dataTableOutput("results_summary_tables_markers"),
            br(),
            uiOutput("footnote_summary_tables_markers")
          )
          
        ),
        
        ## Tab 3: Methodological notes  -----------------------------------
        tabPanel(
          "Methodological notes",
          # br(),
          # h4("How to use this dashboard?"),
          # uiOutput("text_content_dashboard_markers"),
          br(),
          h4("CRS: Creditor Reporting System"),
          p("The data visualisations are based on data from the ", 
            a("OECD Creditor Reporting System (CRS)", 
              href= CRS_link), 
            "and focus on civil society engagement in development co-operation."),
          p("For more information on these flows, please see the OECD's main page on ", 
            a("official development assistance", 
              href= OECD_ODA_web_page), 
            "and ", 
            a("finance for sustainable development", 
              href= ffsd_link),
            ", including ", 
            a("frequently asked questions (FAQs)", 
              href= faq_link),
            " on ODA. See also the ", 
            a("converged statistical reporting directives", 
              href= reporting_directives_link),
            " governing these data, alongside ", 
            a("other guidance on using our data", 
              href= resources_reporting_link),
            "." ),
          br(),
          h4("Policy marker presentation"),
          uiOutput("text_content_methodo_markers"),
          # br(),
          # h4("Coverage ratio"),
          # uiOutput("text_content_coverage"),
          br(),
          h4("Definitions"),
          br(),
          h5(strong("Development Assistance Committee (DAC)")),
          p("The ",
            a("Development Assistance Committee", 
              href= dac_web_page),
            " is a unique international forum of many of the largest providers of aid, including 33 members. It is the committee of the OECD which deals with development co-operation matters." ),
          br(),
          h5(strong("Official development assistance (ODA)")),
          p("Official development assistance (ODA) is the term used by DAC members to refer to what most people would call aid. ODA includes activities carried out with the economic development and welfare of developing countries as their main objective. It is a measure of donor effort, including grants and grant equivalents of concessional loans."),
          h6(strong("Constant prices")),
          p("A deflated amount is a measure given at a constant price, adjusted for the effects of inflation and exchange rates. The amounts in this dashboard are in constant ", defl_year,  "prices."),
          h6(strong("Commitments")),
          p("This dashboard presents ODA commitments New amounts committed during the reporting year. A commitment is a firm written obligation by a government or official agency, backed by the appropriation or availability of the necessary funds, to provide resources of a specified amount under specified financial terms and conditions and for specified purposes for the benefit of a recipient country or a multilateral agency."),
          br(),
          h5("Coverage ratio"),
          p("As from 2010 data, the calculation of allocable aid is based on types of aid. The calculation includes the following types of aid: sector budget support, core support to NGOs, support to specific funds managed by international organisations, pooled funding, projects, donor country personnel and other technical assistance, and scholarships in donor country. The term bilateral allocable aid in this publication refers to this methodology."),
          p("The coverage ratio refers to the share of allocable activities that has been screened with a marker."),
          p("Coverage Ratio = (Sum of allocable activities marked 0, 1 or 2) / (Sum of all allocable activities)"),
          br(),
          br(),
          h4("FAQ - Policy markers"),
          p(tags$em("Forthcoming")),
          #uiOutput("text_content_faq"),
          br(),
          h4("Contact"),
          p(
            "For any questions, please contact",
            a("DAC.contact@oecd.org", href = dac_contact_link),
            "."
          )
        ) ) )),
  
  # br(),
  # p("© OECD 2025"),
  # p(
  #   "The use of this work, whether digital or print, is governed by the Terms and Conditions to be found at ",
  #   a("http://www.oecd.org/termsandconditions", href = "http://www.oecd.org/termsandconditions"),
  #   "."
  # ),
  
  
  tags$div(
    style = "text-align: center; margin-top: 50px;",
    div(
      style = "display: flex; align-items: center; justify-content: space-between; width: 100%;",
      
      div(
        style = "text-align: left; font-weight: 300; flex-grow: 1;",
        h6(strong("© Organisation for Economic Co-operation and Development"))
      ),
      
      div(
        style = "flex-grow: 1; text-align: right;",
        img(src = "EN_Co-fundedbytheEU_RGB_POS.png",
            style = "height:40px;")
      ),
      h1("")
      
    ),
    windowTitle = "Official development assistance by policy objective")
  
  
  
)





# Define Server -----------------------------------------------

#Open Server section
server <- shinyServer(function(input, output) {
  vals <- reactiveValues()
  #It's important to reactive the values if you want them to be displayed
  
  
  ## Section - Overview ----------------------------------------------------------------
  
  #### Text ----------------------------------------------------------------
  
  
  
  output$text_content_donor_profile_markers <- renderUI({
    filtered_data <- dataset_cov |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker)
    
    filtered_names <- dataset_policy_markers_names |>
      filter(marker == input$marker)
    
    marker_long_text <- marker_texts[[input$marker]]
    
    # Construct the dynamic content string
    content <- paste0(
      "
    <b><u><span style='font-size:14px;'>",
      filtered_names$name_marker,
      "</span></u></b>
    <br>
    <br>For <b>",
      filtered_data$donor_name_text,
      "</b>, the  <b> ratio of coverage </b> for this marker against all bilateral allocable ODA is  <b>",
      paste0(filtered_data[[last_period]],"%"),
      "</b> in ", 
      paste0(previous_year, "-", current_year), 
      ".  <b>",
      filtered_data$comment,
      "</b>
    <br>
    <br>The analysis below uses <b>two-year (", 
      paste0(previous_year, "-", current_year), 
      ") averages</b> to account for volatility in the use of <b>commitments</b> data and to align with the historical series of publications at the OECD that use such data. All figures are expressed in constant 2023 USD million unless otherwise stated.
    <br> "
    )
    # Render the content as HTML
    HTML(paste0("<div class='my-text'>", content, "</div>"))
  })
  
  output$title_table1_bis_markers <- renderText({
    filtered_names <- dataset_policy_markers_names |>
      filter(marker == input$marker)
    
    content <- paste0("<span style='font-family:Noto Sans; font-size:14px; font-weight:bold; line-height:22px; color:#101D40;'>",        
                      "<b>Main indicators for ",filtered_names$lower_case_name_marker,"</b><br><sub>",
                      "<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>",
                      " USD million (constant ",defl_year," prices)</span></sub>"
    )
    vals$title_table1_bis_markers <- content
    content
    HTML(paste0("<div class='my-text' style='text-align:center;'>", content, "</div>"))
    
  })
  #### Footnote - Provider profile -----------------------------------
  
  
  output$footnote_markers <- renderUI({
    if (input$marker == "gender") {
      tagList(
        p("Note: 'Principal objective' includes activities scored 2 for this policy objective, as well as activities with purpose codes 15170 or 15180, which have gender equality, by definition, as a 'principal objective'."),
        p("* % of bilateral allocable aid excluding activities not screened against the marker."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else if (input$marker == "biodiversity") {
      tagList(
        p("Note: 'Principal objective' includes activities scored 2 for this policy objective, as well as activities with purpose code 41030, which have biodiversity, by definition, as a 'principal objective'."),
        p("* % of bilateral allocable aid excluding activities not screened against the marker."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else {
      tagList(
        p("Note: * % of bilateral allocable aid excluding activities not screened against the marker."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    }
  })
  
  

  #### Download the results ----------------------------------------------------
  
  
  output$downloadResults <- downloadHandler(
    
    #The filename function specifies the name of the file that will be downloaded (recipient name).
    filename = function() {
      paste0(input$donor_name_marker,"_data_for_",input$marker,".xlsx")
    }
    ,
    
    # The content function defines the actual content to be written to the file when the download button is clicked.
    content = function(file) {
      table_1_download <- dataset_table1_markers |>
        filter(donor_name_e == input$donor_name_marker,
               marker == input$marker) |>
        rename(Indicator = variable, Provider = donor_name_e, `Policy objective` = marker) |>
        mutate(across(
          where(is.character) & !any_of(c("Indicator", "Provider", "Policy objective")),
          ~ suppressWarnings(ifelse(
            Indicator == "as % of screened aid",  # ← was: vals$filtered_table1_markers$Indicator
            .x,
            as.numeric(gsub(" ", "", .x))
          ))
        ))
      chart_1_download <- dataset_chart2_markers |>
        filter(donor_name_e == input$donor_name_marker,
               marker == input$marker) |>
        select(
          Provider = donor_name_e,
          Period = two_year,
          Indicator=variable,
          `Policy objective`=marker,
          vx,
          -c(year, base_year, base)
        ) |>
        rename(value=vx)
      chart_2_download <- dataset_chart1_markers |>
        filter(donor_name_e == input$donor_name_marker,
               marker == input$marker)|>
        rename(Provider = donor_name_e, `Policy objective`=marker)|>
        select(-c(order))
      table_2_download <- dataset_table2_markers |>
        filter(donor_name_e == input$donor_name_marker,
               marker == input$marker) |>
        rename(Recipient = recipient_name_e, Provider = donor_name_e, `Policy objective`=marker)|>
        mutate(across(
          where(is.character) & !any_of(c("Recipient", "Provider","Policy objective","Aid focused on policy objective* - share")),
          ~ suppressWarnings(as.numeric(gsub(" ", "", .x)))
        )) 
      table_A1_download <- dataset_summary_tables_markers |>
        filter(marker == input$marker) |>
        rename(Provider =donor_name_e,`Policy objective`=marker)|>
        mutate(across(
          where(is.character) & !any_of(c("as % of screened aid", "Provider","Policy objective")),
          ~ suppressWarnings(as.numeric(gsub(" ", "", .x)))
        ))
      
      sheets <- list(
        "Overview" = data.frame('Overview' = c(paste0("Provider: ",input$donor_name_marker),
                                               paste0("Policy objective: ",input$marker),
                                               paste0("Source: CRS: Creditor Reporting System (flows)."))),
        "Main indicators" = table_1_download,
        "Trends over time" = chart_1_download ,
        "Sector breakdown" = chart_2_download ,
        "Top ten recipients" = table_2_download ,
        "Cross-provider summary table" = table_A1_download
      )
      write_xlsx(sheets, file)
    }
  )   
  
  
  # Sub-section - Table 1 -----------------------------------
  
  #### Text ----------------------------------------------------------------
  
  output$title_table1_markers <- renderText({
    filtered_names <- dataset_policy_markers_names |>
      filter(marker == input$marker)
    
    content <- paste0(
      "<span style='font-family:Noto Sans; font-size:14px; font-weight:bold; line-height:22px; color:#101D40;'>",        
                      "<b>Main indicators for ",filtered_names$lower_case_name_marker,"</b><br><sub>",
                      "<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>",
                      " USD million (constant ",defl_year," prices)</span></sub>"
    
    )
    vals$title_table1_markers <- content
    content
    HTML(paste0("<div class='my-text' style='text-align:center;'>", content, "</div>"))
    
  })
  
  #### Display Table 1 ----------------------------------------------------------------
  
  output$results_table1_markers <- renderDataTable({
    filtered_table1_markers <- dataset_table1_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      rename(Indicator = variable, Provider = donor_name_e) |>
      select(-c(marker))
    filtered_table1_markers
    
    vals$filtered_table1_markers <-  filtered_table1_markers
    
    # Add custom HTML formatting to specific indicators
    filtered_table1_markers <- filtered_table1_markers %>%
      mutate(
        Indicator = ifelse(
          Indicator %in% c("Total bilateral allocable aid", "as % of screened aid"),
          # List indicators to format
          paste0("<b>", Indicator, "</b>"),
          # Bold
          Indicator
        ),
        Indicator = ifelse(
          Indicator %in% c("Total of aid focused on policy objective"),
          # List indicators to format
          paste0("<b>", Indicator, "</b>"),
          # Bold
          Indicator
        ),
        Indicator = ifelse(
          Indicator %in% c("Total bilateral non-allocable ODA"),
          # List indicators to format
          paste0("<i>", Indicator, "</i>"),
          # italicize
          Indicator
        )
      )
    
    datatable(
      filtered_table1_markers,
      options = list(pageLength = 25, dom = 't'),
      rownames = FALSE,
      escape = FALSE
    )  # Allow HTML rendering
    
  })
  
  #### Display Table 1 (for Donor profile) ----------------------------------------------------------------
  
  output$results_table1_bis_markers <- renderDataTable({
    filtered_table1_bis_markers <- dataset_table1_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      rename(`Indicator` = variable, Provider = donor_name_e) |>
      select(-c(Provider, marker))
    
    filtered_table1_bis_markers
    
    vals$filtered_table1_bis_markers <-  filtered_table1_bis_markers
    
    # Add custom HTML formatting to specific indicators
    filtered_table1_bis_markers <- filtered_table1_bis_markers %>%
      mutate(
        `Indicator` = ifelse(
          `Indicator` %in% c("Total bilateral allocable aid", "as % of screened aid"),
          # List indicators to format
          paste0("<b>", `Indicator`, "</b>"),
          # Bold
          `Indicator`
        ),
        `Indicator` = ifelse(
          `Indicator` %in% c("Total of aid focused on policy objective"),
          # List indicators to format
          paste0("<b>", `Indicator`, "</b>"),
          # Bold
          `Indicator`
        ),
        `Indicator` = ifelse(
          `Indicator` %in% c("Total bilateral non-allocable aid"),
          # List indicators to format
          paste0("<i>", `Indicator`, "</i>"),
          # italicize
          `Indicator`
        )
      )
    
    datatable(
      filtered_table1_bis_markers,
      options = list(pageLength = 25, dom = 't'),
      rownames = FALSE,
      escape = FALSE
    )  # Allow HTML rendering
    
  })
  
  #### Download Table 1 ----------------------------------------------------------------
  
  output$downloadResults_table1_markers <- downloadHandler(
    
    filename = function() {
      paste0(input$donor_name_marker,
             "_",
             input$marker,
             "_main_indicators.xlsx")
    },
    content = function(file) {
      
      filtered_table1_markers_download <- vals$filtered_table1_markers |>
        mutate(across(
          where(is.character) & !any_of(c("Indicator", "Provider")),
          ~ suppressWarnings(ifelse(
            vals$filtered_table1_markers$Indicator == "as % of screened aid",
            .x,
            as.numeric(gsub(" ", "", .x))
          ))
        ))
      
      writexl::write_xlsx(filtered_table1_markers_download, file)
    }
  )
  
  #### Footnote ----------------------------------------------------------------
  
  output$footnote_table1_markers <- renderUI({
    if (input$marker == "gender") {
      tagList(
        p("Note: 'Principal objective' includes activities scored 2 for this policy objective, as well as activities with purpose codes 15170 or 15180, which have gender equality, by definition, as a 'principal objective'."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else if (input$marker == "biodiversity") {
      tagList(
        p("Note: 'Principal objective' includes activities scored 2 for this policy objective, as well as activities with purpose code 41030, which have biodiversity, by definition, as a 'principal objective'."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else {
      tagList(
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    }
  })

  
  
  
  # Sub-section - Table 2 -----------------------------------
  
  #### Text ----------------------------------------------------------------
  
  output$text_content_table2_markers <- renderText({
    content <- paste0(
      "
    <b>Top ten recipients</b>:
    Top ten recipients of ",
      input$marker,
      "-focused aid (USD million (constant ",defl_year," prices))

    "
    )
    vals$text_content_table2_markers <- content
    content
    HTML(paste0("<div class='my-text'>", content, "</div>"))
    
  })
  
  
  output$title_table2_bis_markers <- renderText({
    filtered_names <- dataset_policy_markers_names |>
      filter(marker == input$marker)
    
    content <- paste0("<span style='font-family:Noto Sans; font-size:14px; font-weight:bold; line-height:22px; color:#101D40;'>",        
                      "<b>Top ten recipients of ",filtered_names$lower_case_name_marker,"-focused aid</b><br><sub>",
                      "<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>",
                      " USD million (constant ",defl_year," prices)</span></sub>"
    )
    vals$title_table2_bis_markers <- content
    content
    HTML(paste0("<div class='my-text' style='text-align:center;'>", content, "</div>"))
    
  })
  
  #### Display Table 2 ----------------------------------------------------------------
  
  output$results_table2_markers <- renderDataTable({
    num_vars <- c(
      "Total bilateral allocable aid",
      "Aid focused on policy objective - volume"
    )
    filtered_table2_markers <- dataset_table2_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      rename(Recipient = recipient_name_e, Provider = donor_name_e) |>
      mutate(
        across(
          all_of(num_vars),
          ~ formatC(
            round(as.numeric(gsub(" ", "", .x)), 2),
            format = "f",
            digits = 2,
            big.mark = " "
          )
        ))|>
      select(-c(marker))
    filtered_table2_markers
    vals$filtered_table2_markers <-  filtered_table2_markers
    datatable(
      filtered_table2_markers,
      options = list(pageLength = 25, dom = 't'),
      rownames = FALSE
    )
    
  })
  
  #### Display Table 2 (for Donor profile) ----------------------------------------------------------------
  
  output$results_table2_bis_markers <- renderDataTable({
    num_vars <- c(
      "Total bilateral allocable aid",
      "Aid focused on policy objective - volume"
    )
    filtered_table2_bis_markers <- dataset_table2_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      rename(Recipient = recipient_name_e, Provider = donor_name_e) |>
      mutate(
        across(
          all_of(num_vars),
          ~ formatC(
            round(as.numeric(gsub(" ", "", .x)), 2),
            format = "f",
            digits = 2,
            big.mark = " "
          )
        ))|>
      select(-c(marker, Provider))
    filtered_table2_bis_markers
    vals$filtered_table2_bis_markers <-  filtered_table2_bis_markers
    datatable(
      filtered_table2_bis_markers,
      options = list(pageLength = 25, dom = 't'),
      rownames = FALSE
    )
    
  })
  
  #### Download Table 2 ----------------------------------------------------------------
  
  output$downloadResults_table2_markers <- downloadHandler(
    filename = function() {
      paste0(input$donor_name_marker,
             "_",
             input$marker,
             "_top_ten_recipients.xlsx")
    },
    content = function(file) {
      
      filtered_table2_markers_download <- vals$filtered_table2_markers |>
        mutate(across(
          any_of(c("Total bilateral allocable aid", "Aid focused on policy objective - volume")),
          ~ suppressWarnings(as.numeric(gsub(" ", "", .x)))
        ))
      
      writexl::write_xlsx(filtered_table2_markers_download, file)
    }
  )
  
  #### Footnote ----------------------------------------------------------------
  
  
  output$footnote_chart3_markers <- renderUI({
    if (input$marker == "gender") {
      tagList(
        p("* % of bilateral allocable aid excluding activities not screened against the marker."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else if (input$marker == "biodiversity") {
      tagList(
        p("* % of bilateral allocable aid excluding activities not screened against the marker."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else {
      tagList(
        p("Note: * % of bilateral allocable aid excluding activities not screened against the marker."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    }
  })
  

  
  #### Chart 3 ----------------------------------------------------------------
  
  
  output$plot3_markers <- renderPlotly({ 
    
    filtered_dataset_chart3_markers <- dataset_chart3_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker)
    
    # ── No data guard ──────────────────────────────────────────
    if (nrow(filtered_dataset_chart3_markers) == 0) {
      return(
        plot_ly() |>
          layout(
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(
              list(
                text = paste0("No data available"),
                xref = "paper", yref = "paper",
                x = 0.5, y = 0.5,
                showarrow = FALSE,
                font = list(family = "Noto Sans", size = 14, color = "#586179"),
                align = "center"
              )
            ),
            height = 450
          )
      )
    }
    # ───────────────────────────────────────────────────────────
    
    filename <- paste0(input$donor_name_marker,
                       "_",
                       input$marker,
                       "_top_ten_recipients")
    
    filtered_scale_chart3_markers <- dataset_chart3_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker)|>
      group_by(donor_name_e) |>
      mutate(cumulative_value = cumsum(value)) |>
      ungroup()
    
    max_value <- max(filtered_scale_chart3_markers$cumulative_value, na.rm = TRUE)
    step_size <- case_when(
      max_value > 1000 ~ 1000,
      max_value > 500 ~ 500,
      TRUE ~ 100
    )    
    tickvals <- seq(0, ceiling(max_value / step_size) * step_size, by = step_size)
    ticktext <- format(tickvals, big.mark = " ", scientific = FALSE)
    
    selected_colors1 <- color_mapping1[[input$marker]]
    
    
    plot3_markers <- plot_ly(filtered_dataset_chart3_markers, 
                             x = ~value, 
                             y = ~reorder(recipient_name_e, value), 
                             type = 'bar', 
                             orientation = 'h',
                             marker = list(color = selected_colors1),
                             text = ~format(round(value, 2), big.mark = " "), # Show only the value above the bar
                             hoverinfo = "text", # Display figures on hover
                             hovertext = ~paste0(
                               recipient_name_e, ": ", 
                               format(round(value, 2), big.mark = " "), 
                               " USD million"
                               )
    ) |>
      layout(
        title = paste0(
          "<span style='font-family:Noto Sans; font-size:14px; font-weight:bold; line-height:22px; color:#101D40;'>",        
          "<b>Top ten recipients of ", 
          input$marker, 
          "-focused aid - ",
          input$donor_name_marker, 
          "</b><br><sub>",
          "<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>",
          "USD million (constant ",defl_year," prices)</span></sub>"
        ),
        font = list(family = "Noto Sans", size = 12),
        xaxis = list(
          title = "",
          tickvals=tickvals,
          ticktext=ticktext,
          tickfont = list(family = "Noto Sans", size = 12)
        ),
        yaxis = list(
          title = "",
          tickfont = list(family = "Noto Sans", size = 12)
        ),
        legend = list(
          x = 0.3,            
          y = -0.1,
          tickfont = list(family = "Noto Sans", size = 12)
        ),
        margin = list(l = 50, 
                      r = 50, 
                      t = 150, 
                      b = 50),
        showlegend = FALSE,
        height = 600, 
        width = 800)
    
    vals$plot3_markers <- plot3_markers
    print(plot3_markers)
    class(plot3_markers)
    
    # Configure mode bar options
    config(
      plot3_markers,
      toImageButtonOptions = list(filename = filename),
      modeBarButtonsToRemove = c("zoom2d", "pan2d", "select2d", "lasso2d", 
                                 "zoomIn2d", "zoomOut2d", "resetScale2d"),
      displaylogo = FALSE # Remove Plotly logo
    )
    
  })
  
  # Sub-section - Chart 1 (stacked horizontal bar chart) -----------------------------------
  
  #### Display Chart 1  -----------------------------------
  
  output$plot1_markers <- renderPlotly({
    filtered_data <- reactive({
      dataset_chart1_markers |>
        filter(donor_name_e == input$donor_name_marker,
               marker == input$marker)|>
        arrange(order)
    })
    
    # ── No data guard ──────────────────────────────────────────
    if (nrow(filtered_data()) == 0) {
      return(
        plot_ly() |>
          layout(
            title = list(text = ""),
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(
              list(
                text = paste0("No data available"),
                xref = "paper", yref = "paper",
                x = 0.5, y = 0.5,
                showarrow = FALSE,
                font = list(family = "Noto Sans", size = 14, color = "#586179"),
                align = "center"
              )
            ),
            height = 450
          )
      )
    }
    # ───────────────────────────────────────────────────────────
    
    sorted_data <- filtered_data()
    
    filename <- paste0(input$donor_name_marker,
                       "_",
                       input$marker,
                       "_sector_breakdown")
    
    
    filtered_scale_chart1 <- dataset_chart1_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      group_by(donor_name_e) |>
      mutate(cumulative_value = cumsum(value)) |>
      ungroup()
    
    max_value <- max(filtered_scale_chart1$cumulative_value, na.rm = TRUE)
    step_size <- case_when(
      max_value > 10000 ~ 5000,
      max_value > 5000 ~ 1000,
      TRUE ~ 100
    )     
    tickvals <- seq(0, ceiling(max_value / step_size) * step_size, by = step_size)
    ticktext <- format(tickvals, big.mark = " ", scientific = FALSE)
    
    selected_colors3 <- color_mapping4[[input$marker]]
    
    totals_plot1 <- sorted_data |>
      group_by(category) |>
      summarise(total_value = sum(value, na.rm = TRUE)) |>
      ungroup()
    
    plot1_markers <- filtered_data() |>
      plot_ly(
        x = ~ reorder(category, order),
        # Corresponds to x-axis in ggplot
        y = ~ value,
        # Corresponds to y-axis in ggplot
        color = ~ variable,
        # Fill color by variable
        colors = selected_colors3,
        # Custom colors
        type = "bar",         # Bar chart (geom_bar equivalent),
        hoverinfo = "text", # Display figures on hover
        text = ~paste0(variable, ": ", format(round(value,2), big.mark = " "), " USD million"),
        textposition = "none" # Prevent text from appearing on the bars
      ) |>
      add_trace(  
        data = totals_plot1,
        x = ~reorder(category, category),
        y = ~total_value,
        type = "scatter",
        mode = "text",
        text = ~paste0(format(round(total_value,2), big.mark = " ")),
        textposition = "top center",  
        textfont = list(size = 12, color = "black"),
        hoverinfo = "none",
        showlegend = FALSE,
        inherit = FALSE
      ) |>
      layout(
        title = list(
          text = paste0(
            "<span style='font-family:Noto Sans; font-size:14px; font-weight:bold; line-height:22px; color:#101D40;'>",        
            "<b>",
            policy_markers_names[input$marker],
            " focus by sector categories - ",
            input$donor_name_marker
            ," </b><br><sub>",
            "<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>",
            "USD million (constant ",defl_year," prices)</span></sub>"
          ),
          y = 1.1,
          # Push the title higher
          x = 0.5,
          # Center the title
          xanchor = "center",
          yanchor = "top",
          font = list(size = 14)  # Optional: Adjust title font size
        ),
        font = list(family = "Noto Sans", size = 12),
        xaxis = list(title = "",
                     tickfont = list(family = "Noto Sans", size = 12)  
        ),
        # x-axis label (element_blank)
        yaxis = list(title = "",
                     tickvals=tickvals,
                     ticktext=ticktext,
                     tickfont = list(family = "Noto Sans", size = 12)  
        ),
        legend = list(
          orientation = "h",
          # Horizontal legend
          x = 0.5,
          y = -0.3,
          xanchor = "center",
          title = list(text = ""),
          tickfont = list(family = "Noto Sans", size = 12) 
        ),
        barmode = "stack",
        # Stack bars by variable
        margin = list(
          l = 50,
          r = 20,
          t = 80,
          b = 100
        ),
        height = 600,
        width = 800
      )
    
    vals$plot1_markers <- plot1_markers
    print(plot1_markers)
    class(plot1_markers)
    
    
    # Configure mode bar options
    config(
      plot1_markers,
      toImageButtonOptions = list(filename = filename),
      modeBarButtonsToRemove = c("zoom2d", "pan2d", "select2d", "lasso2d", 
                                 "zoomIn2d", "zoomOut2d", "resetScale2d"),
      displaylogo = FALSE # Remove Plotly logo
    )
  })
  
  
  
  #### Display Chart 1 (for Donor profile) -----------------------------------
  
  output$plot1_bis_markers <- renderPlotly({
    filtered_data <- reactive({
      dataset_chart1_markers |>
        filter(donor_name_e == input$donor_name_marker,
               marker == input$marker)
    })
    
    # ── No data guard ──────────────────────────────────────────
    if (nrow(filtered_data()) == 0) {
      return(
        plot_ly() |>
          layout(
            title = list(text = ""),
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(
              list(
                text = paste0("No data available"),
                xref = "paper", yref = "paper",
                x = 0.5, y = 0.5,
                showarrow = FALSE,
                font = list(family = "Noto Sans", size = 14, color = "#586179"),
                align = "center"
              )
            ),
            height = 450
          )
      )
    }
    # ───────────────────────────────────────────────────────────
    
    sorted_data <- filtered_data() 
    
    filename <- paste0(input$donor_name_marker,
                       "_",
                       input$marker,
                       "_sector_breakdown")
    
    filtered_scale_chart1 <- dataset_chart1_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      group_by(donor_name_e) |>
      mutate(cumulative_value = cumsum(value)) |>
      ungroup()
    
    max_value <- max(filtered_scale_chart1$cumulative_value, na.rm = TRUE)
    
    step_size <- case_when(
      max_value > 10000 ~ 5000,
      max_value > 5000 ~ 1000,
      TRUE ~ 100
    )    
    
    tickvals <- seq(0, ceiling(max_value / step_size) * step_size, by = step_size)
    ticktext <- format(tickvals, big.mark = " ", scientific = FALSE)
    
    selected_colors_bis <- color_mapping4[[input$marker]]


    
    plot1_bis_markers <- filtered_data() |>
      plot_ly(
        x = ~ reorder(category, order),
        # Corresponds to x-axis in ggplot
        y = ~ value,
        # Corresponds to y-axis in ggplot
        color = ~ variable,
        # Fill color by variable
        colors = selected_colors_bis,
        # Custom colors
        # colors = c("#353C61", "#6A738F", "#C2D8E6"),  # Custom colors
        type = "bar",         # Bar chart (geom_bar equivalent)
        hoverinfo = "text", # Display figures on hover
        text = ~paste0(variable, ": ", format(round(value,2), big.mark = " "), " USD million"),
        textposition = "none" # Prevent text from appearing on the bars
        
      ) |>
      layout(
        title = list(
          text = paste0(
            "<span style='font-family:Noto Sans; font-size:14px; font-weight:bold; line-height:22px; color:#101D40;'>",        
            "<b>",
            policy_markers_names[input$marker],
            " focus by sector categories </b><br><sub>",
            "<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>",
            "USD million (constant ",defl_year," prices)</span></sub>"
          ),
          y = 0.9,
          # Push the title higher
          x = 0.5,
          # Center the title
          xanchor = "center",
          yanchor = "top",
          font = list(size = 14)  # Optional: Adjust title font size
        ),
        font = list(family = "Noto Sans", size = 12),
        xaxis = list(title = "",
                     tickfont = list(family = "Noto Sans", size = 12)  
        ),
        # x-axis label (element_blank)
        yaxis = list(title = "",
                     tickvals=tickvals,
                     ticktext=ticktext,
                     tickfont = list(family = "Noto Sans", size = 12)  
        ),
        # y-axis label (element_blank)
        legend = list(
          orientation = "h",
          # Horizontal legend
          x = 0.5,
          y = -0.4,
          xanchor = "center",
          title = list(text = ""),
          tickfont = list(family = "Noto Sans", size = 12) 
        ),
        barmode = "stack",
        # Stack bars by variable
        margin = list(
          l = 50,
          r = 20,
          t = 80,
          b = 100
        ),
        height = 450
      )
    
    vals$plot1_bis_markers <- plot1_bis_markers
    print(plot1_bis_markers)
    class(plot1_bis_markers)
    
    # Configure mode bar options
    config(
      plot1_bis_markers,
      toImageButtonOptions = list(filename = filename),
      modeBarButtonsToRemove = c("zoom2d", "pan2d", "select2d", "lasso2d", 
                                 "zoomIn2d", "zoomOut2d", "resetScale2d"),
      displaylogo = FALSE # Remove Plotly logo
    )
  })
  
  #### Display data used in Chart 1 -----------------------------------
  
  output$results_chart1_markers <- renderDataTable({
    num_vars <- c(
      "Not targeted - volume",
      "Aid focused on policy objective - volume",
      "Not screened - volume"
    )
    filtered_chart1_markers <- dataset_chart1_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      select(-c(marker,order)) |>
      pivot_wider(names_from = "variable", values_from = c("value","percent")) |>
      select(Provider = donor_name_e, `Sector category` = category, `Aid focused on policy objective - volume`=`value_Aid focused on policy objective`, `Aid focused on policy objective* - share`=`percent_Aid focused on policy objective`, `Not targeted - volume`=`value_Not targeted`, `Not targeted - share`=`percent_Not targeted`,`Not screened - volume`=`value_Not screened`,`Not screened - share`=`percent_Not screened`)|>
      mutate(
        across(
          all_of(num_vars),
          ~ formatC(
            round(as.numeric(gsub(" ", "", .x)), 2),
            format = "f",
            digits = 2,
            big.mark = " "
          )
        ),
      `Aid focused on policy objective* - share` = paste0(`Aid focused on policy objective* - share`, "%"),
      `Not targeted - share` = paste0(`Not targeted - share`, "%"),
      `Not screened - share` = paste0(`Not screened - share`, "%"),
      )
    
    filtered_chart1_markers
    vals$filtered_chart1_markers <- filtered_chart1_markers
    datatable(
      filtered_chart1_markers,
      options = list(pageLength = 25, dom = 't'),
      rownames = FALSE
    )
    
  })
  
  
  #### Download Chart 1 (data) -----------------------------------
  
  output$downloadResults_chart1_markers <- downloadHandler(
    filename = function() {
      paste0(input$donor_name_marker,
             "_",
             input$marker,
             "_sector_breakdown.xlsx")
    },
    content = function(file) {
      
      filtered_chart1_markers_download <- vals$filtered_chart1_markers |>
        mutate(across(
          where(is.character) & !any_of(c("Aid focused on policy objective* - share","Not targeted - share","Not screened - share", "Provider")),
          ~ suppressWarnings(as.numeric(gsub(" ", "", .x)))
        ))
      
      writexl::write_xlsx(filtered_chart1_markers_download, file)

    }
  )
  
  
  
  #### Footnote -----------------------------------
  

  
  output$footnote_chart1_markers <- renderUI({
    if (input$marker == "gender") {
      tagList(
        p("* % of bilateral allocable aid excluding activities not screened against the marker."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else if (input$marker == "biodiversity") {
      tagList(
        p("* % of bilateral allocable aid excluding activities not screened against the marker."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else {
      tagList(
        p("Note: * % of bilateral allocable aid excluding activities not screened against the marker."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    }
  })
  
  # Sub-section - Chart 2 (stacked bar chart) -----------------------------------
  
  #### Display Chart 2 -----------------------------------
  
  output$plot2_markers <- renderPlotly({
    filtered_dataset <- dataset_chart2_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker)|>
      select(
        donor_name_e,
        two_year,
        variable,
        vx,
        chart_type,
        marker,
        -c(year, base_year, base))
    
    # ── No data guard ──────────────────────────────────────────
    if (nrow(filtered_dataset) == 0) {
      return(
        plot_ly() |>
          layout(
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(
              list(
                text = paste0("No data available"),
                xref = "paper", yref = "paper",
                x = 0.5, y = 0.5,
                showarrow = FALSE,
                font = list(family = "Noto Sans", size = 14, color = "#586179"),
                align = "center"
              )
            ),
            height = 450
          )
      )
    }
    # ───────────────────────────────────────────────────────────
    
    bar_data <- filtered_dataset |> filter(chart_type == "USD")
    line_data <- filtered_dataset |> filter(chart_type == "percent")
    
    #max_primary <- max(bar_data$vx, na.rm = TRUE)
    max_secondary <- max(line_data$vx, na.rm = TRUE)
    
    filtered_scale_chart2 <- dataset_chart2_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      group_by(year) |>
      mutate(cumulative_value = cumsum(vx)) |>
      ungroup()
    
    filtered_names <- dataset_cov |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker)|>
      mutate(donor_name_text=case_when(
        donor_name_e=="All DAC members" ~ "all DAC members",
        TRUE ~ donor_name_text))
    
    filename <- paste0(input$donor_name_marker,
                       "_",
                       input$marker,
                       "_trends_over_time")
    
    max_value <- max(filtered_scale_chart2$cumulative_value, na.rm = TRUE)
    step_size <- case_when(
      max_value > 5000 ~ 5000,
      max_value > 1000 ~ 1000,
      TRUE ~ 100
    )   
    tickvals <- seq(0, ceiling(max_value / step_size) * step_size, by = step_size)
    ticktext <- format(tickvals, big.mark = " ", scientific = FALSE)
    
    selected_colors2 <- color_mapping2[[input$marker]]
    selected_colors1 <- color_mapping1[[input$marker]]
    
    totals_plot2 <- bar_data |>
      group_by(two_year) |>
      summarise(total_value = sum(vx, na.rm = TRUE))
    
    
    # Create the bar chart
    bar_chart <- plot_ly(
      data = bar_data,
      x = ~ two_year,
      y = ~ vx,
      color = ~ variable,
      colors = selected_colors2,
      # colors = c("#353C61", "#C2D8E6"),  # Custom colors
      type = "bar",
      hoverinfo = "text", # Display figures on hover
      text = ~paste0(variable, ": ", format(vx, big.mark = " "), " USD million"),
      textposition = "none" # Prevent text from appearing on the bars
    )|>
      add_trace(
        data = totals_plot2,
        x = ~two_year,
        y = ~total_value,
        type = "scatter",
        mode = "text",
        text = ~paste0(format(total_value, big.mark = " ")),
        textposition = "top center",  
        textfont = list(size = 12, color = "black"),
        hoverinfo = "none",
        showlegend = FALSE,
        inherit = FALSE
      )
    
    
    # Add the line chart to the same plot
    plot2_markers <- bar_chart |>
      add_trace(
        data = line_data,
        x = ~ two_year,
        y = ~ vx,
        type = "scatter",
        mode = "lines+markers",
        # line = list(color = "#69738F", width = 2),
        
        line = list(color = selected_colors1, width = 2),
        name = paste0("", policy_markers_names[input$marker], "-focused aid (% - right axis)"),
        yaxis = "y2",
        hoverinfo = "text", # Display figures on hover
        text = ~paste0(variable, ": ", format(vx, big.mark = " "), "%"),
        textposition = "none" # Prevent text from appearing on the bars
      ) |>
      layout(
        title = paste0(
          "<span style='font-family:Noto Sans; font-size:14px; font-weight:bold; line-height:22px; color:#101D40;'>",        
          "<b>",
          policy_markers_names[input$marker],
          " focus aid of ",
          filtered_names$donor_name_text,
          " </b><br><sub>"
        ),
        font = list(family = "Noto Sans", size = 12),
        xaxis = list(title = "",
                     tickfont = list(family = "Noto Sans", size = 12)),
        # Shared x-axis
        yaxis = list(
          title = paste0("<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>","USD million (constant ",defl_year," prices)"),
          tickformat = ",.0f",
          #range = c(0, max_primary),
          tickvals = tickvals,
          ticktext = ticktext,
          showgrid = TRUE,
          tickfont = list(family = "Noto Sans", size = 12) 
        ),
        # Primary y-axis for bar chart
        yaxis2 = list(
          title = paste0("<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>","% of bilateral allocable screened aid"),
          overlaying = "y",
          side = "right",
          range = c(0, max_secondary + 5),
          tickvals = seq(0, max_secondary, by = 5),
          # Match intervals
          tickformat = ",.0f",
          showgrid = FALSE  ,
          tickfont = list(family = "Noto Sans", size = 12)
        ),
        # Secondary y-axis for line chart
        barmode = "stack",
        # Stacking mode for the bar chart
        legend = list(
          orientation = "h",
          x = 0.5,
          xanchor = "center",
          title = list(text = ""),
          tickfont = list(family = "Noto Sans", size = 12)
        ),
        margin = list(
          l = 50,
          r = 50,
          t = 50,
          b = 50
        ),
        height = 600,
        width = 800
      )
    
    vals$plot2_markers <- plot2_markers
    print(plot2_markers)
    class(plot2_markers)
    
    # Configure mode bar options
    config(
      plot2_markers,
      toImageButtonOptions = list(filename = filename),
      modeBarButtonsToRemove = c("zoom2d", "pan2d", "select2d", "lasso2d", 
                                 "zoomIn2d", "zoomOut2d", "resetScale2d"),
      displaylogo = FALSE # Remove Plotly logo
    )
  })
  
  #### Display Chart 2 (for Donor profile) -----------------------------------
  
  output$plot2_bis_markers <- renderPlotly({
    filtered_dataset <- dataset_chart2_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker)|>
      select(
        donor_name_e,
        two_year,
        variable,
        vx,
        chart_type,
        marker,
        -c(year, base_year, base))
    
    # ── No data guard ──────────────────────────────────────────
    if (nrow(filtered_dataset) == 0) {
      return(
        plot_ly() |>
          layout(
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(
              list(
                text = paste0("No data available"),
                xref = "paper", yref = "paper",
                x = 0.5, y = 0.5,
                showarrow = FALSE,
                font = list(family = "Noto Sans", size = 14, color = "#586179"),
                align = "center"
              )
            ),
            height = 450
          )
      )
    }
    # ───────────────────────────────────────────────────────────
    
    bar_data <- filtered_dataset |>
      filter(chart_type == "USD")
    line_data <- filtered_dataset |>
      filter(chart_type == "percent")
    
    filtered_names <- dataset_cov |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker)|>
      mutate(donor_name_text=case_when(
        donor_name_e=="All DAC members" ~ "all DAC members",
        TRUE ~ donor_name_text))
    
    #max_primary <- max(bar_data$vx, na.rm = TRUE)
    max_secondary <- max(line_data$vx, na.rm = TRUE)
    
    filename <- paste0(input$donor_name_marker,
                       "_",
                       input$marker,
                       "_trends_over_time")
    
    filtered_scale_chart2 <- dataset_chart2_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      group_by(year) |>
      mutate(vx = replace_na(vx, 0),
             cumulative_value = cumsum(vx)) |>
      ungroup()
    
    max_value <- max(filtered_scale_chart2$cumulative_value, na.rm = TRUE)
    step_size <- case_when(
      max_value > 5000 ~ 5000,
      max_value > 1000 ~ 1000,
      TRUE ~ 100
    )     
    tickvals <- seq(0, ceiling(max_value / step_size) * step_size, by = step_size)
    ticktext <- format(tickvals, big.mark = " ", scientific = FALSE)
    
    selected_colors2_bis <- color_mapping2[[input$marker]]
    selected_colors1_bis <- color_mapping1[[input$marker]]
    
    
    # Create the bar chart
    bar_chart <- plot_ly(
      data = bar_data,
      x = ~ two_year,
      y = ~ vx,
      color = ~ variable,
      # colors = c( "#232A52","#C2D8E6"),
      colors = selected_colors2_bis,
      type = "bar",
      hoverinfo = "text", # Display figures on hover
      text = ~paste0(variable, ": ", format(vx, big.mark = " "), " USD million"),
      textposition = "none" # Prevent text from appearing on the bars
    )
    
    # Add the line chart to the same plot
    plot2_bis_markers <- bar_chart |>
      add_trace(
        data = line_data,
        x = ~ two_year,
        y = ~ vx,
        type = "scatter",
        mode = "lines+markers",
        # line = list(color = "#69738F", width = 2),
        line = list(color = selected_colors1_bis, width = 2),
        hoverinfo = "text", # Display figures on hover
        text = ~paste0(variable, ": ", format(vx, big.mark = " "), "%"),
        textposition = "none", # Prevent text from appearing on the bars
        name = paste0("", policy_markers_names[input$marker], "-focused aid* (% - right axis)"),
        yaxis = "y2"
      ) |>
      layout(
        title = list(
          text = paste0(
            "<span style='font-family:Noto Sans; font-size:14px; font-weight:bold; line-height:22px; color:#101D40;'>",        
            "<b>",
            policy_markers_names[input$marker],
            " focus aid of ",
            filtered_names$donor_name_text,
            " </b><br><sub>"
          ),
          font = list(size = 14)
        ),
        font = list(family = "Noto Sans", size = 12),
        xaxis = list(title = "",
                     tickfont = list(family = "Noto Sans", size = 12)),
        # Shared x-axis
        yaxis = list(
          title = paste0("<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>","USD million (constant ",defl_year," prices)"),
          tickformat = ",.0f",
          #range = c(0, max_primary),
          tickvals = tickvals,
          ticktext = ticktext,
          showgrid = TRUE,
          tickfont = list(family = "Noto Sans", size = 12)  
        ),
        # Primary y-axis for bar chart
        yaxis2 = list(
          title = paste0("<span style='font-family:Noto Sans; font-size:13px; font-weight:500; line-height:22px; color:#586179;'>","% of bilateral allocable screened aid"),
          overlaying = "y",
          side = "right",
          range = c(0, max_secondary + 5),
          #tickvals = seq(0, max_secondary, by = 5),  # Match intervals
          tickformat = ",.0f",
          showgrid = FALSE,
          tickfont = list(family = "Noto Sans", size = 12)
        ),
        # Secondary y-axis for line chart
        barmode = "stack",
        # Stacking mode for the bar chart
        legend = list(
          orientation = "h",
          x = 0.5,
          y=-0.2,
          xanchor = "center",
          title = list(text = ""),
          tickfont = list(family = "Noto Sans", size = 12)
        ),
        margin = list(
          l = 50,
          r = 50,
          t = 50,
          b = 50
        )
      )
    
    vals$plot2_bis_markers <- plot2_bis_markers
    print(plot2_bis_markers)
    class(plot2_bis_markers)
    
    # Configure mode bar options
    config(
      plot2_bis_markers,
      toImageButtonOptions = list(filename = filename),
      modeBarButtonsToRemove = c("zoom2d", "pan2d", "select2d", "lasso2d", 
                                 "zoomIn2d", "zoomOut2d", "resetScale2d"),
      displaylogo = FALSE # Remove Plotly logo
    )
  })
  
  #### Display data used in Chart 2 -----------------------------------
  
  output$results_chart2_markers <- renderDataTable({
    filtered_chart2_markers <- dataset_chart2_markers |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker) |>
      select(
        Provider = donor_name_e,
        Period = two_year,
        variable,
        vx,
        -c(year, base_year, base)
      ) |>
      pivot_wider(names_from = "variable", values_from = "vx") |>
      mutate(
        `Aid focused on policy objective as % of screened aid` = paste0(`Aid focused on policy objective as % of screened aid`, "%"),
        `Significant objective` = format(
          `Significant objective`,
          big.mark = " ",
          scientific = FALSE
        ),
        `Principal objective` = format(
          `Principal objective`,
          big.mark = " ",
          scientific = FALSE
        )
      )
    filtered_chart2_markers
    vals$filtered_chart2_markers <- filtered_chart2_markers
    datatable(
      filtered_chart2_markers,
      options = list(pageLength = 25, dom = 't'),
      rownames = FALSE
    )
    
  })
  
  #### Download Chart 2 (data) -----------------------------------
  
  output$downloadResults_chart2_markers <- downloadHandler(
    filename = function() {
      paste0(input$donor_name_marker,
             "_",
             input$marker,
             "_trends_over_time.xlsx")
    },
    content = function(file) {
      
      filtered_chart2_markers_download <- vals$filtered_chart2_markers |>
        mutate(across(
          where(is.character) & !any_of(c("Period", "Provider", "Aid focused on policy objective as % of screened aid")),
          ~ suppressWarnings(as.numeric(gsub(" ", "", .x)))
        ))
      
      writexl::write_xlsx(filtered_chart2_markers_download, file)

    }
  )
  
  
  #### Footnote -----------------------------------
  

  
  output$footnote_chart2_markers <- renderUI({
    if (input$marker == "gender") {
      tagList(
        p("Note: 'Principal objective' includes activities scored 2 for this policy objective, as well as activities with purpose codes 15170 or 15180, which have gender equality, by definition, as a 'principal objective'."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else if (input$marker == "biodiversity") {
      tagList(
        p("Note: 'Principal objective' includes activities scored 2 for this policy objective, as well as activities with purpose code 41030, which have biodiversity, by definition, as a 'principal objective'."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else {
      tagList(
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    }
  })
  
  
  # Sub-section - Summary table -----------------------------------
  
  #### Text ----------------------------------------------------------------
  
  output$text_content_cross_provider_summary_table_markers <- renderUI({
    
    filtered_names <- dataset_policy_markers_names |>
      filter(marker == input$marker)
    
    content <- paste0(
      "
    <b><u><span style='font-size:14px;'>",
      filtered_names$name_marker,
      " 
      </b></u></span> 
    <br>
     "
    )
    # Render the content as HTML
    HTML(paste0("<div class='my-text'>", content, "</div>"))
  })
  
  
  #### Display Tables ----------------------------------------------------------------
  
  output$results_summary_tables_markers <- renderDataTable({
    filtered_summary_tables_markers <- dataset_summary_tables_markers |>
      rename(Provider = donor_name_e) |>
      filter(marker == input$marker) |>
      select(-c(marker))|>
      arrange(Provider)
    filtered_summary_tables_markers
    
    vals$filtered_summary_tables_markers <- filtered_summary_tables_markers
    
    # Add custom HTML formatting to specific indicators
    filtered_summary_tables_markers <- filtered_summary_tables_markers %>%
      mutate(
        Provider = ifelse(
          Provider == input$donor_name_marker,
          paste0("<b><i>", Provider, "</b></i>"),
          Provider
        )
      )
    
    datatable(
      filtered_summary_tables_markers,
      options = list(pageLength = 50, dom = 't'),
      rownames = FALSE,
      escape = FALSE
    )
    
    
  })
  
  #### Download data used in Tables ----------------------------------------------------------------
  
  output$downloadResults_summary_tables_markers <- downloadHandler(
    filename = function() {
      paste0(input$marker,"_summary_table.xlsx")
    },
    content = function(file) {
      
      filtered_summary_tables_markers_download <- vals$filtered_summary_tables_markers |>
        mutate(across(
          where(is.character) & !any_of(c("as % of screened aid", "Provider")),
          ~ suppressWarnings(as.numeric(gsub(" ", "", .x)))
        ))
      
      writexl::write_xlsx(filtered_summary_tables_markers_download, file)
    }
  )
  
  #### Footnote ----------------------------------------------------------------
  
  
  output$footnote_summary_tables_markers <- renderUI({
    if (input$marker == "gender") {
      tagList(
        p("Note: 'Principal objective' includes activities scored 2 for this policy objective, as well as activities with purpose codes 15170 or 15180, which have gender equality, by definition, as a 'principal objective'."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else if (input$marker == "biodiversity") {
      tagList(
        p("Note: 'Principal objective' includes activities scored 2 for this policy objective, as well as activities with purpose code 41030, which have biodiversity, by definition, as a 'principal objective'."),
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    } else {
      tagList(
        p("Sources: ",
          a("OECD (2026)", href = OECD_ODA_web_page, target = "_blank"),
          ", ",
          a("CRS: Creditor Reporting System (flows)", href = CRS_link, target = "_blank")
        )
      )
    }
  })
  
  
  # Sub-section - Methodological notes -----------------------------------
  
  #### Text ----------------------------------------------------------------
  
  output$text_content_dashboard_markers <- renderUI({
    
    content <- paste0(
      " 
    <br><u>Dashboard Overview:</b></u>  
    <br>- <i>Provider Profile</i>:  
    <br>This section offers a comprehensive view of key trends and insights related to a policy marker for a specific ODA provider. For a more detailed analysis, users can explore the following elements in their respective tabs:  
    <br> &nbsp; &nbsp; - <i>Main Indicators</i>: Top-left table from <i>Provider Profile</i>  
    <br> &nbsp; &nbsp; - <i>Trends over time</i>: Top-right chart from <i>Provider Profile</i>  
    <br> &nbsp; &nbsp; - <i>Sector breakdown</i>: Bottom-left chart from <i>Provider Profile</i>  
    <br> &nbsp; &nbsp; - <i>Top ten recipients</i>: Bottom-right table from <i>Provider Profile</i>  
    <br><u>Cross-Provider Summary Table: </u> 
    <br>This table presents the main indicators for all ODA providers related to the selected policy marker, allowing for cross-provider comparisons at a glance.   
    <br><u>Methodological Notes:</u>  
    <br>This section presents the definitions, data sources, and Frequently Asked Questions on policy markers.  
    <br>
      "
    )
    # Render the content as HTML
    HTML(paste0("<div class='my-text'>", content, "</div>"))
  })
  
  output$text_content_methodo_markers <- renderUI({
    filtered_data <- dataset_cov |>
      filter(donor_name_e == input$donor_name_marker,
             marker == input$marker)
    
    filtered_names <- dataset_policy_markers_names |>
      filter(marker == input$marker)
    
    marker_long_text <- marker_texts[[input$marker]]
    
    # Construct the dynamic content string
    content <- paste0(
      "",
      marker_long_text,
      ""
    )
    # Render the content as HTML
    HTML(paste0("<div class='my-text'>", content, "</div>"))
  })
  
  output$text_content_coverage <- renderUI({
    
    content <- paste0(
      " 
    <br>As from 2010 data, the calculation of allocable aid is based on types of aid. The calculation includes the following types of aid: sector budget support, core support to NGOs, support to specific funds managed by international organisations, pooled funding, projects, donor country personnel and other technical assistance, and scholarships in donor country. The term bilateral allocable aid in this publication refers to this methodology.
    <br>
    <br>The <b>coverage ratio</b> refers to the <b>share of allocable activities that has been screened with a marker.</b>
    <br>
    <br><b><i>Coverage Ratio</b> = (Sum of allocable activities marked 0, 1 or 2) / (Sum of all allocable activities)</i>
      "
    )
    # Render the content as HTML
    HTML(paste0("<div class='my-text'>", 
                content, "</div>"))
  })
  
  
  
  
  
  #### Download text -----------------------------------
  
  output$downloadResults_faq <- downloadHandler(
    filename = function() {
      "faq_policy_markers.txt"
    },
    content = function(file) {
      cat(vals$text_content_faq, file = file)
    }
  )
  
  
  
  
  
  
  # Closing Server section --------------------------------------------------
  
  
  
})
#Close Server section


# Display App -----------------------------------------------

shinyApp(ui, server)
