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
          inov = rnorm(1,0,1)
        }

      simulate_return=inov*desvio_hat +media_hat

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
