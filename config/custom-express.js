const express = require('express');
const bodyParser = require('body-parser');
const consign = require('consign');
const expressValidator = require('express-validator');

const baseUrl = process.env.BASE_URL || '/oee/api/';
const jwtSecret = process.env.JWT_SECRET || '';
const env = process.env.NODE_ENV || 'dev';
const pubsub_verification_token = process.env.PUBSUB_VERIFICATION_TOKEN || '';
const pubsub_topic = process.env.PUBSUB_TOPIC || '';
const corsUrl = process.env.CORS_URL || 'http://localhost:4200';

module.exports = function() {
    var app = express(); 
    var router = express.Router();
    app.set('JWT_SECRET', jwtSecret);
	app.set('BASE_URL', baseUrl);
    app.set('PUBSUB_VERIFICATION_TOKEN', pubsub_verification_token);
    app.set('PUBSUB_TOPIC', pubsub_topic);
    app.use(expressValidator());

    app.use(bodyParser.urlencoded({
        extended: true
    }));    
    app.use(bodyParser.json());

    //rota middleware para validar o token em qualquer requisição
    router.use(function (req, res, next) {
        if(req.originalUrl.indexOf("authentication") == -1)
            console.log('Time:', Date.now());
        next();
    });    
    app.use('/api', router);

    //habilita cors
    app.use(function(req, res, next) {
        res.header("Access-Control-Allow-Origin", corsUrl);
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
    });

    consign()
        .include('database')
        .then('controllers')
        .into(app);

    return app;
}