 -- This is BFSI domain dataset- Collection of information about the high profile loan given by the banking institution to businesses
 -- we need to analyse the financial health and risk associated with the pattern. 

 create database BFSI_db

 use BFSI_db

 -- create a table with the name of loan_portfolio

 create table loan_portfolio
 (loan_id	varchar(max),funded_amount varchar(max),
 funded_date varchar(max),	duration_years varchar(max),duration_months varchar(max),
 Ten_yr_treasury_index_date_funded varchar(max),
 interest_rate_percent	varchar(max),interest_rate varchar(max),
 payments varchar(max),	total_past_payments varchar(max),
 loan_balance varchar(max),	property_value	varchar(max),
 purpose varchar(max),	firstname varchar(max),	middlename varchar(max),lastname varchar(max),
 social varchar(max),	phone varchar(max),	title	varchar(max),employment_length varchar(max),
 BUILDING_CLASS_CATEGORY varchar(max),	TAX_CLASS_AT_PRESENT varchar(max),
 BUILDING_CLASS_AT_PRESENT	varchar(max), ADDRESS1 varchar(max),	ADDRESS2 varchar(max),
 ZIPCODE varchar(max),	CITY varchar(max),	STATE varchar(max),	TOTALUNITS varchar(max),LANDSQUAREFEET varchar(max),
 GROSSSQUAREFEET	 varchar(max),TAXCLASSAT_TIME_OF_SALE varchar(max),)

 drop table loan_portfolio
 -- insert the data

 Bulk insert loan_portfolio
 from 'C:\Users\STANLEY\Downloads\LoanPortfolio.csv'
 WITH  (fieldterminator=',', rowterminator='\n', firstrow=2)

 select column_name, DATA_type  
 from information_schema.columns

 select * from loan_portfolio

 -- funded_amount- money
 --funded_date date
 --durationyear and months- int
 --index= float
 --interest rate percent- float
 ---interest rate- float
 --payments- money
 --past payment- int
 --loan_bal- money
 -- property value- money
 --emp_len- int
 --total_units- int
 --
 /* ADDRESS1
ADDRESS2
BUILDING_CLASS_AT_PRESENT
BUILDING_CLASS_CATEGORY
CITY
duration_months
duration_years
employment_length
firstname
funded_amount
funded_date
GROSSSQUAREFEET
interest_rate
interest_rate_percent
LANDSQUAREFEET
lastname
loan_balance
loan_id
middlename
payments
phone
property_value
purpose
social
STATE
TAX_CLASS_AT_PRESENT
TAXCLASSAT_TIME_OF_SALE
Ten_yr_treasury_index_date_funded
title
total_past_payments
TOTALUNITS
ZIPCODE*/
 -- change the datatype as per their data

 alter table loan_portfolio
 alter column totalunits int

  alter table loan_portfolio
 alter column total_past_payments int

   alter table loan_portfolio
 alter column employment_length int

    alter table loan_portfolio
 alter column funded_date date

 select * from loan_portfolio 

 -- we have 1678 nos loan data

 select DISTINCT loan_id from loan_portfolio

 --- the period of the data for the loan

 select min(funded_date) as 'firstloandate', max(funded_date) as 'lastdaterecorded', datediff(year, min(funded_date),max(funded_date)) as 'total_years'
  from loan_portfolio

  select * from loan_portfolio

  -- we have a purpose attribute, where we can see the distribution of loans_funded between the various purpose

  select distinct purpose from loan_portfolio

  --- analyse the purpose wise funded_amount_distribution

  select purpose, count(loan_id) as 'total_loans', sum(funded_amount) as 'total_funded_amt', avg(funded_amount) as 'avg_funded_amount'
  from loan_portfolio
  group by purpose
  order by total_loans DESC

  -- how the distribution is managed by each year
  SELECT purpose, year(funded_date) as 'the_year',
		 COUNT(loan_id) AS 'total_loans',
		 SUM(funded_amount) AS 'total_funded_amt',
		 AVG(funded_amount) AS 'avg_funded_amount'
  FROM loan_portfolio
  where year(funded_date)=2012
  GROUP BY purpose, year(funded_date)
  ORDER BY total_loans DESC

  --- for the year of 2012- the commercial property is the highest as per the total_loans_given

  with funded_dist as (SELECT purpose,
		 YEAR(funded_date) AS 'the_year',
		 COUNT(loan_id) AS 'total_loans',
		 SUM(funded_amount) AS 'total_funded_amt',
		 AVG(funded_amount) AS 'avg_funded_amount',
		 row_number() over(partition by purpose order by year(funded_date)) as row_num
  FROM loan_portfolio
  /*WHERE YEAR(funded_date) = 2013*/
  GROUP BY purpose,
		   YEAR(funded_date))

select * from funded_dist
  where row_num=1
  ORDER BY funded_dist.total_loans

  --- we want to analyse the year wise which purpose has most loans 

  WITH funded_dist
  AS
  (
	  SELECT purpose,
			 YEAR(funded_date) AS 'the_year',
			 COUNT(loan_id) AS 'total_loans',
			 SUM(funded_amount) AS 'total_funded_amt',
			 AVG(funded_amount) AS 'avg_funded_amount',
			 ROW_NUMBER() OVER (PARTITION BY year(funded_date) ORDER BY count(loan_id) desc) AS row_num
	  FROM loan_portfolio
	  /*WHERE YEAR(funded_date) = 2013*/
	  GROUP BY purpose,
			   YEAR(funded_date)
  )

  SELECT *
  FROM funded_dist
  where row_num=1
--modify the query to get the top funded_purpose for each year
-- the purpose type Commercial_property, Home, Investment_property are top loan segment distributes among these year (2012-2019)

-- the banking insitution wants to categorized the loan as per their fundedamount with three segments (high, medium and low based on distribution)

-- min value, avg_value, max_value

select min(funded_amount) as 'min_value_funded', avg(funded_amount) as 'mean_value', max(funded_amount) as 'max_funded_amount'
from loan_portfolio

--- min-440000, avg- 1848830.1549, max- 156000000.00

select * from loan_portfolio
where funded_amount between 440000 and 1848829


select 1259.00/1678.00   /* 75 % data is under this range (min and avg_value)
--- 25% data is goes above this range

-- Segment 1- low_segment - 600000
--- segment 2- between 600001 and 1000000
-- segment 3- above 1000000*/

select purpose, count(loan_id) as 'total_loans', case when funded_amount<=600000 then 'Low_segment'
														when funded_amount between 600001 and 1000000 then 'med_segment'
														else 'high_segment' end as Loan_segment
from loan_portfolio
group by purpose,case when funded_amount<=600000 then 'Low_segment'
														when funded_amount between 600001 and 1000000 then 'med_segment'
														else 'high_segment'  end
order by total_loans DESC


--- The banking institution wants to segregate the customers based on their interest rate applicable to their loans

select distinct interest_rate_percent from loan_portfolio

SELECT DISTINCT interest_rate_percent
FROM loan_portfolio

--- so the distinct interest range is 2, 3, 4

select * from loan_portfolio
where interest_rate_percent<3.0

-- we have 32 loans where the interest rate is below than 3.0

SELECT *
FROM loan_portfolio
WHERE interest_rate_percent between 3.0 and 4.0
--- mostly the loan is distributed in this interest rate range- 1096

SELECT *
FROM loan_portfolio
WHERE interest_rate_percent>4.0

-- total_loans- 550

select min(funded_amount),avg(funded_amount),max(funded_amount)
from loan_portfolio
where BFSI_db.dbo.loan_portfolio.interest_rate_percent>4.0




select case when funded_amount<12500000 and interest_rate_percent<4.0 then 'Segment1'
			when funded_amount between 12500000 and 15000000 and interest_rate_percent<=3.0 then 'segment2'
			else 'Segment3' end as 'Customer_segments', avg(loan_balance) as 'loanamtpending'
from loan_portfolio
group by case when funded_amount<12500000 and interest_rate_percent<4.0 then 'Segment1'
			when funded_amount between 12500000 and 15000000 and interest_rate_percent<=3.0 then 'segment2'
			else 'Segment3' end 

select * from loan_portfolio

alter table loan_portfolio
alter column loan_balance money


select distinct property_value from loan_portfolio

--- here you need to evaluate the property value , so that in case of any default Bank can realised the value for NPA
-- create a property value segment in your data, create a column with this name and impute the segment_indicators as per the property evaluation
-- assignment--