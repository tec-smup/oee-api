module.exports = function(api) {
    let _yaman = api.models.yaman;

    this.get = function(req, res, next) {
        var query = req.query;	

        _yaman.autenticateToken(query.token, function(exception, result) {
            if(exception) {
                return res.status(500).send('Erro interno');
            }
            if(!result[0]) {
                return res.status(401).send('Token inválido');
            }
            
            _yaman.get(function(exception, result) {
                if(exception) {
                    return res.status(400).send('Erro interno');
                }
                res.status(200).send(result);              
            }); 
            
        });                
    };
            
    return this;
};