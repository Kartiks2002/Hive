-- Drop the table if it exists
DROP TABLE IF EXISTS startups;

-- Create the table
CREATE TABLE startups (
    Incubation_Center STRING,     -- Center where startups are incubated
    Name_of_startup STRING,       -- Name of the startup
    Location_of_company STRING,   -- Location of the company
    Sector STRING,                -- Business sector of the startup
    City STRING,                  -- City where the startup is located
    State STRING                  -- State where the startup is located
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = ",",        -- Separator used in the CSV file
    "quoteChar" = "\""           -- Quote character used in the CSV file (typically double quotes)
)
TBLPROPERTIES ('skip.header.line.count'='1');  -- Skip the header row of the CSV file

-- Load the data from the CSV file into the 'startups' table
LOAD DATA INPATH '/user/cloudera/Cleaned_Listofstartups.csv' INTO TABLE startups;

-- Query 1: Get the sector with the most number of startups
SELECT 
    CONCAT(sector, ' sector has the most no of startups.') AS description, 
    COUNT(1) AS num_startups
FROM startups
GROUP BY sector
ORDER BY num_startups DESC
LIMIT 1;

-- Query 2: Get the state with the most number of startups
SELECT 
    CONCAT('State with most number of startups is: ', state) AS description, 
    COUNT(*) AS count
FROM startups
WHERE state IS NOT NULL
GROUP BY state
ORDER BY count DESC
LIMIT 1;

-- Query 3: Get the total number of startups from Maharashtra
SELECT 
    CONCAT('The total startups from Maharashtra: ', COUNT(*)) AS total_count
FROM startups
WHERE state = 'Maharashtra';

-- Query 4: Get the number of startups in the "Healthcare" sector using RLIKE
SELECT 
    CONCAT('No of startups that were formed in Healthcare: ', COUNT(*)) AS healthcare_count
FROM startups
WHERE sector RLIKE 'Healthcare';

