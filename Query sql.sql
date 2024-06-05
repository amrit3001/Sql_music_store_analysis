    											/* Q. Simple Questions*/
					
					

/* Q1. Who is the senior most employee based on job title? */
	
	select * from employee
	order by levels desc
	limit 1

/* Q2. Which countries have the most Invoices? */
	
	Select count(*) as number_of_invoices, BILLING_COUNTRY From invoice 
	Group by Billing_countrY
	order by number_of_invoices
	
/* Q3. What are top 3 values of total invoice? */
	
	Select invoice_id,total from invoice
	order by Total desc
	limit 3
	
/* Q4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
    Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.*/
	
	Select sum(total)as Sum_of_all_invoice_totals, billing_city as city_name from invoice
	Group by billing_city
	order by Sum_of_all_invoice_totals desc
	limit 1
	
/* Q5. Who is the best customer?The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money */

	select sum(total) as Total_purchases, c.first_name, c.last_name 
	from customer c 
	join invoice i
	on c.customer_ID = i.customer_id
	group by c.customer_id
	order by Total_purchases desc
	limit 1
	
	
											/* Q. Intermediate Questions */	
							
							

/* Q1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
   Return your list ordered alphabetically by email starting with A */
  
   	select distinct c.email, c.first_name, c.last_name
   	from customer  c
	join invoice
	on invoice.customer_id = c.customer_id
  	join invoice_line
   	on invoice_line.invoice_id = invoice.invoice_id
 	where track_id in (select t.track_id 
	   					from track  t
	   					join genre g
					  	on g.genre_id = T.genre_id
	   					where g.name like 'Rock')
	order by c.email
   
										OR
										
	select distinct c.email, c.first_name, c.last_name
   	from customer  c
   	join invoice on invoice.customer_id = c.customer_id
   	join invoice_line on invoice_line.invoice_id = invoice.invoice_id
   	join track on track.track_id = invoice_line.invoice_id
   	join genre on track.genre_id = track.genre_id
   	where genre.name like 'Rock'
   	order by c.email
										
   
/* Q2. Let's invite the artists who have written the most rock music in our dataset. 
    Write a query that returns the Artist name and total track count of the top 10 rock bands */


	select artist.name ,  count (*) as total_track
	from track 
	join album  on track.album_id = album.album_id
	join artist on album.artist_id = artist.artist_id
	where track.track_id in 
					(select t.track_id 
	   					from track  t
	   					join genre g
					  	on g.genre_id = T.genre_id
	   					where g.name like 'Rock')					
	group by artist.name
	order by total_track desc
	limit 20
	
	
									OR
									
									
	select artist.name ,  count (*) as total_track
	from track 
	join album  on track.album_id = album.album_id
	join artist on album.artist_id = artist.artist_id
	join genre on genre.genre_id = track.genre_id
	where genre.name like 'Rock'
	group by artist.name
	order by total_track desc
	limit 20
   
 /* Q3. Return all the track names that have a song length longer than the average song length.
     Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first */
	 
	 select  name, milliseconds
	 from track
	 where milliseconds > (
	 						select avg(milliseconds) as avg_time 
	 						from track
	 						) 						
	 order by milliseconds desc
	 
	 
	 
                                                					/* Advanced Questions */


/* Q1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

	W ith most_sold_artist as (
	select artist.name as artist_name, artist.artist_id,
    sum(invoice_line.unit_price *invoice_line.quantity) as total_spent
	from invoice_line
	join track on invoice_line.track_id = track.track_id
	join album on track.album_id = album.album_id
	join artist on album.artist_id = artist.artist_id
	group by 2
	order by 3 desc
	limit 1
	)
	
	select c.customer_id, c.first_name, c.last_name, msa.artist_name, sum(invoice_line.unit_price * invoice_line.quantity) as amount_spent
	from customer c
	join invoice on invoice.customer_id = c.customer_id
	join invoice_line on invoice_line.invoice_id = invoice.invoice_id
	join track on track.track_id = invoice_line.track_id
	join album on track.album_id = album.album_id
	join most_sold_artist   msa on msa.artist_id = album.artist_id
	group by 1 ,2 ,3 ,4
	order by 5 desc 

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

	With most_sold_genre as (
	select count (il.quantity) , c.country, g.genre_id, g.name,
	row_number () over ( partition by c.country order by count (il.quantity) desc ) as row_no
	from invoice_line il 
	join invoice i on il.invoice_id = i.invoice_id
	join customer c on c.customer_id = i.customer_id
	join track t on t.track_id = il.track_id
	join genre g on g.genre_id = t.genre_id
	group by 2,3,4
	order by 1 desc ,2 asc
			   )
	select * from most_Sold_genre 
	where row_no = 1

/* Q3. Write a query that determines the customer that has spent the most on music for each country. 
   Write a query that returns the country along with the top customer and how much they spent. 
   For countries where the top amount spent is shared, provide all customers who spent this amount */
   
   	With top_customer as (
   	select c.country, c.first_name, c.last_name , sum(i.total) as total_spending,
   	row_number () over ( partition by c.country order by sum(i.total) desc) as Row_no
   	from  customer c
   	join invoice i on i.customer_id = c.customer_id
   	group by 1, 2, 3 
   	order by 4 desc, 1 asc
	   )
	   select *
	   from top_customer where Row_no =1
   
   
   
   
   
   
   
   
   
   
   
	
