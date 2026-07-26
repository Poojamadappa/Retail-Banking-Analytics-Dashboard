--Executive loan KPIs
SELECT
    COUNT(*) AS TotalLoans,
    SUM(loan_amount) AS TotalLoanAmount,
    AVG(loan_amount) AS AverageLoanAmount,
    MIN(loan_amount) AS MinimumLoanAmount,
    MAX(loan_amount) AS MaximumLoanAmount,
    AVG(interest_rate) AS AverageInterestRate
FROM dbo.Loans;

--Loan originations by year
SELECT
    YEAR(start_date) AS LoanStartYear,
    COUNT(*) AS TotalLoans,
    SUM(loan_amount) AS TotalLoanAmount,
    AVG(loan_amount) AS AverageLoanAmount,
    AVG(interest_rate) AS AverageInterestRate
FROM dbo.Loans
GROUP BY YEAR(start_date)
ORDER BY LoanStartYear;

--Top 10 customers by total borrowing
SELECT TOP 10
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    COUNT(l.loan_id) AS NumberOfLoans,
    SUM(l.loan_amount) AS TotalBorrowed,
    AVG(l.interest_rate) AS AverageInterestRate
FROM dbo.Customers c
JOIN dbo.Loans l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY TotalBorrowed DESC;

--Customers with multiple loans
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    COUNT(l.loan_id) AS NumberOfLoans,
    SUM(l.loan_amount) AS TotalBorrowed
FROM dbo.Customers c
JOIN dbo.Loans l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(l.loan_id) > 1
ORDER BY
    NumberOfLoans DESC,
    TotalBorrowed DESC;


--Loan amount bands

SELECT
    CASE
        WHEN loan_amount < 50000 THEN 'Under $50K'
        WHEN loan_amount < 100000 THEN '$50K–$99K'
        WHEN loan_amount < 200000 THEN '$100K–$199K'
        ELSE '$200K+'
    END AS LoanAmountBand,
    COUNT(*) AS TotalLoans,
    SUM(loan_amount) AS TotalLoanAmount,
    AVG(loan_amount) AS AverageLoanAmount
FROM dbo.Loans
GROUP BY
    CASE
        WHEN loan_amount < 50000 THEN 'Under $50K'
        WHEN loan_amount < 100000 THEN '$50K–$99K'
        WHEN loan_amount < 200000 THEN '$100K–$199K'
        ELSE '$200K+'
    END
ORDER BY MIN(loan_amount);

--Interest-rate bands
SELECT
    CASE
        WHEN interest_rate < 5 THEN 'Below 5%'
        WHEN interest_rate < 10 THEN '5%–9.99%'
        WHEN interest_rate < 15 THEN '10%–14.99%'
        ELSE '15%+'
    END AS InterestRateBand,
    COUNT(*) AS TotalLoans,
    SUM(loan_amount) AS TotalLoanAmount,
    AVG(loan_amount) AS AverageLoanAmount
FROM dbo.Loans
GROUP BY
    CASE
        WHEN interest_rate < 5 THEN 'Below 5%'
        WHEN interest_rate < 10 THEN '5%–9.99%'
        WHEN interest_rate < 15 THEN '10%–14.99%'
        ELSE '15%+'
    END
ORDER BY MIN(interest_rate);

--Largest individual loans

SELECT TOP 20
    l.loan_id,
    l.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    l.loan_amount,
    l.interest_rate,
    l.start_date
FROM dbo.Loans l
JOIN dbo.Customers c
    ON l.customer_id = c.customer_id
ORDER BY l.loan_amount DESC;


--Potential annual interest income
SELECT
    SUM(loan_amount * interest_rate / 100.0) AS EstimatedAnnualInterestIncome,
    AVG(loan_amount * interest_rate / 100.0) AS AverageEstimatedInterestPerLoan
FROM dbo.Loans;

--Estimated interest income by year of origination
SELECT
    YEAR(start_date) AS LoanStartYear,
    COUNT(*) AS TotalLoans,
    SUM(loan_amount) AS TotalLoanAmount,
    SUM(loan_amount * interest_rate / 100.0)
        AS EstimatedAnnualInterestIncome
FROM dbo.Loans
GROUP BY YEAR(start_date)
ORDER BY LoanStartYear;

--Customer lending compared with deposits
WITH CustomerDeposits AS
(
    SELECT
        customer_id,
        SUM(balance_usd) AS TotalDeposits
    FROM dbo.Accounts
    GROUP BY customer_id
),
CustomerLoans AS
(
    SELECT
        customer_id,
        SUM(loan_amount) AS TotalBorrowed
    FROM dbo.Loans
    GROUP BY customer_id
)
SELECT TOP 20
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    COALESCE(d.TotalDeposits, 0) AS TotalDeposits,
    COALESCE(l.TotalBorrowed, 0) AS TotalBorrowed,
    COALESCE(l.TotalBorrowed, 0)
        - COALESCE(d.TotalDeposits, 0) AS NetBorrowingPosition
FROM dbo.Customers c
LEFT JOIN CustomerDeposits d
    ON c.customer_id = d.customer_id
LEFT JOIN CustomerLoans l
    ON c.customer_id = l.customer_id
WHERE l.TotalBorrowed IS NOT NULL
ORDER BY NetBorrowingPosition DESC;
