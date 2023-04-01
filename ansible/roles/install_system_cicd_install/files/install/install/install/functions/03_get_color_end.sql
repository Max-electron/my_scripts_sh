create or replace function install.get_color_end() returns varchar as
$body$
begin
  if current_setting('application_name') = 'psql' then                                                   
    return '[1;30m[1;m[1;m';
  else  
    return '';  
  end if;  
end;
$body$
language plpgsql;
