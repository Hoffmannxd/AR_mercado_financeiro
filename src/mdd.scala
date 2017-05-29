import 
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf


object HelloWorld {
  def main( args: Array[String] ) ={
    println("Hello World!")
    val logFile = "/home/aracy_t/apps/spark-2.1.0/README.md" // Should be some file on your system
    val conf = new SparkConf().setAppName("Simple Application").setMaster("local[2]")
    val sc = new SparkContext(conf)
    val logData = sc.textFile(logFile, 2).cache()
    val numAs = logData.filter(line => line.contains("http")).count()
    val numBs = logData.filter(line => line.contains("b")).count()
    println(s"Lines with a: $numAs, Lines with b: $numBs")
    sc.stop()
  }
}


package bigdata.spark_apps

import org.apache.spark.sql.SparkSession

object Mdd {
  def main( args: Array[String] ) = {
    
    val spark = SparkSession.builder().master("local[2]").appName("Mdd app").getOrCreate()
       
    val path = "/home/aracy_t/projectReps/AR_mercado_financeiro/src/mdd/dummy_data.json";
    val df_mdd = spark.sqlContext.read.json(path);
    
    df_mdd.show();
  
  }
}


	<dependency>
	    <groupId>org.apache.spark</groupId>
	    <artifactId>spark-core_2.10</artifactId>
	    <version>2.1.0</version>
	</dependency>
	<!-- https://mvnrepository.com/artifact/org.apache.spark/spark-sql_2.11 -->
	<dependency>
	    <groupId>org.apache.spark</groupId>
	    <artifactId>spark-sql_2.11</artifactId>
	    <version>2.1.0</version>
	</dependency>
