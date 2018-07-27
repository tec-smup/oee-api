module.exports = function(api) {
    let _feedConfig = api.models.feedConfig;
    
    this.list = function(req, res, next) {
        var channelId = req.params.channel;
        
        _feedConfig.list(channelId, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.status(200).send(result[0] || {});
        });                
    }; 

    this.updateConfig = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('channel_id', 'Canal não informado.').notEmpty();
        req.assert('field1', 'Descrição do campo 1 não informado.').notEmpty();
        req.assert('field2', 'Descrição do campo 2 não informado.').notEmpty();
        req.assert('field3', 'Descrição do campo 3 não informado.').notEmpty();
        req.assert('field4', 'Descrição do campo 4 não informado.').notEmpty();
        req.assert('field5', 'Descrição do campo 5 não informado.').notEmpty();
        req.assert('refresh_time', 'Tempo de atualização não informado.').notEmpty();
        req.assert('chart_tooltip_desc', 'Tooltip do gráfico não informado.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _feedConfig.updateConfig(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.status(200).send(bodyData);
        });
    };     

    this.updateSQL = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('channel_id', 'Canal não informado.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _feedConfig.updateSQL(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.status(200).send(bodyData);
        });
    };      
    
    return this;
};