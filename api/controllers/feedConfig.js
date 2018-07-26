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
    
    return this;
};