#!/bin/bash
chmod 0700 /opt/emc/boostfs/lockbox/* && chmod 1700 /opt/emc/boostfs/lockbox && chmod 1700 /opt/emc/boostfs/log
setfacl -m u:postgres:rwx /opt/emc/boostfs/lockbox && setfacl -m u:postgres:rwx /opt/emc/boostfs/log && setfacl -m u:postgres:rw /opt/emc/boostfs/lockbox/*
