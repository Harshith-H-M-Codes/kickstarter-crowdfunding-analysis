CREATE DATABASE IF NOT EXISTS Crowd_Funding;
USE Crowd_Funding;

-- Calendar_Table:
CREATE TABLE Calendar_Table (
    created_at DATE PRIMARY KEY,
    `Year` INT,
    Monthno INT,
    Monthfullname VARCHAR(255),
    `Quarter` VARCHAR(255),
    YearMonth VARCHAR(255),
    Weekdayno INT,
    Weekdayname VARCHAR(255),
    `Financial Month` VARCHAR(255),
    `Financial Quarter` VARCHAR(255)
);

describe Calendar_Table;

-- Load Data into Calendar_Table:
LOAD DATA INFILE 'Calendar_Table.csv' 
INTO TABLE Calendar_Table
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES 
(@var_date, Year, Monthno, Monthfullname, Quarter, YearMonth,
 Weekdayno, Weekdayname, `Financial Month`, `Financial Quarter`)
SET created_at = STR_TO_DATE(@var_date, '%d-%m-%Y');

select count(*) from Calendar_Table;
select * from Calendar_Table;

-- Category:
CREATE TABLE Category (
    id INT PRIMARY KEY,
    `name` VARCHAR(255),
    parent_id INT,
    position INT
);

describe Category;

-- Load Data into Category:
LOAD DATA INFILE 'Category.csv'
INTO TABLE Category
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(id, name, @parent_id, position)
SET parent_id = NULLIF(@parent_id, '');

select Count(*) from Category;
select * from Category;

-- Crowdfunding_Creator:
CREATE TABLE Crowdfunding_Creator (
    id BIGINT PRIMARY KEY,
    `name` VARCHAR(255),
    chosen_currency VARCHAR(255)
);

describe Crowdfunding_Creator;

-- Load Data into Crowdfunding_Creator:
LOAD DATA INFILE 'Crowdfunding_Creator.csv'
INTO TABLE Crowdfunding_Creator
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(id, @name, @chosen_currency)
SET 
    `name` = NULLIF(@name, ''),
    chosen_currency = NULLIF(@chosen_currency, '');

select Count(*) from Crowdfunding_Creator;
select * from Crowdfunding_Creator;

-- Crowdfunding_Location:
CREATE TABLE Crowdfunding_Location (
    id INT PRIMARY KEY,
    displayable_name VARCHAR(255),
    `type` VARCHAR(255),
    `name` VARCHAR(255),
    state VARCHAR(255),
    short_name VARCHAR(255),
    is_root VARCHAR(255),
    country VARCHAR(255),
    localized_name VARCHAR(255),
    `country name` VARCHAR(255)
);

describe Crowdfunding_Location;

-- Load Data into Crowdfunding_Location:
LOAD DATA INFILE 'Crowdfunding_Location.csv'
INTO TABLE Crowdfunding_Location
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(id, displayable_name, `type`, `name`, @state, 
short_name, is_root, country, @localized_name, `country name`)
SET 
    state = NULLIF(@state, ''),
    localized_name = NULLIF(@localized_name, '');
    
select Count(*) from Crowdfunding_Location;
select * from Crowdfunding_Location;

-- Main_Table:
CREATE TABLE Main_Table (
    id BIGINT PRIMARY KEY,
    state VARCHAR(255),
    `name` VARCHAR(255),
    country VARCHAR(255),
    creator_id BIGINT,
    location_id INT,
    category_id INT,
    created_at DATE,
    deadline DATE,
    updated_at DATE,
    state_changed_at DATE,
    successful_at DATE,
    launched_at DATE,
    goal DOUBLE,
    pledged DOUBLE,
    currency VARCHAR(255),
    currency_symbol VARCHAR(255),
    usd_pledged DOUBLE,
    static_usd_rate DOUBLE,
    goal_usd DOUBLE,
    backers_count INT,
    spotlight VARCHAR(255),
    staff_pick VARCHAR(255),
    blurb VARCHAR(1000),
    currency_trailing_code VARCHAR(255),
    disable_communication VARCHAR(255),
    `no. of days` INT,
    `Goal Range` VARCHAR(255),
    FOREIGN KEY (created_at) REFERENCES Calendar_Table(created_at) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (creator_id) REFERENCES Crowdfunding_Creator(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (location_id) REFERENCES Crowdfunding_Location(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(id) ON DELETE CASCADE ON UPDATE CASCADE
);

describe Main_Table;

-- Load Data into Main_Table:
LOAD DATA INFILE 'Main_Table.csv'
INTO TABLE Main_Table
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(id, state, `name`, country, creator_id, @location_id, category_id, @created_at, @deadline,
 @updated_at, @state_changed_at, @successful_at, @launched_at, goal, pledged, currency, currency_symbol,
 usd_pledged, static_usd_rate, goal_usd, backers_count, spotlight, staff_pick, blurb,
 currency_trailing_code, disable_communication, `no. of days`, `Goal Range`)
SET 
    location_id = NULLIF(@location_id, ''),
    created_at = STR_TO_DATE(@created_at, '%d-%m-%Y') ,
    deadline = STR_TO_DATE(@deadline, '%d-%m-%Y'),
    updated_at = STR_TO_DATE(@updated_at, '%d-%m-%Y'),
    state_changed_at = STR_TO_DATE(@state_changed_at, '%d-%m-%Y'),
    successful_at = STR_TO_DATE(@successful_at, '%d-%m-%Y'),
    launched_at = STR_TO_DATE(@launched_at, '%d-%m-%Y');

select Count(*) from Main_Table;
select * from  Main_Table;

SET SQL_SAFE_UPDATES = 0;

UPDATE Main_Table
SET successful_at = NULL
WHERE successful_at = '1970-01-01';

SET SQL_SAFE_UPDATES = 1;

select * from  Main_Table;


