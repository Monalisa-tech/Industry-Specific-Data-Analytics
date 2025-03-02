----Data-Driven analysis of Vehicle Theft Trends---
Create database Vehicle_Theftdb
use Vehicle_Theftdb

----Stolen_Vehicle Table1----

create table st_veh
(Vehicle_id varchar(max),Vehicle_type varchar(max),make_id varchar(max),model_year varchar(max),Vehicle_desc varchar(max),color varchar(max),date_stolen varchar(max), location_id varchar(max))

Bulk insert st_veh
from 'C:\Users\USER\Desktop\stolen_vehicles.csv'
with (fieldterminator=',',rowterminator='\n', firstrow=2,maxerrors=20)

select* from st_veh

----make details table2---
create table make_d
(make_id varchar(max),make_name  varchar(max),make_type varchar(max))

Bulk insert make_d
from 'C:\Users\USER\Desktop\make_details.csv'
with (fieldterminator=',',rowterminator='\n', firstrow=2,maxerrors=20)

select* from make_d


------Locations Table3----
create table locations
(location_id varchar(max),region varchar(max),country varchar(max),population varchar(max),density varchar(max))

Bulk insert locations
from 'C:\Users\USER\Desktop\locations.csv'
with (fieldterminator=',',rowterminator='\n', firstrow=2,maxerrors=20)

select * from locations




select date_stolen,TRY_CONVERT(varchar(40),date_stolen) as formatted_date from st_veh
where TRY_CONVERT(varchar(40),date_stolen,105) is null

select date_stolen,TRY_CONVERT(date,date_stolen,105) as formatted_date from st_veh
where TRY_CONVERT(date,date_stolen) is null

select date_stolen,TRY_CONVERT(date,date_stolen) as formatted_date from st_veh
where TRY_CONVERT(varchar(40),date_stolen,105) is null

select* from st_veh
where isdate(date_stolen)=0

update st_veh set date_stolen=case when date_stolen='2021/15/10' then '2021-10-15'
                               when date_stolen='13-02-2022' then '2022-02-13'
							   else date_stolen end

update st_veh set date_stolen=convert(date,date_stolen)

alter table st_veh
alter column date_stolen date

select * from st_veh

select * from locations

alter table locations
alter column population int

alter table locations
alter column density decimal(5,2)

select* from st_veh
select count(*) from st_veh
select distinct count(*) from st_veh


select count(*) from locations
select distinct count(*) from locations

select distinct vehicle_type from st_veh

select vehicle_type,color,count(vehicle_id) as 'no_of_veh_stolen' from st_veh
group by Vehicle_type,color
order by no_of_veh_stolen desc

update st_veh set Vehicle_type='unknown_type'
where Vehicle_type is null

select distinct vehicle_type,vehicle_desc from st_veh
where Vehicle_desc is null

update st_veh set Vehicle_desc='not-provided'
where Vehicle_desc is null


select distinct vehicle_type,vehicle_desc from st_veh
where Vehicle_desc='not-provided'

select distinct  vehicle_type,vehicle_desc from st_veh
where vehicle_desc like 'D%' and vehicle_type='Boat trailer'

select distinct model_year  from st_veh

select min(model_year) as 'oldest_model_year', max(model_year) as 'latest_model_year' from st_veh

selcet*, case when model_year between 1940 and 1960 then  'vintage model'
              when model_year between 1961 and 1990 then  'classic model'
			   when model_year between 1991 and 2018 then  'oldest model'
              when model_year>2018 then 'vintage model'
			  else 'unknown' end as 'Model_group'  from st_veh

alter table st_veh
add model_group varchar(40)

update st_veh set model_year= case when model_year between 1940 and 1960 then  'vintage model'
              when model_year between 1961 and 1990 then  'classic model'
			   when model_year between 1991 and 2018 then  'oldest model'
              else 'latest model' end

alter table st_veh
drop column model_year

create table st_veh1
(Vehicle_id varchar(max),Vehicle_type varchar(max),make_id varchar(max),model_year varchar(max),Vehicle_desc varchar(max),
color varchar(max),date_stolen varchar(max), location_id varchar(max))

Bulk insert st_veh1
from 'C:\Users\USER\Desktop\stolen_vehicles.csv'
with (fieldterminator=',',rowterminator='\n', firstrow=2,maxerrors=20)

alter table st_veh
add model_year varchar(max)

Update st_veh set model_year=st_veh1.model_year
from st_veh 
join st_veh1 
on st_veh.Vehicle_id=st_veh1.Vehicle_id

select * from st_veh
drop table st_veh1

update st_veh set model_group= case when model_year between 1940 and 1960 then  'vintage model(1940-60)'
              when model_year between 1961 and 1990 then  'classic model(1961-90)'
			   when model_year between 1991 and 2018 then  'oldest model(1991-2018)'
              else 'latest model(>2018)' end


select model_group,vehicle_type,count(vehicle_id) as 'total_st_veh_count' from st_veh
group by model_group,Vehicle_type
order by total_st_veh_count desc

select model_group,vehicle_type,vehicle_desc,count(vehicle_id) as 'total_st_veh_count' from st_veh
group by model_group,Vehicle_type,vehicle_desc
order by total_st_veh_count desc
-----create a stolen_vehicle profile report----trend analysis/insights/Determine that the thift are inc or dec within the trend and luxury brand or not/Risk Vehicle type/Geogrophical thieft hotspot

with st_veh_prof as(select st.vehicle_id,m.make_id,l.location_id,vehicle_type,vehicle_desc,color,model_group,model_year,make_name,make_type,region,population,density from st_veh st
join locations l
on st.location_id=l.location_id
join make_d m
on st.make_id=m.make_id)
select region,count(vehicle_id) as'stolencnt',
count(distinct make_name) as 'make',
count(distinct color) as 'color',
count(model_year) as 'M_year',
avg(cast(population as float)) as 'avg_pop',
avg(density) as'Avg_den'
from st_veh_prof 
group by region
order by avg_pop desc  

------Monthly Theft Trend Analysis----
with monthly_theft as (select l.location_id,region,datename(month,date_stolen) as 'theft_month'
,count(Vehicle_id) as 'no_of_vehicle_stolen'
from st_veh st
join locations l
on st.location_id=l.location_id
group by l.location_id,region,datename(month,date_stolen))
,theft_pr as(select mt.location_id,mt.region,mt.theft_month, mt.no_of_vehicle_stolen as 'Monthly_cnt',
LEAD(mt.no_of_vehicle_stolen) over(partition by mt.location_id order by mt.theft_month) as 'next_month_theft' 
from monthly_theft mt)
select*from theft_pr
where monthly_cnt<next_month_theft 

---Analyse longterm trend by using 3 month rolling avg of stolen_veh--

with yearly_theft as (select l.location_id,region,year(date_stolen) as 'the_year',month(date_stolen) as 'the_month'
,count(Vehicle_id) as 'no_of_vehicle_stolen'
from st_veh st
join locations l
on st.location_id=l.location_id
group by l.location_id,region,year(date_stolen),month(date_stolen))
,theft_trends as(select yt.location_id,yt.region,yt.the_year,yt.the_month, yt.no_of_vehicle_stolen as 'Monthly_cnt',
Avg(yt.no_of_vehicle_stolen) over(partition by yt.location_id,yt.the_year order by yt.the_month rows between 2 preceding and current row) as 'Rolling_avg' 
from yearly_theft yt)
select*from theft_trends
order by region,the_year,the_month


with yearly_theft as (select l.location_id,region,year(date_stolen) as 'the_year',month(date_stolen) as 'the_month'
,count(Vehicle_id) as 'no_of_vehicle_stolen'
from st_veh st
join locations l
on st.location_id=l.location_id
group by l.location_id,region,year(date_stolen),month(date_stolen))
,theft_trends as(select yt.location_id,yt.region,yt.the_year,yt.the_month, yt.no_of_vehicle_stolen as 'Monthly_cnt',
Avg(yt.no_of_vehicle_stolen) over(partition by yt.location_id,yt.the_year order by yt.the_month rows between 2 preceding and current row) as '3_mnth_Rolling_avg' 
from yearly_theft yt)
select*from theft_trends
order by region,the_year,the_month

select distinct year(date_stolen),month(date_stolen) from st_veh

------will calculate the probility fo each make within a vehicle type---
select*from make_d

select make_type,count(vehicle_id)as 'total_st_cnt' from make_d m
join st_veh st
on m.make_id=st.make_id
group by make_type

select vehicle_type,make_id,count(vehicle_id)as 'theft_cnt' from st_veh
group by Vehicle_type,make_id
having count(vehicle_id)>50 

with veh_counts as (select vehicle_type, make_name, m.make_id, m.make_type,count(vehicle_id)as 'theft_cnt' from st_veh st
join make_d m
on st.make_id=m.make_id
group by Vehicle_type, m.make_id,make_name,make_type
having count(vehicle_id)>0)

select make_name,vehicle_type,theft_cnt,make_type,
(theft_cnt*1.0/sum(theft_cnt) over (partition by vehicle_type))*100 as 'theft_probability' from veh_counts
order by theft_probability desc 


-----correlation with population and density----
select l.region,population,density,count(vehicle_id) as 'theft_cnt',
count(vehicle_id)*1.0/density as 'theft_per_density'
from st_veh st
join locations l
on  st.location_id=l.location_id
group by region,population,density
order by theft_per_density desc 
-----checking the weekday/weekends trend of the theft rate---
with weekly_ranking as(select datename(weekday,date_stolen) as 'Day_names',count(vehicle_id) as 'veh_stolen_cnt',
rank() over(order by count(vehicle_id)desc) as 'Top_rank',
rank() over(order by count(vehicle_id) ) as 'Bottom_rank' from st_veh
group by datename(weekday,date_stolen))
select day_names,veh_stolen_cnt,case when top_rank<=3 then 'Top' +cast(top_rank as varchar(5))
                                    when  bottom_rank<=3 then 'Bottom' +cast(bottom_rank as varchar(5))

									else 'NA' end as ranking_lable from weekly_ranking

		order by case when top_rank<=3 then top_rank 
                                    when  bottom_rank<=3 then (bottom_rank+3) else 4 end 

