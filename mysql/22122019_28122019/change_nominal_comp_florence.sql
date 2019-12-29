update commands set query = '
select b.hora
	 , b.hora_short
     , b.production
     , b.nominal
     , (b.nominal - b.production) as diff
     , round(((b.production / b.nominal)*100),2) as eficiency     
  from (
	select a.hora
		 , replace(a.hora,\':00\',\'\') as hora_short
		 , greatest(if(@ordem > 0, a.production - @production, a.production),0) as production
		 , greatest(if(@ordem > 0, a.nominal - @nominal, a.nominal),0) as nominal
		 , @ordem := a.ordem as ordem
		 , @production := a.production as v_production
		 , @nominal := a.nominal as v_nominal
	  from (	
		select f.id
			 , f.mc_cd
			 , concat(hour(f.inserted_at), \':00 - \', if(hour(f.inserted_at)+1 > 23, \'00\', hour(f.inserted_at)+1), \':00\') as hora
			 , ifnull(round(sum(f.field3),0),0) as production
			 , ifnull(round(sum(m.nominal_output * f.field5),0),0) as nominal
			 , hour(f.inserted_at) ordem
			from feed f
			inner join (select max(id) as id
						  from feed
						 where ch_id = __ch_id
						   and mc_cd = \'__mc_cd\'
						   and inserted_at between 
							   (STR_TO_DATE(\'__date_ini\', \'%Y-%m-%d %H:%i:%s\')) 
						   and (STR_TO_DATE(\'__date_fin\', \'%Y-%m-%d %H:%i:%s\'))
                         group by mc_cd, date_format(inserted_at, \'%d%m%Y\'), hour(inserted_at)
						 order by date_format(inserted_at, \'%d%m%Y\'), hour(inserted_at), mc_cd) ids on ids.id = f.id
			inner join machine_data m on m.code = f.mc_cd	
            group by hour(inserted_at)
	) a,
	(select @ordem := 0, @production := 0, @nominal := 0) SQLVars
) b;'
where channel_id = 14
and type = 'machine_comparative_prod_nominal';