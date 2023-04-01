create or replace function install.show_active_session_fnc() returns text as
$body$
declare  
  v_result text;
  v_rec record;
begin
    v_result :=  
    install.write_log_txt('  ' ||
        rpad('pid',10)              || ' | '||
        rpad('usename',15)          || ' | '||            
        rpad('application_name',16) || ' | '||            
        rpad('client_addr',18)      || ' | '||            
        rpad('client_port',11)      || ' | '||
        rpad('backend_start',19)    || ' | '||
        rpad('xact_start',19)       || ' | '||
        rpad('query_start',19)      || ' | '||
        rpad('state_change',19)     || ' | '||
        rpad('wait_e_type',10)  || ' | '||
        rpad('wait_event',10)       || ' | '||
        rpad('query',50)            || ' | ', 'cyan');	
    for v_rec in (
      select p.pid
            ,p.usename
            ,p.application_name
            ,p.client_addr
            ,p.client_port
            ,to_char(p.backend_start, 'dd.mm.yyyy hh24:mi:ss') as backend_start
            ,to_char(p.xact_start, 'dd.mm.yyyy hh24:mi:ss') as xact_start
            ,to_char(p.query_start, 'dd.mm.yyyy hh24:mi:ss') as query_start
            ,to_char(p.state_change, 'dd.mm.yyyy hh24:mi:ss') as state_change
            ,p.wait_event_type
            ,p.wait_event
            ,substr(p.query, 1, 50) as query
        from pg_stat_activity p
       where p.state = 'active'
         and p.backend_type = 'client backend'
        order by p.usename, p.backend_start
    )
    loop
        v_result := v_result || chr(10) || 
        install.write_log_txt('  ' ||
            rpad(coalesce(v_rec.pid::varchar,''),10)              || ' | '||
            rpad(coalesce(v_rec.usename,''),15)                   || ' | '||            
            rpad(coalesce(v_rec.application_name,''),16)          || ' | '||            
            rpad(coalesce(v_rec.client_addr::varchar,''),18)      || ' | '||            
            rpad(coalesce(v_rec.client_port::varchar,''),11)      || ' | '||
            rpad(coalesce(v_rec.backend_start,''),19)             || ' | '||
            rpad(coalesce(v_rec.xact_start,''),19)                || ' | '||
            rpad(coalesce(v_rec.query_start,''),19)               || ' | '||
            rpad(coalesce(v_rec.state_change,''),19)              || ' | '||
            rpad(coalesce(v_rec.wait_event_type::varchar,''),10)  || ' | '||
            rpad(coalesce(v_rec.wait_event::varchar,''),10)       || ' | '||
            rpad(coalesce(v_rec.query,''),50)                     || ' | ', 'cyan'
        );
    end loop;
    return v_result;
end;
$body$ language plpgsql;
