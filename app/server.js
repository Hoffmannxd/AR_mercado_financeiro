const controller = require("./controller");
const express = require('express');
const app = express();
var path = require("path");

app.use(express.static("public"));

app.use("/chart", express.static("./../node_modules/chart.js/dist/"));

app.post('/ar_mf', function (req, res) {
    req.on('data', function (data) {
            console.log(data.toString());
    });
    controller.exeCmd("bash ./sh_runAnalysis/sh_runAnalysis.sh");

    //response

    var JSON_response = [];
    for(var i = 0; i < 8; i++) {
        var JSON_point = new Object();
        JSON_point.x= i+1;
        JSON_point.y= i;
        JSON_response.push(JSON_point);
    }

    console.log(JSON_response);
    res.writeHead(200, {"Content-Type": "application/json"});
    res.end(JSON.stringify(JSON_response));
});


app.listen(3000, function () {
    console.log("Server running on 3000 port");
});
