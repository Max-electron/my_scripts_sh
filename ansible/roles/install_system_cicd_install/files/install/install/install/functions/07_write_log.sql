create or replace function install.write_log(p_message_type varchar
                                             ,p_action       varchar default ''
                                             ,p_text         varchar default ''
                                             ,p_color        varchar default 'none') returns text as
$body$
declare  
  c_str_lenght     smallint := 15;
  c_separator      varchar(255) := '[---------------------------------------------------------------------------------------------------------------]';
  v_message_screen text;
  v_message_log    text;
begin
  v_message_screen := '[' || install.set_color_text(to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss'), 'green') || ' : ' ||
                      install.set_color_text('POSTGRES', 'green') || ' : ' ||
                      install.set_color_text(rpad(p_action, c_str_lenght), 'green') || ' : ';
  v_message_log    := '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' ||
                      rpad(p_action, c_str_lenght) || ' : ';

  if p_message_type = 'SEP'
  then
    raise notice '%', install.set_color_text(c_separator, p_color);
    v_message_log := c_separator;
  elsif p_message_type = 'INF'
  then
    v_message_screen := v_message_screen || install.set_color_text(p_message_type, 'blue') || '] ' || p_text;
    v_message_log    := v_message_log || p_message_type || '] ' || p_text;
    raise notice '%', v_message_screen;
  elsif p_message_type = 'WRN'
  then
    v_message_screen := v_message_screen || install.set_color_text(p_message_type, 'pink') || '] ' ||
                        install.set_color_text(p_text, 'pink');
    v_message_log    := v_message_log || p_message_type || '] ' || p_text;
    raise notice '%', v_message_screen;    
  elsif p_message_type = 'ERR'
  then
    v_message_screen := v_message_screen || install.set_color_text(p_message_type, 'red') || '] ' ||
                        install.set_color_text(p_text, 'red');
    v_message_log    := v_message_log || p_message_type || '] ' || p_text;
    raise notice '%', v_message_screen;
  elsif p_message_type = 'TRC'
  then
    v_message_screen := v_message_screen || install.set_color_text(p_message_type, 'yellow') || '] ';
    raise notice '%', v_message_screen;
    raise notice '%', install.set_color_text(c_separator, p_color);
    raise notice '...[ERROR] %', p_text;
    raise notice '%', install.set_color_text(c_separator, p_color);
    v_message_log := v_message_log || p_message_type || '] ' || chr(10) || c_separator || chr(10) || '...[ERROR] ' ||
                     p_text || chr(10) || c_separator;
  elsif p_message_type = 'TXT'
  then
    raise notice '%', install.set_color_text(p_text, p_color);
    v_message_log := p_text;
  end if;
  return v_message_log;
end;
$body$
language plpgsql;
