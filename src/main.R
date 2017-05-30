install.packages("timeSeries")
install.packages("PerformanceAnalytics")
install.packages("quantmod")
install.packages("rugarch")
install.packages("tseries")
install.packages("RQuantLib")
install.packages("ggplot2")
install.packages("fExtremes")
install.packages("fGarch")
install.packages("forecast")
install.packages("bayesGARCH")

library(rugarch)
library(graphics)
library(RQuantLib)
library(ggplot2)
library(fExtremes)
library(fGarch)
library(forecast)
library(tseries)
library(timeSeries)
library(quantmod)
library(PerformanceAnalytics)


########## Calculo Maximo Drawdown de uma Serie #########

calc_MDD <- function (precos_array)

{

DD_Atual=0
DD_Maximo=0
Maximo_cota=0

for (i in 1:lenght (precos_array))
{
  cota = precos_array [i]
  if (cota > Maximo_Cota){
    Maximo_Cota = cota
  } else {
    DD_Atual = (cota / Maximo_Cota - 1)
  }

  if (DD_Atual < DD_Maximo){
    DD_Maximo = DD_Atual
  }
}

  result <- list (MDD=DD_Maximo)
  return (result)
}

### Fim ###

### Funcao para transformar para t-stundet ###

pp.rt <- function (n, df)
{
  sqrt ((df - 2)/df) * rt(n, df)
}

### Fim###

### Path_Simulation_GBM ###
##Funcao para simular os caminhos de um ativo com GBM###

path_simulation_GBM <- function (Returns, Preco_inicial_acao, N_dias, N_sim){

  #estimacao dos parametros

  mu <- mean (Returns)
  sigma <- stdev (Returns)

  #Parametros
  Precos=matrix(0,N_dias+1,N_sim)
  Returnos_sim=matrix(0,N_dias,N_sim)
  Drawdown_sim=matrix(0,N_sim,2)

  for (i in 1:N_sim)
  {
    Precos[1,i]=Preco_inicial_acao

    for(j in 1:N_dias+1)
    {
      Precos[j,i]=Precos[j-1,i]*exp((mu-(sigma^2)/2)+sigma*rnorm(1))
    }

    Drawdown_sim[i,1]=cale_MDD(Precos[,i])$MDD

  }

  result <-list (drawdowns_array=Drawdown_sim[,1], drawdowns_array_lenght=
    Drawdown_sim[,2], precos_sim=Precos)

    return (result)
}

### Fim ###

### Path Simulation ###
### Simula os caminhosde um ativo###

path_simulation <- function (Returns, Preco_inicial_acao, N_dias, N_Sim, dist_inov)
{
#dist_inov t for t-student for Normal

  fit.arma <- Arima (coredata (Returns), order=c(1,0,1)) #modelo para media
  fit.res <- resid (fit.arma) #residuos do modelo

  if (dist_inov=="t"){
    fit.garch <- garchFit(~garch(1,1), fit.res, cond.dist="std", trace=FALSE)
  } else {
    fit.garch <- garchFit(~garch(1,1), fit.res, trace=FALSE)
  }

  meida_hat_inicio <- forescast.Arima(fit.arma)$mean[1]
  desvio_hat_inicio <- prediet (fit.garch, n.ahead=1)[["standartDeviation"]]

  n_ativos=1

  GARCH_Parameters=matrix(0,n_ativos, 6)

  GARCH_Parameters[1,2]=coef(fit.garch)[["omega"]]
  GARCH_Parameters[1,3]=coef(fit.garch)[["alpha1"]]
  GARCH_Parameters[1,4]=coef(fit.garch)[["beta1"]]
  GARCH_Parameters[1,6]=desvio_hat_inicio

  mu=GARCH_Parameters[1,1]
  alpha_0=GARCH_Parameters[1,2]
  alpha_1=GARCH_Parameters[1,3]
  beta_1=GARCH_Parameters[1,4]

  if(dist_inov=="t"){
    df <- coef(fit.garch)[["shape"]]
  }


#Parametros

  Precos=matrix(Preco_inicial_acao, N_dias+1, N_sim)
  Volatilidade=matrix(100,N_dias+1,N_sim)
  Retornos_sim=matrix(0,N_dias,N_sim)
  Drawdown_sim=matrix(0,N_sim,2)

  Volatilidade[1,] = desvio_hat_inicio*sqrt(252)*100

  for(i in 1:N_sim)
  {
    desvio_hat=desvio_hat_inicio
    ht_ant=desvio_hat_inicio^2

    media_hat=media_hat_inicio
    price=Preco_inicial_acao

      for (j in 1:N_dias)
      {
        if(dist_inov=="t"){
          inov=pp.rt(1,df)
        } else {
          inov=rnorm(1,0,1)
        }

      simulate_return=inov*desvio_hat+media_hat

      ht_alpha_0+((simulate_return-media_hat)^2)*alpha_1 + ht_ant*beta_1

      desvio_hat=sqrt(ht)
      ht_ant=ht

      price=price*exp(simulate_return)

      Precos[j+1,i]=price

      Volatilidade [j+1,i]=round(desvio_hat*sqrt(252)*100,2)
      Retornos_sim[j,i]=round(simulate_return*100,2)

      }

    Drawdown_sim[i,1]=cale_MDD(Precos[,i])$MDD
    }

  result<- list (drawdowns_array=Drawdown_sim[,1],drawdowns_array_lenght=
    Drawdown_sim[,2], precos_sim=Precos, volatilidade_sim=Volatilidade)
  return (result)
  
}

###Fim##

### Path_Simulation_GJR ###
### Funcao para simular os caminhos de um ativo com o GJR GARCH ###

path_simulation_GJR <- function (Returns, Preco_inicial_acao, N_dias, N_sim) {

  #Parametros

  Precos=matrix(Preco_inicial_acao, N_dias+1, N_sim)
  Volatilidade=matrix(100,N_dias+1,N_sim)
  Retornos_sim=matrix(0,N_dias, N_sim)
  Drawdown_sim=matrix(0,N_sim, 2)

  #dist_inov t for t-student N for Normal

  spec.gjrGARCH = ugarchspec(variance.model=list (model="gjrGARCH", garchOrder=c
    (1,1)), mean.model=list (armaOrder=c(1,1), include.mean=TRUE), distribution.model="std")

  fit.garch=c(0,0)

  options(show.error.messages=FALSE)
  try(
    fit.garch <- ugarchfit(Returns2, spec=spec.gjrGARCH)
  )

  if(lenght(fit.garch)>1){
    result <- list(drawdowns_array=Drawdown_sim[,1], drawdowns_array_lenght=
      Drawdown_sim [,2], precos_sim=Precos, volatilidades_sim=Volatilidade)
    return (result)
  }

 options(show.error.messages = TRUE)

 alpha0 = coef(fit.garch)[["omega"]]

 if(is.null(alpha0)){
  result <- list(drawdowns_array=Drawdown_sim[,1], drawdowns_array_lenght=
    Drawdown_sim[,2], precos_sim=Precos, volatilidades_sim=Volatilidade)

  return(result)

 }

 forecast_garch=ugarchforecast(fit.garch,n.ahead=1)

 media_hat_inicio <- fittes (forecast_garch)
 desvio_hat_inicio <- sigma (forecast_garch)

 n_ativos=1

 GARCH_Parameters=matrix(0,n_ativos,6)

 alpha_0=coef(fit.garch)[["omega"]]
 alpha_1=coef(fit.garch)[["alpha1"]]
 beta_1=coef(fit.garch)[["beta1"]]
 gamma=coef(fit.garch)[["gamma1"]]

 df <- coef(fit.garch[["shape"]])


##################################

  Volatilidade [1,] = desvio_hat_inicio*sqrt (252)*100

  for (i in 1:N_dias)
  {

    desvio_hat=desvio_hat_inicio
    ht_ant=desvio_hat_inicio^2

    media_hat=media_hat_inicio
    price = Preco_inicial_acao

    for (j in 1:N_dias)
    {
      inov=pp.rt(1,df)

      simulate_return=inov*desvio_hat +media_hat

      if (simulate_return<0){
      lev_efect=gamma1*(simulate_return-media_hat)^2
      } else {
        lev_efect=0
      }
      ht=alpha_0+((simulate_return-media_hat)^2)*alpha_1 + ht_ant*beta_1+lev_efect

      devio_hat=sqrt(ht)
      ht_ant=ht

      price=price*exp(simulate_return)

      Precos[j+1,i]=price

      Volatilidade[j+1,i]=round(desvio_hat*sqrt(252)*100,2)
      Retornos_sim[j,i]=round(simulate_return*100,2)
    }

    Drawdown_sim[i,1]=cale_MDD(Precos[,i]) $MDD

  }

  result <- list(drawdowns_array=Drawdown_sim[,1], drawdowns_array_lenght= Drawdown_sim[,2], precos_sim=Precos , volatilidade_sim=Volatilidade)

  return ( result )
}
### Fim ###

### backtest_models ###
## Realiza backtest dos modelos ##

backteste_models <- function (ticker, data_inicio, data_fim, alpha_list, n_dias, N_sim, step, inicio, print_evolution)
{

  stockData <- new.env() #Faz novo ambiente para quantmod pra guardar os dados
  startDate = as.Date(data_inicio) #Especifica o periodo de tempo que estamos interessados
  endDate = as.Date(data_fim)
  tickers <- c(ticker) #define os tickers que eh de interesse

  #Baixar o historico para todos os tickers
  suppressWarnings(getSymbols(tickers, env = stockData, src = "yahoo", from = startDate, to = endDate))

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
    DD_Array[j,2]= calc_MDD(preco_real[i:(i+n_dias+1)]) $MDD #Drawdown Observado

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

    if(print_evolution==TRUE){
      print (i)
    }
  }

  DD_Array=DD_Array[1:j-1,]

  result <-list (drawdowns_backtest=DD_Array, precos=preco_real_zoo)
}
### Fim ###

#### Rotina principal para chamar o backtest ####

resultado = backteste_models(ticker="SPY", data_inicio="1995-01-01", data_fim="2014-09-01", alpha_list=c(0.01,0.025,0.05), n_dias=22, N_sim=10000, step=5, inicio=1500, print_evolution=TRUE)

write.csv (x$drawdowns_backtest, file = "IBOV.csv")
