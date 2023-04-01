create or replace function install.write_log_sep(p_color varchar default 'none') returns text as
$body$
declare
  v_result text;
begin
  select install.write_log(p_message_type => 'SEP', p_color => p_color) into v_result;
  return v_result;
end;
$body$
language plpgsql;
