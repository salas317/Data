##' @title Practica retornos y portafolios manuales
##' @description
##' Uso de lenguaje R para calcular los retornos de un activo y algunas formas de calcular el riesgo.

if (!require("rstudioapi")) install.packages("rstudioapi")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, EnvStats, ggpubr, psych, quantmod, TTR, 
               purrr, PerformanceAnalytics, highcharter, timetk, readxl, xts, writexl)
options(scipen = 999)

# 1. Carga de los precios ----

## 1.1. Descarga de los precios desde yahoo ----

# SPDR S&P 500 ETF (SPY)
# iShares MSCI EAFE ETF (EFA)
# iShares S&P Small-Cap 600 Value ETF (IJS)
# iShares MSCI Emerging Markets ETF (EEM)
# iShares Core U.S. Aggregate Bond ETF (AGG)

symbols <- c("SPY","EFA", "IJS", "EEM","AGG")

precios <- quantmod::getSymbols(symbols, src = 'yahoo',
                                from = "2014-12-31",
                                #to = "2025-08-31",
                                periodicity = "daily",
                                auto.assign = TRUE,
                                warnings = FALSE) %>% 
    purrr::map(~quantmod::Ad(get(.))) %>% 
    purrr::reduce(merge.xts) %>% 
    `colnames<-`(symbols)

# Exportar a excel

precios_xls <- precios %>% data.frame() %>% 
    mutate(date = index(precios), .before = 1) %>% 
    `rownames<-`(NULL) 

write_xlsx(precios_xls, "Data/datos.xlsx")

# Exportar a csv

write_csv(x = precios_xls, file = "Data/datos.csv")
