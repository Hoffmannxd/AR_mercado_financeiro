const controller = require("./controller");
const express = require('express');
const app = express();
var path = require("path");

app.use(express.static("public"));

app.get('/bla', function (req, res) {
    res.send("Execute analysis");
    controller.exeCmd("pwd");
});






app.listen(3000, function () {
    console.log("Server running on 3000 port");
});
