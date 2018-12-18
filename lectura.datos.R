## Traduccion a R del tutorial en https://www.dataquest.io/blog/data-science-portfolio-project/
## Bibliotecas
library(purrr)
library(dplyr)
library(magrittr)

## Lectura de datos
files <- c("ap_2010.csv", "class_size.csv", "demographics.csv", 
          "graduation.csv", "hs_directory.csv", "math_test_results.csv", "sat_results.csv")
regexp <- "\\.csv"
nombres <- unlist(strsplit(files, regexp))
        
data = list()
data = lapply(files, read.csv)
names(data) <- nombres

## Explorando los datos
map(data, head)

## Trabajo previo a la unión de datos
# DBN = CSD + SCHOOL_CODE
data[['class_size']]$DBN <- paste0(data[['class_size']]$CSD, data[['class_size']]$SCHOOL.CODE) %>% 
        str_pad(width = 6, pad = '0')

data[['hs_directory']] %<>% rename(DBN = dbn)

## Leyendo datos de encuestas de factores
survey1 <- read.table('masterfile11_gened_final.txt', sep = '\t', header = T, encoding = 'windows-1252')
survey2 <- read.table('masterfile11_d75_final.txt', sep = '\t', header = T, encoding = 'windows-1252')

comun <- intersect(names(survey1), names(survey2))


survey1 %<>% select(comun)
survey2 %<>% select(comun)

survey <- rbind(survey1, survey2) %>% select(dbn:aca_tot_11)
