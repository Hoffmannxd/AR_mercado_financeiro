########## Calculo Maximo Drawdown de uma Serie #########

cale_MDD <- function (precos_array)

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
