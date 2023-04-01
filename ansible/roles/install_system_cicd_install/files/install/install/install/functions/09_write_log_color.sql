create or replace function install.write_log_color(p_color varchar default 'none') returns void as
$body$
begin
  --Если выполняем функцию из psql, то добавляется цвет
  if current_setting('application_name') = 'psql' and coalesce(current_setting('context.COLORED', true)::integer,0) = 1 then   
     raise notice '%', install.get_color_start(p_color);
  end if;     
end;
$body$
language plpgsql;
