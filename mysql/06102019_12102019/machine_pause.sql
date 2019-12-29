delete from machine_pause;

alter table machine_pause drop column date_ref;
alter table machine_pause drop column justification;

alter table machine_pause add start_date datetime;
alter table machine_pause add end_date datetime;
alter table machine_pause add pause_reason_id int;
alter table machine_pause add constraint fk_pause_reason_id foreign key(pause_reason_id) references pause_reason(id);

USE `oee`;
DROP procedure IF EXISTS `prc_machine_pause`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_machine_pause`(
	in p_token varchar(50),
	in p_mc_cd varchar(10),
	in p_pause int,
	in p_start_date varchar(20),
    in p_end_date varchar(20),
	in p_pause_reason_id varchar(5000)
)
BEGIN
	declare v_count int(11);
    
    select count(*) into v_count 
      from channel 
	 where token = p_token;
     
    /*canal não existe ou token está duplicado*/
	if (v_count = 0 or v_count > 1) then 
		signal sqlstate '99999'
		set message_text = 'Token inválido';
    end if;      

    insert into machine_pause(
		mc_cd, 
		pause, 
        start_date, 
        end_date,
        pause_reason_id
	)
    values(
		p_mc_cd, 
        p_pause, 
        STR_TO_DATE(p_start_date, '%Y-%m-%d %H:%i:%s'),
        STR_TO_DATE(p_end_date, '%Y-%m-%d %H:%i:%s'),
        p_pause_reason_id
	);
END$$

DELIMITER ;



