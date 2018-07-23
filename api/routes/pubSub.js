const router = require('express').Router();

module.exports = function(api) {
    const _pubSubController = api.controllers.pubSub;

    router.post('/push', _pubSubController.post);
    router.get('/', _pubSubController.get);

    return router;
};