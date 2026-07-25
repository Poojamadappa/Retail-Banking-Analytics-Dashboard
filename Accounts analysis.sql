--Total Balance by Account Type
SELECT
    account_type,
    COUNT(account_id) AS TotalAccounts,
    SUM(balance_usd) AS TotalBalance,
    AVG(balance_usd) AS AverageBalance
FROM Accounts
GROUP BY account_type
ORDER BY TotalBalance DESC;

--Top 10 Highest Balance Accounts
SELECT TOP 10
    account_id,
    account_type,
    balance_usd
FROM Accounts
ORDER BY balance_usd DESC;

--Accounts Opened by Year
SELECT
    YEAR(open_date) AS OpenYear,
    COUNT(*) AS AccountsOpened
FROM Accounts
GROUP BY YEAR(open_date)
ORDER BY OpenYear;


--Average Balance by Year
SELECT
    YEAR(open_date) AS OpenYear,
    AVG(balance_usd) AS AverageBalance
FROM Accounts
GROUP BY YEAR(open_date)
ORDER BY OpenYear;

--Distribution of Account Types
SELECT
    account_type,
    COUNT(*) AS TotalAccounts,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Accounts),2
    ) AS PercentageShare
FROM Accounts
GROUP BY account_type
ORDER BY PercentageShare DESC;

--KPI 
SELECT

COUNT(*) AS TotalAccounts,

SUM(balance_usd) AS TotalDeposits,

AVG(balance_usd) AS AverageBalance,

MAX(balance_usd) AS HighestBalance,

MIN(balance_usd) AS LowestBalance

FROM Accounts;