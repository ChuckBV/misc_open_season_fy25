# script1_read_hmo_dat.R

# Load needed libraries
library(tidyverse)
library(readxl)
library(janitor)

# Exmine files in path
list.files()

# Read hmo data
glimpse(read_excel("2025-hmo-non-postal-rates-fehb.xlsx"))

hmo <- read_excel("2025-hmo-non-postal-rates-fehb.xlsx",
           range = "A3:O1445")

hmo <- clean_names(hmo)

glimpse(hmo)
colnames(hmo)
# [1] "plan"                                  "option"                               
# [3] "enrollment_code"                       "location"                             
# [5] "enrollment_type"                       "x2024_biweekly_total_premium"         
# [7] "x2025_biweekly_total_premium"          "x2025_biweekly_govt_pays"             
# [9] "x2025_biweekly_empl_pays"              "x2025_biweekly_change_in_empl_payment"
# [11] "x2024_monthly_total_premium"           "x2025_monthly_total_premium"          
# [13] "x2025_monthly_govt_pays"               "x2025_monthly_empl_pays"              
# [15] "x2025_monthly_change_in_empl_payment" 

unique(hmo$option)
# [1] "Advantage"       "CDHP"            "Value"           "HDHP"            "High"           
# [6] "Standard"        "Basic"           "Prosper"         "Saver"           "Blue Value Plus"
# [11] "Wellness"       

unique(hmo$location)
# [1] "Alabama"                  "Alaska"                   "Arizona"                 
# [4] "Arkansas"                 "California"               "Colorado"                
# [7] "Connecticut"              "Delaware"                 "District Of Columbia"    
# [10] "Florida"                  "Georgia"                  "Guam"                    
# [13] "Hawaii"                   "Idaho"                    "Illinois"                
# [16] "Indiana"                  "Iowa"                     "Kansas"                  
# [19] "Kentucky"                 "Louisiana"                "Maine"                   
# [22] "Maryland"                 "Massachusetts"            "Michigan"                
# [25] "Minnesota"                "Mississippi"              "Missouri"                
# [28] "Montana"                  "Nebraska"                 "Nevada"                  
# [31] "New Hampshire"            "New Jersey"               "New Mexico"              
# [34] "New York"                 "North Carolina"           "North Dakota"            
# [37] "Northern Mariana Islands" "Ohio"                     "Oklahoma"                
# [40] "Oregon"                   "Palau"                    "Pennsylvania"            
# [43] "Puerto Rico"              "Rhode Island"             "South Carolina"          
# [46] "South Dakota"             "Tennessee"                "Texas"                   
# [49] "Utah"                     "Vermont"                  "Virgin Islands"          
# [52] "Virginia"                 "Washington"               "West Virginia"           
# [55] "Wisconsin"                "Wyoming"    

unique(hmo$enrollment_type)
# [1] "Self"          "Self & Family" "Self Plus One"

hmo <- hmo %>% 
  select(c("plan","option","enrollment_code","location","enrollment_type","x2025_biweekly_empl_pays","x2025_biweekly_change_in_empl_payment")) %>% 
  rename(code = enrollment_code,
         type = enrollment_type,
         employee_biwkly = x2025_biweekly_empl_pays,
         change = x2025_biweekly_change_in_empl_payment) %>% 
  mutate(employee_biwkly = as.numeric(employee_biwkly),
         change = as.numeric(employee_biwkly))
