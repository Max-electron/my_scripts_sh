create or replace function install.set_color_text(p_text  varchar
                                                 ,p_color varchar default 'none') returns varchar as
$body$
begin
  --Если выполняем функцию из psql, то добавляется цвет
  if current_setting('application_name') = 'psql' and coalesce(current_setting('context.COLORED', true)::integer,0) = 1 then                                                   
    return install.get_color_start(p_color) || p_text || install.get_color_end();
  else  
    return p_text;  
  end if;  
end;
$body$
language plpgsql;
