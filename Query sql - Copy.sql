Q1. /*Who is the senior most employee based on job title? */
	
	select * from employee
	order by levels desc
	limit 1

Q2. /*Which countries have the most Invoices? */
	
	Select count(*) as number_of_invoices, BILLING_COUNTRY From invoice 
	Group by Billing_countrY
	order by number_of_invoices
	
Q3. /*What are top 3 values of total invoice? */
	
	Select invoice_id,total from invoice
	order by Total desc
	limit 3
	
Q4./* Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
    Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.*/
	
	Select sum(total)as Sum_of_all_invoice_totals, billing_city as city_name from invoice
	Group by billing_city
	order by Sum_of_all_invoice_totals desc
	limit 1
	
Q5./* Who is the best customer?The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money */

	select sum(total) as Total_purchases, c.first_name, c.last_name 
	from customer c 
	join invoice i
	on c.customer_ID = i.customer_id
	group by c.customer_id
	order by Total_purchases desc
	limit 1
	
	
	