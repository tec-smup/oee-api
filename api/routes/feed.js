const router = require('express').Router();

module.exports = function(api) {
    const _feedController = api.controllers.feed;

    router.get('/update', _feedController.update);
    router.get('/lastFeed', _feedController.lastFeed);
    router.get('/chart', _feedController.chart);
    router.get('/:user/:channel/:machine/:date/:limit/feed/mobile', _feedController.mobile);

    return router;
};