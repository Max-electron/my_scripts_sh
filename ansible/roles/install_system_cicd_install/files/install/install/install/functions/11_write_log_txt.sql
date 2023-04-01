create or replace function install.write_log_txt(p_text  varchar
                                                 ,p_color varchar default 'none') returns text as
$body$
declare
  v_result text;
begin
  select install.write_log(p_message_type => 'TXT', p_text => p_text, p_color => p_color) into v_result;
  return v_result;
end;
$body$
language plpgsql;
