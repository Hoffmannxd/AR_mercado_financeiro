var cmd = require('node-cmd');

exports.exeCmd = function(str_cmd, j_data, res){
	//montagem do comando para rodar o codigo;
	console.log("exeCmd");
	str_cmd = str_cmd + " "+j_data.end_date + " "+j_data.delta+ " "+j_data.index;
	//console.log(str_cmd);

	//execuçao
	cmd.get(str_cmd , function(err, data, stderr){
		//data contem o output o console
		console.log('the current working dir is : ',data);

		//montagem da resposta json
		var JSON_response = [];
	    for(var i = 0; i < 8; i++) {
	        var JSON_point = new Object();
	        JSON_point.x= i+1;
	        JSON_point.y= i;
	        JSON_response.push(JSON_point);
	    }
	    //console.log(JSON_response);
	    res.writeHead(200, {"Content-Type": "application/json"});
	    res.end(JSON.stringify(JSON_response));


    });
}
