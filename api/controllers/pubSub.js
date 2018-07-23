const Buffer = require('safe-buffer').Buffer;

// By default, the client will authenticate using the service account file
// specified by the GOOGLE_APPLICATION_CREDENTIALS environment variable and use
// the project specified by the GOOGLE_CLOUD_PROJECT environment variable. See
// https://github.com/GoogleCloudPlatform/google-cloud-node/blob/master/docs/authentication.md
// These environment variables are set automatically on Google App Engine
const PubSub = require('@google-cloud/pubsub');

//instancia do pubsub
const pubsub = PubSub();

//lista das mensagens recebidas
const messages = [];

module.exports = function(api) {

    this.post = function(req, res, next) {
        if (req.query.token !== process.env.PUBSUB_VERIFICATION_TOKEN) {
            res.status(400).send();
            return;
        } 
        //a mensagem vem codificada em base64
        const message = Buffer.from(req.body.message.data, 'base64').toString('utf-8');    
        messages.push(message);    
        res.status(200).send();                   
    }; 

    this.get = function(req, res, next) {
        res.send(messages);                 
    };
    
    return this;
};