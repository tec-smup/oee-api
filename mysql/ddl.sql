create database oee;

use oee;

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

create table machine_pause
(
	id int not null primary key,
    mc_cd varchar(10) not null,
    pause_at date not null,
    justification1 varchar(300) null,
    justification2 varchar(300) null,
    justification3 varchar(300) null
);
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