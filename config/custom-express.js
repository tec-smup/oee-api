const express = require('express');
const consign = require('consign');
const expressValidator = require('express-validator');

module.exports = function() {
    var app = express(); 
    app.use(expressValidator());

    consign()
        .include('controllers')
        .then('database')
        .into(app);

    return app;
}