/****** Script for SelectTopNRows command from SSMS  ******/


CREATE MASTER KEY;

CREATE DATABASE SCOPED CREDENTIAL ADLSCreds
WITH
	IDENTITY = 'datalakeg2dp201demo01' ,
    SECRET = 'VSpshzGat3s9GJ0wjCfWb0AMZVSQ7qfjLK/cFMGNVFxoV4yQ9w9Hq2SKlM21SVRHgCsDU6CZAxJmVGeZN61eAg=='
;

-- https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction-abfs-uri
CREATE EXTERNAL DATA SOURCE ADLG2Source
WITH
  ( LOCATION = 'abfss://synapseinput@datalakeg2dp201demo01.dfs.core.windows.net/sample-csv.csv' ,
   CREDENTIAL = ADLSCreds,
    TYPE = HADOOP
 );


CREATE EXTERNAL FILE FORMAT csvFile
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
      FIELD_TERMINATOR = ',',
      STRING_DELIMITER = '"',
      FIRST_ROW = 2,
      USE_TYPE_DEFAULT = FALSE,
      ENCODING = 'UTF8')
);


CREATE EXTERNAL TABLE dbo.MyExternalTable (
	   [firstname] NVARCHAR(256) NULL
      ,[lastname] NVARCHAR(256) NULL
      ,[gender] NVARCHAR(256) NULL
	  ,[location] NVARCHAR(256) NULL
      ,[subscription_type] NVARCHAR(256) NULL
)
WITH (
    LOCATION='../',
    DATA_SOURCE=ADLG2Source,
    FILE_FORMAT=csvFile,
	REJECT_TYPE = value,
	REJECT_VALUE = 2
);

