function feed(connection) {
    this._connection = connection;
}

feed.prototype.autenticateToken = function(token, callback) {
    this._connection.query("select id, time_shift from channel where token = ?", token, callback);
}

feed.prototype.save = function(data, callback) {
    this._connection.query("insert into feed set ?", data, callback);
}

feed.prototype.update = function(data, callback) {
    this._connection.query("update feed set field1 = ?, field2 = ?, field3 = ?, field4 = ?, field5 = ? where id = ?"
        , [data.field1, data.field2, data.field3, data.field4, data.field5, data.id], callback);
}

feed.prototype.lastFeed = function(data, callback) {
    let sql = `
        select c.name as channel_name
            , md.code as machine_code
            , md.name as machine_name
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
        from feed f
        inner join channel c on c.id = f.ch_id
        inner join machine_data md on md.code = f.mc_cd
        inner join feed_config fc on fc.channel_id = c.id
        where date_format(f.inserted_at, '%d/%m/%Y') = ?
        order by f.inserted_at desc
        limit 100
    `;
    this._connection.query(sql, [data.date], callback);
}

feed.prototype.chart = function(data, callback) {
    let sql = `
        select date_format(f.inserted_at, '%H:%i:%s') as time  
            , case f.field4 when 0
                then 0 
            else 
                round(((f.field2 / f.field4)*100),2) 
            end as oee            
        from feed f
        inner join channel c on c.id = f.ch_id
        inner join machine_data md on md.code = f.mc_cd
        inner join feed_config fc on fc.channel_id = c.id
        where date_format(f.inserted_at, '%d/%m/%Y %H:%i') between ? and ?
        and ch_id = ?
        and mc_cd = ?
        order by f.inserted_at
    `;
    this._connection.query(sql, [
            data.date_ini, 
            data.date_fin, 
            data.ch_id, 
            data.mc_cd
        ]
        , callback);
}

module.exports = function() {
    return feed;
};