module.exports = function(api) {
    let _pool = api.database.connection; 
    
    this.save = function(data, callback) {    
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_machine_pause(?,?,?,?)", 
            [
                data.mc_cd,
                data.pause,
                data.date_ref,
                data.justification
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });     
    };
    
    // this.list = function(data, callback) {
    //     var query = `
    //         select f.mc_cd
    //             , concat(f.mc_cd, ' - ', md.name) as mc_name 
    //             , (max(f.field4 - f.field2) - (select coalesce(sum(pause), 0) 
    //                                             from machine_pause 
    //                                             where mc_cd = f.mc_cd
    //                                             and date_ref = date(max(f.inserted_at)))) as pause
    //             , time_format(
    //                 sec_to_time(
    //                     (max(f.field4 - f.field2)*60) - (select coalesce(sum(pause)*60, 0) 
    //                                                         from machine_pause 
    //                                                     where mc_cd = f.mc_cd
    //                                                         and date_ref = date(max(f.inserted_at)))
    //                 ), '%H:%i:%s'
    //             ) as pause_to_time
    //             , date_format(max(inserted_at), '%d/%m/%Y %H:%i:%s') as date
    //             , date_format(max(inserted_at), '%d/%m/%Y') as date_ref
    //             , null as justification
    //         from feed	f
    //         inner join machine_data md on md.code = f.mc_cd
    //         inner join channel_machine cm on cm.machine_code = md.code
    //         inner join user_channel uc on uc.channel_id = cm.channel_id
    //         where date_format(f.inserted_at, '%d/%m/%Y') = ?
    //           and uc.user_id = ? 
    //         group by f.mc_cd
    //     `;  
    //     _pool.getConnection(function(err, connection) {
    //         connection.query(query, 
    //         [
    //             data.dateIni, 
    //             parseInt(data.userId)
    //         ], 
    //         function(error, result) {
    //             connection.release();
    //             callback(error, result);
    //         });
    //     });
    // };
    
    this.listPauses = function(data, callback) {
        var query = `
            select a.date_ref_format
                , a.machine_name
                , time_format(sec_to_time(sum(a.pause)*60), '%H:%i:%s') as pause_time
                , sum(a.pause) as pause_in_minutes
                , a.pause_reason
                , a.pause_type
                , a.type
            from(
                select DATE_FORMAT(mpd.date_ref, "%d/%m/%Y") as date_ref_format
                    , md.name as machine_name		
                    , pr.name as pause_reason    
                    , mpd.pause
                    , pr.type
                    , case pr.type when 'PP' then 'Pausa programada' else 'Pausa não programada' end as pause_type
                from machine_pause_dash mpd
                inner join pause_reason pr on pr.id = mpd.pause_reason_id
                inner join machine_data md on md.code = mpd.machine_code
                where mpd.channel_id = ?
                and mpd.machine_code = ?
                and mpd.date_ref between 
                    (STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')) 
                and (STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s'))
                group by mpd.insert_index 
            ) a
            group by a.date_ref_format, a.machine_name, a.pause_reason
            order by sum(pause);

            select b.machine_code
                , sec_to_time(sum(pp)*60) as pp
                , sec_to_time(sum(pnp)*60) as pnp
                , sec_to_time((sum(pp)+sum(pnp))*60) as total
            from (
            select a.machine_code 
                , case a.type
                    when 'PP' then sum(a.pause)
                    else 0 end as pp
                , case a.type
                    when 'NP' then sum(a.pause)
                    else 0 end as pnp        
            from (       
                select mpd.machine_code
                    , pr.type
                    , mpd.pause 
                from channel c
                inner join channel_machine cm on cm.channel_id = c.id
                left join machine_pause_dash mpd on mpd.channel_id = c.id and mpd.machine_code = cm.machine_code
                left join pause_reason pr on pr.id = mpd.pause_reason_id
                where c.id = ?
                and cm.machine_code = ?
                and mpd.date_ref between 
                        (STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')) 
                    and (STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s'))
                group by mpd.insert_index) a
            group by a.machine_code, a.type) b
            group by b.machine_code;            
        `; 
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                parseInt(data.ch_id),
                data.mc_cd,  
                data.dateIni, 
                data.dateFin,
                parseInt(data.ch_id),
                data.mc_cd,  
                data.dateIni, 
                data.dateFin                
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };

    // this.listPauses = function(data, callback) {
    //     var dateIni = data.dateIni.substring(0, data.dateIni.indexOf(" "));
    //     var dateFin = data.dateFin.substring(0, data.dateFin.indexOf(" "));
    //     var query = `
    //         select mp.id
    //              , mp.mc_cd 
    //              , md.name
    //              , date_format(mp.date_ref, '%d/%m/%Y') as date_ref
    //              , mp.justification
    //              , date_format(mp.inserted_at, '%d/%m/%Y %H:%i:%s') as inserted_at
    //              , time_format(sec_to_time(mp.pause*60), '%H:%i:%s') as pause
    //           from machine_pause mp
    //          inner join machine_data md on md.code = mp.mc_cd
    //          inner join channel_machine cm on cm.machine_code = md.code
    //          inner join user_channel uc on uc.channel_id = cm.channel_id
    //          where mp.date_ref between ? and ?
    //            and uc.user_id = ?
    //          order by mp.mc_cd, mp.inserted_at desc 
    //     `; 
    //     _pool.getConnection(function(err, connection) {
    //         connection.query(query, 
    //         [
    //             dateIni,  
    //             dateFin, 
    //             parseInt(data.userId)
    //         ], 
    //         function(error, result) {
    //             connection.release();
    //             callback(error, result);
    //         });
    //     });
    // };    

    return this;
};