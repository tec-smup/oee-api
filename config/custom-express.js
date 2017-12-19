const express = require('express');
const bodyParser = require('body-parser');
const consign = require('consign');
const expressValidator = require('express-validator');

module.exports = function() {
    var app = express(); 
    app.use(expressValidator());

    app.use(bodyParser.urlencoded({
        extended: true
    }));    

    consign()
        .include('controllers')
        .then('database')
        .into(app);

    return app;
}