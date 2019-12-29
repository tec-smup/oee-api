USE `oee`;

CREATE TABLE sponsor (
  id int(11) NOT NULL AUTO_INCREMENT,
  channel_id int(11) not null,
  name varchar(100) NOT NULL,
  email varchar(100) NOT NULL,
  PRIMARY KEY (id)
);
alter table sponsor add constraint fk_channel foreign key(channel_id) references channel(id);

CREATE TABLE alert (
  id int(11) NOT NULL AUTO_INCREMENT,
  channel_id int(11) NOT NULL,
  sponsor_id int(11) not null,
  pause_reason_id int(11) not null,
  pause_time tinyint not null,
  PRIMARY KEY (id)
);
alter table alert add constraint fk_channel foreign key(channel_id) references channel(id);
alter table alert add constraint fk_sponsor foreign key(sponsor_id) references sponsor(id);
alter table alert add constraint fk_pause_reason foreign key(pause_reason_id) references pause_reason(id);

DROP procedure IF EXISTS `prc_sponsor`;

DELIMITER $$
CREATE PROCEDURE `prc_sponsor`(
	in p_channel_id int(11),
    in p_name varchar(100),
    in p_email varchar(100)
)
begin   
	if exists (select 1 from sponsor where channel_id = p_channel_id and email = p_email) then 
		signal sqlstate '99999'
		set message_text = 'Responsável informado já existe';
    end if;
    insert into sponsor(channel_id, name, email)
    values(p_channel_id, p_name, p_email);
     
     select s.id as sponsor_id
            , s.channel_id
            , c.name channel_name
            , s.name as sponsor_name
            , s.email
        from sponsor s
        inner join channel c on c.id = s.channel_id
        where s.id = LAST_INSERT_ID();
     
end$$

DELIMITER ;


DROP procedure IF EXISTS `prc_alert`;

DELIMITER $$
CREATE PROCEDURE prc_alert (
	in p_channel_id int(11),
    in p_sponsor_id int(11),
    in p_pause_reason_id int(11),
    in p_pause_time tinyint
)
BEGIN
	if exists (select 1 
				 from alert 
				where channel_id = p_channel_id 
                  and sponsor_id = p_sponsor_id 
                  and pause_reason_id = p_pause_reason_id
                  and pause_time = p_pause_time) then 
		signal sqlstate '99999'
		set message_text = 'Configuração de alerta já existe';
    end if;
    insert into alert(channel_id, sponsor_id, pause_reason_id, pause_time)
    values(p_channel_id, p_sponsor_id, p_pause_reason_id, p_pause_time);
    
	select a.id
		, a.channel_id
		, c.name as channel_name
		, a.sponsor_id
		, s.name as sponsor_name
		, a.pause_reason_id
		, pr.name as pause_reason_name
		, case a.pause_time
			when 0 then 'Imediato'
            when 5 then '5 minutos'
            when 10 then '10 minutos'
            when 30 then '30 minutos'
		  end as pause_time
	from alert a
	inner join channel c on c.id = a.channel_id
	inner join sponsor s on s.id = a.sponsor_id
	inner join pause_reason pr on pr.id = a.pause_reason_id
	where a.id = LAST_INSERT_ID();  
END$$
DELIMITER ;


DROP procedure IF EXISTS `prc_delete_sponsor`;

DELIMITER $$
CREATE PROCEDURE prc_delete_sponsor (
	in p_id int(11)
)
BEGIN
    delete from alert where sponsor_id = p_id;
    delete from sponsor where id = p_id;
END$$

DELIMITER ;

DROP procedure IF EXISTS `prc_delete_alert`;

DELIMITER $$
CREATE PROCEDURE prc_delete_alert (
	in p_id int(11)
)
BEGIN
	delete from alert where id = p_id;
END$$

DELIMITER ;




