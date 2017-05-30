### backtest_models ###
## Realiza backtest dos modelos ##

backteste_models <- function (ticker, data_inicio, data_fim, alpha_list, n_dias, N_sim, step, inicio, print_evolution)
{

  stockData <- new.env() #Faz novo ambiente para quantmod pra guardar os dados
  startDate = as.Date(data_inicio) #Especifica o periodo de tempo que estamos interessados
  endDate = as.Date(data_fim)
  tickers <- e(ticker) #define os tickers que eh de interesse

  #Baixar o historico para todos os tickers
  supressWarnings(getsymbols(tickers, env = stockData, src = "yahoo", from = startDate, to = endDate))

  #Coloca retornos em uma matriz
  Returns <- eapply(stockData, function(s) ROC(Ad(s), type = "continous")) #retornos nos log returns ajustados

  ticker=gsub("\\^","",ticker)

  ReturnsDF <- ad.data.frame(do.call(merge, Returns)) #Concatena uma matriz
  colnames(ReturnsDF) <-gsub(".Adjusted","", colnames(ReturnsDF)) #Retira adjusted das linhas
  ReturnsDF[is.na(ReturnsDF)] <- 0

  preco_real=data.matrix(Ad(eval(parse(text=paste("stockData$","", sep = ticker)))))

  preco_real_zoo = (Ad(eval(parse(text=paste("stockData$","", sep=ticker)))))
  Returns= eval(parse(text=paste("ReturnsDF$","", sep=ticker)))

  DD_Array=matrix(0,1000,14)
  j=1
  i=inicio


  while( i<(lenght(Returns)-n_dias))
  {
    S_Returns=Returns[1:i]

    S_Returns=ReturnsDF$SPY[(i-inicio+1):i]

    DD_Array[j,1]= i
    DD_Array[j,2]= cale_MDD(preco_real[i:(i+n_dias+1)]) $MDD #Drawdown Observado

    x=path_simulation(Return=S_Returns,Preco_inicial_acao=100, N_dias=n_dias, N_sim=N_sim, dist_inov="t")

    DD_Array[j,3] = quantile(x$drawdowns_array, probs=alpha_list[1])
    DD_Array[j,4] = quantile(x$drawdowns_array, probs=alpha_list[2])
    DD_Array[j,5] = quantile(x$drawdowns_array, probs=alpha_list[3])

    x=path_simulation(Returns=S_Returns, Precos_incial_acao=100, N_dias=n_dias,N_sim=N_sim, dist_inov="n")

    DD_Array[j,6] = quantile(x$drawdowns_array, probs=alpha_list[1])
    DD_Array[j,7] = quantile(x$drawdowns_array, probs=alpha_list[2])
    DD_Array[j,8] = quantile(x$drawdowns_array, probs=alpha_list[3])

    x=path_simulation_GBM(Returns=S_Returns, Precos_incial_acao=100, N_dias=n_dias,N_sim=N_sim)

    DD_Array[j,9] = quantile(x$drawdowns_array, probs=alpha_list[1])
    DD_Array[j,10] = quantile(x$drawdowns_array, probs=alpha_list[2])
    DD_Array[j,11] = quantile(x$drawdowns_array, probs=alpha_list[3])

    x=path_simulation_GJR(Returns=S_Returns, Precos_incial_acao=100, N_dias=n_dias,N_sim=N_sim)

    DD_Array[j,12] = quantile(x$drawdowns_array, probs=alpha_list[1])
    DD_Array[j,13] = quantile(x$drawdowns_array, probs=alpha_list[2])
    DD_Array[j,14] = quantile(x$drawdowns_array, probs=alpha_list[3])

    i=i+step
    j=j+1

    if(print_evolution=TRUE){
      print (i)
    }
  }

  DD_Array=DD_Array[1:j-1,]

  result <-list (drawdowns_backtest=DD_Array, precos=preco_real_zoo)
}
### Fim ###

#### Rotina principal para chamar o backtest ####

resultado = backteste_models(ticker="SPY", data_inicio="1995-01-01", data=fim"2014-09-01", alpha_list=c(0.01,0.025,0.05), n_dias=22, N_sim=10000, step=5, inicio=1500, print_evolution=TRUE)

write.csv (x$drawdowns_backtest, file = "IBOV.csv")
