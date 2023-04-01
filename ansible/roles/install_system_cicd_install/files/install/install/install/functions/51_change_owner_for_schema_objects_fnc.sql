create or replace function install.change_owner_for_schema_objects_fnc(p_new_owner text, p_schema text) returns text as
$body$
declare
  v_tables cursor for
    select tablename from pg_catalog.pg_tables
    where schemaname = p_schema;
  v_user_defined_types cursor for
   select user_defined_type_name 
   from information_schema.user_defined_types udt 
   where udt.user_defined_type_schema = p_schema;   
  v_views cursor for
    select viewname from pg_catalog.pg_views
    where schemaname = p_schema;
  v_matviews cursor for   
    select matviewname from pg_catalog.pg_matviews pm 
    where schemaname = p_schema;   
  v_functions cursor for
    select p.proname as name,
    case p.prokind 
	     when 'p' then 'procedure'
	     else 'function'
	end as type,
    pg_catalog.pg_get_function_identity_arguments(p.oid) as params
    from pg_catalog.pg_proc p 
    join pg_namespace n on n.oid = p.pronamespace 
    where n.nspname = p_schema;
  v_statement text;
  v_result text;
begin
  v_result := 'Change owner to ' || p_new_owner || ' for all objects in schema ' || p_schema ||':';
  for v_rec in v_tables loop
	v_statement := 'alter table ' || p_schema || '.' || v_rec.tablename || ' owner to ' || p_new_owner || ';'; 
    v_result := v_result || chr(10) || '    ' || v_statement;
    execute v_statement;
  end loop;
  for v_rec in v_user_defined_types loop
	v_statement := 'alter type ' || p_schema || '.' || v_rec.user_defined_type_name || ' owner to ' || p_new_owner || ';'; 
    v_result := v_result || chr(10) || '    ' || v_statement;
    execute v_statement;
  end loop; 
  for v_rec in v_views loop
    v_statement := 'alter view ' || p_schema || '.' || v_rec.viewname || ' owner to ' || p_new_owner || ';';
    v_result := v_result || chr(10) || '    ' || v_statement;
    execute v_statement;
  end loop;
  for v_rec in v_matviews loop
    v_statement := 'alter materialized view ' || p_schema || '.' || v_rec.matviewname || ' owner to ' || p_new_owner || ';';
    v_result := v_result || chr(10) || '    ' || v_statement;
    execute v_statement;
  end loop; 
  for v_rec in v_functions loop
    v_statement := 'alter '|| v_rec.type || ' ' || p_schema || '.' || v_rec.name || '(' ||  v_rec.params || ') owner to ' || p_new_owner || ';';
    v_result := v_result || chr(10) || '    ' || v_statement;
    execute v_statement;
  end loop;
  return v_result; 
end;
$body$
language plpgsql;