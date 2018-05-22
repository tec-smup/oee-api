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
);

create table feed_config
(
    id int not null auto_increment primary key,
    channel_id int not null,
    field1 varchar(100) not null,
    field2 varchar(100) not null,
    field3 varchar(100) not null,
    field4 varchar(100) not null,
    field5 varchar(100) not null
);
alter table feed_config add constraint fk_feed_config_channel foreign key(channel_id) references channel(id);

create table feed 
(
	id int not null auto_increment primary key,
    ch_id int not null,
    mc_cd varchar(10) null,
    field1 varchar(100) null,
    field2 float(8,2) null,
    field3 float(8,2) null,
    field4 float(8,2) null,
    field5 varchar(100) null,
	inserted_at timestamp not null default CURRENT_TIMESTAMP
);
alter table feed add constraint fk_feed_channel foreign key(ch_id) references channel(id);
alter table feed add constraint fk_feed_machine_data foreign key(mc_cd) references machine_data(code);

create table machine_data
(
    code varchar(10) not null primary key,
    name varchar(20) not null,
    department varchar(100) null,
    product varchar(100) null,
    last_maintenance date null,
    next_maintenance date null
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_machine_data`(
	in p_code varchar(10),
    in p_name varchar(20),
    in p_department varchar(100),
    in p_product varchar(100),
    in p_last_maintenance date,
    in p_next_maintenance date
)
begin   
	if exists (select 1 from machine_data where code = p_code) then 
		signal sqlstate '99999'
		set message_text = 'Código informado já existe';
    end if;
    insert into machine_data(code, name, department, product, last_maintenance, next_maintenance)
    values(p_code, p_name, p_department, p_product, p_last_maintenance, p_next_maintenance);
end$$

DELIMITER ;
/*prc_machine_data*/

/*prc_delete_machine_data*/
DROP procedure IF EXISTS `prc_delete_machine_data`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_delete_machine_data`(in p_code varchar(10))
BEGIN
    set @msg = concat('Não é possível excluir a máquina ', p_code, '. Existem dados de medições vinculados a ela.');
	if exists (select 1 from feed where mc_cd = p_code) then 
		signal sqlstate '99999'
		set message_text = @msg;
    end if;
    delete from machine_data where code = p_code;
END$$

DELIMITER ;
/*prc_delete_machine_data*/


/*prc_delete_channel*/
DROP procedure IF EXISTS `prc_delete_channel`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_delete_channel`(in p_channel_id int)
BEGIN
	set @name = (select name from channel where id = p_channel_id);
    
    set @msg = concat('Não é possível excluir o canal ', @name, '. Existem dados de medição vinculados a ele.');
    
	if exists (select 1 from feed where ch_id = p_channel_id) then 
		signal sqlstate '99999'
		set message_text = @msg;
    end if;
    delete from channel where id = p_channel_id; 
END$$

DELIMITER ;
/*prc_delete_channel*/

/*prc_channel*/
DROP procedure IF EXISTS `prc_channel`;

DELIMITER $$
CREATE PROCEDURE `prc_channel` (
	in p_name varchar(100),
    in p_description varchar(500),
    in p_token varchar(50),
    in p_active bit,
    in p_time_shift int(11)
)
BEGIN
	if exists (select 1 from channel where token = p_token) then 
		signal sqlstate '99999'
		set message_text = 'Token informado já existe';
    end if;
    insert into channel(name, description, token, active, created_at, updated_at, time_shift)
    values(p_name, p_description, p_token, p_active, now(), now(), p_time_shift);
END$$

DELIMITER ;
/*prc_channel*/

/*prc_machine_pause*/
DROP procedure IF EXISTS `prc_machine_pause`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE prc_machine_pause (
	in p_mc_cd varchar(10),
	in p_pause_ini datetime,
	in p_pause_fin datetime,
	in p_justification1 varchar(300),
    in p_justification2 varchar(300),
    in p_justification3 varchar(300)
)
BEGIN
	if exists (
		select 1 from machine_pause 
         where mc_cd = p_mc_cd
           and pause_ini = p_pause_ini
           and pause_fin = p_pause_fin
    ) then 
		signal sqlstate '99999'
		set message_text = 'Pausa com dados informados já existe';
    end if;
    insert into machine_pause(mc_cd, pause_ini, pause_fin, justification1, justification2, justification3)
    values(p_mc_cd, p_pause_ini, p_pause_fin, p_justification1, p_justification2, p_justification3);
END$$

DELIMITER ;
/*prc_machine_pause*/

/*prc_delete_machine_pause*/
DROP procedure IF EXISTS `prc_delete_machine_pause`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE prc_delete_machine_pause (in p_id int)
BEGIN
	delete from machine_pause where id = p_id; 
END$$

DELIMITER ;
/*prc_delete_machine_pause*/

/*stored procedures*/