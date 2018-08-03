const bcrypt = require('bcrypt-nodejs');
const saltRounds = 10;

module.exports = function(api) {
    let _pool = api.database.connection; 

    this.authentication = function(username, callback) {
        let query = `
            select u.id
                 , u.password
              from user u
             where u.username = ?
               and u.active = true
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, username, function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };

    this.getUserData = function(id, callback) {
        let query = `
            select case u.admin when 1 then 1 else 0 end as admin
                 , u.username
                 , c.name as channel_name
                 , c.initial_turn
                 , c.final_turn
                 , u.id
              from user u
              left join user_channel uc on uc.user_id = u.id
              left join channel c on c.id = uc.channel_id
             where u.id = ?
               and u.active = true
             order by c.id
             limit 1
        `;
    
        _pool.getConnection(function(err, connection) {
            connection.query(query, id, function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };    
    
    this.list = function(callback) {
        var query = `
            select u.id
                , u.username
                , u.password
                , case u.active when 1 then 'Ativo' else 'Inativo' end as active
                , case u.admin when 1 then 'Sim' else 'Não' end as admin
                , DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i:%s') as created_at
                , company_name
                , phone
             from user u	
        `; 
        
        _pool.getConnection(function(err, connection) {
            connection.query(query, [], function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.save = function(data, callback) {
        let salt = bcrypt.genSaltSync(saltRounds);
        if(data.isMobile) {
            _pool.getConnection(function(err, connection) {
                connection.query("call prc_user_mobile(?,?,?,?,?,?)", 
                [
                    data.company_name,
                    data.username,
                    bcrypt.hashSync(data.password, salt),
                    data.active,
                    data.admin,
                    data.phone
                ], 
                function(error, result) {
                    connection.release();
                    callback(error, result);
                });
            });
        }
        else {
            _pool.getConnection(function(err, connection) {
                connection.query("set @userId = 0; call prc_user(?,?,?,?,?,?,@userId)", 
                [
                    data.username,
                    bcrypt.hashSync(data.password, salt),
                    data.active,
                    data.admin,
                    data.company_name,
                    data.phone
                ], 
                function(error, result) {
                    connection.release();
                    callback(error, result);
                });
            });
        }
    };
    
    this.changePass = function(data, callback) {
        let salt = bcrypt.genSaltSync(saltRounds);
        
        _pool.getConnection(function(err, connection) {
            connection.query("update user set password = ? where id = ?", 
            [
                bcrypt.hashSync(data.password, salt),
                data.id
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
        
    };

    this.update = function(data, callback) {
        let query = `
            update user set active = ?
                          , admin = ? 	
                          , company_name = ?
                          , phone = ?
                      where id = ?
        `;
        
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.active, 
                data.admin, 
                data.company_name,
                data.phone,
                data.id
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.delete = function(data, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_delete_user(?)", [data.id], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };    

    return this;
};