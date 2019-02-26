module.exports = function(api) {
    let _mobile = api.models.mobile;
    
    this.chartGauge = function(req, res, next) { 
        var params = req.params;

        _mobile.chartGauge(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.status(200).send(result[0] || []);       
        });                 
    };
    
    return this;
};