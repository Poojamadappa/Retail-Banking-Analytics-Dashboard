--PART 1 – Executive KPIs
/*=====================================================
EXECUTIVE KPI SUMMARY
=====================================================*/

SELECT
    (SELECT COUNT(*) FROM Customers) AS TotalCustomers,

    (SELECT COUNT(*) FROM Accounts) AS TotalAccounts,

    (SELECT SUM(balance_usd) FROM Accounts) AS TotalDeposits,

    (SELECT COUNT(*) FROM Transactions) AS TotalTransactions,

    (SELECT SUM(amount_usd) FROM Transactions) AS TotalTransactionValue,

    (SELECT COUNT(*) FROM Loans) AS TotalLoans,

    (SELECT SUM(loan_amount) FROM Loans) AS TotalLoanAmount,

    (SELECT COUNT(*) FROM Merchants) AS TotalMerchants;

    --Create Customer Summary View
CREATE VIEW vw_CustomerSummary AS

SELECT

c.customer_id,

CONCAT(c.first_name,' ',c.last_name) AS CustomerName,

COUNT(DISTINCT a.account_id) AS TotalAccounts,

COUNT(DISTINCT cd.card_id) AS TotalCards,

COUNT(DISTINCT l.loan_id) AS TotalLoans,

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

c.last_name;


--Transaction Summary View
CREATE VIEW vw_TransactionSummary AS

SELECT

YEAR(transaction_date) AS TransactionYear,

MONTH(transaction_date) AS TransactionMonth,

COUNT(*) AS TotalTransactions,

SUM(amount_usd) AS TotalTransactionValue,

AVG(amount_usd) AS AverageTransaction

FROM Transactions

GROUP BY

YEAR(transaction_date),

MONTH(transaction_date);

--Merchant Performance View
CREATE VIEW vw_MerchantPerformance AS

SELECT

m.merchant_id,

m.merchant_name,

m.city,

COUNT(t.transaction_id) AS TotalTransactions,

SUM(t.amount_usd) AS TotalTransactionValue,

AVG(t.amount_usd) AS AverageTransaction

FROM Merchants m

JOIN Transactions t

ON m.merchant_id=t.merchant_id

GROUP BY

m.merchant_id,

m.merchant_name,

m.city;


--Loan Summary View
CREATE VIEW vw_LoanSummary AS

SELECT

YEAR(start_date) AS LoanYear,

COUNT(*) AS TotalLoans,

SUM(loan_amount) AS TotalLoanAmount,

AVG(interest_rate) AS AverageInterestRate

FROM Loans

GROUP BY YEAR(start_date);

--Account Summary View
CREATE VIEW vw_AccountSummary AS

SELECT

account_type,

COUNT(*) AS TotalAccounts,

SUM(balance_usd) AS TotalBalance,

AVG(balance_usd) AS AverageBalance

FROM Accounts

GROUP BY account_type;

--Verify the views
SELECT * FROM vw_CustomerSummary;
SELECT * FROM vw_TransactionSummary;
SELECT * FROM vw_MerchantPerformance;
SELECT * FROM vw_LoanSummary;
SELECT * FROM vw_AccountSummary;
