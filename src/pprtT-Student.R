### Funcao para transformar para t-stundet ###

pp.rt <- function (n, df)
{
  sqrt ((df - 2)/df) * rt(n, df)
}

### Fim###
