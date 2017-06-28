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
app.use("/bootstrap", express.static("./../node_modules/bootstrap/dist/"));

app.post('/ar_mf', function (req, res) {

    //monta a resposta
    controller.exeCmd("bash ./sh_runAnalysis/sh_runAnalysis.sh", req.body, res);

});


app.listen(5000, function () {
    console.log("Server running on 5000 port");
});
