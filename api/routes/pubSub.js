const router = require('express').Router();

module.exports = function(api) {
    const _pubSubController = api.controllers.pubSub;
    const _tokenController = api.controllers.token;

    router.post('/push', _tokenController.verify, _pubSubController.post);
    router.get('/', _tokenController.verify, _pubSubController.get);

    return router;
};