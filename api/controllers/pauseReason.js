module.exports = function(api) {
    let _pauseReason = api.models.pauseReason;
    
    this.dropdown = function(req, res, next) {
        var channelId = req.params.channel;
        
        _pauseReason.dropdown(channelId, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.status(200).send(result);
        });                
    }; 

    return this;
};