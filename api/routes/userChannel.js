const router = require('express').Router();

module.exports = function(api) {
    const _userChannelController = api.controllers.userChannel;
    const _tokenController = api.controllers.token;

    router.post('/', _tokenController.verify, _userChannelController.post);
    router.post('/delete', _tokenController.verify, _userChannelController.delete);

    return router;
};