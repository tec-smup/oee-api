const router = require('express').Router();

module.exports = function(api) {
    const _machineShiftController = api.controllers.machineShift;
    const _tokenController = api.controllers.token;

    router.get('/list/:machineCode', _tokenController.verify, _machineShiftController.list);

    return router;
};