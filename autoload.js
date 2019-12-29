const express = require('express');
const bodyParser = require('body-parser');
const consign = require('consign');
const expressValidator = require('express-validator');

module.exports = function() {    
    let api = new express();

    api.use(bodyParser.urlencoded({
        extended: true
    }));    
    api.use(bodyParser.json());
    api.use(expressValidator());

    //essa rota escuta por todas e serve para corrigir CORS
    api.use((req, res, next) => {
        res.header("Access-Control-Allow-Origin", process.env.CORS_URL);
        res.header(
            "Access-Control-Allow-Headers",
            "Origin, X-Requested-With, Content-Type, Accept, Authorization, x-access-token"
        );
        //browsers verificam antes através do metodo OPTIONS se é possivel efetuar post na url
        //habilitamos CORS para POST, GET atualmente
        //outras opções: PUT, PATCH, DELETE
        if (req.method === 'OPTIONS') {
            res.header('Access-Control-Allow-Methods', 'POST, GET');
            return res.status(200).json({});
        }
        next();
    });

    //permite acesso aos arquivos teste
    api.use('/view', express.static('public'));

    //autoload das pastas (para poder acessar api.controllers.nomedoarquivo)
    consign({cwd: 'api'})
        .include('database')
        .then('enums')
        .then('models')
        .then('services')
        .then('controllers')
        .then('routes')
        .into(api);

    return api;
}