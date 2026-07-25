--– Top 10 Customers by Total Account Balance
SELECT TOP 10
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name,
    COUNT(a.account_id) AS NumberOfAccounts,
    SUM(a.balance_usd) AS TotalBalance
FROM Customers c
JOIN Accounts a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY TotalBalance DESC;

---Customers with Multiple Accounts
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name,
    COUNT(a.account_id) AS TotalAccounts
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(a.account_id) > 1
ORDER BY TotalAccounts DESC;

--Customers with Loans
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    COUNT(l.loan_id) AS TotalLoans,
    SUM(l.loan_amount) AS LoanValue
FROM Customers c
JOIN Loans l
ON c.customer_id=l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY LoanValue DESC;

--Customers Without Loans
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name
FROM Customers c
LEFT JOIN Loans l
ON c.customer_id=l.customer_id
WHERE l.loan_id IS NULL;

--Customers with Cards
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
    COUNT(cd.card_id) AS TotalCards
FROM Customers c
JOIN Accounts a
ON c.customer_id=a.customer_id
JOIN Cards cd
ON a.account_id=cd.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY TotalCards DESC;

--Customer Relationship Value

SELECT

    c.customer_id,

    CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,

    COUNT(DISTINCT a.account_id) AS Accounts,

    COUNT(DISTINCT cd.card_id) AS Cards,

    COUNT(DISTINCT l.loan_id) AS Loans,

    SUM(DISTINCT a.balance_usd) AS TotalBalance

FROM Customers c

LEFT JOIN Accounts a
ON c.customer_id=a.customer_id

LEFT JOIN Cards cd
ON a.account_id=cd.account_id

LEFT JOIN Loans l
ON c.customer_id=l.customer_id

GROUP BY

    c.customer_id,

    c.first_name,

    c.last_name

ORDER BY TotalBalance DESC;