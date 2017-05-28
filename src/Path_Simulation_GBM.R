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
