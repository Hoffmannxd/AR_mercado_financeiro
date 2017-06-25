const controller = require("./controller");
const express = require('express');
var path = require("path");
var bodyParser = require('body-parser');

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(express.static("public"));

app.use("/chart", express.static("./../node_modules/chart.js/dist/"));
app.use("/jquery", express.static("./../node_modules/jquery/dist/"));

app.post('/ar_mf', function (req, res) {

    //values sended from client forms
    console.log(req.body);

    //executa script shell e recebe o valor
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


app.listen(5000, function () {
    console.log("Server running on 5000 port");
});
