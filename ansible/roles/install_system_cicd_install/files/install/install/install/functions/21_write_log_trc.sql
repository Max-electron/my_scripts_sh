create or replace function install.write_log_trc(p_action varchar default ''
                                                 ,p_text   varchar default ''
                                                 ,p_color  varchar default 'red') returns text as
$body$
declare
  v_result text;
begin
  select install.write_log(p_message_type => 'TRC', p_action => p_action, p_text => p_text, p_color => p_color) into v_result;
  return v_result;
end;
$body$
language plpgsql;
