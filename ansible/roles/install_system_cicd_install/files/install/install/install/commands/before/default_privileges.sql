grant usage on schema install to public;
alter default privileges for role install revoke all on tables from public;
alter default privileges for role install grant select on tables to public;
alter default privileges for role install revoke all on sequences from public;
alter default privileges for role install revoke all on types from public;
alter default privileges for role install revoke execute on routines from public;
