-- 요금제별로 고객 한 명이 2025년 한 해 평균 몇 번 문의했나
-- 조인 규칙: 문의를 고객별로 먼저 집계 → customers를 왼쪽에 둔 LEFT JOIN
-- 분모: 그 요금제 고객 전체 (문의가 없는 고객은 0번으로 셈)
WITH 문의 AS (
  SELECT customer_id, COUNT(*) AS 문의수
  FROM support_tickets
  WHERE created_date BETWEEN DATE '2025-01-01' AND DATE '2025-12-31'
  GROUP BY customer_id
)
SELECT c.plan_type AS 요금제,
       COUNT(*) AS 고객,
       COALESCE(SUM(m.문의수), 0) AS 문의,
       ROUND(AVG(COALESCE(m.문의수, 0)), 2) AS 고객당_문의
FROM customers c
LEFT JOIN 문의 m ON m.customer_id = c.customer_id
GROUP BY c.plan_type
ORDER BY 고객당_문의 DESC
