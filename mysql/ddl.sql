create database oee;

use oee;

/*tables*/
create table user
(
    id int not null auto_increment primary key,
    username varchar(100) not null,
    password varchar(500) not null,
    active bit not null default true,
    admin bit not null default false,
	comnpany_name varchar(200) null,
    phone varchar(11) null,
    created_at timestamp not null default CURRENT_TIMESTAMP
);

create table channel 
(
	id int not null auto_increment primary key,
    name varchar(100) not null,
    description varchar(500) null,
    token varchar(50) not null,
    active bit not null default false, 
	created_at timestamp not null default CURRENT_TIMESTAMP,
	updated_at timestamp not null default CURRENT_TIMESTAMP,
    time_shift int null default 0,
	initial_turn char(5) null,
	final_turn char(5) null,
    reset_time_shift bit null,
    wlp_hard_coder int(4)
);

create table channel_machine 
(
	channel_id int not null,
    machine_code varchar(10) not null COLLATE latin1_swedish_ci,
	created_at timestamp not null default CURRENT_TIMESTAMP,
	updated_at timestamp not null default CURRENT_TIMESTAMP,
	primary key(channel_id, machine_code)
	
);
alter table channel_machine add constraint fk_channel_machine_channel foreign key(channel_id) references channel(id);
alter table channel_machine add constraint fk_channel_machine_machine foreign key(machine_code) references machine_data(code);

create table user_channel 
(
	user_id int not null,
	channel_id int not null,
	created_at timestamp not null default CURRENT_TIMESTAMP,
	updated_at timestamp not null default CURRENT_TIMESTAMP,
	primary key(user_id, channel_id)
	
);
alter table user_channel add constraint fk_user_channel_channel foreign key(channel_id) references channel(id);
alter table user_channel add constraint fk_user_channel_user foreign key(user_id) references user(id);

create table channel_pause_reason
(
    channel_id int not null,
    pause_reason_id int not null,
    created_at timestamp not null default CURRENT_TIMESTAMP,
    primary key(channel_id, pause_reason_id)
);
alter table channel_pause_reason add constraint fk_channel_pause_reason_channel foreign key(channel_id) references channel(id);
alter table channel_pause_reason add constraint fk_channel_pause_reason foreign key(pause_reason_id) references pause_reason(id);

create table feed_config
(
    id int not null auto_increment primary key,
    channel_id int not null,
    field1 varchar(100) not null,
    field2 varchar(100) not null,
    field3 varchar(100) not null,
    field4 varchar(100) not null,
    field5 varchar(100) not null,
    chart_sql text null,
    refresh_time int null,
    chart_tooltip_desc varchar(50) null,
    mobile_sql text null,
    production_sql text null
);
alter table feed_config add constraint fk_feed_config_channel foreign key(channel_id) references channel(id);

create table feed_config_prod_query
(
    id int not null auto_increment primary key,
    channel_id int not null,
    sql_query text not null,
    position int not null
);
alter table feed_config_prod_query add constraint fk_feed_config_prod_query foreign key(channel_id) references channel(id);

create table feed 
(
	id int not null auto_increment primary key,
    ch_id int not null,
    mc_cd varchar(10) null,
    field1 varchar(100) null,
    field2 float(15,2) null,
    field3 float(15,2) null,
    field4 float(15,2) null,
    field5 varchar(100) null,
	inserted_at timestamp not null default CURRENT_TIMESTAMP
);
alter table feed add constraint fk_feed_channel foreign key(ch_id) references channel(id);
alter table feed add constraint fk_feed_machine_data foreign key(mc_cd) references machine_data(code);

create table machine_data
(
    code varchar(10) not null primary key,
    name varchar(20) not null,
	mobile_name varchar(5) null,
    department varchar(100) null,
    product varchar(100) null,
    last_maintenance date null,
    next_maintenance date null,
    state bit default 1
);
alter table machine_data add unique key code_unique(code);
CREATE INDEX code_idx ON machine_data(code);

create table machine_pause
(
	id int not null auto_increment primary key,
    mc_cd varchar(10) not null COLLATE latin1_swedish_ci,
    pause int not null,
    date_ref date not null,
    inserted_at timestamp not null default CURRENT_TIMESTAMP,
    justification varchar(5000) null
);
CREATE INDEX code_idx ON machine_pause(mc_cd);
alter table machine_pause add constraint fk_pause_machine foreign key(mc_cd) references machine_data(code);

create table machine_config
(
	id int not null auto_increment primary key,
    machine_code varchar(10) not null COLLATE latin1_swedish_ci,
    chart_tooltip_desc varchar(50) null,
    chart_sql text null,
    mobile_sql text null,
    inserted_at timestamp not null default CURRENT_TIMESTAMP    
);
CREATE INDEX machine_config_idx ON machine_config(machine_code);
alter table machine_config add constraint fk_machine_config foreign key(machine_code) references machine_data(code);

create table machine_pause_dash
(
	id int not null auto_increment primary key,
    channel_id int not null,
    machine_code varchar(10) not null COLLATE latin1_swedish_ci,
    date_ref datetime not null,
    pause int null,
    pause_reason_id int not null,
    inserted_at timestamp not null default CURRENT_TIMESTAMP
);
CREATE INDEX code_idx ON machine_pause_dash(machine_code);
alter table machine_pause_dash add constraint fk_machine_pause_dash_channel foreign key(channel_id) references channel(id);
alter table machine_pause_dash add constraint fk_machine_pause_dash_machine foreign key(machine_code) references machine_data(code);
alter table machine_pause_dash add constraint fk_machine_pause_dash_reason foreign key(pause_reason_id) references pause_reason(id);

create table log 
(
	id int not null auto_increment primary key,
    message varchar(500) null,
    remoteAddress varchar(50) null,
    remotePort varchar(10) null,
    remoteFamily varchar(10) null,
    localAddress varchar(50) null,
    localPort varchar(10) null,
    bufferSize varchar(20) null,
    bytesRead varchar(20) null,
    bytesWritten varchar(20) null,
	created_at timestamp not null default CURRENT_TIMESTAMP
);

create table deleted_feed
(
	id int not null,
    ch_id int not null,
    mc_cd varchar(10) null,
    field1 varchar(100) null,
    field2 float(8,2) null,
    field3 float(8,2) null,
    field4 float(8,2) null,
    field5 varchar(100) null,
	inserted_at varchar(50) not null, 
	deleted_at timestamp not null default CURRENT_TIMESTAMP
);


create table pause_reason
(
    id int not null auto_increment primary key,
    name varchar(100) not null,
    description varchar(500) null,
    active bit not null default true,
    created_at timestamp not null default CURRENT_TIMESTAMP
);

/*
Nova estrutura
com base nesses campos será criado a tabela feed_x (onde x é o id do canal)
obs: sempre criar o campo machine_code referenciando a tabela machine_data no script
*/
create table feed_field
(
    id int not null auto_increment primary key,
    channel_id int not null,
    field_name varchar(100) not null,
    field_description varchar(100) not null,
    field_type varchar(50) not null,
    created_at timestamp not null default CURRENT_TIMESTAMP,
);
alter table channel_feed_config add constraint fk_feed_field_channel foreign key(channel_id) references channel(id);
/*tables*/

/*stored procedures*/

/*prc_machine_data*/
DROP procedure IF EXISTS `prc_machine_data`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_machine_data`(
	in p_code varchar(10),
    in p_name varchar(20),
    in p_mobile_name varchar(5),
    in p_department varchar(100),
    in p_product varchar(100),
    in p_last_maintenance date,
    in p_next_maintenance date,
    in p_user_id int,
    in p_nominal_output double
)
begin   
	if exists (select 1 from machine_data where code = p_code) then 
		signal sqlstate '99999'
		set message_text = 'Código informado já existe';
    end if;
    insert into machine_data(code, name, mobile_name, department, product, last_maintenance, next_maintenance, nominal_output)
    values(p_code, p_name, p_mobile_name, p_department, p_product, p_last_maintenance, p_next_maintenance, p_nominal_output);
    
    insert into machine_config(machine_code) values(p_code);
end$$

DELIMITER ;

/*prc_machine_data*/

/*prc_delete_machine_data*/
DROP procedure IF EXISTS `prc_delete_machine_data`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_delete_machine_data`(in p_code varchar(10))
BEGIN
	declare msg varchar(100);
    set msg = concat('Não é possível excluir a máquina ', p_code, ' pois existem medições vinculadas a ela');
	if exists (select 1 from feed where mc_cd = p_code) then 
		signal sqlstate '99999'
		set message_text = msg;
    end if;
    delete from channel_machine where machine_code = p_code;
    delete from machine_config where machine_code = p_code;
    delete from machine_data where code = p_code;
END$$

DELIMITER ;


/*prc_delete_machine_data*/


/*prc_delete_channel*/
DROP procedure IF EXISTS `prc_delete_channel`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_delete_channel`(in p_channel_id int)
BEGIN
	set @name = (select name from channel where id = p_channel_id);
    
    set @msg = concat('Não é possível excluir o canal ', @name, '. Existem dados de medição vinculados a ele.');
    
	if exists (select 1 from feed where ch_id = p_channel_id) then 
		signal sqlstate '99999'
		set message_text = @msg;
    end if;
    delete from channel_machine where channel_id = p_channel_id;
    delete from user_channel where channel_id = p_channel_id;
    delete from feed_config where channel_id = p_channel_id;
    delete from channel where id = p_channel_id; 
END$$

DELIMITER ;


/*prc_delete_channel*/

/*prc_channel*/
DROP procedure IF EXISTS `prc_channel`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_channel`(
	in p_name varchar(100),
    in p_description varchar(500),
    in p_token varchar(50),
    in p_active bit,
    in p_time_shift int(11),
	in p_initial_turn char(5),
	in p_final_turn char(5),
    in p_user_id int,
    in p_reset_time_shift bit,
    out p_channel_id int(11)
)
BEGIN
	if exists (select 1 from channel where token = p_token) then 
		signal sqlstate '99999'
		set message_text = 'Token informado já existe';
    end if;
    insert into channel(name, description, token, active, created_at, updated_at, time_shift, initial_turn, final_turn, reset_time_shift)
    values(p_name, p_description, p_token, p_active, now(), now(), p_time_shift, p_initial_turn, p_final_turn, p_reset_time_shift);
    set p_channel_id = LAST_INSERT_ID();
    call prc_user_channel(p_user_id, p_channel_id);
    
    insert into feed_config(channel_id, field1, field2, field3, field4, field5, refresh_time, chart_tooltip_desc) 
    values(p_channel_id, 'Descrição campo 1', 'Descrição campo 2', 'Descrição campo 3', 'Descrição campo 4', 'Descrição campo 5', 300, 'OEE: __value%');
END$$

DELIMITER ;

/*prc_channel*/

/*prc_machine_pause*/
DROP procedure IF EXISTS `prc_machine_pause`;

DELIMITER $$
CREATE PROCEDURE `prc_machine_pause`(
	in p_mc_cd varchar(10),
	in p_pause int,
	in p_date_ref varchar(10),
	in p_justification varchar(5000)
)
BEGIN
    insert into machine_pause(mc_cd, pause, date_ref, justification)
    values(p_mc_cd, p_pause, STR_TO_DATE(p_date_ref, '%d/%m/%Y'), p_justification);
END$$

DELIMITER ;
/*prc_machine_pause*/

/*prc_user*/
DROP procedure IF EXISTS `prc_user`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_user`(
	in p_username varchar(100),
	in p_password varchar(500),
	in p_active bit,
	in p_admin bit,
    in p_company_name varchar(200),
    in p_phone varchar(11),
    out p_user_id int(11)
)
BEGIN
	if exists (select 1 from user where username = p_username) then 
		signal sqlstate '99999'
		set message_text = 'Usuário informado já existe';
    end if;
    insert into user(username, password, active, admin, company_name, phone)
    values(p_username, p_password, p_active, p_admin, p_company_name, p_phone);
    set p_user_id = LAST_INSERT_ID();
END$$

DELIMITER ;

/*prc_user*/

/*prc_user_channel*/
DROP procedure IF EXISTS `prc_user_channel`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_user_channel`(
	in p_user_id int(11),
	in p_channel_id int(11)
)
BEGIN
	if not exists (select 1 from user_channel where user_id = p_user_id and channel_id = p_channel_id) then 
		insert into user_channel(user_id, channel_id) values(p_user_id, p_channel_id);
    end if;
END$$

DELIMITER ;
/*prc_user_channel*/

/*prc_channel_machine*/
DROP procedure IF EXISTS `prc_channel_machine`;

CREATE PROCEDURE prc_channel_machine (
	in p_channel_id int(11),
    in p_machine_code varchar(10)
)
BEGIN
	insert into channel_machine(channel_id, machine_code)
    values(p_channel_id, p_machine_code);
END$$

DELIMITER ;
/*prc_channel_machine*/

/*prc_user_mobile*/
DROP procedure IF EXISTS `prc_user_mobile`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_user_mobile`(
	in p_company_name varchar(200),
	in p_username varchar(100),
	in p_password varchar(500),
    in p_active bit,
	in p_admin bit,
    in p_phone varchar(11)
)
BEGIN
    set @v_maq1_test = 'MAQ1*';
    set @v_maq2_test = 'MAQ2*';
    set @v_maq3_test = 'MAQ3*';

	if exists (select 1 from user where username = p_username) then 
		signal sqlstate '99999'
		set message_text = 'Usuário informado já existe';
    end if;
    
    /*testa se maquinas de teste já existem*/
	if not exists (select 1 from machine_data where code = @v_maq1_test) then 
		CALL prc_machine_data(@v_maq1_test, 'Máquina 1', null, null, null, null);
    end if;   
	if not exists (select 1 from machine_data where code = @v_maq2_test) then 
		CALL prc_machine_data(@v_maq2_test, 'Máquina 2', null, null, null, null);
    end if; 
	if not exists (select 1 from machine_data where code = @v_maq3_test) then 
		CALL prc_machine_data(@v_maq3_test, 'Máquina 3', null, null, null, null);
    end if;     
    
    /*cria usuário*/	
    CALL prc_user(p_username, p_password, p_active, p_admin, p_company_name, p_phone, @v_user_id);
    
    /*cria canal do usuário*/
    CALL prc_channel(p_company_name, p_company_name, date_format(now(), '%d%m%Y%H%i%s'), p_active, null, null, null, @v_user_id, @v_channel_id);

    /*vincula canal ao usuário*/
    CALL prc_user_channel(@v_user_id, @v_channel_id);
    
    /*vincula maquinas ao canal*/
    CALL prc_channel_machine(@v_channel_id, @v_maq1_test);
    CALL prc_channel_machine(@v_channel_id, @v_maq2_test);
    CALL prc_channel_machine(@v_channel_id, @v_maq3_test);
END$$

DELIMITER ;
/*prc_user_mobile*/

/*prc_chart*/
DROP procedure IF EXISTS `prc_chart`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_chart`(
	in p_date_ini varchar(20),
    in p_date_fin varchar(20),
    in p_ch_id int(11),
    in p_mc_cd varchar(10)
)
BEGIN
	SET @chart_sql = coalesce(
		(select chart_sql 
           from machine_config 
		  where machine_code = p_mc_cd),
		(select chart_sql 
		   from feed_config 
		  where channel_id = p_ch_id)
	);
	
    SET @chart_sql = REPLACE(@chart_sql, '__date_ini', p_date_ini);
    SET @chart_sql = REPLACE(@chart_sql, '__date_fin', p_date_fin);
    SET @chart_sql = REPLACE(@chart_sql, '__ch_id', p_ch_id);
    SET @chart_sql = REPLACE(@chart_sql, '__mc_cd', p_mc_cd);
    
    PREPARE stmt FROM @chart_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;
/*prc_chart*/

/*prc_mobile*/
DROP procedure IF EXISTS `prc_mobile`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`%` PROCEDURE `prc_mobile`(
	in p_user_id int(11),
	in p_date varchar(8),
    in p_ch_id int(11),
    in p_mc_cd varchar(10),
    in p_limit int(11)
)
BEGIN
	SET @mobile_sql = coalesce(
		nullif((select mobile_sql 
           from machine_config 
		  where machine_code = p_mc_cd), ''),
		nullif((select mobile_sql 
		   from feed_config 
		  where channel_id = p_ch_id), '')
	);
	
    SET @mobile_sql = REPLACE(@mobile_sql, '__user_id', p_user_id);
    SET @mobile_sql = REPLACE(@mobile_sql, '__date', p_date);
    SET @mobile_sql = REPLACE(@mobile_sql, '__ch_id', p_ch_id);
    SET @mobile_sql = REPLACE(@mobile_sql, '__mc_cd', p_mc_cd);
    SET @mobile_sql = REPLACE(@mobile_sql, '__limit', p_limit);
    
    PREPARE stmt FROM @mobile_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

/*prc_mobile*/

/*resetTimeShift*/

set global event_scheduler = ON;

[11:55, 8/29/2018] Washington Peroni: 6:40 90
[11:55, 8/29/2018] Washington Peroni: 6:50 91
[11:55, 8/29/2018] Washington Peroni: 7:00 10

[11:55, 8/29/2018] Washington Peroni: 17:00 90
[11:56, 8/29/2018] Washington Peroni: 17:10 91
[11:56, 8/29/2018] Washington Peroni: 17:20 10

-- :/
  
/*muda leolac para 91 as 6:50h*/
create event if not exists resetTimeShift_Leolac_0650
	on schedule every 1 day starts '2018-11-12 06:50:00' do	
	update channel 
	   set time_shift = wlp_hard_coder + 1,
           updated_at = now() 
	 where reset_time_shift = 1
       and id = 1;  

/*muda leolac para 90 as 17:00h*/
create event if not exists resetTimeShift_Leolac_1700
	on schedule every 1 day starts '2018-11-12 17:00:00' do	
	update channel 
	   set time_shift = wlp_hard_coder,
           updated_at = now() 
	 where reset_time_shift = 1
       and id = 1;  


-- reset da fantastico
create event if not exists reset_leolac_0530 
	on schedule every 1 day starts '2018-11-12 05:30:00' do	
		insert into feed(ch_id, mc_cd, field1, field2, field3, field4, field5)
		select channel_id
			 , machine_code
			 , 'Reset StartMeUp'
			 , 0
			 , 0
			 , 0
			 , '0'
		  from channel_machine
		 where channel_id = 2;

create event if not exists reset_leolac_1900 
	on schedule every 1 day starts '2018-11-12 19:00:00' do	
		insert into feed(ch_id, mc_cd, field1, field2, field3, field4, field5)
		select channel_id
			 , machine_code
			 , 'Reset StartMeUp'
			 , 0
			 , 0
			 , 0
			 , '0'
		  from channel_machine
		 where channel_id = 2;         

/*resetTimeShift*/     

/*prc_feed_update*/
DROP procedure IF EXISTS `prc_feed_update`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_feed_update`(
	in p_token varchar(50),
    in p_mc_cd varchar(10),
    in p_field1 varchar(100),
    in p_field2 float(15,2),
    in p_field3 float(15,2),
    in p_field4 float(15,2),
    in p_field5 varchar(100),
    out p_time_shift int(11)
)
BEGIN
	declare v_count int(11);
    declare v_ch_id int(11);
    declare v_time_shift int(11);
    declare v_can_transmit bit;
    
    select count(*) into v_count 
      from channel 
	 where token = p_token;
    
    /*canal não existe ou token está duplicado*/
	if (v_count = 0 or v_count > 1) then 
		signal sqlstate '99999'
		set message_text = 'Token inválido';
    end if;        
    
	select id
         , time_shift 
		 , case when DATE_FORMAT(now(), '%H:%i') between initial_turn and final_turn
			then 1
			else 0
		   end as transmissao_liberada         
      into v_ch_id
         , v_time_shift
         , v_can_transmit
      from channel 
	 where token = p_token;
     
	/*maquina pertence ao canal?*/
	if not exists (select 1 from channel_machine where channel_id = v_ch_id and machine_code = p_mc_cd) then 
		signal sqlstate '99999'
		set message_text = 'Máquina informada não pertence ao canal';
    end if;   
			
    set p_time_shift = v_time_shift;
    
    /*transmite somente dentro do horario de turno do canal*/
    if(v_can_transmit = 1) then
		insert into feed(ch_id, mc_cd, field1, field2, field3, field4, field5)
		values(v_ch_id, p_mc_cd, p_field1, p_field2, p_field3, p_field4, p_field5);
    end if;
    
END$$

DELIMITER ;

/*prc_feed_update*/

DROP procedure IF EXISTS `prc_production_count`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_production_count`(
	in p_ch_id int(11),
    in p_date_ini varchar(20),
    in p_date_fin varchar(20),
    in p_position int
)
BEGIN
	SET @prod_sql = coalesce(
		(select sql_query 
           from feed_config_prod_query 
		  where channel_id = p_ch_id
            and position = p_position), null);
	
    if(@prod_sql is not null) then
		SET @prod_sql = REPLACE(@prod_sql, '__date_ini', p_date_ini);
		SET @prod_sql = REPLACE(@prod_sql, '__date_fin', p_date_fin);
		SET @prod_sql = REPLACE(@prod_sql, '__ch_id', p_ch_id);
        
		PREPARE stmt FROM @prod_sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;          
    end if;  
END$$

DELIMITER ;

/*prc_machine_pause_dash*/
DROP procedure IF EXISTS `prc_machine_pause_dash`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_machine_pause_dash`(
	in p_channel_id int,
    in p_machine_code varchar(10),
    in p_date_ini varchar(50),
    in p_date_fin varchar(50),
    in p_pause_reason_id int,
    in p_pause int
)
BEGIN
    set @insert_index = (select ifnull(max(insert_index),0)+1 from machine_pause_dash);
    
	insert into machine_pause_dash(channel_id, machine_code, date_ref, pause_reason_id, pause, insert_index)
	select f.ch_id
		 , f.mc_cd
		 , DATE_FORMAT(f.inserted_at, '%Y-%m-%d %H:%i:%s') as date_ref
		 , p_pause_reason_id
         , p_pause
         , @insert_index
	  from feed f
	 where f.ch_id = p_channel_id
	   and f.mc_cd = p_machine_code
	   and f.inserted_at between p_date_ini and p_date_fin
	   and not exists(select 1 
						from machine_pause_dash mpd 
					   where mpd.channel_id = f.ch_id 
						 and mpd.machine_code = f.mc_cd 
						 and mpd.date_ref = f.inserted_at);
END$$

DELIMITER ;

/*prc_machine_pause_dash*/

/*prc_oee*/
USE `oee`;
DROP procedure IF EXISTS `prc_oee`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`%` PROCEDURE `prc_oee`(
	in p_channel_id int,
	in p_date_ini varchar(20),
    in p_date_fin varchar(20)    
)
begin
	declare v_done int default false;
    declare v_machine_code varchar(10);
    declare v_machine_name varchar(20);
    declare v_quality int;
    	
	/*curso de maquinas do canal*/
	declare c cursor for select cm.machine_code, m.name
						   from channel_machine cm
						  inner join machine_data m on m.code = cm.machine_code
						  where cm.channel_id = p_channel_id;
	
	declare continue handler for not found set v_done = true;    
	declare exit handler for sqlexception, sqlwarning
	begin
		rollback;
		resignal;
	end;    

	drop temporary table if exists tmp_oee;
	create temporary table if not exists tmp_oee(
		channel_id int,
		machine_code varchar(10),
        machine_name varchar(100),
		availability float(8,2),
		performance float(8,2),
		quality float(8,2),
		oee float(8,2)
	);
    
	drop temporary table if exists tmp_performance;
	create temporary table if not exists tmp_performance(
		machine_code varchar(10),
		field3 float(8,2),
		field5 float(8,2),
		performance float(8,2)
	);
    
	drop temporary table if exists tmp_availability;
	create temporary table if not exists tmp_availability(
		machine_code varchar(10),
		pp float(8,2),
		pnp float(8,2)
	);    

	/*desempenho*/
	insert into tmp_performance
	select f.mc_cd
		 , f.field3
		 , cast(f.field5 as decimal(8,2)) as field5
		 , case f.mc_cd 
			when 'EF3' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF4' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF5' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF6' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF7' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'RB1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'RB2' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			else 0
		   end as performance 
	  from feed f 
	 inner join (select max(f.id) as id
				   from feed f
				  where f.ch_id = p_channel_id
					and f.inserted_at between 
						(STR_TO_DATE(p_date_ini, '%Y-%m-%d %H:%i:%s')) 
					and (STR_TO_DATE(p_date_fin, '%Y-%m-%d %H:%i:%s'))			
				  group by f.mc_cd) tmp on f.id = tmp.id
	 inner join machine_data m on m.code = f.mc_cd;    

	/*disponibilidade*/
	insert into tmp_availability
	select b.machine_code
		 , sum(pp) as pp
		 , sum(pnp) as pnp
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
		 where c.id = p_channel_id
		   and mpd.date_ref between 
				   (STR_TO_DATE(p_date_ini, '%Y-%m-%d %H:%i:%s')) 
			   and (STR_TO_DATE(p_date_fin, '%Y-%m-%d %H:%i:%s'))
		 group by mpd.insert_index) a
	 group by a.machine_code, a.type) b
	 group by b.machine_code;

	if not exists(select 1 from tmp_performance) then
		signal sqlstate '45000' set message_text = 'sem dados';
	end if;
    
    set v_quality = (select quality from channel where id = p_channel_id);

	open c;
 
	read_loop: loop
		fetch c into v_machine_code, v_machine_name;	
        
		if v_done then
			leave read_loop;
		end if;			
	
		set @v_pp = 0;
        set @v_pnp = 0;
        set @v_performance = 0;
        set @v_availability = 0.01; /*somente para não dar divisao por zero*/
        set @v_real_availability = 0;        
        
		select @v_pp := pp
			 , @v_pnp := pnp
		  from tmp_availability 
		 where machine_code = v_machine_code;
		        
		select @v_performance := performance
			 , @v_availability := (field5 - coalesce(@v_pp,0))
			 , @v_real_availability := (@v_availability - coalesce(@v_pnp,0))
		  from tmp_performance 
		 where machine_code = v_machine_code;
		
		insert into tmp_oee(channel_id, machine_code, machine_name, availability, performance, quality, oee) 
		values (p_channel_id
			  , v_machine_code
              , v_machine_name
			  , round(((@v_real_availability / @v_availability)*100),2)
			  , round((@v_performance * 100),2)
			  , v_quality
			  , ((@v_performance * (@v_real_availability / @v_availability) * 1) * 100) 
		);
	end loop;

	close c;
	select * from tmp_oee; 
end$$

DELIMITER ;
/*prc_oee*/

/*prc_commands_executer*/

USE `oee`;
DROP procedure IF EXISTS `prc_commands_executer`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_commands_executer`(
	in p_channel_id int(11),
    in p_machine_code varchar(10),
    in p_date_ini varchar(20),
    in p_date_fin varchar(20),
    in p_type varchar(50)
)
BEGIN
	declare v_done int default false;
    declare v_query text;
    
	declare c cursor for select query
						   from commands q 
						  where q.channel_id = p_channel_id
							and q.type = p_type;

	declare continue handler for not found set v_done = true;    
	declare exit handler for sqlexception, sqlwarning
	begin
		rollback;
		resignal;
	end;  
	
	open c;
 
	read_loop: loop
		fetch c into v_query;	
        
		if v_done then
			leave read_loop;
		end if;			
	    
        SET @v_query = v_query;
		SET @v_query = REPLACE(@v_query, '__date_ini', p_date_ini);
		SET @v_query = REPLACE(@v_query, '__date_fin', p_date_fin);
		SET @v_query = REPLACE(@v_query, '__ch_id', p_channel_id);
        SET @v_query = REPLACE(@v_query, '__mc_cd', p_machine_code);
			
		PREPARE stmt FROM @v_query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt; 
		
	end loop;

	close c;    
    
END$$

DELIMITER ;

/*prc_commands_executer*/

/*stored procedures*/

/*functions*/
DROP function IF EXISTS `fnc_machine_pause`;

DELIMITER $$
USE `oee`$$
CREATE FUNCTION `fnc_machine_pause`(
	p_channel_id int,
    p_machine_code varchar(10),
    p_date_ini varchar(20),
    p_date_fin varchar(20),
    p_pause_type char(2)
) RETURNS int(11)
    DETERMINISTIC
begin
	declare v_pause int;
    set v_pause = 0;
    select sum(a.pause) as pause
      into v_pause
	  from (
		select mpd.pause 
		  from channel c
		 inner join channel_machine cm on cm.channel_id = c.id
		  left join machine_pause_dash mpd on mpd.channel_id = c.id and mpd.machine_code = cm.machine_code
		  left join pause_reason pr on pr.id = mpd.pause_reason_id
		 where c.id = p_channel_id
		   and cm.machine_code = p_machine_code
		   and mpd.date_ref between 
				   (str_to_date(p_date_ini, '%Y-%m-%d %H:%i:%s')) 
			   and (str_to_date(p_date_fin, '%Y-%m-%d %H:%i:%s'))
		   and pr.type = p_pause_type    
		 group by mpd.insert_index
	) a;
	return coalesce(v_pause, 0);
end$$

DELIMITER ;
/*functions*/

alter table feed_config add production_sql text null;

CREATE INDEX feed_ch_id_mc_cd_inserted_at_index ON feed (ch_id, mc_cd, inserted_at);

alter table pause_reason add type char(2) null;

alter table machine_pause_dash add insert_index int;

alter table machine_data add nominal_output double null;

//nao sei se vou manter isso
create table channel_shift_prod_count(
	channel_id int(11) not null,
    hour int(2) not null,
    primary key(channel_id, hour),
    constraint fk_channel_shift_prod_count_channel FOREIGN KEY (channel_id) REFERENCES channel (id)
);

/*02-02-2019 - adicionando tabela de commands*/
create table commands(
	id int not null auto_increment primary key,
	channel_id int(11) not null,
    machine_code varchar(10) null COLLATE latin1_swedish_ci,
    type varchar(50) not null,
    query text null
);
alter table commands add constraint fk_commands_channel foreign key(channel_id) references channel(id);
alter table commands add constraint fk_commands_machine foreign key(machine_code) references machine_data(code);

alter table channel add quality int null;