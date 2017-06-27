#!/usr/bin/env Rscript
#Versão do R > 3.4.0, intalar pacote "quantmod" com install.packages("quantmod")
#Yahoo mudou alguns diretórios, instalar: devtools::install_github("joshuaulrich/quantmod", ref="157_yahoo_502")
#Pra funcionar, precisdo do Rtools, analisar o erro que tem o link pra download

library(quantmod)
library(zoo)
library(TTR)
library(methods)

#Seleção do período de análise via linha de comando
args = commandArgs(trailingOnly=TRUE)
startDate = as.Date(args[1]) #2017-05-01
endDate = as.Date(args[2]) #"2017-05-28"

#Seleção das ações
tickers <- c("^BVSP")

#Download dos dados do período
getSymbols(tickers, src = "yahoo", from = startDate, to = endDate)

#Exportando dados
write.table(BVSP,file="bvspprices.csv",sep=",")


#plota o gráfico
#candleChart(---)
