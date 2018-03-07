var app = require('./config/custom-express')();
const port = process.env.PORT || 3000;
const env = process.env.NODE_ENV || 'dev';

app.listen(port, function() {
    console.log('listen on:', port, 'env:', env);   
});
