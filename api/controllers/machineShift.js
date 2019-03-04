module.exports = function(api) {
    let _machineShift = api.models.machineShift;
    
    this.list = function(req, res, next) {
        var params = req.params;
        _machineShift.list(params, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.status(200).send(result);
        });                
    }; 

    return this;
};