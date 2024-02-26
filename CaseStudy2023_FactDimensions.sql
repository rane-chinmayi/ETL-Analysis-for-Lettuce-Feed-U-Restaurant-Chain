use SP23_kschrane
go

DROP TABLE if exists SalesFact
DROP TABLE if exists ProductDimension
DROP TABLE if exists TimeDimension
DROP TABLE if exists StoreDimension
Drop TABLE if exists CleanedMasterTable

go




-- Create TimeDimension

CREATE TABLE TimeDimension (
date_key int PRIMARY KEY IDENTITY(1,1),
fulldate datetime,
year_nbr int,
month_nbr int,
day_nbr int,
qtr int,
day_of_week int,
day_of_year int,
day_name char(15),
month_name char(15)
)
go


-- Create ProductDimension

CREATE TABLE ProductDimension (
	product_key int PRIMARY KEY IDENTITY(1,1),
    ProductNbr INT NOT NULL,
    MenuName VARCHAR(255) NOT NULL,
    ProductDesc VARCHAR(255),
    MenuCategory VARCHAR(50),
    MenuSubCategory VARCHAR(50),
    MenuType VARCHAR(50),
    DefaultProductPrice DECIMAL(10,2)
);

-- Create clean master table

CREATE TABLE CleanedMasterTable (
    [StoreNbr] int,
    [ReceiptNbr] int,
    [TransDate] datetime,
    [TransTime] time(7),
    [ProductNbr] int,
    [Quantity] int,
    [ProductGrossAmt] numeric(18,4),
    [ProductTaxAmt] numeric(18,4),
    [ProductNetAmt] numeric(18,4),
    [NbrDriveThruLanes] int,
    [NbrParkingSpaces] int,
    [StoreCapacity] int,
    [BuildingType] nvarchar(50),
    [DateStore Opened] datetime,
    [StoreStatus] nvarchar(255),
    [StoreAddress] nvarchar(255),
    [StoreCity] nvarchar(255),
    [StoreState] nvarchar(255),
    [StoreZipCode] nvarchar(20),
    [MenuName] nvarchar(255),
    [ProductDesc] nvarchar(255),
    [MenuCategory] nvarchar(255),
    [MenuSubCategory] nvarchar(255),
    [MenuType] nvarchar(255),
    [DefaultProductPrice] numeric(18,4)
);




--Create StoreDimesion

CREATE TABLE StoreDimension (
	store_key int PRIMARY KEY IDENTITY(1,1),
    StoreNbr INT NOT NULL,
    NbrDriveThruLanes INT,
    NbrParkingSpaces INT,
    StoreCapacity INT,
    BuildingType VARCHAR(50),
    DateStoreOpened DATE,
    StoreStatus VARCHAR(50),
    StoreState CHAR(2),
    StoreZipCode CHAR(5)
);





-- Sales Fact
   
CREATE TABLE SalesFact (

    sales_key INT IDENTITY(1,1) PRIMARY KEY,
    date_key INT,
	-- product_key INT
    product_key INT,
	-- store_key INT
    store_key INT,
    ProductNbr INT NOT NULL,
    StoreNbr INT NOT NULL,
	ReceiptNbr INT NOT NULL,
	TransDate datetime NOT NULL,
    Quantity INT,
    ProductGrossAmt DECIMAL(10,2),
    ProductTaxAmt DECIMAL(10,2),
    ProductNetAmt DECIMAL(10,2),
    CONSTRAINT FK_DateDimension FOREIGN KEY (date_key) REFERENCES TimeDimension(date_key),
    CONSTRAINT FK_ProductDimension FOREIGN KEY (product_key) REFERENCES ProductDimension(product_key),
    CONSTRAINT FK_StoreDimension FOREIGN KEY (store_key) REFERENCES StoreDimension(store_key),
);

--- storeprocedure for date
DROP PROCEDURE if exists insertIntoDateDim
go

CREATE PROCEDURE insertIntoDateDim
as
BEGIN
DECLARE @date date = '2021-01-01'
DECLARE @date_key int = 1
WHILE (@date <= '2023-12-31')
BEGIN
SET IDENTITY_INSERT TimeDimension ON
INSERT INTO TimeDimension (date_key, fulldate, year_nbr, month_nbr,
day_nbr, qtr, day_of_week, day_of_year, day_name, month_name)
VALUES (@date_key, @date, YEAR(@date), MONTH(@date), DAY(@date),
DATEPART(quarter, @date), DATEPART(dw, @date), DATEPART(dy, @date),
DATENAME(weekday, @date), DATENAME(month, @date))

SET @date = DATEADD(day, 1, @date)
SET @date_key = @date_key + 1
END
END
SET IDENTITY_INSERT TimeDimension OFF








