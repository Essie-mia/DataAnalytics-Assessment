SELECT 
    u.id AS customer_id,
    u.username AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(sa.id) AS total_transactions,
    -- Estimated CLV = (total value / tenure in months) * 12 months * 0.1% profit
    ROUND(
        (
            (SUM(sa.confirmed_amount) / 100) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)
        ) * 12 * 0.001, 
        2
    ) AS estimated_clv
FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount sa ON sa.plan_id = p.id
WHERE sa.confirmed_amount > 0
GROUP BY u.id, u.username, tenure_months
ORDER BY estimated_clv DESC;