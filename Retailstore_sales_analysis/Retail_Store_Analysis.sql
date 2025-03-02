 

create table sales
(sale_id varchar(max),Date varchar(max),Store_ID varchar(max),Product_ID varchar(max),Units varchar(max))
select*from sales



bulk insert sales 
from /* path of the file*/'C:\Users\USER\Desktop\sales.csv'
with 
   (fieldterminator=',',rowterminator='\n',firstrow=2,maxerrors=20);

   select*from sales

create table Products
(Product_id varchar(max),Product_Name varchar(max),Product_category varchar(max),Product_cost varchar(max),Product_Price varchar(max))
select*from products
bulk insert Products
from /* path of the file*/'C:\Users\USER\Desktop\products (1).csv'
with 
   (fieldterminator=',',rowterminator='\n',firstrow=2,maxerrors=20);
   select*from products

   create table Stores
(Store_id varchar(max),Store_Name varchar(max),Store_City varchar(max),Store_Location varchar(max),Store_Open_Date varchar(max))
select*from Stores

bulk insert Stores
from /* path of the file*/'C:\Users\USER\Desktop\stores (1).csv'
with 
   (fieldterminator=',',rowterminator='\n',firstrow=2,maxerrors=20);
   select*from Stores


   create table Inventory
(Store_id varchar(max),Product_ID varchar(max),Stock_On_Hand varchar(max))
select*from Inventory

bulk insert Inventory
from /* path of the file*/'C:\Users\USER\Desktop\inventory (1).csv'
with 
   (fieldterminator=',',rowterminator='\n',firstrow=2,maxerrors=20);
   select*from Inventory

   select count(distinct sale_ID) from sales 
   select count(distinct product_ID) from products
   select count(distinct Store_ID) from Stores
   select count(distinct Store_ID) from Inventory

   select* from sales
   where ISNUMERIC(sale_id)=0

   select sale_id,case when isnumeric(sale_id)=0 then replace(sale_id,substring(sale_id,patindex('[^0-9]',sale_id)

   select sale_id,replace(sale_id,substring(sale_id,patindex('%[^0-9]%',sale_id),1),' ')
   substring(sale_id,patindex('%[^0-9]%',sale_id),1),
   patindex('%[^0-9]%',sale_id)from sales
    where ISNUMERIC(sale_id)=0

	update sales set  sale_id=replace(sale_id,substring(sale_id,patindex('%[^0-9]%',sale_id),1),'')
	where ISNUMERIC(sale_id)=0

	alter table sales
	alter column sale_id int

	update sales set Date='01-04-2022'
	where convert(varchar(20),try_convert(Date,[Date]),23) is null

select Date from sales

	alter table sales
	alter column Date date 

alter table sales
alter column Store_ID int

	alter table sales
	alter column Product_ID int

	alter table sales
	alter column Units int
	select* from sales
   where ISNUMERIC(units)=0

   update sales set units= case when units='1A' then 1 
                                when units='10%' then 10
								 else  units end

select column_name,data_type
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='products'

select* from products
where isnumeric(Product_ID)=0

update products set Product_ID='14'
where Product_ID='14$'

alter table products
alter column Product_ID int

select* from products
where isnumeric(Product_cost)=0

update products set Product_cost=replace(Product_cost,'$','')

update products set Product_Price=replace(Product_Price,'$','')

alter table products
alter column Product_cost decimal(5,2)

alter table products
alter column Product_Price decimal(5,2)

select column_name,data_type
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='Stores'
 select*from Stores

 select* from Stores
where isnumeric(Store_ID)=0

alter table Stores
alter column Store_ID int


select* from Stores
where isdate(Store_Open_Date)=0

select Store_Open_Date,convert(varchar(20),try_convert(date,Store_Open_Date,105),23) from Stores

update Stores set Store_Open_Date=convert(varchar(20),try_convert(date,Store_Open_Date,105),23)

select column_name,data_type
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='Inventory'
 select*from Inventory

 alter table Inventory
alter column Store_ID int

 alter table Inventory
alter column Product_ID int

alter table Inventory
alter column Stock_On_Hand int


select column_name,data_type
from INFORMATION_SCHEMA.COLUMNS

create function remnonnumeric(@instr as varchar(100))
returns varchar(100)
AS 
Begin 
  Declare @Ostr as varchar(100)=''
  Declare @length int=len(@instr)
  Declare @index  int=1
   while @index<=@length
   begin
      if SUBSTRING(@instr,@index,1) like '[0-9]'
	  set @Ostr=@Ostr+ substring(@instr,@index,1)
	  set @index=@index+1
	  end

	return @Ostr
	End

	create table testing
	(sale_id varchar(100),Product_ID varchar(30))
	insert into testing
	values('100*1','100-00'),('1001','1$00'),('100#1','1!0000')
	select*from testing 
	update testing set sale_id=dbo.remnonnumeric(sale_id)

------check duplicate records------

select*from sales
select distinct sale_id,date,store_ID,product_ID,Units from sales

with duplicates as(select*,row_number()over(partition by sale_ID,date,store_ID,product_ID,Units order by sale_id) 
as row_num from sales)
select*from duplicates
where row_num>1


with duplicates as(select*,row_number()over(partition by Product_id,Product_Name,Product_category,Product_cost,Product_price order by Product_id) 
as row_num from products)
select*from duplicates
where row_num>1

Select*from Products

with duplicates as(select*,row_number()over(partition by Product_id,Product_Name,Product_category,Product_cost,Product_price order by Product_id) 
as row_num from products)
delete from duplicates
where row_num>1

Select*from Products

with duplicates as(select*,row_number()over(partition by Store_id,Store_Name,Store_city,Store_location,Store_Open_Date order by Store_id) 
as row_num from Stores)
select*from duplicates
where row_num>1


with duplicates as(select*,row_number()over(partition by Store_id,Product_ID,Stock_On_Hand order by Store_id) 
as row_num from Inventory)
select*from duplicates
where row_num>1

alter table sales
alter column sale_id int not null

alter table sales
add constraint pksid primary key(sale_id)

select*from products

alter table products
alter column Product_ID int not null

alter table products
add constraint pkpid primary key(Product_ID)

select*from Stores

alter table Stores
alter column Store_ID int not null

alter table Stores
add constraint pkstid primary key(Store_ID)

select*from Inventory

alter table Inventory
alter column Store_ID int not null

alter table Sales
add constraint fkstr foreign key(Store_ID) references Stores(Store_ID)

alter table Inventory
add constraint fkstr1 foreign key(Store_ID) references Stores(Store_ID)

alter table Inventory
add constraint fkprd1 foreign key(product_ID) references products(product_ID)

alter table Sales
add constraint fkprd foreign key(product_ID) references products(product_ID)

-----sales trend over the time-----
select*from sales
select min(date)as sales_start_date, max(date) as last_date_recorded,datediff(MONTH,min(date),max(date)) as 'sales_periods_in_months' from sales 

select min(date)as sales_start_date, max(date) as last_date_recorded,datediff(day,min(date),max(date)) as 'sales_periods_in_days' from sales 

-----To analysis sales part in different timepart-----

select year(date)as 'the_year',datepart(quarter,date) as 'quarterly_sales',datename(month,date) as 'the_month',sum(units) as 'total_un_sold' from sales 
group by year(date),datepart(quarter,date),datename(month,date)   
order by year(date)

 with comp_sales_table as(select datename(month,date)as 'the_month',datepart(quarter,date) as 'quarterly_sales',sum(case when year(date)=2022 then units else 0 end) as 'total_un_sold2022',sum(case when year(date)=2023 then units else 0 end)as 'total_un_sold2023' from sales
 group by datename(month,date),datepart(quarter,date))
 select* ,total_un_sold2023-total_un_sold2022 as 'diff_in_sales',case when total_un_sold2023-total_un_sold2022>0 then 'inclined_in_sales' else 'declined_in_sales' end as sales_trend
 from comp_sales_table
order by  quarterly_sales


select datename(weekday,date) as 'sales_week', sum(units) as 'total_units' from sales
where format(date,'yyyy') in(2022,2023) and datename(weekday,date) in('Sunday','Saturday')
group by datename(weekday,date)

union all 
select datename(weekday,date) as 'sales_week', sum(units) as 'total_units' from sales
where format(date,'yyyy') in(2022,2023) and datename(weekday,date) not in('Sunday','Saturday')
group by datename(weekday,date)
order by sales_week


select datename(weekday,date) as 'sales_week', sum(units) as 'total_units' from sales
where format(date,'yyyy') in(2022,2023) and datename(weekday,date) in('Sunday','Saturday')
group by datename(weekday,date)

union all 
select datename(weekday,date) as 'sales_week', sum(units) as 'total_units' from sales
where format(date,'yyyy') in(2022,2023) and datename(weekday,date) not in('Sunday','Saturday')
group by datename(weekday,date)
order by total_units

select*from Stores
select top 5 store_name,sum(units) as 'total_un_sold',sum(units*product_price) as 'Total_revenue' from Stores st
join sales s
on st.Store_ID=s.Store_ID
join products p
on s.Product_ID=p.Product_ID
group by Store_Name
order by Total_revenue desc


select Store_Location,sum(s.units) as 'total_un_sold',sum(units*product_price) as 'Total_revenue' from Stores st
join sales s
on st.Store_ID=s.Store_ID
join products p
on s.Product_ID=p.Product_ID
group by Store_Location
order by Total_revenue desc

select Store_Location,count(distinct st.Store_ID),sum(s.units) as 'total_un_sold',sum(units*product_price) as 'Total_revenue' from Stores st
join sales s
on st.Store_ID=s.Store_ID
join products p
on s.Product_ID=p.Product_ID
group by Store_Location
order by Total_revenue desc

select*from products  
select*from Stores

With product_analyse as( select Product_Category,sum(case when year(date)=2022 then units else 0 end) as 'total_un_sold2022',sum(case when year(date)=2023 then units else 0 end) as 'total_un_sold2023',
 sum(case when year(date)=2022 then units*product_price else 0 end)as 'Total_rev_2022',
 sum(case when year(date)=2023 then units*product_price else 0 end)as 'Total_rev_2023' from Products p
 join Sales s
 on p.Product_id=s.Product_id
 group by Product_Category,Product_name)
 select*,total_un_sold2023-total_un_sold2022 as 'dif_in_unitsold',Total_rev_2023-Total_rev_2022 as 'dif_in_revnue'
  from product_analyse
  order by dif_in_unitsold desc

  ---findout highly sold product_name  each category-----
  ----/** ranked_products as (select*,row_number()over partition by Product_Category order by Total_un_Sold) as 'rankd' from Product_Table)/**----

 With Product_Table as( Select Product_Category,Product_Name,sum(Units) as 'total_un_sold' from Products p
 join Sales s
 on p.Product_id=s.Product_id
 group by Product_Category,Product_Name)
 select*,row_number()over (partition by Product_Category order by total_un_sold) as 'rankd' from Product_Table
 


 
 With Product_Table as( Select Product_Category,Product_Name,sum(Units) as 'total_un_Sold' from Products p
 join Sales s
 on p.Product_id=s.Product_id
 group by Product_Category,Product_Name)
 ,ranked_products as (select*,row_number()over (partition by Product_Category order by total_un_Sold) as 'rankd' from Product_Table)
select pt.Product_Category,pt.Product_Name,pt.total_un_Sold,r.rankd from Product_Table pt
 join ranked_Products r
 on pt.Product_Name=r.Product_Name
 where r.rankd=1

 With Sales_sum as(Select Product_Category,Product_Name,p.Product_id,sum(Units)as 'total_un_Sold',sum(Units*Product_Price)as'revnue',avg(Units) as 'avg_un_sold',sum(Units*Product_cost)as 'costp',
 (sum(Units*Product_Price)-sum(Units*Product_cost)) as 'Profit' from Products p
 join Sales s
 on p.Product_id=s.Product_id
 group by Product_Category,Product_Name,p.Product_id)
 
 select*,Profit/revnue*100.0 from Sales_sum
 order by Product_Category

 -----Last six month performance with date record----
 select max(date) from Sales    ----Last date saledata 2023-09-30----
 select dateadd(month,-6,(select max(date) from Sales)) from Sales 

 select s.Store_id,s.date,st.Store_name,sum(Units) as 'total_un_sold',sum(Units*Product_Price)as 'revnue' from Sales s
 join Stores st
 on s.Store_id=st.Store_id
 join Products p
 on s.Product_id=p.Product_id
 where s.date between dateadd(month,-6,(select max(date) from Sales)) and (select max(date) from Sales)
 group by s.Store_id,s.date,st.Store_name  

 ----Check Inventory Turnover----
 With Sales_analyse as(Select Product_Name,sum(case when year(date)=2022 then Units*Product_Cost else 0 end) as COGS_2022,sum(case when year(date)=2023 then Units*Product_Cost else 0 end)as COGS_2023 from Sales s
 join Products p
 On s.Product_id=p.Product_id
 group by Product_Name),
 average_Inv as (Select p.Product_Name,avg(case when year(s.date)=2022 then Stock_On_Hand else 0 end) as 'avg_inv_2022',avg(case when year(s.date)=2023 then Stock_On_Hand else 0 end)as 'avg_inv_2023' from Inventory i
 join Products p
 on i.Product_ID=p.Product_ID
 Join Sales s
 On i.Product_ID=s.Product_ID
 group by Product_Name
 )
 select sa.Product_Name,sa.COGS_2022,ai.avg_inv_2022,sa.COGS_2023,ai.avg_inv_2023,
 case when avg_inv_2022=0 then null
 else (COGS_2022/avg_inv_2022) end as inv_ratio_2022,
 case when avg_inv_2023=0 then null
 else (COGS_2023/avg_inv_2023) end as inv_ratio_2023
 from  Sales_analyse sa
 join average_Inv ai      
 on sa.Product_Name=ai.Product_Name

 ----- Indivisual product performance with last sold,current sold--------
With sales_trend as( select month(date) as 'S_month',sum(Units) as 'total_un_sold' from sales s
 join Products p
 on s.Product_ID=p.Product_ID
 where year(date) in (2022,2023)
 and datepart(quarter,date)<=2
 and Product_category='Electronics'
 group by month(date)),
post_period_sales as(select month(date) as 'S_month',sum(Units) as 'post_un_sold' from sales s
 join Products p
 on s.Product_ID=p.Product_ID
 where year(date) in (2022,2023)
 and datepart(quarter,date)>2
 and Product_category='Electronics'
 group by month(date))
 select 'Electronics' as Product_category,st.S_month,st.total_un_sold as 'un_sold_12qtrs',ps.post_un_sold as 'un_sold_112qtrs',coalesce (st.total_un_sold,0)-coalesce(ps.post_un_sold,0) as chn_in_unt_sold
 from sales_trend st
 full join post_period_sales ps
 on st.S_month=ps.S_month
order by 
coalesce(st.S_month,ps.S_month)

-----Product performance(Top5)----
select top 5 Product_Name,sum(units) as 'total_un_sold',avg(units*Product_Price) as'avg_sales',sum(units*Product_cost) as 'total_Co',sum(units*Product_Price)-sum(units*Product_cost) as 'profit'
from products p
join Sales s
on p.Product_ID=s.Product_ID
group by Product_Name
order by total_un_sold desc
-------------------------------------
With Total_Sales as(select Product_Name,sum(units) as 'total_un_sold'
from products p
join Sales s
on p.Product_ID=s.Product_ID
group by Product_Name),

avg_sal as( select  Product_Name,avg(units*Product_Price) as'avg_sales'
from products p
join Sales s
on p.Product_ID=s.Product_ID
group by Product_Name),

total_Cost as(select  Product_Name,sum(units*Product_cost) as 'total_Co'
from products p
join Sales s
on p.Product_ID=s.Product_ID
group by Product_Name),

profit as (select Product_Name,sum(units*Product_Price)-sum(units*Product_cost) as 'profit'
from products p
join Sales s
on p.Product_ID=s.Product_ID
group by Product_Name)

select ts.Product_Name,ts.total_un_sold,avs.avg_sales,tc.total_Co,profit
from Total_Sales ts
join avg_sal avs
on ts.Product_Name=avs.Product_Name
join total_Cost tc
on ts.Product_Name=tc.Product_Name
join profit pf
on ts.Product_Name=pf.Product_Name
order by pf.profit desc

