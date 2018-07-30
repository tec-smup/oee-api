const router = require('express').Router();

module.exports = function(api) {
    const _exportExcelController = api.controllers.exportExcel;

    router.get('/chart', _exportExcelController.exportChart);

    return router;
};