import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions._

object mddApp {
    def main(args: Array[String]) {

        val path = "./../data/serieHistorica.csv";
        val df_mdd = readPriceFromCsvData(path);//data frame
        //df_mdd.printSchema();

        println(mddCalc(df_mdd));
    }

    //receiva data from CSV
    def readPriceFromCsvData(path: String) : DataFrame = {
        val spark = SparkSession.builder().master("local[*]").appName("Mdd app").getOrCreate();
        val df_mdd = spark.sqlContext.read.format("csv").option("header", "true").option("inferSchema", "true").load(path);
        return (df_mdd);
    }

    //calculo do MDD
    def mddCalc(df: DataFrame) : Integer = {
        val princeDay_max = df.agg(max(df("BVSP-High"))).first().getInt(0);
        val princeDay_min = df.agg(min(df("BVSP-Low"))).first().getInt(0);

        return (princeDay_max - princeDay_min);
    }
}
