SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM (
    SELECT
        u.id AS user_id,
        u.username,
        -- Calculate average transactions per active month per user
        AVG(monthly_tx_count) AS avg_transactions_per_month,
        CASE
            WHEN AVG(monthly_tx_count) >= 10 THEN 'High Frequency'
            WHEN AVG(monthly_tx_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM (
        SELECT
            p.owner_id,
            YEAR(sa.transaction_date) AS year,
            MONTH(sa.transaction_date) AS month,
            COUNT(*) AS monthly_tx_count
        FROM savings_savingsaccount sa
        JOIN plans_plan p ON sa.plan_id = p.id
        GROUP BY p.owner_id, YEAR(sa.transaction_date), MONTH(sa.transaction_date)
    ) AS monthly_counts
    JOIN users_customuser u ON u.id = monthly_counts.owner_id
    GROUP BY u.id, u.username
) AS customer_frequencies
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');