import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types._
import org.apache.spark.sql.SQLContext
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.sql

object mddApp {
    def main(args: Array[String]) {

        val path = args(0);

        val df_mdd = readPriceFromCsvData(path);//data frame
        df_mdd.printSchema();

        println(desvPadraoCalc(df_mdd))
        println(mddCalc(df_mdd));
    }

    //receiva data from CSV
    def readPriceFromCsvData(path: String) : DataFrame = {
        val spark = SparkSession.builder().master("local[*]").appName("Mdd app").getOrCreate();
        val esquema = StructType (
                      StructField("Index", IntegerType) ::
                      StructField("Open", IntegerType) ::
                      StructField("High", IntegerType) ::
                      StructField("Low", IntegerType) ::
                      StructField("Close", IntegerType) ::
                      StructField("Volume", IntegerType) ::
                      StructField("Adjusted", IntegerType) :: Nil )

    val df_mdd = spark.sqlContext.read.schema(esquema).format("csv").option("header", "true").option("inferSchema", "true").load(path);

    return (df_mdd);
    }
    //calculo do MDD
    def mddCalc(df: DataFrame) : Integer = {
        val princeDay_max = df.agg(max(df("High"))).first().getInt(0);
        val princeDay_min = df.agg(min(df("Low"))).first().getInt(0);

        return (princeDay_max - princeDay_min);
    }

    def desvPadraoCalc(df: DataFrame) : Double = {

      val stdDev = df.agg(stddev_samp("High")).first.getDouble(0) //desvio padrao
      val avg = df.select(sum("High")/count("High")).first().getDouble(0) //media
      ///val aux = df.select("High" + (avg))

      return (stdDev)
    }
}
