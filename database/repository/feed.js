function feed(connection) {
    this._connection = connection;
}

feed.prototype.autenticateToken = function(token, callback) {
    this._connection.query("select id, time_shift from channel where token = ?", token, callback);
}

feed.prototype.save = function(data, callback) {
    this._connection.query(`
        call prc_feed_update(?,?,?,?,?,?,?,@timeShift);
        select @timeShift as timeShift;`, 
    [
        data.token,
        data.mc_cd,
        data.field1,
        data.field2,
        data.field3,
        data.field4,
        data.field5,
    ], callback);    
}

feed.prototype.update = function(data, callback) {
    this._connection.query("update feed set field1 = ?, field2 = ?, field3 = ?, field4 = ?, field5 = ? where id = ?"
        , [data.field1, data.field2, data.field3, data.field4, data.field5, data.id], callback);
}

feed.prototype.lastFeed = function(data, callback) {
    let sql = `
        select c.name as channel_name
            , md.code as machine_code
            , concat('[', md.code, '] ', md.name) as machine_name
            , f.field1
            , f.field2
            , f.field3
            , f.field4
            , f.field5 
            , date_format(f.inserted_at, '%d/%m/%Y %H:%i:%s') as inserted_at   
            , fc.field1 as field1_desc
            , fc.field2 as field2_desc
            , fc.field3 as field3_desc
            , fc.field4 as field4_desc
            , fc.field5 as field5_desc
            , fc.refresh_time
        from feed f
        inner join channel c on c.id = f.ch_id
        inner join machine_data md on md.code = f.mc_cd
        inner join feed_config fc on fc.channel_id = c.id
        where date_format(f.inserted_at, '%d/%m/%Y') = ?
          and f.ch_id = ?
          and f.mc_cd = ?
        order by f.inserted_at desc
        limit 100
    `;
    this._connection.query(sql, [data.date, parseInt(data.ch_id), data.mc_cd], callback);
}

feed.prototype.chart = function(data, callback) {
    let sql = 'call prc_chart(?,?,?,?)';

    this._connection.query(sql, [
            data.date_ini, 
            data.date_fin, 
            parseInt(data.ch_id), 
            data.mc_cd
        ]
        , callback);
}

feed.prototype.mobile = function(user, channelId, machineCode, date, limit, callback) {
    let sql = 'call prc_mobile(?,?,?,?,?)';
    this._connection.query(sql, [
            parseInt(user), 
            date, 
            parseInt(channelId),
            machineCode,
            parseInt(limit),
        ]
        , callback);
}

module.exports = function() {
    return feed;
};