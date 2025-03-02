-----BFSI domain dataset:High Profile loan given by the banking institution to Business (risk assessment for high-profile loan portfolios)----
---*/We need to analyse the financial health and risk associated with the pattern----

create database BFSI_db
use BFSI_db

create table loan_portfolio
(loan_id varchar(max),funded_amount varchar(max),funded_date varchar(max),duration_years varchar(max),duration_months varchar(max),
Ten_yr_treasury_index_date_funded varchar(max),interest_rate_percent varchar(max),interest_rate varchar(max), payments varchar(max),total_past_payments varchar(max),loan_balance varchar(max),property_value varchar(max),
purpose varchar(max),firstname varchar(max),middlename varchar(max),lastname varchar(max),social varchar(max),phone varchar(max),Title varchar(max),
employement_length varchar(max),BUILDING_CLASS_CATEGORY varchar(max),TAX_CLASS_AT_PRESENT varchar(max),BUILDING_CLASS_AT_PRESENT varchar(max),ADDRESS1 varchar(max),
ADDRESS2 varchar(max),ZIPCOD varchar(max),CITY varchar(max),STATE varchar(max),TOTALUNITS varchar(max),LANDSQUAREFEET varchar(max),GROSSSQUAREFEET varchar(max),
TAXCLASSAT_TIME_OF_SALE varchar(max))

Bulk insert loan_portfolio
from 'C:\Users\USER\Desktop\LoanPortfolio.csv'
with (fieldterminator=',',rowterminator='\n',firstrow=2)

select * from loan_portfolio

---change the data type as per their data---

select column_name,DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS



alter table loan_portfolio
alter column TOTALUNITS int

alter table loan_portfolio
alter column total_past_payments int

alter table loan_portfolio
alter column employement_length int

alter table loan_portfolio
alter column duration_years int

alter table loan_portfolio
alter column duration_months int

alter table loan_portfolio
alter column funded_amount money

alter table loan_portfolio
alter column property_value money

alter table loan_portfolio
alter column payments money

alter table loan_portfolio
alter column Ten_yr_treasury_index_date_funded float

alter table loan_portfolio
alter column interest_rate_percent float

alter table loan_portfolio
alter column interest_rate float

alter table loan_portfolio
alter column funded_date date

alter table loan_portfolio
alter column loan_balance money


select * from loan_portfolio
-----Number of loan customer data is 1678 in record---
select distinct loan_id from loan_portfolio

----The period of data for the loan--
select min (funded_date) as 'firstloandate',max(funded_date) as'lastdaterecorded',DATEDIFF(day,min (funded_date), max(funded_date)) as 'total_days' from loan_portfolio
 
 select min (funded_date) as 'firstloandate',max(funded_date) as'lastdaterecorded',DATEDIFF(YEAR,min (funded_date), max(funded_date)) as 'total_years' from loan_portfolio

 ----we have a purpose attribute,where we can see the distribution of loan_funded betwwen the various purpose----
 select distinct purpose from loan_portfolio

 ---Analyse the purpose wise funded_amount distribution---
 select purpose,count(loan_id) as 'total_loans',sum(funded_amount) as 'total_funded_amt',avg(funded_amount) as 'avg_funded_amount' from loan_portfolio
 group by purpose
 order by total_loans desc

 ---how distribution managed by each year---
 select purpose,year(funded_date) as 'the_year',count(loan_id) as 'total_loans',sum(funded_amount) as 'total_funded_amt',avg(funded_amount) as 'avg_funded_amount' from loan_portfolio
 group by purpose,year(funded_date)
 order by the_year 

 ---for the year of 2012/the commercial property is the highest  as per the data----
 select purpose,year(funded_date) as 'the_year',count(loan_id) as 'total_loans',sum(funded_amount) as 'total_funded_amt',avg(funded_amount) as 'avg_funded_amount' from loan_portfolio
 where year(funded_date)=2012
 group by purpose,year(funded_date)
 order by total_loans desc 

 ---Analyse year wise highest loan with purpose -----

with funded_dist as
 (select purpose,year(funded_date) as 'the_year',count(loan_id) as 'total_loans',sum(funded_amount) as 'total_funded_amt',avg(funded_amount) as 'avg_funded_amount',
 ROW_NUMBER() over(partition by year(funded_date) order by count(loan_id)desc) as row_num from loan_portfolio
 group by purpose,year(funded_date))
 select*from funded_dist
 where row_num=1

 -----*/ outcome:top funded purpose loan/commercial property/home/investment property/*----

 ---- statistics rang of funded amount----
 select min(funded_amount) as 'min_value_funded',avg(funded_amount) as 'mean_value',max(funded_amount) as 'max_value_funded' from loan_portfolio

 select*from loan_portfolio
 where funded_amount between  440000 and 1848829
 select 1259.00/1678.00   ----*/75% data is under min and avg value and 25% is on upper limit/*----

 -----*/segment1(low)-600000/segment2(avg range)-600001 to 1000000/segment3(max)-1000000/*---

 select purpose,count(loan_id) as 'total_loans',case when funded_amount<=600000 then 'low_segment'
                                                     when funded_amount between 600001 and 1000000 then 'medium_segment' else 'high_segment' end as 'loan_segment'
													 from loan_portfolio


	group by purpose,case when funded_amount<=600000 then 'low_segment'
                                                     when funded_amount between 600001 and 1000000 then 'medium_segment' else 'high_segment' end

	order by total_loans desc 

	----Organisation wants to segregate the customers based on their intrest rate applicable to their loans---
	select distinct interest_rate from loan_portfolio

	select distinct interest_rate_percent from loan_portfolio

	---(Distinct interest rang 2,3,4)--

	select*from loan_portfolio
	where interest_rate_percent<3.0   

	select*from loan_portfolio
	where interest_rate_percent between 3.0 and 4.0 

	select*from loan_portfolio
	where interest_rate_percent>4.0

	------Result 32 loanid are under 3percent and range 3-4) is 1096 (range 4-5) is 550--
	select 32+1096+550

	select min(funded_amount) as 'min_value_funded',avg(funded_amount) as 'mean_value',max(funded_amount) as 'max_value_funded' from loan_portfolio
	where BFSI_db.dbo.loan_portfolio.interest_rate_percent<3.0

	select case when funded_amount<12500000 and interest_rate_percent<3.0 then 'segment1'
	when funded_amount between 12500000 and 25000000 and interest_rate_percent between 3.0 and 4.0  then 'segment2'
	else 'segment3' end as 'customer_segments',avg(loan_balance) as 'loanamtpending' from loan_portfolio
	group by case when funded_amount<12500000 and interest_rate_percent<3.0 then 'segment1'
	when funded_amount between 12500000 and 25000000 and interest_rate_percent between 3.0 and 4.0  then 'segment2'
	else 'segment3' end 


	select min(funded_amount) as 'min_value_funded',avg(funded_amount) as 'mean_value',max(funded_amount) as 'max_value_funded' from loan_portfolio
	where BFSI_db.dbo.loan_portfolio.interest_rate_percent>4.0

	select case when funded_amount<12500000 and interest_rate_percent<4.0 then 'segment1'
	when funded_amount between 12500000 and 15000000 and interest_rate_percent<=3.0 then 'segment2'
	else 'segment3' end as 'customer_segments',avg(loan_balance) as 'loanamtpending' from loan_portfolio
	group by case when funded_amount<12500000 and interest_rate_percent<4.0 then 'segment1'
	when funded_amount between 12500000 and 15000000 and interest_rate_percent<=3.0 then 'segment2'
	else 'segment3' end


	select distinct property_value from  loan_portfolio

	select * from loan_portfolio
	where BFSI_db.dbo.loan_portfolio.property_value<BFSI_db.dbo.loan_portfolio.funded_amount

	---Here we evaluate the property value, so that in case of my default Bank can realised the value for NPA

	---create property segment---
	alter table loan_portfolio
	add property_segment varchar(40)

	select min(property_value) as 'minimum',avg(property_value) as 'mean_point',max(property_value) as 'maximum' from loan_portfolio

	select*from loan_portfolio
	where property_value<=1500000

	select*from loan_portfolio
	where property_value between 1500001 and 5000000

	select*from loan_portfolio
	where property_value>5000000

	with prop_seg as(select purpose, count(loan_id) as 'total_loans',case when property_value<=1500000 then 'low_value_segment'
	                                                 when property_value between 1500001 and 5000000 then 'mid_value_segment'
													  when property_value>5000000 then 'High_value_segment'  end as 'property_segment' from loan_portfolio
													  group by BFSI_db.dbo.loan_portfolio.purpose,
													  case when property_value<=1500000 then 'low_value_segment'
	                                                 when property_value between 1500001 and 5000000 then 'mid_value_segment'
													  when property_value>5000000 then 'High_value_segment'  end)
	select property_segment,sum(total_loans) from prop_seg
	group by prop_seg.property_segment

	 

	update loan_portfolio set property_segment=case when property_value<=1500000 then 'low_value_segment'
	                                                 when property_value between 1500001 and 5000000 then 'mid_value_segment'
													  when property_value>5000000 then 'High_value_segment'  end

select property_segment,purpose,count(loan_id) as 'total_loans',sum(funded_amount) as 'total_fund',sum(loan_balance) as 'loan_bal_amount' from loan_portfolio
group by property_segment,purpose
order by total_loans desc

With evaluation_seg_wise  as (select property_segment,purpose,count(loan_id) as 'total_loans',sum(funded_amount) as 'total_fund',sum(loan_balance) as 'loan_bal_amount' from loan_portfolio
group by property_segment,purpose)

select*,total_fund-loan_bal_amount as 'amt_to_realise',round(cast((total_fund-loan_bal_amount) as float)/total_fund,2)*100.00 as 'perc_to_realise' from evaluation_seg_wise
where evaluation_seg_wise.property_segment='high_value_segment'
order by perc_to_realise

With evaluation_seg_wise  as (select property_segment,purpose,count(loan_id) as 'total_loans',sum(funded_amount) as 'total_fund',sum(loan_balance) as 'loan_bal_amount' from loan_portfolio
group by property_segment,purpose)

select*,total_fund-loan_bal_amount as 'amt_to_realise',round(cast((total_fund-loan_bal_amount) as float)/total_fund,2)*100.00 as 'perc_to_realise' from evaluation_seg_wise
where evaluation_seg_wise.property_segment='Mid_value_segment'
order by perc_to_realise	 

With evaluation_seg_wise  as (select property_segment,purpose,count(loan_id) as 'total_loans',sum(funded_amount) as 'total_fund',sum(loan_balance) as 'loan_bal_amount' from loan_portfolio
group by property_segment,purpose)

select*,total_fund-loan_bal_amount as 'amt_to_realise',round(cast((total_fund-loan_bal_amount) as float)/total_fund,2)*100.00 as 'perc_to_realise' from evaluation_seg_wise
where evaluation_seg_wise.property_segment='Mid_value_segment'
order by perc_to_realise	 

select purpose,funded_amount,year(funded_date) as 'The_year',month(funded_date) as 'the_month',duration_years,loan_balance,funded_amount-loan_balance as'amt_realised' from loan_portfolio
where purpose='Plane' and property_segment='Mid_value_segment'
order by year(funded_date)

-----Here we check the correlation with funded amount,duration,IR,sol:corr_coefficient-----

Declare @avg_dur as float,@avg_fund as float,@avg_int as float
select @avg_dur=avg(duration_years),
       @avg_fund=avg(funded_amount),
	   @avg_int=avg(interest_rate)
from loan_portfolio
---- correlation between duration and fund----
declare @corr_dur_fund as float
select  @corr_dur_fund=sum((duration_years-@avg_dur)*(funded_amount-@avg_fund))/sqrt(sum(power(duration_years-@avg_dur,2)))*sqrt(sum(power(funded_amount-@avg_fund,2)))
from loan_portfolio

---- correlation between  duration and interest----
declare @corr_dur_int as float
select  @corr_dur_int=sum((duration_years-@avg_dur)*(Interest_rate-@avg_int))/sqrt(sum(power(duration_years-@avg_dur,2)))*sqrt(sum(power(Interest_rate-@avg_int,2)))
from loan_portfolio

---- correlation between  fund amount and interest----

declare @corr_fun_int as float
select  @corr_fun_int=sum((funded_amount-@avg_fund)*(Interest_rate-@avg_int))/sqrt(sum(power(funded_amount-@avg_fund,2)))*sqrt(sum(power(Interest_rate-@avg_int,2)))
from loan_portfolio

select @corr_dur_fund as 'corr_coeff_DF', @corr_dur_int as 'corr_coeff_DI', @corr_fun_int as 'corr_coeff_FI'
	

with fund_seg as (select funded_amount,duration_years,case when funded_amount<12500000 and interest_rate_percent<4.0 then 'segment1'
	when funded_amount between 12500000 and 15000000 and interest_rate_percent<=3.0 then 'segment2'
	else 'segment3' end as 'customer_segments' from loan_portfolio)
	select max(funded_amount) from fund_seg
	where duration_years=30

	with fund_seg as (select funded_amount,duration_years,case when funded_amount<12500000 and interest_rate_percent<4.0 then 'segment1'
	when funded_amount between 12500000 and 15000000 and interest_rate_percent<=3.0 then 'segment2'
	else 'segment3' end as 'customer_segments' from loan_portfolio)
	select max(funded_amount) from fund_seg
	where duration_years=15

	select distinct duration_years from loan_portfolio
	select count(*) from loan_portfolio
	where duration_years=30

	select count(*) from loan_portfolio
	where duration_years=15

	select count(*) from loan_portfolio
	where duration_years=20

	select count(*) from loan_portfolio
	where duration_years=10

	alter table loan_portfolio
	add LTV_ratio float
	update  loan_portfolio set ltv_ratio=(funded_amount/property_value)

	select loan_id,funded_amount,property_value,LTV ration, case when ltv_ratio<0 then 'funamt>property' else 'high_end' end as 'property_valuation',
	Tax_class_at_present,BUILDING_CLASS_AT_PRESENT
	from loan_portfolio
	order by ltv_ration desc

	alter table loan_portfolio
	add Building_cat varchar(30)

	update loan_portfolio set Building_cat='Condos'
	where BUILDING_CLASS_CATEGORY like '%Condos%'

	select BUILDING_CLASS_CATEGORY,Building_cat from loan_portfolio
	where Building_cat is not null

	select case when  BUILDING_CLASS_CATEGORY like '%residential%' then 'Residential'
	when BUILDING_CLASS_CATEGORY like '%commercial%' then 'commercial'  else 'others' end AS building_type
	,case when BUILDING_CLASS_CATEGORY like '%Condos%' then 'Condos_mixtype'
	 when BUILDING_CLASS_CATEGORY like '%Rental%' then 'rental'
	 when BUILDING_CLASS_CATEGORY like '%Warehouse%' then 'Warehouse' else 'others' end as Property_type,funded_amount,Interest_rate,duration_years,property_value
	 from loan_Portfolio 

	 alter table loan_portfolio
	drop column Building_cat

	 ----Using CTE----

	 WITH BuildingClassification AS (
    SELECT 
        CASE 
            WHEN BUILDING_CLASS_CATEGORY LIKE '%residential%' THEN 'Residential'
            WHEN BUILDING_CLASS_CATEGORY LIKE '%commercial%' THEN 'Commercial'
            ELSE 'Others' 
        END AS building_type,
        
        CASE 
            WHEN BUILDING_CLASS_CATEGORY LIKE '%Condos%' THEN 'Condos_mixtype'
            WHEN BUILDING_CLASS_CATEGORY LIKE '%Rental%' THEN 'Rental'
            WHEN BUILDING_CLASS_CATEGORY LIKE '%Warehouse%' THEN 'Warehouse'
            ELSE 'Others' 
        END AS Property_type,
        
        funded_amount,
        Interest_rate,
        duration_years,
        property_value
    FROM loan_Portfolio
)
SELECT * 
FROM BuildingClassification;




 
 

