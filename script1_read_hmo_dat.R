# script1_read_hmo_dat.R

# Load needed libraries
library(tidyverse)
library(readxl)
library(janitor)

### Identify structure of spreadsheet, get the table into a data frame,
### and adjust messy names and useless file formats

# Read hmo data
hmo <- read_excel("2025-hmo-non-postal-rates-fehb.xlsx",
           range = "A3:O1445")

# Make names manageable
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

# Identify valuues for key variables
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

# Make into a small managemeble data frame with appropriate data types
hmo2 <- hmo %>% 
  select(c("plan","option","enrollment_code","location","enrollment_type","x2025_biweekly_empl_pays","x2025_biweekly_change_in_empl_payment")) %>% 
  rename(code = enrollment_code,
         type = enrollment_type,
         employee_biwkly = x2025_biweekly_empl_pays,
         change = x2025_biweekly_change_in_empl_payment) %>% 
  mutate(employee_biwkly = as.numeric(employee_biwkly),
         change = as.numeric(change))

#### Pull out records of use to me
cal_hmo <- hmo2 %>%  
  filter(location == "California")           # Reduces from 1442 to 63 records

unique(cal_hmo$plan)
# [1] "Aetna Advantage"                            "Aetna Direct"                              
# [3] "Aetna HealthFund CDHP and Aetna Value Plan" "Aetna HealthFund HDHP"                     
# [5] "Aetna Open Access"                          "Anthem Blue Cross Select HMO"              
# [7] "Health Net of California"                   "Kaiser Permanente - Fresno California"     
# [9] "Kaiser Permanente - Northern California"    "Kaiser Permanente - Southern California"   
# [11] "Sharp Health Plan"                          "Western Health Advantage"   

cal_hmo %>% 
  filter(str_detect(plan,"Aetna") | str_detect(plan,"Fresno"),
         type == "Self & Family") %>% 
  select(-c("location","type"))
# # A tibble: 8 × 5
#   plan                                       option    code  employee_biwkly change
#   <chr>                                      <chr>     <chr>           <dbl>  <dbl>
# 1 Aetna Advantage                            Advantage Z25              141. -11.8 
# 2 Aetna Direct                               CDHP      N62              194.   6.67
# 3 Aetna HealthFund CDHP and Aetna Value Plan Value     JS5              706. 119.  
# 4 Aetna HealthFund CDHP and Aetna Value Plan CDHP      JS2              762.  31.3 
# 5 Aetna HealthFund HDHP                      HDHP      225              241.  11.4 
# 6 Aetna Open Access                          High      2X2              771. 100.  
# 7 Kaiser Permanente - Fresno California      Standard  NZ5              199.  26.4 
# 8 Kaiser Permanente - Fresno California      High      NZ2              341.  71.6 
