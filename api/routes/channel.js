const router = require('express').Router();

module.exports = function(api) {
    const _channelController = api.controllers.channel;

    //migrado pro index route por enquanto
    //router.get('/:channel/timeShift', _channelController.timeShift);
    //router.get('/:channel/get', _channelController.get);
    //router.get('/:user/channel', _channelController.userChannel);

    router.get('/:channel/delete', _channelController.deleteFeeds); 
    router.post('/', _channelController.post);
    router.post('/machine', _channelController.addMachine);
    router.post('/update', _channelController.update);
    router.post('/delete', _channelController.delete);
    router.post('/delete/machine', _channelController.deleteMachine);
    router.get('/all', _channelController.listAll);

    return router;
};