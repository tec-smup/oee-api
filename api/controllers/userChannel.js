module.exports = function(api) {
    let _userChannel = api.models.userChannel; 
    
    this.post = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('userId', 'Usuário não informado.').notEmpty();
        req.assert('channelId', 'Canal não informado.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _userChannel.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }                 
            return res.send(bodyData);
        });                 
    }; 
    
    this.delete = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('userId', 'Usuário não informado.').notEmpty();
        req.assert('channelId', 'Canal não informado.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         

        delete bodyData.token;
        _userChannel.delete(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });
    };

    return this;
};