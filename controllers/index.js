const path = require('path');

module.exports = function(app) {
	const baseUrl = app.get('BASE_URL');
	
    app.get('/', function(req, res) {
        res.sendFile(path.join(__dirname, '../public/', 'index.html'));
    });
    app.get(baseUrl, function(req, res) {
        res.sendFile(path.join(__dirname, '../public/', 'index.html'));
    });    
}