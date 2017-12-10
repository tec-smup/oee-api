var app = require('./config/custom-express')();
const port = process.env.PORT || 3000;

app.listen(port, function() {
    console.log('listen on :' + port);
});
