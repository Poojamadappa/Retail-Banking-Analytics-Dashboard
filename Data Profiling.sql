SELECT 'Customers' AS Table_Name, COUNT(*) AS Row_Count FROM dbo.Customers
UNION ALL
SELECT 'Accounts', COUNT(*) FROM dbo.Accounts
UNION ALL
SELECT 'Branches', COUNT(*) FROM dbo.Branches
UNION ALL
SELECT 'Cards', COUNT(*) FROM dbo.Cards
UNION ALL
SELECT 'Loans', COUNT(*) FROM dbo.Loans
UNION ALL
SELECT 'Merchants', COUNT(*) FROM dbo.Merchants
UNION ALL
SELECT 'Transactions', COUNT(*) FROM dbo.Transactions;

---check for null values
SELECT
COUNT(*) AS TotalRows,

SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS Missing_FirstName,

SUM(CASE WHEN last_name IS NULL THEN 1 ELSE 0 END) AS Missing_LastName,

SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS Missing_Email

FROM Customers;

---duplicate customers
SELECT
customer_id,
COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

--Accounts by type
SELECT
account_type,
COUNT(*) AS TotalAccounts
FROM Accounts
GROUP BY account_type
ORDER BY TotalAccounts DESC;

--customer growth
SELECT
YEAR(open_date) AS YearOpened,
COUNT(*) AS AccountsOpened
FROM Accounts
GROUP BY YEAR(open_date)
ORDER BY YearOpened;

--total bank balance
SELECT
SUM(balance_usd) AS TotalBalance,
AVG(balance_usd) AS AverageBalance,
MIN(balance_usd) AS MinimumBalance,
MAX(balance_usd) AS MaximumBalance
FROM Accounts;

--loan protfolio
SELECT
COUNT(*) AS TotalLoans,
SUM(loan_amount) AS TotalLoanAmount,
AVG(loan_amount) AS AverageLoanAmount
FROM Loans;

--merchant distribution
SELECT
city,
COUNT(*) AS TotalMerchants
FROM Merchants
GROUP BY city
ORDER BY TotalMerchants DESC;

--transaction summary
SELECT

COUNT(*) AS TotalTransactions,

SUM(amount_usd) AS TotalTransactionValue,

AVG(amount_usd) AS AverageTransaction,

MAX(amount_usd) AS LargestTransaction

FROM Transactions;