
# Tidying the WHO malaria report -------------------------------------------


library(tidyr) # required for fill() and pipe function
library(dplyr) # needed for rename() function

clean_number <- function(x) {
  as.numeric(gsub("[^0-9]", "", x))
}
# function for later use - removes non-numeric characters


# Importing the data ------------------------------------------------------

casesdf <-
  read.table(
    "data_cleaning_assignment_190862651.txt",
    sep = "\t",
    header = T,
    na.strings = c("")
  ) %>%
  fill(WHO.region.Country.area) 
# filling in empty values in the countries column
 

# Moving all the years into a single column -------------------------------

casesdf <- pivot_longer(
  data = casesdf,
  cols = c(3:14),
  names_to = "year",
  values_to = "cases"     
)
# corresponding values moved to new column called 'cases'

# Creating new columns from variables in column 'X' ---------------------------

  casesdf <-
    pivot_wider(casesdf, names_from = "X", values_from = "cases")
  


# Renaming columns --------------------------------------------------------


casesdf <-
  casesdf %>% rename_with(tolower, everything())
# make all colnames lowercase


casesdf <-
  casesdf %>% rename(c("location" = "who.region.country.area"))
# rename 'who.region...' column to 'location'


# Changing values with mutate ---------------------------------------------

casesdf <-
  casesdf %>% mutate("location" = gsub("[0-9]", "", location))
casesdf
# removes any numeric characters in the location column


casesdf <- casesdf %>% mutate(across(!location, clean_number))
# removes all non-numeric characters in all columns except location
# converts into numeric factors


casesdf <- casesdf %>% mutate(location = as.factor(location))
# converts region from a character variable to a factor


str(casesdf)
# final check

