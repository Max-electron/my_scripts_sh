create or replace function install.get_color_start(p_color varchar) returns varchar as
$body$
begin
  case p_color
    when 'black' then
      return '[1;30m';
    when 'gray' then
      return '[1;30m';      
    when 'red' then
      return '[1;31m';
    when 'green' then
      return '[1;32m';
    when 'yellow' then
      return '[1;33m';
    when 'blue' then
      return '[1;34m';
    when 'pink' then
      return '[1;35m';
    when 'cyan' then
      return '[1;36m';
    when 'white' then
      return '[1;37m';
    else
      return '';
  end case;
end;
$body$
language plpgsql;
