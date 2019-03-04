module.exports = function(api) {
    let _shift = api.models.shift;
    
    this.dropdown = function(req, res, next) {
        _shift.dropdown(function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.status(200).send(result);
        });                
    }; 

    return this;
};