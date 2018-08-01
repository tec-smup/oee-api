const router = require('express').Router();

module.exports = function(api) {
    const _channelController = api.controllers.channel;
    const _tokenController = api.controllers.token;

    //migrado pro index route por enquanto
    //router.get('/:channel/timeShift', _channelController.timeShift);
    //router.get('/:channel/get', _channelController.get);
    //router.get('/:user/channel', _channelController.userChannel);

    router.get('/:channel/delete', _tokenController.verify, _channelController.deleteFeeds); 
    router.post('/', _tokenController.verify, _channelController.post);
    router.post('/machine', _tokenController.verify, _channelController.addMachine);
    router.post('/update', _tokenController.verify, _channelController.update);
    router.post('/delete', _tokenController.verify, _channelController.delete);
    router.post('/delete/machine', _tokenController.verify, _channelController.deleteMachine);
    router.get('/all', _tokenController.verify, _channelController.listAll);

    return router;
};