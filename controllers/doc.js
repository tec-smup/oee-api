const path = require('path');

module.exports = function(app) {
	const baseUrl = app.get('BASE_URL');
	
    app.get(baseUrl + 'docs', function(req, res) {
        res.sendFile(path.join(__dirname, '../public/', 'doc.html'));
    });
}