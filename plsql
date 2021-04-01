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
