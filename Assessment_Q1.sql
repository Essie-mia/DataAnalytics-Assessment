SELECT 
    u.id AS owner_id,
    u.username AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    ROUND(SUM(sa.confirmed_amount) / 100, 2) AS total_deposits
FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount sa ON sa.plan_id = p.id
WHERE p.status_id IN (1, 2) -- active plans
  AND sa.confirmed_amount > 0
GROUP BY u.id, u.username
-- Only include customers who have both savings and investment plans
HAVING 
    savings_count > 0 AND
    investment_count > 0
ORDER BY total_deposits DESC;