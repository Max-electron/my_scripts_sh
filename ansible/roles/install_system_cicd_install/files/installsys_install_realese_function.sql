create or replace function installsys.install_realese(p_command varchar) returns text as
$body$
declare
  v_err_sqlstate text;
  v_err_message text;
  v_err_context text;
begin
  if lower(p_command) = 'start'
  then
    execute 'grant installsys to install';
    return 'INSTALL_REALESE('''|| upper(p_command) ||''') - OK';
  elsif lower(p_command) = 'stop'
  then
    execute 'revoke installsys from install';
    return 'INSTALL_REALESE('''|| upper(p_command) ||''') - OK';
  else
    return 'INSTALL_REALESE('''|| upper(p_command) ||''') - invalid parameter. Use ''START'' or ''STOP''.'; 
  end if;
exception
when others then
  GET STACKED DIAGNOSTICS
      v_err_sqlstate = returned_sqlstate,
      v_err_message = message_text,
      v_err_context = pg_exception_context;
  return 'INSTALL_REALESE('''|| upper(p_command) ||''') - ERROR ' || v_err_sqlstate || ': ' || v_err_message || chr(10) || 'CONTEXT: ' || v_err_context;
end;
$body$
language plpgsql security definer;
