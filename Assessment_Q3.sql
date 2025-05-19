SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(sa.transaction_date) AS last_transaction_date,
    -- Calculate number of days since last transaction
    DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days
FROM plans_plan p
-- Use LEFT JOIN to keep plans that may have no inflows
LEFT JOIN savings_savingsaccount sa ON sa.plan_id = p.id AND sa.confirmed_amount > 0
WHERE p.status_id IN (1, 2) -- active plans
GROUP BY p.id, p.owner_id, type
-- Filter for inactive plans (no inflow in the last 365 days or never)
HAVING MAX(sa.transaction_date) IS NULL OR DATEDIFF(CURDATE(), MAX(sa.transaction_date)) > 365;