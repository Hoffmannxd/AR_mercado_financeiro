#Versao do R > 3.4.0, intalar pacote "quantmod" com install.packages("quantmod")
#Yahoo mudou alguns diretorios, instalar: devtools::install_github("joshuaulrich/quantmod", ref="157_yahoo_502") para alterar "quantmod"
#Pra funcionar, precisa do Rtools, analisar o erro que tem o link pra download

require(quantmod)
#Selecao do per�odo de an�lise
startDate = as.Date("2017-05-01") #ser� passado pelo usu�rio
endDate = as.Date("2017-05-28") #idem

#Selecao dos ativos
tickers <- c("GOOG","PETR4.SA","^BVSP")#idem

#Download dos dados do per�odo
getSymbols(tickers, src = "yahoo", from = startDate, to = endDate)
write.table(BVSP,file="serieHistorica.txt",sep=",")#escrever em um documento

