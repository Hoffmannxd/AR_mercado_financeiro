var cmd = require('node-cmd');

exports.exeCmd = function(str_cmd){
	console.log(str_cmd);
	cmd.get(str_cmd , function(err, data, stderr){
        		console.log('the current working dir is : ',data);
        	}
    	);
}
