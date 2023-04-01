revoke execute on function install.start_upgrade_system(varchar, varchar, varchar, varchar, varchar, integer, integer, varchar, varchar, boolean) from public;
revoke execute on function install.finish_upgrade_system(varchar, varchar, varchar, boolean) from public;
grant execute on function install.get_version(varchar,timestamp) to public;
