const router = require('express').Router();

module.exports = function(api) {
    const _indexController = api.controllers.index;
    const _machineController = api.controllers.machine;
    const _channelController = api.controllers.channel;
    const _feedController = api.controllers.feed;

    router.get('/', _indexController.redirect);

    //rotas estão aqui somente pra que fiquem transparentes 
    //quando puder, organizar nas rotas originais
    
    //machine
    router.get('/:machine/getMax', _machineController.getMax);
    router.get('/:user/:channel/machine/list', _machineController.list);

    //channel
    router.get('/:channel/get', _channelController.get);
    router.get('/:channel/timeShift', _channelController.timeShift);
    router.get('/:user/channel', _channelController.userChannel);

    //feed
    router.get('/:user/:channel/:machine/:date/:limit/feed/mobile', _feedController.mobile);

    return router;
};