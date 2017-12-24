const path = require('path');

module.exports = function(app) {
    app.get('/oee/api/doc', function(req, res) { 
        res.sendFile(path.join(__dirname, '../public/', 'doc.html'));       
    });    
}
