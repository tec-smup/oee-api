const router = require('express').Router();

module.exports = function(api) {
    const _userChannelController = api.controllers.userChannel;

    router.post('/', _userChannelController.post);
    router.post('/delete', _userChannelController.delete);

    return router;
};