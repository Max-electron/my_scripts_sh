create or replace view install.sys_registry_data as
select r.id_sys_reg
      ,r.sys_name
      ,r.version
      ,r.install_date
      ,r.dbuser
      ,r.osuser
  from install.sys_registry_data_tbl r
 where clock_timestamp() >= r.install_date
   and clock_timestamp() <= coalesce(r.uninstall_date, to_timestamp('01.01.9999', 'dd.mm.yyyy'));
