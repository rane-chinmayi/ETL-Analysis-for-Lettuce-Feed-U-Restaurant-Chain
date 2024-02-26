Introduction:
Lettuce Feed U is a restaurant chain that belongs to Health Options, Inc., a company that has been in business for 20 years and has various establishments located in different parts of the United States. Each restaurant offers one or more drive-thru lanes for customer convenience, and all of them offer the same menu items at identical prices.

Project Objectives:
•	To clean the dataset CaseStudy2023_New and create a master cleaned dataset. 
•	Define, create, and populate the fact and dimension tables using SSIM and Microsoft Visual Studio.
•	Provide accurate and reliable insights to the executive team based on our ETL analysis.


Data Analysis:
1.	Data Access & Preparation – 
The first step was to create a master table in our own database and insert data from the CaseStudy2023 dataset provided to us. This data had some inconsistencies like null values, the number zero in the description column, and some invalid characters. This portion was executed in SSIM.

DROP TABLE if exists [CaseStudy2023_new]
go

SELECT *
INTO SP23_kschrane.dbo.CaseStudy2023_new
FROM CaseStudy2023.dbo.CaseStudy2023AllRecs_new
GO

select * from CaseStudy2023_new

Data Cleaning & Transformation
We followed the following steps for our data-cleaning process. This process is executed in Visual Studio.
1.	Remove the duplicates- We used the ‘Sort’ tool and checked the ‘remove duplicates’ checkbox
2.	Replace weird values -  We used ‘Derived Columns’ to replace the following:
•	BuildingType - Replace NULL value to “NONE”
•	StoreAddress - Replace comma “,” to “”
•	ProductDescr column
o	Replace “?” to “”
o	Replace “,” to “+” (I chose to output a csv file. Because comma is the delimited in the flat file destination, extra commas in ProductDescr string would produce extra columns in the destination file)
o	Replace “0” to “None”
•	MenuSubCategory – Replace “0” to “None”
3.	Change data type when loading data to the OLE DB Destination
o	ReceiptNbr, StoreNbr, ProductNbr use 4 bytes unsigned integer
o	ProductGrossAmt, ProductNetAmt, ProductTaxAmt use float data type
o	BuildingType use string(200)
o	TransDate, DateStoreOpened use date data type
o	TransTime use database time
o	StoreStatus use string(50)
o	StoreAddress, StoreCity, StoreState use string(200)
o	StoreZipCode use string(10)
o	MenuName use string(10)
o	ProductDesc use string(300), MenuCategory, MenuSubCategory, MenuType use string(200)
o	DefaultProductPrice use float
o	Remove the column File1ID

4.	By the end of this process, we have two datasets – one is the original before cleaning and the newer version after cleaning named CleanedMasterTable.

