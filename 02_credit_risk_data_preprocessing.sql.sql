EXEC sp_help 'credit_record'

SELECT *
FROM application_record
WHERE ID IN (
	  SELECT ID
	  FROM application_record
	  GROUP BY ID
	  HAVING COUNT(*) > 1
	  )
	  ORDER BY ID

-- BƯỚC 1: Tính toán Thang điểm Rủi ro (Credit_Scores)
WITH Credit_Scores AS(
	SELECT ID,
		   MONTHS_BALANCE,
		   -- Ánh xạ STATUS (nvarchar) sang thang điểm số (Number)
		   CASE STATUS
				WHEN 'C' THEN 0 -- Đã thanh toán đầy đủ
				WHEN 'X' THEN 0 -- Không có khoản vay trong tháng
				WHEN '0' THEN 1 -- Chậm từ 1-29 ngày (RỦI RO NHẸ)
				WHEN '1' THEN 2 -- Chậm 30-59 ngày (RỦI RO TRUNG BÌNH)
				WHEN '2' THEN 3 -- Chậm 60-89 ngày (Ngưỡng RỦI RO NGHIÊM TRỌNG)
				WHEN '3' THEN 4  -- CHẬM 90-119 ngày
				WHEN '4' THEN 5  -- CHẬM 120-149 ngày
				WHEN '5' THEN 6  -- Vỡ nợ / Xóa sổ (> 150 ngày)
				ELSE -1
			END AS RISK_SCORE
	FROM credit_record
	)
-- BƯỚC 2: Tổng hợp Tính năng Tín dụng và Tạo Biến Mục tiêu
, Aggregated_Credit AS(
	SELECT ID,
		   -- Tạo biến TARGET 
		   CASE 
		   WHEN MAX(RISK_SCORE) >=3 THEN 1 ELSE 0 --Tìm điểm rủi ro số cao nhất mà khách hàng từng đạt được trong toàn bộ lịch sử 
		   END AS TARGET,
		   -- Mức rủi ro tối đa
		   MAX(RISK_SCORE) AS MAX_RISK_SCORE,
		   -- Độ dài lịch sử tín dụng
		   ABS(MIN(MONTHS_BALANCE)) AS MONTHS_SINCE_OPEN, --mốc lâu nhất trong lịch sử tín dụng
		   -- Số lần chậm trễ nghiêm trọng
		   SUM(CASE WHEN RISK_SCORE >=3 THEN 1 ELSE 0 END) AS COUNT_MAJOR_DEFAULT
	FROM Credit_Scores
	GROUP BY ID
)
 ---Loại dòng trùng hoàn toàn bằng DISTINCT
, Cleaned_Application AS (
SELECT*
FROM (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ID) rn
	FROM application_record 
) A
WHERE rn = 1 -- chỉ giữ 1 dòng duy nhất của mỗi ID
)
-- BƯỚC 3: Ghép Dữ liệu application_record, Aggregated_Credit và Làm sạch
SELECT Ap.ID, 
	   Ag.TARGET,
	   Ag.MAX_RISK_SCORE,
	   Ag.MONTHS_SINCE_OPEN,
	   Ag.COUNT_MAJOR_DEFAULT,

	   Ap.CODE_GENDER,
	   Ap.FLAG_OWN_CAR,
       Ap.FLAG_OWN_REALTY,
       Ap.CNT_CHILDREN,
	   Ap.AMT_INCOME_TOTAL,
       Ap.NAME_INCOME_TYPE,
       Ap.FLAG_MOBIL,
       Ap.FLAG_WORK_PHONE,
       Ap.FLAG_PHONE,
       Ap.FLAG_EMAIL,
       Ap.CNT_FAM_MEMBERS,
	   -- Chuẩn hóa NAME_EDUCATION_TYPE (thay " / " thành "_")
       REPLACE(LTRIM(RTRIM(Ap.NAME_EDUCATION_TYPE)), ' / ', '_') AS NAME_EDUCATION_TYPE,
	   -- Gộp Family Status
       CASE 
            WHEN Ap.NAME_FAMILY_STATUS IN ('Married', 'Civil marriage') THEN 'Married'
            WHEN Ap.NAME_FAMILY_STATUS = 'Single / not married' THEN 'Single'
            ELSE Ap.NAME_FAMILY_STATUS
       END AS NAME_FAMILY_STATUS,
	    -- Chuẩn hóa TYPE Housing
       REPLACE(Ap.NAME_HOUSING_TYPE, ' / ', '_') AS NAME_HOUSING_TYPE,
	   --Chuyển đổi DAYS_BIRTH (số ngày âm) thành tuổi dương (số năm).
	   CAST(ABS(Ap.DAYS_BIRTH) / 365.25 AS INT) AS AGE,
	   --Xử lý Ngoại lai & Chuyển đổi
	   CASE WHEN Ap.DAYS_EMPLOYED > 0 THEN 0
			ELSE CAST(ABS(Ap.DAYS_EMPLOYED) / 365.25 AS INT) 
	   END AS EMPLOYED_YRS,
	   --Xử lý Missing Value
	   CASE WHEN Ap.OCCUPATION_TYPE IS NULL OR Ap.OCCUPATION_TYPE = '' THEN 'Unknown'
			ELSE Ap.OCCUPATION_TYPE
		END AS OCCUPATION_TYPE_CLEANED
FROM application_record Ap
INNER JOIN Aggregated_Credit Ag ON Ap.ID = Ag.ID

