
with cte
as (
	select
		 c."Campaign_key"
		,max(c."AmountInUSD") "Max_AmountInUSD"
	from
		charges c
	group by
		c."Campaign_key"
)
select
	 w."Campaign_name"
    ,c."ClientID"
    ,c."Event_date"
from
		 widgets w
    ----
    join charges c
		on w."Campaign_key" = c."Campaign_key"
        and w."Company_name" <> 'My_company'
        and NOT exists (
					select 
						1 
					from 
						websites_events we 
					where 
							c."ClientID" = we."ClientID"
                        and we."EventType" = 'elementView'
                        and we."EventTime" >= c."Event_date"
                        and we."EventTime" < c."Event_date" + interval '1 day' -- postgres
				)
		and exists (
					select
						2
					from
						cte cte
					where
							w."Campaign_key" = cte."Campaign_key"
                        and c."AmountInUSD" = cte."Max_AmountInUSD"
				);