'use strict'

const express = require('express');
const fs = require('fs');
const https = require('https');
const path = require('path');
const mysql = require('mysql')

const app = express();
const port = 8080;

const httpsOptions = {
  cert: fs.readFileSync(path.join(__dirname, 'ssl', 'server_dev.crt')),
  key: fs.readFileSync(path.join(__dirname, 'ssl', 'server_dev.key'))
}

app.post('/register',function(req,res){
    if (req.method == 'POST') {
        var name = '';
        var password = '';
        var email = '';
        var salt = '';

        req.on('data', function (data) {
          var obj = JSON.parse(data);
          name = obj.name;
          password = obj.password;
          email = obj.email;
          salt = obj.salt;
        });

        var connection = mysql.createConnection({
          host: 'localhost',
          user: 'root',
          password: 'Tyler01!',
          database: 'sign_in_dev'
        })

        connection.connect(function(err) {
          if (err)
          console.log(err)
          else{
            console.log('You are now connected...')
            connection.query('INSERT INTO UserInfo (email, password, salt, name) VALUES (?, ?, ?, ?)', [email, password, salt, name], function(err, result) {
              console.log(result)
              console.log(err)
            })
            console.log(name)
            console.log(password)
            console.log(email)
            console.log(salt)
          }
        })

        console.log(req);

        req.on('end', function () {

        });
    }
});

https.createServer(httpsOptions, app)
  .listen(port, function(){
    console.log("Listening at Port 8080")
  })
