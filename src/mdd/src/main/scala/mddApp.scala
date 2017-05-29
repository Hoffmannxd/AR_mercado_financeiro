import org.apache.spark.sql.SparkSession

object mddApp {
    def main(args: Array[String]) {
        val spark = SparkSession.builder().master("local[*]").appName("Mdd app").getOrCreate()
        val path = "/home/aracy_t/projectReps/AR_mercado_financeiro/src/data/dummy_data.json";
        val df_mdd = spark.sqlContext.read.json(path);

        df_mdd.show();

        //calc mdd split into functions
        val testList = Array(100.0,102,105,103,99,98,101,95,100,101);
        var dd_atual=0.0;
        var dd_max=0.0;
        var m_cota=0.0;
        var cota=0.0;

        for(p <- testList) {
            cota = p;
            if(cota > m_cota) {
                m_cota = cota;
                //println(m_cota);
            }
            else {
                dd_atual = (cota / (m_cota - 1));

            }

            if (dd_atual < dd_max){
                dd_max = dd_atual;
                println(dd_max);
            }
        }

    }
}
