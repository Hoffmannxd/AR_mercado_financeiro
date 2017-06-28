var cmd = require('node-cmd');
var csv = require("fast-csv");
const fs = require('fs');
var filepath = "./../src/data/serieHistorica.csv";

exports.exeCmd = function(str_cmd, j_data, res){
	//montagem do comando para rodar o codigo;
	console.log("exeCmd");
	str_cmd = str_cmd + " "+j_data.end_date + " "+j_data.delta+ " "+j_data.index;
	//console.log(str_cmd);

	//execuçao
	cmd.get(str_cmd , function(err, data, stderr){
		//data contem o output o console
		console.log('Output : ',data);
		console.log("End output");

		//get spark analysis
		var pattern_result = /(\d+\.\d+|\d+)/g;
		var result = data.match(pattern_result);
		var std_desvio = result[0];
		var mdd = result[1];
		var avg = result[2];

		//
		var JSON_response_open = [];
		var JSON_response_close = [];

		var stream = fs.createReadStream(filepath);
    	csv.fromStream(stream, {headers: true})
    		.on("data", function(data) {
	            //console.log(data);
				//console.log(data.Open);
				//console.log(data.Close);
				JSON_response_open.push(parseInt(data.Open));
				JSON_response_close.push(parseInt(data.Close));

        	})
    		.on("end", function(){
				var JSON_response = {};
				JSON_response = new Object();
				JSON_response.open = JSON_response_open;
				JSON_response.close = JSON_response_close;
				JSON_response.desvio = std_desvio;
				JSON_response.avg = avg;
				JSON_response.mdd = mdd;

			    res.writeHead(200, {"Content-Type": "application/json"});
			    res.end(JSON.stringify(JSON_response));
    		});





    });
}
