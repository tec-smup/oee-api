const router = require('express').Router();

module.exports = function(api) {
    const _machineController = api.controllers.machine;

    router.post('/', _machineController.post);
    router.post('/update', _machineController.update);
    router.post('/delete', _machineController.delete);
    router.get('/:user/:channel/machine/list', _machineController.list);
    router.get('/:machine/getMax', _machineController.getMax);

    return router;
};