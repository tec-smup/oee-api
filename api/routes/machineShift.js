const router = require('express').Router();

module.exports = function(api) {
    const _machineShiftController = api.controllers.machineShift;
    const _tokenController = api.controllers.token;

    router.get('/list/:machineCode', _tokenController.verify, _machineShiftController.list);
    router.post('/', _tokenController.verify, _machineShiftController.add);
    router.post('/delete', _tokenController.verify, _machineShiftController.delete);
    router.get('/oee/:channelId/:machineCode/:dateIni/:dateFin', _tokenController.verify, _machineShiftController.OEE);
    
    return router;
};