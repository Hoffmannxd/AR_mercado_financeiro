### Path_Simulation_GJR ###
### Funcao para simular os caminhos de um ativo com o GJR GARCH ###

path_simulation_GJR <- function (Returns, Preco_inicial_acao, N_dias, N_sim) {

  #Parametros

  Precos=matrix(Preco_inicial_acao, N_dias+1, N_sim)
  Volatilidade=matrix(100,N_dias+1,N_sim)
  Retornos_sim=matrix(0,N_dias, N_sim)
  Drawdown_sim=matrix(0,N_sim, 2)

  #dist_inov t for t-student N for Normal

  spec.gjrGARCH = ugarchspec(variance.model=list (model="gjrGARCH", garchOrder=e
    (1,1)), mean.model=list (armaOrder=e(1,1), include.mean=TRUE), distribution.model="std")

  fit.garch=e(0,0)

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
  result <- list(drawdowns_array=Drawdown_sim[,1]), drawdowns_array_lenght=
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
