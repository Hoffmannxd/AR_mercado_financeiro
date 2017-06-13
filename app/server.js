const controller = require("./controller");
const express = require('express');
const app = express();
var path = require("path");

app.use(express.static("public"));

app.post('/ar_mf', function (req, res) {
    req.on('data', function (data) {
            console.log(data.toString());
    });
    controller.exeCmd("pwd");
});







app.listen(3000, function () {
    console.log("Server running on 3000 port");
});
