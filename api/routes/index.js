const router = require('express').Router();

module.exports = function(api) {
    const _indexController = api.controllers.index;
    const _machineController = api.controllers.machine;
    const _channelController = api.controllers.channel;
    const _feedController = api.controllers.feed;
    const _tokenController = api.controllers.token;

    router.get('/', _indexController.redirect);

    //rotas estão aqui somente pra que fiquem transparentes 
    //quando puder, organizar nas rotas originais
    
    //machine
    router.get('/:machine/getMax', _machineController.getMax); //n jwt
    router.get('/:user/:channel/machine/list', _tokenController.verify, _machineController.list);

    //channel
    router.get('/:channel/get', _tokenController.verify, _channelController.get);
    router.get('/:channel/timeShift', _channelController.timeShift); //n jwt
    router.get('/:user/channel', _tokenController.verify, _channelController.userChannel);

    //feed
    router.get('/:user/:channel/:machine/:date/:limit/feed/mobile', _tokenController.verify, _feedController.mobile);

    return router;
};