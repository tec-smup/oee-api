const router = require('express').Router();

module.exports = function(api) {
    const _channelController = api.controllers.channel;

    router.get('/:channel/get', _channelController.get);
    router.get('/:channel/delete', _channelController.deleteFeeds);
    router.get('/:channel/timeShift', _channelController.timeShift);
    router.get('/:user/channel', _channelController.userChannel);
    router.post('/', _channelController.post);
    router.post('/update', _channelController.post);
    router.post('/delete', _channelController.delete);

    return router;
};