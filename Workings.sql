--Appending monthly sales data to create annual sales table

CREATE OR REPLACE TABLE rfm-493217.sales.sales_2025 AS
SELECT * FROM rfm-493217.sales.2025_01
UNION ALL SELECT * FROM rfm-493217.sales.2025_02
UNION ALL SELECT * FROM rfm-493217.sales.2025_03
UNION ALL SELECT * FROM rfm-493217.sales.2025_04
UNION ALL SELECT * FROM rfm-493217.sales.2025_05
UNION ALL SELECT * FROM rfm-493217.sales.2025_06
UNION ALL SELECT * FROM rfm-493217.sales.2025_07
UNION ALL SELECT * FROM rfm-493217.sales.2025_08
UNION ALL SELECT * FROM rfm-493217.sales.2025_09
UNION ALL SELECT * FROM rfm-493217.sales.2025_10
UNION ALL SELECT * FROM rfm-493217.sales.2025_11
UNION ALL SELECT * FROM rfm-493217.sales.2025_12;

--Calculating R,F,M ranks by combining views with CTEs

CREATE OR REPLACE VIEW rfm-493217.sales.rfmmetrics
AS 
WITH current_date AS (
  SELECT DATE ('2026-04-14') AS analysis_date --todays's date
),
rfm AS (
  SELECT
    CustomerID,
    MAX(OrderDate) AS  latest_order_date,
    date_diff((SELECT analysis_date FROM current_date),MAX(OrderDate),DAY) AS recency,
    COUNT(*) AS frequency,
    SUM(OrderValue)AS monetary
  FROM rfm-493217.sales.sales_2025
  GROUP BY CustomerID
)

SELECT rfm.*,
ROW_NUMBER() OVER(ORDER BY recency ASC) AS r_rank,
ROW_NUMBER() OVER(ORDER BY frequency DESC) AS f_rank,
ROW_NUMBER() OVER(ORDER BY monetary DESC) AS m_rank
 FROM rfm;

