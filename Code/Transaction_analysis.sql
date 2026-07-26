-- Monthly transaction trend
SELECT
    YEAR(transaction_date) AS TransactionYear,
    MONTH(transaction_date) AS TransactionMonth,
    COUNT(*) AS TotalTransactions,
    SUM(amount_usd) AS TotalTransactionValue,
    AVG(amount_usd) AS AverageTransactionValue
FROM dbo.Transactions
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date)
ORDER BY
    TransactionYear,
    TransactionMonth;

--Transaction trend by year
SELECT
    YEAR(transaction_date) AS TransactionYear,
    COUNT(*) AS TotalTransactions,
    SUM(amount_usd) AS TotalTransactionValue,
    AVG(amount_usd) AS AverageTransactionValue
FROM dbo.Transactions
GROUP BY YEAR(transaction_date)
ORDER BY TransactionYear;

--Top 10 merchants by transaction value
SELECT TOP 10
    m.merchant_id,
    m.merchant_name,
    m.city,
    COUNT(t.transaction_id) AS TotalTransactions,
    SUM(t.amount_usd) AS TotalTransactionValue,
    AVG(t.amount_usd) AS AverageTransactionValue
FROM dbo.Transactions t
JOIN dbo.Merchants m
    ON t.merchant_id = m.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name,
    m.city
ORDER BY TotalTransactionValue DESC;

--Top 10 accounts by transaction value
SELECT TOP 10
    t.account_id,
    COUNT(t.transaction_id) AS TotalTransactions,
    SUM(t.amount_usd) AS TotalTransactionValue,
    AVG(t.amount_usd) AS AverageTransactionValue
FROM dbo.Transactions t
GROUP BY t.account_id
ORDER BY TotalTransactionValue DESC;

--Top 10 customers by transaction value
SELECT TOP 10
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    COUNT(t.transaction_id) AS TotalTransactions,
    SUM(t.amount_usd) AS TotalTransactionValue,
    AVG(t.amount_usd) AS AverageTransactionValue
FROM dbo.Customers c
JOIN dbo.Accounts a
    ON c.customer_id = a.customer_id
JOIN dbo.Transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY TotalTransactionValue DESC;

--Largest individual transactions
SELECT TOP 20
    transaction_id,
    account_id,
    merchant_id,
    amount_usd,
    transaction_date
FROM dbo.Transactions
ORDER BY amount_usd DESC;

--Transaction activity by day of week
SELECT
    DATENAME(WEEKDAY, transaction_date) AS DayOfWeek,
    COUNT(*) AS TotalTransactions,
    SUM(amount_usd) AS TotalTransactionValue,
    AVG(amount_usd) AS AverageTransactionValue
FROM dbo.Transactions
GROUP BY
    DATENAME(WEEKDAY, transaction_date),
    DATEPART(WEEKDAY, transaction_date)
ORDER BY DATEPART(WEEKDAY, transaction_date);

--Transaction value by merchant city
SELECT
    m.city,
    COUNT(t.transaction_id) AS TotalTransactions,
    SUM(t.amount_usd) AS TotalTransactionValue,
    AVG(t.amount_usd) AS AverageTransactionValue
FROM dbo.Transactions t
JOIN dbo.Merchants m
    ON t.merchant_id = m.merchant_id
GROUP BY m.city
ORDER BY TotalTransactionValue DESC;

--Transaction value by account type
SELECT
    a.account_type,
    COUNT(t.transaction_id) AS TotalTransactions,
    SUM(t.amount_usd) AS TotalTransactionValue,
    AVG(t.amount_usd) AS AverageTransactionValue
FROM dbo.Accounts a
JOIN dbo.Transactions t
    ON a.account_id = t.account_id
GROUP BY a.account_type
ORDER BY TotalTransactionValue DESC;

--Executive transaction KPIs
SELECT
    COUNT(*) AS TotalTransactions,
    SUM(amount_usd) AS TotalTransactionValue,
    AVG(amount_usd) AS AverageTransactionValue,
    MIN(amount_usd) AS MinimumTransactionValue,
    MAX(amount_usd) AS MaximumTransactionValue,
    COUNT(DISTINCT account_id) AS ActiveTransactionAccounts,
    COUNT(DISTINCT merchant_id) AS ActiveMerchants
FROM dbo.Transactions;
