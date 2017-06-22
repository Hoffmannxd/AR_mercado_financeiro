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
    res.end("bla");
});


app.listen(5000, function () {
    console.log("Server running on 3000 port");
});
