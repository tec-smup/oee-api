module.exports = function(api) {    
    this.redirect = function(req, res, next) {
        res.redirect('/view/index.html');                
    };         
    return this;
};