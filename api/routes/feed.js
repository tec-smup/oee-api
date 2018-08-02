const router = require('express').Router();

module.exports = function(api) {
    const _feedController = api.controllers.feed;
    const _tokenController = api.controllers.token;

    router.get('/update', _feedController.update); //n jwt
    router.get('/lastFeed', _tokenController.verify, _feedController.lastFeed);
    router.get('/chart', _tokenController.verify, _feedController.chart);
    //router.get('/:user/:channel/:machine/:date/:limit/feed/mobile', _feedController.mobile);

    return router;
};