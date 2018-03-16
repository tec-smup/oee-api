const path = require('path');

module.exports = function(app) {
    app.get('/api/docs', function(req, res) {
        res.sendFile(path.join(__dirname, '../public/', 'doc.html'));
    });
}