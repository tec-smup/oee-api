var jwt = require('jsonwebtoken');

module.exports = function(api) {

    this.verify = function(req, res, next) {
        var token = req.headers['x-access-token'];

        if (!token) {
            let error = new Error('Token não informado');
            error.status = 403;
            return next(error);            
        }
          
        jwt.verify(token, process.env.JWT_SECRET, function(err, decoded) {
            if (err) {
                let error = new Error('Falha na autenticação do token. Talvez o token não exista ou já tenha expirado.');
                error.status = 403;
                return next(error);               
            }
            req.userId = decoded.userId;
            next();
        });
    };    
            
    return this;
};