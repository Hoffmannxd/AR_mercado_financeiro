import org.apache.spark.sql.SparkSession

object mddApp {
    def main(args: Array[String]) {
        val spark = SparkSession.builder().master("local[*]").appName("Mdd app").getOrCreate()
        val path = "/home/aracy_t/projectReps/AR_mercado_financeiro/src/dummy_data.json";
        val df_mdd = spark.sqlContext.read.json(path);

        df_mdd.show();
  }
}
