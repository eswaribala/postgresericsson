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
