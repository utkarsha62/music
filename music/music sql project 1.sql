create database music ;
use music;
/* Q1 . who is the senior most employee based on job title? */

select * from employee
order by levels desc 
limit 3; 

/*Q2 which countries have the most invoices ? */
select count(*) as c , billing_country
from invoice
group by  billing_country
order by c   desc ;

select count(billing_country) as no_of_invoice ,  billing_country  
from invoice
group by  billing_country
order by  no_of_invoice desc;

/* Q3  WHAT ARE TOP 3 VALUES OF TOTAL INVOICES? */

select * FROM invoice 
 order by total desc
 limit 3 ;

 /* Q4 Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals */

select sum(total) as seles, billing_city
from invoice
group by billing_city
order by seles desc ;

/* Q5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money ? */


select custemer.custemer_id as custemer_id  ,custemer.first_name   ,sum(invoice.total) as total
from custemer
inner join invoice  
on custemer.custemer_id = invoice.custemer_id 
group by custemer.custemer_id,custemer.first_name
order by total  desc 
limit 1 ;

/* Q6 1. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A   */

select custemer.first_name ,  custemer.last_name , custemer.email , genre.name as music_type 
from genre 
inner join track
on genre.genre_id = track.genre_id 
inner join invoice_line 
on track.track_id =  invoice_line.track_id 
inner join invoice 
on invoice_line.invoice_id = invoice.invoice_id 
inner join custemer 
on invoice.custemer_id = custemer.custemer_id 
where genre.genre_id = '1'
order by email  ; 

/* Q7 . Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands  */

select artist.name , count(album.artist_id) as no_of_song , genre.name as song_type
from artist 
inner join album 
on artist.artist_id =album.artist_id
inner join track 
on track.album_id = album.album_id 
inner join genre
on genre.genre_id = track.genre_id 
where genre.name = "Rock" 
group by artist.name   , genre.name 
order by no_of_song desc
limit 10 ;

/* Q8. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first  */   

select name , track.milliseconds
from track 
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;

/* Q9. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent */

select  custemer.first_name , custemer.last_name , artist.name as artist_name , sum(invoice_line.unit_price * invoice_line.quantity)  as total_spend 
from artist
inner join album 
on artist.artist_id = album.artist_id
inner join track
on track.album_id = album.album_id
inner join invoice_line
on track.track_id = invoice_line.track_id 
inner join invoice 
on invoice_line.invoice_id = invoice.invoice_id 
inner join custemer 
on invoice.custemer_id = custemer.custemer_id 
group by custemer.first_name , custemer.last_name , artist.name 
order by total_spend desc;

/* Q10 We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres */

select   invoice.billing_country as country , genre.name as music_type , genre.genre_id, count(invoice_line.quantity) as no_of_selling
from artist
inner join album 
on artist.artist_id = album.artist_id
inner join track
on track.album_id = album.album_id
inner join invoice_line
on track.track_id = invoice_line.track_id 
inner join invoice 
on invoice_line.invoice_id = invoice.invoice_id
inner join genre 
on track.genre_id = genre.genre_id 
group by invoice.billing_country , genre.name , genre.genre_id 
order by no_of_selling desc ;

/*Q 11   Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount */

with recursive
    custemer_with_country as (
        select 
            custemer.custemer_id, 
            first_name, 
            last_name, 
            billing_country, 
            sum(total) as total_spending
        from invoice 
        inner join custemer on custemer.custemer_id = invoice.custemer_id
        group by 1, 2, 3, 4
    ),
    country_max_spending as (
        select 
            billing_country, 
            max(total_spending) as max_spending
        from custemer_with_country
        group by billing_country
    )
    select 
        cc.billing_country, 
        cc.total_spending, 
        cc.first_name, 
        cc.last_name 
    from 
        custemer_with_country cc
    join 
        country_max_spending ms
    on  
        cc.billing_country = ms.billing_country
    and 
        cc.total_spending = ms.max_spending
    order by 1;


with recursive
    custemer_with_country as (
        select 
            custemer.custemer_id, 
            first_name, 
            last_name, 
            billing_country, 
            sum(total) as total_spending
        from invoice 
        inner join custemer on custemer.custemer_id = invoice.custemer_id
        group by 1, 2, 3, 4
    ),
    country_max_spending as (
        select 
            billing_country, 
            max(total_spending) as max_spending
        from custemer_with_country
        group by billing_country
    )
    select 
        custemer_with_country.billing_country, 
        custemer_with_country.total_spending, 
        custemer_with_country.first_name, 
        custemer_with_country.last_name 
    from 
        custemer_with_country 
    join 
        country_max_spending 
    on  
        custemer_with_country.billing_country = country_max_spending .billing_country
    and 
        custemer_with_country.total_spending = country_max_spending .max_spending
    order by 1;
    
   
