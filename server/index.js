'use strict'

const express = require('express');
const fs = require('fs');
const https = require('https');
const path = require('path');

const app = express();
const port = 8080;

const httpsOptions = {
  cert: fs.readFileSync(path.join(__dirname, 'ssl', 'server_dev.crt')),
  key: fs.readFileSync(path.join(__dirname, 'ssl', 'server_dev.key'))
}

app.post('/RegisterUser',function(req,res){
    if (req.method == 'POST') {
        var jsonString = '';

        req.on('data', function (data) {
            jsonString += data;
        });

        req.on('end', function () {
            console.log(JSON.parse(jsonString));
        });
    }
});

https.createServer(httpsOptions, app)
  .listen(port, function(){
    console.log("Listening at Port 8080")
  })
