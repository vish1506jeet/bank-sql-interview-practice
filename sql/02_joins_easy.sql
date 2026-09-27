-- ============================================================
-- 01. JOINS — EASY
-- Straightforward inner/left joins across the core tables.
-- ============================================================

-- Q1. List every account with the customer's full name and the branch it belongs to.
SELECT a.account_id, c.first_name || ' ' || c.last_name AS customer_name,
       a.account_type, b.branch_name
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
JOIN branches b ON a.branch_id = b.branch_id;

-- Q2. How many customers have never opened an account?
SELECT COUNT(*) AS customers_without_accounts
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL;

-- Q3. List all currently active loans with the borrower's name and the branch that issued it.
SELECT l.loan_id, c.first_name || ' ' || c.last_name AS customer_name,
       l.loan_type, b.branch_name, l.outstanding_balance
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
JOIN branches b ON l.branch_id = b.branch_id
WHERE l.status = 'Active';

-- Q4. What's the total balance held in active accounts at each branch?
SELECT b.branch_name, SUM(a.balance) AS total_active_balance
FROM branches b
JOIN accounts a ON a.branch_id = b.branch_id AND a.account_status = 'Active'
GROUP BY b.branch_name
ORDER BY total_active_balance DESC;
