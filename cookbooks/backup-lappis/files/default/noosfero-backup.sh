#!/bin/bash
BKP_DIR_NOOSFERO=/var/backups/portal
BKP_DIR_REDMINE=/var/backups/redmine
BKP_DIR_SPB=/var/backups/spb
BKP_DIR_REDMINE_FILES=/var/backups/redmine_files
#Apaga os backups com mais de 7 dias
cd $BKP_DIR_NOOSFERO
for i in `find $BKP_DIR_NOOSFERO/ -maxdepth 1 -type d -mtime +3 -print`; do rm -rf $i; done

cd $BKP_DIR_REDMINE
for i in `find $BKP_DIR_REDMINE/ -maxdepth 1 -type d -mtime +3 -print`; do rm -rf $i; done

cd $BKP_DIR_REDMINE_FILES
for i in `find $BKP_DIR_REDMINE_FILES/ -maxdepth 1 -type d -mtime +3 -print`; do rm -rf $i; done

#cd $BKP_DIR_SPB
#for i in `find $BKP_DIR_SPB/ -maxdepth 1 -type d -mtime +3 -print`; do rm -rf $i; done
