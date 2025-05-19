# DataAnalytics-Assessment

This repository contains solutions to a SQL-based data analytics assessment. The task involves querying a simulated customer and transaction database to derive insights that support different business departments such as Finance, Marketing, and Operations. Each SQL file answers a single question, and the queries were written to be clear and easy to update. For example, sections that are hard to understand have been marked with comments.

---

## Assessment_Q1.sql – Funded Plan Segmentation

**Approach**  
To identify customers with at least one funded savings plan and one funded investment plan, I filtered the `plans_plan` table using relevant indicators (`is_regular_savings = 1` for savings, and `is_a_fund = 1` for investment). I ensured only funded plans were considered by checking `status_id IN (1, 2)`, which I determined represented active/funded statuses based on data exploration. I then used conditional aggregation to count plan types per user, joined with deposit transactions (`savings_savingsaccount`) for total deposit calculation, and filtered to keep only users with both types of plans.

**Challenges**  
The main challenge was identifying what qualifies as a "funded" plan, as there was no explicit `is_funded` column. I had to inspect the meaning of `status_id` values by analyzing the distribution and confirming with the data owner. Once I knew 1 and 2 represented active plans, I used them in the filter.

---

## Assessment_Q2.sql – Transaction Frequency Segmentation

**Approach**  
To segment users based on how frequently they transact, I calculated the average number of transactions per month per customer. I did this by grouping transactions by user and month, then computing the average monthly count. Users were then bucketed into frequency segments using a `CASE` statement.

**Challenges**  
MySQL’s `ONLY_FULL_GROUP_BY` mode triggered an error when aggregating data without explicitly including all non-aggregated fields in the `GROUP BY` clause. I restructured the query to avoid referencing unaggregated columns and used a subquery to isolate monthly transaction counts cleanly.

---

## Assessment_Q3.sql – Inactive Account Detection

**Approach**  
This query flags active plans that haven't had any inflow (deposit) transactions in the last 365 days. I filtered for plans where `status_id IN (1, 2)` and joined with the `savings_savingsaccount` table. I then used `MAX(transaction_date)` to get the last transaction date and calculated inactivity using `DATEDIFF()` from the current date.

**Challenges**  
The tricky part here was identifying the correct column that represented the transaction date. The `savings_savingsaccount` table contained multiple date fields, but after checking the column purposes, I settled on `transaction_date` as the most reliable indicator of inflow activity.

---

## Assessment_Q4.sql – Customer Lifetime Value (CLV) Estimation

**Approach**  
For each customer, I calculated their account tenure in months since signup (using `created_on`), counted total confirmed inflow transactions, and applied a simplified CLV formula:  
**CLV = (total_transactions / tenure_months) * 12 * average_profit_per_transaction**, with **average_profit_per_transaction = 0.1%** of each transaction's value.

**Challenges**  
There was some ambiguity in which field represented inflow value; after examining the table schema, I used `confirmed_amount`, which appeared to reflect successful deposit transactions. I also had to convert amounts from **kobo to naira**, since all values were stored in kobo.


I appreciate your time in reviewing this assessment. Each SQL file contains the complete logic and is commented where necessary to enhance clarity and understanding.
