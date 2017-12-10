const express = require('express');
const consign = require('consign');

module.exports = function() {
    var app = express(); 

    consign()
        .include('controllers')
        .then('database')
        .into(app);

    return app;
}