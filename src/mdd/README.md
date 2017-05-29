## Como criar arquivos
Para criar arquivos .scala use a pasta src/main/scala

## Como compilar
Nao mexa na estrutura de arquivos, isso vai atrapalhar o build do sbt
* Para "compilar"
	sbt package

* Para executar 
	spark-submit --class "mddApp" --master local[4] target/scala-2.11/simple-project_2.11-1.0.jar

Note que é necessário adicionar o spark as variaveis de ambiente ou ir até o diretório bin do mesmo


