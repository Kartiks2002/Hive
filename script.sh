#!/bin/bash

# Author : Kartik
# Created on : 20-11-2024
# Last Modified : 20-11-2024

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

HDFS_DIR="/user/cloudera"

# Check if the CSV file already exists on HDFS
hdfs dfs -test -f $HDFS_DIR/Cleaned_Listofstartups.csv
if [ $? -eq 0 ]; then
    echo -e "${GREEN}File Cleaned_Listofstartups.csv already exists in HDFS. Removing it...${NC}"
    hdfs dfs -rm $HDFS_DIR/Cleaned_Listofstartups.csv
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}File successfully removed.${NC}"
    else
        echo -e "${RED}Error: Failed to remove the file from HDFS.${NC}"
        exit 1
    fi
fi

# Put the CSV file on HDFS from local
echo -e "${GREEN}Uploading Cleaned_Listofstartups.csv to HDFS...${NC}"
hdfs dfs -put Cleaned_Listofstartups.csv $HDFS_DIR/
if [ $? -eq 0 ]; then
    echo -e "${GREEN}File uploaded successfully to HDFS. ${NC}"
else
    echo -e "${RED}Error: Failed to upload the file to HDFS.${NC}"
    exit 1
fi

# Execute Hive query from the hql script
echo -e "${GREEN}Executing Hive queries from new_queries.hql...${NC}"
hive -f queries.hql > result.log 2>&1

# To capture only the lines immediately after the "OK" (the results part), use awk
grep -A 2 "OK" result.log | grep -v "OK"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Hive queries executed successfully.${NC}"
else
    echo -e "${RED}Error: Hive query execution failed.${NC}"
    exit 1
fi
