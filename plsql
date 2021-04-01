do $$ 
<<country_block>>
declare
  country_count integer := 0;
begin
   -- get the number of countries
   select count(*) 
   into country_count
   from country;
   -- display a message
   raise notice 'The number of countries is %', country_count;
end country_block $$
do $$
<<payment_block>>
declare
  payment_count integer := 0;
begin
   -- get the number of countries
   select count(*) 
   into payment_count
   from payment;
   -- display a message
   raise notice 'The number of payments is %', payment_count;
end payment_block $$;
======================================================================================================================================
do $$ 
declare
   v_first_name staff.first_name%type;
   v_last_name staff.last_name%type;
   v_user_name v_last_name%type;
   v_last_update staff.last_update%type; 
begin 
   -- get title of the film id 100
   select first_name,last_name,username,last_update
   from staff
   into v_first_name,v_last_name,v_user_name,v_last_update
   where staff_id = 1;
   
   -- show the film title
   raise notice 'Staff id 1: %s , %s , %s %s', v_first_name,v_last_name,v_user_name, TO_CHAR(v_last_update,'Mon-DD-YYYY');
end; $$
==========================================================================================================
do $$ 
<<country_block>>
declare
  country_count integer := 0;
  languages integer := 1;
begin
   -- get the number of countries
   languages = languages + 1;
   raise notice 'The Language count in country block is %',languages;
   select count(*) 
   into country_count
   from country;
   -- display a message
   raise notice 'The number of countries is %', country_count;
   declare
     languages integer :=1;
   begin
     languages = languages + 100;
     raise notice 'The Language count in country block is % and langugae count in sub block is %',country_block.languages,languages;
   end;

end country_block $$;
do $$
<<payment_block>>
declare
  payment_count integer := 0;
begin
   -- get the number of countries
   select count(*) 
   into payment_count
   from payment;
   -- display a message
   raise notice 'The number of payments is %', payment_count;
end payment_block $$;
================================================================================================================
do $$
declare
   v_film film%rowtype;
   len_description varchar(100);
begin  

  select * from film
  into v_film
  where film_id = 100;
  
  if not found then
     raise notice 'Film not found';
  else
      if v_film.length >0 and v_film.length <= 50 then
		 len_description := 'Short';
	  elsif v_film.length > 50 and v_film.length < 120 then
		 len_description := 'Medium';
	  elsif v_film.length > 120 then
		 len_description := 'Long';
	  else 
		 len_description := 'N/A';
	  end if;
    
	  raise notice 'The % film is %.',
	     v_film.title,  
	     len_description;
  end if;
end $$
============================================================================================================================

do $$
declare 
	price   stock.cost%type;
	price_segment varchar(50);
begin
    -- get the rental rate
    select cost into price
    from stock
    where invoice_no = 1;
	
	-- assign the price segment
	if found then
		case price
		   when 45000 then
              price_segment =  'Mass';
		   when 300000 then
              price_segment = 'Mainstream';
		   when 2000000 then
              price_segment = 'High End';
		   else
	    	  price_segment = 'Unspecified';
		   end case;
		raise notice '%', price_segment;  
    end if;
end; $$
================================================================================================
do $$ 
declare
    total_payment numeric; 
    service_level varchar(25) ;
begin
     select sum(cost) into total_payment
     from stock
     where invoice_no = 1; 
	 
	 if found then
	    case 
		   when total_payment > 200 then
               service_level = 'Platinum' ;
           when total_payment > 100 then
	           service_level = 'Gold' ;
           else
               service_level = 'Silver' ;
        end case;
		raise notice 'Service Level: %', service_level;
     else
	    raise notice 'Customer not found';
	 end if;
end; $$
=====================================================================================
create function get_acc_payment_by_staff(p_staff_id int)
returns int
language plpgsql
as
$$
declare
   v_total_amount integer;
begin
   SELECT sum(amount) into v_total_amount
	FROM public.payment group by staff_id having staff_id=p_staff_id;
   
   return v_total_amount;
end;
$$;
===============================================================================

create or replace function staff_customer_count(
	inout id int
) 
language plpgsql	
as $$
begin
   select count(customer_id) into id from rental group by staff_id having staff_id=id;
end; $$;

=============================================================================
create or replace function get_film (
  p_pattern varchar
) 
	returns table (
		film_title varchar,
		film_release_year int
	) 
	language plpgsql
as $$
begin
	return query 
		select
			title,
			release_year::integer
		from
			film
		where
			title ilike p_pattern;
end;$$
=======================================================

SELECT * FROM get_film ('Al%');
==================================================
\c plsqldb

drop table if exists accounts;

create table accounts (
    id int generated by default as identity,
    name varchar(100) not null,
    balance dec(15,2) not null,
    primary key(id)
);

insert into accounts(name,balance)
values('Bob',10000);

insert into accounts(name,balance)
values('Alice',10000);
===================================================
create or replace procedure transfer(
   sender int,
   receiver int, 
   amount dec
)
language plpgsql    
as $$
begin
    -- subtracting the amount from the sender's account 
    update accounts 
    set balance = balance - amount 
    where id = sender;

    -- adding the amount to the receiver's account
    update accounts 
    set balance = balance + amount 
    where id = receiver;

    commit;
end;$$
===========================================================
call transfer(1,2,1000);
===============================================================
