-- 01. Data quality checks
-- Run against the raw loaded tables before writing any of the practice questions.

-- row counts, confirm nothing got lost or duplicated on import
SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'branches', COUNT(*) FROM branches
UNION ALL
SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'loans', COUNT(*) FROM loans;

-- nulls in columns that shouldn't have any
SELECT
    COUNT(*) FILTER (WHERE email IS NULL) AS null_email,
    COUNT(*) FILTER (WHERE credit_score IS NULL) AS null_credit_score,
    COUNT(*) FILTER (WHERE annual_income IS NULL) AS null_income
FROM customers;

-- orphaned foreign keys, accounts pointing at a customer that doesn't exist
SELECT COUNT(*) AS orphaned_accounts
FROM accounts a
LEFT JOIN customers c ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- duplicate primary keys (the PK constraint should already block this, this just confirms it)
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- credit scores outside a real 300-850 range
SELECT COUNT(*) AS out_of_range_credit_scores
FROM customers
WHERE credit_score < 300 OR credit_score > 850;

-- negative transaction amounts (a withdrawal is stored as a positive amount with its own type,
-- not as a negative number)
SELECT COUNT(*) AS negative_amounts
FROM transactions
WHERE amount < 0;

-- negative outstanding loan balances
SELECT COUNT(*) AS negative_outstanding
FROM loans
WHERE outstanding_balance < 0;
