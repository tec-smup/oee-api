const api = require('./autoload')();
const port = process.env.PORT || 3000;
const env = process.env.NODE_ENV || 'dev';

//routes
//ex local: /oee/api/
//ex google: /api/ ou /
const index_route = process.env.BASE_URL; 
const auth_route = `${process.env.BASE_URL}auth`; 
const machine_route = `${process.env.BASE_URL}machine`;
const channel_route = `${process.env.BASE_URL}channel`;
const feed_route = `${process.env.BASE_URL}feed`;
const machinePause_route = `${process.env.BASE_URL}machinepause`;
const user_route = `${process.env.BASE_URL}user`;
const userChannel_route = `${process.env.BASE_URL}userchannel`;
const feedConfig_route = `${process.env.BASE_URL}channelconfig`;
const machineConfig_route = `${process.env.BASE_URL}machineconfig`;
const exportExcel_route = `${process.env.BASE_URL}exportexcel`;
//const yaman_route = process.env.BASE_URL + 'yaman';
const pauseReason_route = `${process.env.BASE_URL}pausereason`;
const machinePauseDash_route = `${process.env.BASE_URL}machinepausedash`;
const mobile_route = `${process.env.BASE_URL}mobile`;
const shift_route = `${process.env.BASE_URL}shift`;
const machineShift_route = `${process.env.BASE_URL}machineshift`;
const sponsor_route = `${process.env.BASE_URL}sponsor`;
const alert_route = `${process.env.BASE_URL}alert`;

//rotas que ouvimos
api.use(index_route, api.routes.index);
api.use(auth_route, api.routes.auth);
api.use(machine_route, api.routes.machine);
api.use(channel_route, api.routes.channel);
api.use(feed_route, api.routes.feed);
api.use(machinePause_route, api.routes.machinePause);
api.use(user_route, api.routes.user);
api.use(userChannel_route, api.routes.userChannel);
api.use(feedConfig_route, api.routes.feedConfig);
api.use(machineConfig_route, api.routes.machineConfig);
api.use(exportExcel_route, api.routes.exportExcel);
//api.use(yaman_route, api.routes.yaman);
api.use(pauseReason_route, api.routes.pauseReason);
api.use(machinePauseDash_route, api.routes.machinePauseDash);
api.use(mobile_route, api.routes.mobile);
api.use(shift_route, api.routes.shift);
api.use(machineShift_route, api.routes.machineShift);
api.use(sponsor_route, api.routes.sponsor);
api.use(alert_route, api.routes.alert);

//rotas não encontradas serão respondidas por essa
api.use((req, res, next) => {
    const error = new Error('Not found');
    error.status = 404;
    next(error);
});

//faz o handle de qualquer erro lançado
api.use((error, req, res, next) => {
    res.status(error.status || 500);
    res.json({
        success: false,
        message: error.message
    });
});

api.listen(port, () => {
    console.log('listen on:', port, 'env:', env);   
});
