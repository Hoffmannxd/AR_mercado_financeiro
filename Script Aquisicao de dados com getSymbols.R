#Versão do R > 3.4.0, intalar pacote "quantmod" com install.packages("quantmod")
#Yahoo mudou alguns diretórios, instalar: devtools::install_github("joshuaulrich/quantmod", ref="157_yahoo_502")
#Pra funcionar, precisdo do Rtools, analisar o erro que tem o link pra download

require(quantmod)
#Seleção do período de análise
startDate = as.Date("2017-05-01")
endDate = as.Date("2017-05-28")

#Seleção das ações
tickers <- c("GOOG","PETR4.SA","^BVSP")

#Download dos dados do período
getSymbols(tickers, src = "yahoo", from = startDate, to = endDate)


#Mostra os primeiros 5 registros para as ações da Petrobras
#head(PETR4.SA,5) 
#plota o gráfico
#candleChart(PETR4.SA)
