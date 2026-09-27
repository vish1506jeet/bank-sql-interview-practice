-- ============================================================
-- 02. CTEs AND SELF-JOINS — MEDIUM
-- ============================================================

-- Q5. Which customers have referred at least 3 other customers?
SELECT r.referred_by_customer_id AS referrer_id,
       c.first_name || ' ' || c.last_name AS referrer_name,
       COUNT(*) AS customers_referred
FROM customers r
JOIN customers c ON c.customer_id = r.referred_by_customer_id
GROUP BY r.referred_by_customer_id, c.first_name, c.last_name
HAVING COUNT(*) >= 3
ORDER BY customers_referred DESC;

-- Q6. For every "Transfer Out" transaction, show the sender's name and the recipient's name.
SELECT t.transaction_id,
       sender.first_name || ' ' || sender.last_name AS sender_name,
       recipient.first_name || ' ' || recipient.last_name AS recipient_name,
       t.amount
FROM transactions t
JOIN accounts sender_acc ON t.account_id = sender_acc.account_id
JOIN customers sender ON sender_acc.customer_id = sender.customer_id
JOIN accounts recipient_acc ON t.counterparty_account_id = recipient_acc.account_id
JOIN customers recipient ON recipient_acc.customer_id = recipient.customer_id
WHERE t.transaction_type = 'Transfer Out';

-- Q7. Which 5 branches have disbursed the most in total loan principal?
WITH branch_loans AS (
    SELECT branch_id, SUM(principal_amount) AS total_disbursed, COUNT(*) AS loan_count
    FROM loans
    GROUP BY branch_id
)
SELECT b.branch_name, bl.total_disbursed, bl.loan_count
FROM branch_loans bl
JOIN branches b ON b.branch_id = bl.branch_id
ORDER BY bl.total_disbursed DESC
LIMIT 5;

-- Q8. Which customers currently owe more in active loans than they earn in a year?
WITH customer_debt AS (
    SELECT customer_id, SUM(outstanding_balance) AS total_outstanding
    FROM loans
    WHERE status = 'Active'
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name,
       c.annual_income, cd.total_outstanding
FROM customer_debt cd
JOIN customers c ON c.customer_id = cd.customer_id
WHERE cd.total_outstanding > c.annual_income
ORDER BY cd.total_outstanding DESC;

-- Q9. For each account, how many days passed between opening it and its first transaction?
WITH first_txn AS (
    SELECT account_id, MIN(transaction_date) AS first_transaction_date
    FROM transactions
    GROUP BY account_id
)
SELECT a.account_id, c.first_name || ' ' || c.last_name AS customer_name,
       a.opened_date, ft.first_transaction_date,
       (ft.first_transaction_date::date - a.opened_date) AS days_to_first_transaction
FROM accounts a
JOIN first_txn ft ON ft.account_id = a.account_id
JOIN customers c ON c.customer_id = a.customer_id
ORDER BY days_to_first_transaction DESC;
