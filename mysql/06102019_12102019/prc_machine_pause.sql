ALTER TABLE machine_pause DROP FOREIGN KEY fk_pause_reason_id;

alter table machine_pause modify start_date varchar(20);
alter table machine_pause modify end_date varchar(20);

DROP procedure IF EXISTS `prc_machine_pause`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_machine_pause`(
	in p_token varchar(50),
    in p_id int,
	in p_mc_cd varchar(10),
	in p_pause int,
	in p_start_date varchar(20),
    in p_end_date varchar(20),
	in p_pause_reason_id int,
    out p_new_id int
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
    
    if(p_id = 0) then
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
            p_start_date,
            p_end_date,
			/*STR_TO_DATE(p_start_date, '%Y-%m-%d %H:%i:%s'),
			STR_TO_DATE(p_end_date, '%Y-%m-%d %H:%i:%s'),*/
			p_pause_reason_id
		); 
		set p_new_id = LAST_INSERT_ID();
    else
		update machine_pause 
		   set end_date = p_end_date,
			   pause = p_pause,
               pause_reason_id = p_pause_reason_id 
		 where id = p_id;
        set p_new_id = p_id;
    end if;

END$$

DELIMITER ;

