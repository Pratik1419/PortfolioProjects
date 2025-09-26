
const { render } = require('ejs');
const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const app = express();

app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({extended:true}));  //impotant to remebers
app.use(express.static(__dirname + "/public")); // to accpect the css file into app.js

const connection = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: 'pratik1234',
    database: 'web_app'
});

app.get("/", function (req, res) {
    // Find count of users in DB
    const q = "SELECT COUNT(*) AS count FROM users";
    connection.query(q, function(err, results){
        if(err) throw err;
        const count = results[0].count;
        // var msg = "We have " + results[0].count + " users";
        // res.send(msg);
        res.render("home", {count: count});
    });
    // Respond with that count 
});


// post request.. 
app.post("/register", function (req, res) {
  const person = { email: req.body.email };
  connection.query("INSERT INTO users SET ?", person, function (err, result) {
    console.log(err);
    console.log(result);
    res.redirect("/");
  });
});

app.get("/random_number", function (req, res) {
    var rand_num = Math.floor(Math.random() * 10) + 1;
    res.send("Your lucky number is " + rand_num);
});

app.listen(8080, function () {
    console.log("Server Running on 8080!");
});