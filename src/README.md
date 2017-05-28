# Setups to run on scala ide eclipse

## Install scala
Don't really know if is need, try to skip this one, if get any problems install and then go again.

## Install spark 
Go to apache spark page and download spark core version 2.1.0. The instructions to install are on README.md - inside spark-2.1.0 folder.
[Link to apache download page](https://spark.apache.org/downloads.html)

## Install eclipse-scala IDE
Just unzip somewhere and go under bin to find the executable.
[Link to scala IDE page](http://scala-ide.org/)

# How to manage projects

* Create a maven project - leave all as the deafaults
* Refactor-rename "src/main/java" and "src/text/java" to scala
* Right-click on project root->Configure->AddScalaNature
* Right-click on "Scala-library-container"->Properties then select "Fixed Scala Libray container: 2.10.6"
	You do really need to select this option. Spark works better with this one, you will probrably get a bunch of errors if not select this one
* Right-click on the package under "src/main/scala" then create scala object
* Don'to forget to include the using deps on pom.xml
* That's all folks. Try some dummy code there to make sure everything is ok.


