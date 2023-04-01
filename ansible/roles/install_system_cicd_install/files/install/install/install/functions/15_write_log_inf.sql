create or replace function install.write_log_inf(p_action varchar default ''
                                                 ,p_text   varchar default '') returns text as
$body$
declare
  v_result text;
begin
  select install.write_log(p_message_type => 'INF', p_action => p_action, p_text => p_text) into v_result;
  return v_result;
end;
$body$
language plpgsql;
