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
    declare v_last_feed float(15,2);
    
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
     
	select ifnull(sum(field2 + field3),0) as last
      into v_last_feed
	  from feed f
	 inner join (select max(id) as id
				   from feed
				  where ch_id = v_ch_id
					and mc_cd = p_mc_cd
					and date(inserted_at) = DATE_FORMAT(now(), "%Y-%m-%d")
				  group by mc_cd) ids on ids.id = f.id
	 inner join machine_data m on m.code = f.mc_cd;     
     
	/*maquina pertence ao canal?*/
	if not exists (select 1 from channel_machine where channel_id = v_ch_id and machine_code = p_mc_cd) then 
		signal sqlstate '99999'
		set message_text = 'Máquina informada não pertence ao canal';
    end if;   
			
    set p_time_shift = v_time_shift;
    
    /*transmite somente dentro do horario de turno do canal*/
    if(v_can_transmit = 1 and ((p_field2 + p_field3) >= v_last_feed)) then
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


-- 20/02/2019
-- pareto
USE `oee`;
DROP procedure IF EXISTS `prc_chart_pause_pareto`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_chart_pause_pareto`(
	in p_channel_id int,
    in p_machine_code varchar(10),
    in p_time_filter int
)
BEGIN
	set @totalPauses := 0;
	set @queryPausesCount = '
		select sum(p.pause)
		  into @totalPauses
		  from (
			select year(mpd.date_ref) as year
				 , month(mpd.date_ref) as month
				 , day(mpd.date_ref) as day
				 , week(mpd.date_ref) as week
				 , mpd.pause
			  from machine_pause_dash mpd
			 inner join pause_reason pr on pr.id = mpd.pause_reason_id
			 where mpd.channel_id = __channel_id
			   __machine_filter
			 group by mpd.insert_index
		) p
		where p.year = year(now())
		  __filter';
    
	set @queryPauses = '       
		select d.*
			 , sec_to_time(d.pause*60) as pause_in_time
			 , round(@frequencyCount := @frequencyCount + d.percentage, 2) as sum_percentage
		  from (
			select c.*
			  from (
				select p.pause_name 
					 , case when length(p.pause_name) > 10 then concat(left(p.pause_name, 10), \'...\') else p.pause_name end as pause_name_short
					 , p.pause_type
					 , sum(p.pause) as pause             
					 , round(((sum(p.pause) * 100) / @totalPauses),2) as percentage   
				  from (
					select year(mpd.date_ref) as year
						 , month(mpd.date_ref) as month
						 , day(mpd.date_ref) as day
						 , week(mpd.date_ref) as week
						 , mpd.pause_reason_id
						 , mpd.pause
						 , pr.name as pause_name
						 , case pr.type when \'PP\' then \'Pausa programada\' else \'Pausa não programada\' end as pause_type
						 , mpd.channel_id
					  from machine_pause_dash mpd
					 inner join pause_reason pr on pr.id = mpd.pause_reason_id
					 where mpd.channel_id = __channel_id
					   __machine_filter
					 group by mpd.insert_index
				) p
				where p.year = year(now())
				  __filter
				group by p.pause_reason_id
			) c
			order by c.pause desc
		) d,
		(select @frequencyCount := 0) SQLVars;';
        
        -- canal
		set @queryPauses = replace(@queryPauses, '__channel_id', p_channel_id);
		set @queryPausesCount = replace(@queryPausesCount, '__channel_id', p_channel_id);
        
        -- filtro por maquina
        if(p_machine_code is not null) then
			set @queryPauses = replace(@queryPauses, '__machine_filter', concat('and mpd.machine_code = ', '''', p_machine_code, ''''));
            set @queryPausesCount = replace(@queryPausesCount, '__machine_filter', concat('and mpd.machine_code = ', '''', p_machine_code, '''')); 
        else    
			set @queryPauses = replace(@queryPauses, '__machine_filter', '');
            set @queryPausesCount = replace(@queryPausesCount, '__machine_filter', '');        
        end if;
        
        -- filtro somente por ano
        if(p_time_filter = 0) then
			set @queryPauses = replace(@queryPauses, '__filter', '');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', '');
        -- filtro somente por mes
        elseif (p_time_filter = 1) then
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.month = month(now())');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.month = month(now())'); 
        -- filtro por mes/semana
        elseif(p_time_filter = 2) then
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.week = week(now()) and p.month = month(now())');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.week = week(now()) and p.month = month(now())');        
		-- filtro por mes/dia
        else
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.day = day(now()) and p.month = month(now())');
			set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.day = day(now()) and p.month = month(now())');
        end if;    
        
    prepare stmt from @queryPausesCount;
	execute stmt;
	deallocate prepare stmt;  
    
    prepare stmt from @queryPauses;
	execute stmt;
	deallocate prepare stmt;      
        
END$$

DELIMITER ;


-- 25/02/2019
alter table machine_config add max_day_production float(15,2) null;

-- 26/02/2019
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
							and ((q.machine_code = p_machine_code) or q.machine_code is null)
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

insert into commands(channel_id, type, query) 
values(2, 'mobile_gauge_chart', '
select a.machine_code
     , a.machine_name
     , a.max_day_production
     , round(coalesce(((a.production * 100) / a.max_day_production), 0), 2) as production
     , a.chart_tooltip_desc
     , a.date
  from ( 
select f.mc_cd as machine_code
     , m.name as machine_name
     , case f.mc_cd 
		when \'EF3\' then f.field2
        when \'EF4\' then f.field2
        when \'EF5\' then f.field3 
        when \'EF6\' then f.field3
        when \'EF7\' then f.field3 
        else 0 end as production
     , coalesce(mc.max_day_production, 0) as max_day_production
     , case f.mc_cd 
		when \'EF3\' then replace(mc.chart_tooltip_desc, \'__value\', f.field2)
        when \'EF4\' then replace(mc.chart_tooltip_desc, \'__value\', f.field2)
        when \'EF5\' then replace(mc.chart_tooltip_desc, \'__value\', f.field3) 
        when \'EF6\' then replace(mc.chart_tooltip_desc, \'__value\', f.field3)
        when \'EF7\' then replace(mc.chart_tooltip_desc, \'__value\', f.field3)
        else 0 end as chart_tooltip_desc     
     , DATE_FORMAT(f.inserted_at, \'%d/%m/%Y %H:%i:%s\') as date
  from feed f
 inner join machine_data m on m.code = f.mc_cd
 inner join (select max(id) as id
			   from feed f 
			  where f.ch_id = __ch_id
			    and DATE_FORMAT(f.inserted_at, \'%d%m%Y\') = \'__date_ini\'
			  group by f.mc_cd) tmp on tmp.id = f.id
 inner join machine_config mc on mc.machine_code = f.mc_cd) a;');

 update machine_config set max_day_production = 3000 where machine_code in('EF3','EF4','EF5','EF6','EF7');

insert into commands(channel_id, type, query) 
values(16, 'mobile_gauge_chart', '
select a.machine_code
     , a.machine_name
     , a.max_day_production
     , round(coalesce(((a.production * 100) / a.max_day_production), 0), 2) as production
     , a.chart_tooltip_desc
     , a.date
  from ( 
select f.mc_cd as machine_code
     , m.name as machine_name
     , case f.mc_cd 
		when \'AB1\' then f.field3
        when \'AB2\' then f.field3
        else 0 end as production
     , coalesce(mc.max_day_production, 0) as max_day_production
     , case f.mc_cd 
		when \'AB1\' then replace(mc.chart_tooltip_desc, \'__value\', f.field3)
        when \'AB2\' then replace(mc.chart_tooltip_desc, \'__value\', f.field3)
        else 0 end as chart_tooltip_desc     
     , DATE_FORMAT(f.inserted_at, \'%d/%m/%Y %H:%i:%s\') as date
  from feed f
 inner join machine_data m on m.code = f.mc_cd
 inner join (select max(id) as id
			   from feed f 
			  where f.ch_id = __ch_id
			    and DATE_FORMAT(f.inserted_at, \'%d%m%Y\') = \'__date_ini\'
			  group by f.mc_cd) tmp on tmp.id = f.id
 inner join machine_config mc on mc.machine_code = f.mc_cd) a;');

 update machine_config set max_day_production = 600000 where machine_code in('AB1','AB2');

 -- 01/03/2019
 USE `oee`;
DROP procedure IF EXISTS `prc_chart_pause_pareto`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`%` PROCEDURE `prc_chart_pause_pareto`(
	in p_channel_id int,
    in p_machine_code varchar(10),
    in p_time_filter int
)
BEGIN
	set @totalPauses := 0;
	set @queryPausesCount = '
		select sum(p.pause)
		  into @totalPauses
		  from (
			select year(mpd.date_ref) as year
				 , month(mpd.date_ref) as month
				 , day(mpd.date_ref) as day
				 , mpd.date_ref
				 , mpd.pause
			  from machine_pause_dash mpd
			 inner join pause_reason pr on pr.id = mpd.pause_reason_id
			 where mpd.channel_id = __channel_id
			   __machine_filter
			 group by mpd.insert_index
		) p
		where p.year = year(now())
		  __filter';
    
	set @queryPauses = '       
		select d.*
			 , sec_to_time(d.pause*60) as pause_in_time
			 , round(@frequencyCount := @frequencyCount + d.percentage, 2) as sum_percentage
		  from (
			select c.*
			  from (
				select p.pause_name 
					 , case when length(p.pause_name) > 10 then concat(left(p.pause_name, 10), \'...\') else p.pause_name end as pause_name_short
					 , p.pause_type
					 , sum(p.pause) as pause             
					 , round(((sum(p.pause) * 100) / @totalPauses),2) as percentage   
				  from (
					select year(mpd.date_ref) as year
						 , month(mpd.date_ref) as month
						 , day(mpd.date_ref) as day
						 , mpd.date_ref
						 , mpd.pause_reason_id
						 , mpd.pause
						 , pr.name as pause_name
						 , case pr.type when \'PP\' then \'Pausa programada\' else \'Pausa não programada\' end as pause_type
						 , mpd.channel_id
					  from machine_pause_dash mpd
					 inner join pause_reason pr on pr.id = mpd.pause_reason_id
					 where mpd.channel_id = __channel_id
					   __machine_filter
					 group by mpd.insert_index
				) p
				where p.year = year(now())
				  __filter
				group by p.pause_reason_id
			) c
			order by c.pause desc
		) d,
		(select @frequencyCount := 0) SQLVars;';
        
        -- canal
		set @queryPauses = replace(@queryPauses, '__channel_id', p_channel_id);
		set @queryPausesCount = replace(@queryPausesCount, '__channel_id', p_channel_id);
        
        -- filtro por maquina
        if(p_machine_code is not null) then
			set @queryPauses = replace(@queryPauses, '__machine_filter', concat('and mpd.machine_code = ', '''', p_machine_code, ''''));
            set @queryPausesCount = replace(@queryPausesCount, '__machine_filter', concat('and mpd.machine_code = ', '''', p_machine_code, '''')); 
        else    
			set @queryPauses = replace(@queryPauses, '__machine_filter', '');
            set @queryPausesCount = replace(@queryPausesCount, '__machine_filter', '');        
        end if;
        
        -- filtro somente por ano
        if(p_time_filter = 0) then
			set @queryPauses = replace(@queryPauses, '__filter', '');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', '');
        -- filtro somente por mes
        elseif (p_time_filter = 1) then
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.month = month(now())');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.month = month(now())'); 
        -- filtro por mes/semana
        elseif(p_time_filter = 2) then
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.date_ref between date_sub(now(), interval 7 day) and now()');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.date_ref between date_sub(now(), interval 7 day) and now()');        
		-- filtro por mes/dia
        else
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.day = day(now()) and p.month = month(now())');
			set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.day = day(now()) and p.month = month(now())');
        end if;    
        
    prepare stmt from @queryPausesCount;
	execute stmt;
	deallocate prepare stmt;  
    
    prepare stmt from @queryPauses;
	execute stmt;
	deallocate prepare stmt;      
        
END$$

DELIMITER ;

-- 04/03 - adicionandno tabela de turno por maquina
create table machine_shift(
	id int not null auto_increment,
    machine_code varchar(10) not null COLLATE latin1_swedish_ci,
	hour_ini char(5) not null,
    hour_fin char(5) not null,
    primary key(id, machine_code)
);

alter table machine_shift add constraint fk_machine_shift_machine FOREIGN KEY (machine_code) REFERENCES machine_data (code);

-- tabela com horarios de turno
create table shift(
	id int not null auto_increment,
    hour char(5) not null,
    primary key(id)
);
insert into shift(hour) values('00:00');
insert into shift(hour) values('01:00');
insert into shift(hour) values('02:00');
insert into shift(hour) values('03:00');
insert into shift(hour) values('04:00');
insert into shift(hour) values('05:00');
insert into shift(hour) values('06:00');
insert into shift(hour) values('07:00');
insert into shift(hour) values('08:00');
insert into shift(hour) values('09:00');
insert into shift(hour) values('10:00');
insert into shift(hour) values('12:00');
insert into shift(hour) values('13:00');
insert into shift(hour) values('14:00');
insert into shift(hour) values('15:00');
insert into shift(hour) values('16:00');
insert into shift(hour) values('17:00');
insert into shift(hour) values('18:00');
insert into shift(hour) values('19:00');
insert into shift(hour) values('20:00');
insert into shift(hour) values('21:00');
insert into shift(hour) values('22:00');
insert into shift(hour) values('23:00');

-- procedure de inserção de turno da maquina
USE `oee`;
DROP procedure IF EXISTS `prc_machine_shift`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_machine_shift`(
	in p_machine_code varchar(10),
    in p_hour_ini char(5),
    in p_hour_fin char(5)
)
BEGIN    
    set @msg = 'Horário inválido ou já cadastrado';
    
	if (exists (select 1 from machine_shift 
				where machine_code = p_machine_code
                  and hour_ini = p_hour_ini
                  and hour_fin = p_hour_fin) or p_hour_ini = p_hour_fin) then 
		signal sqlstate '99999'
		set message_text = @msg;
    end if;
    insert into machine_shift(machine_code, hour_ini, hour_fin) 
	values(p_machine_code, p_hour_ini, p_hour_fin);
END$$

DELIMITER ;

-- 07/03/2019 - melhorias prc oee
USE `oee`;
DROP procedure IF EXISTS `prc_oee`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_oee`(
	in p_channel_id int,
	in p_date_ini varchar(20),
    in p_date_fin varchar(20),
    in p_machine_code varchar(10)
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
						  where cm.channel_id = p_channel_id
                            and ((cm.machine_code = p_machine_code) or ifnull(p_machine_code, '') = '');
	
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
		 , cast(coalesce(f.field5,0) as decimal(15,2)) as field5
         , coalesce(case f.mc_cd 
			when 'EF3' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF4' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF5' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF6' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF7' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'RB1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'RB2' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'AB1' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'AB2' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            /*when 'MAQ1' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ2' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ3' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ4' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ5' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'LLC6' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC7' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC8' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC9' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC10' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC11' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC12' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC13' then round((((f.field4 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'OP1' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) */
            else 0
		   end, 0) as performance 
	  from feed f 
	 inner join (select max(f.id) as id
				   from feed f
				  where f.ch_id = p_channel_id
                    and ((f.mc_cd = p_machine_code) or ifnull(p_machine_code, '') = '')
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
		  from machine_pause_dash mpd
		  left join pause_reason pr on pr.id = mpd.pause_reason_id
		 where mpd.channel_id = p_channel_id
           and ((mpd.machine_code = p_machine_code) or ifnull(p_machine_code, '') = '')
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

-- procedure de geração do oee por turno
USE `oee`;
DROP procedure IF EXISTS `prc_shift_oee`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_shift_oee`(
	in p_channel_id int(11),
    in p_machine_code varchar(10),
    in p_date_ini varchar(20),
    in p_date_fin varchar(20)
)
BEGIN
	declare v_done int default false;
    declare v_hour_ini char(5);
    declare v_hour_fin char(5);
    
	declare c cursor for select hour_ini, hour_fin
						   from machine_shift ms 
						  where ms.machine_code = p_machine_code;

	declare continue handler for not found set v_done = true;    
	declare exit handler for sqlexception, sqlwarning
	begin
		rollback;
		resignal;
	end;  
	
	open c;
 
	read_loop: loop
		fetch c into v_hour_ini, v_hour_fin;	
        
		if v_done then
			leave read_loop;
		end if;			
        
        set @v_date_ini = concat(convert(date_format(str_to_date(p_date_ini, '%Y-%m-%d %H:%i:%s'), '%Y-%m-%d'), char(10)), ' ', v_hour_ini, ':00');
        set @v_date_fin = concat(convert(date_format(str_to_date(p_date_fin, '%Y-%m-%d %H:%i:%s'), '%Y-%m-%d'), char(10)), ' ', v_hour_fin, ':00');
        
		select p_machine_code as machine_code, concat('OEE turno: ', v_hour_ini, ' - ', v_hour_fin) as oee_msg;
        call prc_oee(p_channel_id, @v_date_ini, @v_date_fin, p_machine_code);
		
	end loop;

	close c;    
END$$

DELIMITER ;

-- 09/03
insert into shift(hour) values('00:00');
insert into shift(hour) values('00:01');
insert into shift(hour) values('00:05');
insert into shift(hour) values('00:10');
insert into shift(hour) values('00:15');
insert into shift(hour) values('00:20');
insert into shift(hour) values('00:25');
insert into shift(hour) values('00:30');
insert into shift(hour) values('00:35');
insert into shift(hour) values('00:40');
insert into shift(hour) values('00:45');
insert into shift(hour) values('00:50');
insert into shift(hour) values('00:55');

insert into shift(hour) values('01:00');
insert into shift(hour) values('01:01');
insert into shift(hour) values('01:05');
insert into shift(hour) values('01:10');
insert into shift(hour) values('01:15');
insert into shift(hour) values('01:20');
insert into shift(hour) values('01:25');
insert into shift(hour) values('01:30');
insert into shift(hour) values('01:35');
insert into shift(hour) values('01:40');
insert into shift(hour) values('01:45');
insert into shift(hour) values('01:50');
insert into shift(hour) values('01:55');

insert into shift(hour) values('02:00');
insert into shift(hour) values('02:01');
insert into shift(hour) values('02:05');
insert into shift(hour) values('02:10');
insert into shift(hour) values('02:15');
insert into shift(hour) values('02:20');
insert into shift(hour) values('02:25');
insert into shift(hour) values('02:30');
insert into shift(hour) values('02:35');
insert into shift(hour) values('02:40');
insert into shift(hour) values('02:45');
insert into shift(hour) values('02:50');
insert into shift(hour) values('02:55');

insert into shift(hour) values('03:00');
insert into shift(hour) values('03:01');
insert into shift(hour) values('03:05');
insert into shift(hour) values('03:10');
insert into shift(hour) values('03:15');
insert into shift(hour) values('03:20');
insert into shift(hour) values('03:25');
insert into shift(hour) values('03:30');
insert into shift(hour) values('03:35');
insert into shift(hour) values('03:40');
insert into shift(hour) values('03:45');
insert into shift(hour) values('03:50');
insert into shift(hour) values('03:55');

insert into shift(hour) values('04:00');
insert into shift(hour) values('04:01');
insert into shift(hour) values('04:05');
insert into shift(hour) values('04:10');
insert into shift(hour) values('04:15');
insert into shift(hour) values('04:20');
insert into shift(hour) values('04:25');
insert into shift(hour) values('04:30');
insert into shift(hour) values('04:35');
insert into shift(hour) values('04:40');
insert into shift(hour) values('04:45');
insert into shift(hour) values('04:50');
insert into shift(hour) values('04:55');

insert into shift(hour) values('05:00');
insert into shift(hour) values('05:01');
insert into shift(hour) values('05:05');
insert into shift(hour) values('05:10');
insert into shift(hour) values('05:15');
insert into shift(hour) values('05:20');
insert into shift(hour) values('05:25');
insert into shift(hour) values('05:30');
insert into shift(hour) values('05:35');
insert into shift(hour) values('05:40');
insert into shift(hour) values('05:45');
insert into shift(hour) values('05:50');
insert into shift(hour) values('05:55');

insert into shift(hour) values('06:00');
insert into shift(hour) values('06:01');
insert into shift(hour) values('06:05');
insert into shift(hour) values('06:10');
insert into shift(hour) values('06:15');
insert into shift(hour) values('06:20');
insert into shift(hour) values('06:25');
insert into shift(hour) values('06:30');
insert into shift(hour) values('06:35');
insert into shift(hour) values('06:40');
insert into shift(hour) values('06:45');
insert into shift(hour) values('06:50');
insert into shift(hour) values('06:55');

insert into shift(hour) values('07:00');
insert into shift(hour) values('07:01');
insert into shift(hour) values('07:05');
insert into shift(hour) values('07:10');
insert into shift(hour) values('07:15');
insert into shift(hour) values('07:20');
insert into shift(hour) values('07:25');
insert into shift(hour) values('07:30');
insert into shift(hour) values('07:35');
insert into shift(hour) values('07:40');
insert into shift(hour) values('07:45');
insert into shift(hour) values('07:50');
insert into shift(hour) values('07:55');

insert into shift(hour) values('08:00');
insert into shift(hour) values('08:01');
insert into shift(hour) values('08:05');
insert into shift(hour) values('08:10');
insert into shift(hour) values('08:15');
insert into shift(hour) values('08:20');
insert into shift(hour) values('08:25');
insert into shift(hour) values('08:30');
insert into shift(hour) values('08:35');
insert into shift(hour) values('08:40');
insert into shift(hour) values('08:45');
insert into shift(hour) values('08:50');
insert into shift(hour) values('08:55');

insert into shift(hour) values('09:00');
insert into shift(hour) values('09:01');
insert into shift(hour) values('09:05');
insert into shift(hour) values('09:10');
insert into shift(hour) values('09:15');
insert into shift(hour) values('09:20');
insert into shift(hour) values('09:25');
insert into shift(hour) values('09:30');
insert into shift(hour) values('09:35');
insert into shift(hour) values('09:40');
insert into shift(hour) values('09:45');
insert into shift(hour) values('09:50');
insert into shift(hour) values('09:55');

insert into shift(hour) values('10:00');
insert into shift(hour) values('10:01');
insert into shift(hour) values('10:05');
insert into shift(hour) values('10:10');
insert into shift(hour) values('10:15');
insert into shift(hour) values('10:20');
insert into shift(hour) values('10:25');
insert into shift(hour) values('10:30');
insert into shift(hour) values('10:35');
insert into shift(hour) values('10:40');
insert into shift(hour) values('10:45');
insert into shift(hour) values('10:50');
insert into shift(hour) values('10:55');

insert into shift(hour) values('11:00');
insert into shift(hour) values('11:01');
insert into shift(hour) values('11:05');
insert into shift(hour) values('11:10');
insert into shift(hour) values('11:15');
insert into shift(hour) values('11:20');
insert into shift(hour) values('11:25');
insert into shift(hour) values('11:30');
insert into shift(hour) values('11:35');
insert into shift(hour) values('11:40');
insert into shift(hour) values('11:45');
insert into shift(hour) values('11:50');
insert into shift(hour) values('11:55');

insert into shift(hour) values('12:00');
insert into shift(hour) values('12:01');
insert into shift(hour) values('12:05');
insert into shift(hour) values('12:10');
insert into shift(hour) values('12:15');
insert into shift(hour) values('12:20');
insert into shift(hour) values('12:25');
insert into shift(hour) values('12:30');
insert into shift(hour) values('12:35');
insert into shift(hour) values('12:40');
insert into shift(hour) values('12:45');
insert into shift(hour) values('12:50');
insert into shift(hour) values('12:55');

insert into shift(hour) values('13:00');
insert into shift(hour) values('13:01');
insert into shift(hour) values('13:05');
insert into shift(hour) values('13:10');
insert into shift(hour) values('13:15');
insert into shift(hour) values('13:20');
insert into shift(hour) values('13:25');
insert into shift(hour) values('13:30');
insert into shift(hour) values('13:35');
insert into shift(hour) values('13:40');
insert into shift(hour) values('13:45');
insert into shift(hour) values('13:50');
insert into shift(hour) values('13:55');

insert into shift(hour) values('14:00');
insert into shift(hour) values('14:01');
insert into shift(hour) values('14:05');
insert into shift(hour) values('14:10');
insert into shift(hour) values('14:15');
insert into shift(hour) values('14:20');
insert into shift(hour) values('14:25');
insert into shift(hour) values('14:30');
insert into shift(hour) values('14:35');
insert into shift(hour) values('14:40');
insert into shift(hour) values('14:45');
insert into shift(hour) values('14:50');
insert into shift(hour) values('14:55');

insert into shift(hour) values('15:00');
insert into shift(hour) values('15:01');
insert into shift(hour) values('15:05');
insert into shift(hour) values('15:10');
insert into shift(hour) values('15:15');
insert into shift(hour) values('15:20');
insert into shift(hour) values('15:25');
insert into shift(hour) values('15:30');
insert into shift(hour) values('15:35');
insert into shift(hour) values('15:40');
insert into shift(hour) values('15:45');
insert into shift(hour) values('15:50');
insert into shift(hour) values('15:55');

insert into shift(hour) values('16:00');
insert into shift(hour) values('16:01');
insert into shift(hour) values('16:05');
insert into shift(hour) values('16:10');
insert into shift(hour) values('16:15');
insert into shift(hour) values('16:20');
insert into shift(hour) values('16:25');
insert into shift(hour) values('16:30');
insert into shift(hour) values('16:35');
insert into shift(hour) values('16:40');
insert into shift(hour) values('16:45');
insert into shift(hour) values('16:50');
insert into shift(hour) values('16:55');

insert into shift(hour) values('17:00');
insert into shift(hour) values('17:01');
insert into shift(hour) values('17:05');
insert into shift(hour) values('17:10');
insert into shift(hour) values('17:15');
insert into shift(hour) values('17:20');
insert into shift(hour) values('17:25');
insert into shift(hour) values('17:30');
insert into shift(hour) values('17:35');
insert into shift(hour) values('17:40');
insert into shift(hour) values('17:45');
insert into shift(hour) values('17:50');
insert into shift(hour) values('17:55');

insert into shift(hour) values('18:00');
insert into shift(hour) values('18:01');
insert into shift(hour) values('18:05');
insert into shift(hour) values('18:10');
insert into shift(hour) values('18:15');
insert into shift(hour) values('18:20');
insert into shift(hour) values('18:25');
insert into shift(hour) values('18:30');
insert into shift(hour) values('18:35');
insert into shift(hour) values('18:40');
insert into shift(hour) values('18:45');
insert into shift(hour) values('18:50');
insert into shift(hour) values('18:55');

insert into shift(hour) values('19:00');
insert into shift(hour) values('19:01');
insert into shift(hour) values('19:05');
insert into shift(hour) values('19:10');
insert into shift(hour) values('19:15');
insert into shift(hour) values('19:20');
insert into shift(hour) values('19:25');
insert into shift(hour) values('19:30');
insert into shift(hour) values('19:35');
insert into shift(hour) values('19:40');
insert into shift(hour) values('19:45');
insert into shift(hour) values('19:50');
insert into shift(hour) values('19:55');

insert into shift(hour) values('20:00');
insert into shift(hour) values('20:01');
insert into shift(hour) values('20:05');
insert into shift(hour) values('20:10');
insert into shift(hour) values('20:15');
insert into shift(hour) values('20:20');
insert into shift(hour) values('20:25');
insert into shift(hour) values('20:30');
insert into shift(hour) values('20:35');
insert into shift(hour) values('20:40');
insert into shift(hour) values('20:45');
insert into shift(hour) values('20:50');
insert into shift(hour) values('20:55');

insert into shift(hour) values('21:00');
insert into shift(hour) values('21:01');
insert into shift(hour) values('21:05');
insert into shift(hour) values('21:10');
insert into shift(hour) values('21:15');
insert into shift(hour) values('21:20');
insert into shift(hour) values('21:25');
insert into shift(hour) values('21:30');
insert into shift(hour) values('21:35');
insert into shift(hour) values('21:40');
insert into shift(hour) values('21:45');
insert into shift(hour) values('21:50');
insert into shift(hour) values('21:55');

insert into shift(hour) values('22:00');
insert into shift(hour) values('22:01');
insert into shift(hour) values('22:05');
insert into shift(hour) values('22:10');
insert into shift(hour) values('22:15');
insert into shift(hour) values('22:20');
insert into shift(hour) values('22:25');
insert into shift(hour) values('22:30');
insert into shift(hour) values('22:35');
insert into shift(hour) values('22:40');
insert into shift(hour) values('22:45');
insert into shift(hour) values('22:50');
insert into shift(hour) values('22:55');

insert into shift(hour) values('23:00');
insert into shift(hour) values('23:01');
insert into shift(hour) values('23:05');
insert into shift(hour) values('23:10');
insert into shift(hour) values('23:15');
insert into shift(hour) values('23:20');
insert into shift(hour) values('23:25');
insert into shift(hour) values('23:30');
insert into shift(hour) values('23:35');
insert into shift(hour) values('23:40');
insert into shift(hour) values('23:45');
insert into shift(hour) values('23:50');
insert into shift(hour) values('23:55');


-- 16/03
USE `oee`;
DROP procedure IF EXISTS `prc_oee`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`%` PROCEDURE `prc_oee`(
	in p_channel_id int,
	in p_date_ini varchar(20),
    in p_date_fin varchar(20),
    in p_machine_code varchar(10)
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
						  where cm.channel_id = p_channel_id
                            and ((cm.machine_code = p_machine_code) or ifnull(p_machine_code, '') = '');
	
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
		availability float(15,2),
		performance float(15,2),
		quality float(15,2),
		oee float(15,2)
	);
    
	drop temporary table if exists tmp_performance;
	create temporary table if not exists tmp_performance(
		machine_code varchar(10),
		field5 float(15,2),
		performance float(15,2)
	);
    
	drop temporary table if exists tmp_availability;
	create temporary table if not exists tmp_availability(
		machine_code varchar(10),
		pp float(15,2),
		pnp float(15,2)
	);    

	/*desempenho*/
	insert into tmp_performance
	select f.mc_cd
		 , cast(coalesce(f.field5,0) as decimal(15,2)) as field5
         , coalesce(case f.mc_cd 
			when 'EF3' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF4' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF5' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF6' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF7' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'RB1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'RB2' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'AB1' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'AB2' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'MAQ1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ2' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ3' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ4' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ5' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'LLC6' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC7' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC8' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC9' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC10' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC11' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC12' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC13' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'SEL1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
            else 0
		   end, 0) as performance 
	  from feed f 
	 inner join (select max(f.id) as id
				   from feed f
				  where f.ch_id = p_channel_id
                    and ((f.mc_cd = p_machine_code) or ifnull(p_machine_code, '') = '')
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
		  from machine_pause_dash mpd
		  left join pause_reason pr on pr.id = mpd.pause_reason_id
		 where mpd.channel_id = p_channel_id
           and ((mpd.machine_code = p_machine_code) or ifnull(p_machine_code, '') = '')
		   and mpd.date_ref between 
				   (STR_TO_DATE(p_date_ini, '%Y-%m-%d %H:%i:%s')) 
			   and (STR_TO_DATE(p_date_fin, '%Y-%m-%d %H:%i:%s'))
		 group by mpd.insert_index) a
	 group by a.machine_code, a.type) b
	 group by b.machine_code;

	-- if not exists(select 1 from tmp_performance) then
	-- 	signal sqlstate '45000' set message_text = 'sem dados';
	-- end if;
    
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
			 , @v_availability := if((field5 - coalesce(@v_pp,0)) = 0, 0.01, (field5 - coalesce(@v_pp,0)))
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

-- 30/03
USE `oee`;
DROP procedure IF EXISTS `prc_oee`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_oee`(
	in p_channel_id int,
	in p_date_ini varchar(20),
    in p_date_fin varchar(20),
    in p_machine_code varchar(10)
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
						  where cm.channel_id = p_channel_id
                            and ((cm.machine_code = p_machine_code) or ifnull(p_machine_code, '') = '');
	
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
		availability float(15,2),
		performance float(15,2),
		quality float(15,2),
		oee float(15,2)
	);
    
	drop temporary table if exists tmp_performance;
	create temporary table if not exists tmp_performance(
		machine_code varchar(10),
		field5 float(15,2),
		performance float(15,2)
	);
    
	drop temporary table if exists tmp_availability;
	create temporary table if not exists tmp_availability(
		machine_code varchar(10),
		pp float(15,2),
		pnp float(15,2)
	);    

	/*desempenho*/
	insert into tmp_performance
	select f.mc_cd
		 , cast(coalesce(f.field5,0) as decimal(15,2)) as field5
         /*, coalesce(case f.mc_cd 
			when 'EF3' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF4' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF5' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF6' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF7' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'RB1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'RB2' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'AB1' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'AB2' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'MAQ1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ2' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ3' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ4' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ5' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'LLC6' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC7' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC8' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC9' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC10' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC11' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC12' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC13' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'SEL1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
            else 0
		   end, 0) as performance */
		 , coalesce(round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2), 0) as performance 
	  from feed f 
	 inner join (select max(f.id) as id
				   from feed f
				  where f.ch_id = p_channel_id
                    and ((f.mc_cd = p_machine_code) or ifnull(p_machine_code, '') = '')
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
		  from machine_pause_dash mpd
		  left join pause_reason pr on pr.id = mpd.pause_reason_id
		 where mpd.channel_id = p_channel_id
           and ((mpd.machine_code = p_machine_code) or ifnull(p_machine_code, '') = '')
		   and mpd.date_ref between 
				   (STR_TO_DATE(p_date_ini, '%Y-%m-%d %H:%i:%s')) 
			   and (STR_TO_DATE(p_date_fin, '%Y-%m-%d %H:%i:%s'))
		 group by mpd.insert_index) a
	 group by a.machine_code, a.type) b
	 group by b.machine_code;

	-- if not exists(select 1 from tmp_performance) then
	-- 	signal sqlstate '45000' set message_text = 'sem dados';
	-- end if;
    
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
        
		select pp
			 , pnp
		  from tmp_availability 
		 where machine_code = v_machine_code
          into @v_pp, @v_pnp;
		        
		select performance
			 , if((field5 - coalesce(@v_pp,0)) = 0, 0.01, (field5 - coalesce(@v_pp,0)))
		  from tmp_performance 
		 where machine_code = v_machine_code
		  into @v_performance, @v_availability;
          
        set @v_real_availability = (@v_availability - coalesce(@v_pnp,0));  
		
		insert into tmp_oee(channel_id, machine_code, machine_name, availability, performance, quality, oee) 
		values (p_channel_id
			  , v_machine_code
              , v_machine_name
			  , round(((@v_real_availability / @v_availability)*100),2)
			  , round((@v_performance * 100),2)
			  , v_quality
			  , ((@v_performance * (@v_real_availability / @v_availability) * 1) * 100) 
		);
        -- para evitar casos onde não tem dados nos selects dentro do loop
		set v_done = false;
	end loop;

	close c;
	select * from tmp_oee; 
end$$

DELIMITER ;







