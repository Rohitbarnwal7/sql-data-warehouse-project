/*
===============================================================================
 Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

 Script Purpose:
     This stored procedure loads data into the 'bronze' schema from external CSV files.
     It performs the following actions:
     - Truncates the bronze tables before loading data.
     - Uses the `BULK INSERT` command to load data from CSV files.

 Parameters:
     None.
     This stored procedure does not accept any parameters or return any values.

 Usage Example:
     EXEC bronze.load_bronze;

===============================================================================
*/

--- Source: Bronze schema
--- CRM
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id VARCHAR(50),
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(200),
    cst_lastname VARCHAR(200),
    cst_marital_status VARCHAR(20),
    cst_gndr VARCHAR(10),
    cst_create_date VARCHAR(50)
);
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(255),
    prd_cost VARCHAR(50),
    prd_line VARCHAR(100),
    prd_start_dt VARCHAR(50),
    prd_end_dt VARCHAR(50)
);
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id VARCHAR(50),
    sls_order_dt VARCHAR(50),
    sls_ship_dt VARCHAR(50),
    sls_due_dt VARCHAR(50),
    sls_sales VARCHAR(50),
    sls_quantity VARCHAR(50),
    sls_price VARCHAR(50)
);
--- ERP
IF OBJECT_ID('bronze.erp_cust', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust;
CREATE TABLE bronze.erp_cust (
    CID VARCHAR(50),
    BDATE VARCHAR(50),
    GEN VARCHAR(20)
);
IF OBJECT_ID('bronze.erp_cust_location', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_location;
CREATE TABLE bronze.erp_cust_location (
    CID VARCHAR(50),
    CNTRY VARCHAR(100)
);
IF OBJECT_ID('bronze.erp_prd_category', 'U') IS NOT NULL
    DROP TABLE bronze.erp_prd_category;
CREATE TABLE bronze.erp_prd_category (
    ID VARCHAR(50),
    CAT VARCHAR(100),
    SUBCAT VARCHAR(100),
    MAINTENANCE VARCHAR(100)
);

CREATE OR ALTER PROCEDURE bronze.load_bronze AS

BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME , @batch_end_time DATETIME

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '==========================================';
        PRINT 'LOADING BRONZE LAYER';
        PRINT '==========================================';

        PRINT '------------------------------------------';
        PRINT 'LOADING CRM Tables';
        PRINT '------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data into: bronze.crm_cust_info';

            BULK INSERT bronze.crm_cust_info
            FROM "C:\Users\rohit\Downloads\Sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv"
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        SET @end_time= GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF (second, @start_time , @end_time) AS NVARCHAR) + ' seconds'
        PRINT '>> Truncating Table: bronze.crm_prd_info';

        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data into: bronze.crm_prd_info';

            BULK INSERT bronze.crm_prd_info
            FROM "C:\Users\rohit\Downloads\Sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv"
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        PRINT '>> Truncating Table: bronze.crm_sales_details';

        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data into: bronze.crm_sales_details';

            BULK INSERT bronze.crm_sales_details
            FROM "C:\Users\rohit\Downloads\Sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv"
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );

        PRINT '------------------------------------------';
        PRINT 'LOADING ERP Tables';
        PRINT '------------------------------------------';
    
        PRINT '>> Truncating Table: bronze.erp_cust';

        TRUNCATE TABLE bronze.erp_cust;

        PRINT '>> Inserting Data into: bronze.erp_cust';

            BULK INSERT bronze.erp_cust
            FROM "C:\Users\rohit\Downloads\Sql\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv"
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );

        PRINT '>> Truncating Table: bronze.erp_cust_location';

        TRUNCATE TABLE bronze.erp_cust_location;

        PRINT '>> Inserting Data into: bronze.erp_cust_location';

            BULK INSERT bronze.erp_cust_location
            FROM "C:\Users\rohit\Downloads\Sql\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv"
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );

        PRINT '>> Truncating Table: bronze.erp_prd_category';

        TRUNCATE TABLE bronze.erp_prd_category;
    
        PRINT '>> Inserting Data into: bronze.erp_prd_category';

            BULK INSERT bronze.erp_prd_category
            FROM "C:\Users\rohit\Downloads\Sql\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv"
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
    END TRY
    BEGIN CATCH
            PRINT '================================================';
            PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
            PRINT 'Error Message' + ERROR_MESSAGE();
            PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
            PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
            PRINT '================================================';
    END CATCH
    SET @batch_end_time = GETDATE()
    PRINT '>> BRONZE Layer Completed'
    PRINT '>> Total Load Duration: ' + CAST(DATEDIFF (second, @batch_start_time , @batch_end_time) AS NVARCHAR) + ' seconds'
END
