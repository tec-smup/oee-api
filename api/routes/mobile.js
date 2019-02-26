const router = require('express').Router();

module.exports = function(api) {
    const _mobileController = api.controllers.mobile;
    const _tokenController = api.controllers.token;

    router.get('/chart/gauge/:channelId/:machineCode/:date', _tokenController.verify, _mobileController.chartGauge); 

    return router;
};