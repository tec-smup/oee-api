insert 
  into commands(channel_id, type, query) 
values(
	14, 
    'production',
	'select b.tipo
		 , b.hora
		 , replace(b.hora,\':00\',\'\') as hora_short
		 , greatest(round(if(@ordem > 0, b.MAQ_SQB10 - @MAQ_SQB10, b.MAQ_SQB10),2),0) as `COL_SQBI10`
		 , greatest(round(if(@ordem > 0, b.MAQ_SQBI12 - @MAQ_SQBI12, b.MAQ_SQBI12),2),0) as `COL_SQBI12`
		 , greatest(round(if(@ordem > 0, b.MAQ_LB02 - @MAQ_LB02, b.MAQ_LB02),2),0) as `COL_LB02`
		 , greatest(round(if(@ordem > 0, b.MAQ_CABP031 - @MAQ_CABP031, b.MAQ_CABP031),2),0) as `COL_CABP3-1`
		 , greatest(round(if(@ordem > 0, b.MAQ_CABP032 - @MAQ_CABP032, b.MAQ_CABP032),2),0) as `COL_CABP3-2`
		 , greatest(round(if(@ordem > 0, b.total - @total, b.total),2),0) as total
		 , greatest(round(if(@ordem > 0, b.taxa - @taxa, b.taxa),2),0) as taxa
		 , @ordem := b.ordem as ordem
		 , @MAQ_SQB10 := b.MAQ_SQB10 as v_MAQ_SQB10
		 , @MAQ_SQBI12 := b.MAQ_SQBI12 as v_MAQ_SQBI12
		 , @MAQ_LB02 := b.MAQ_LB02 as v_MAQ_LB02
		 , @MAQ_CABP031 := b.MAQ_CABP031 as v_MAQ_CABP031
		 , @MAQ_CABP032 := b.MAQ_CABP032 as v_MAQ_CABP032
		 , @total := b.total as v_total
		 , @taxa := b.taxa as v_taxa_ref
	  from (
		select a.tipo
			 , a.hora
			 , sum(a.SQB10) as MAQ_SQB10
			 , sum(a.SQBI12) as MAQ_SQBI12
			 , sum(a.LB02) as MAQ_LB02
			 , sum(a.CABP031) as MAQ_CABP031
			 , sum(a.CABP032) as MAQ_CABP032
			 , (sum(a.SQB10) + sum(a.SQBI12) + sum(a.LB02) + sum(CABP031) + sum(CABP032)) as total
			 , ((((sum(a.SQB10) + sum(a.SQBI12) + sum(a.LB02) + sum(CABP031) + sum(CABP032)) / 60) * 100) / 100) as taxa
			 , a.ordem
		  from (
			select max(id) as id
				 , mc_cd
				 , concat(hour(inserted_at), \':00 - \', case hour(inserted_at) when 23 then \'00\' else hour(inserted_at)+1 end, \':00\') as hora
				 , (case mc_cd when \'SQB10\' then ifnull(round(max(field3),2),0)  else 0 end) as SQB10
				 , (case mc_cd when \'SQBI12\' then ifnull(round(max(field3),2),0)  else 0 end) as SQBI12
				 , (case mc_cd when \'LB02\' then ifnull(round(max(field3),2),0)  else 0 end) as LB02
				 , (case mc_cd when \'CABP031\' then ifnull(round(max(field3),2),0)  else 0 end) as CABP031
				 , (case mc_cd when \'CABP032\' then ifnull(round(max(field3),2),0)  else 0 end) as CABP032
				 , \'M/Hora\' as tipo
				 , hour(inserted_at) ordem
				from feed
				where ch_id = __ch_id
				and mc_cd in(\'SQB10\', \'SQBI12\', \'LB02\', \'CABP031\', \'CABP032\')
				and inserted_at between 
				   (STR_TO_DATE(\'__date_ini\', \'%Y-%m-%d %H:%i:%s\')) 
				and (STR_TO_DATE(\'__date_fin\', \'%Y-%m-%d %H:%i:%s\'))
			  group by mc_cd, day(inserted_at), hour(inserted_at)
			  order by hour(inserted_at), mc_cd
		) a
		group by a.hora, a.ordem, a.tipo
		order by a.tipo, a.ordem
	) b,
	(select @ordem := 0, @MAQ_SQB10 := 0, @MAQ_SQBI12 := 0, @MAQ_LB02 := 0, @MAQ_CABP031 := 0, @MAQ_CABP032 := 0, @total := 0, @taxa := 0) SQLVars;'
);