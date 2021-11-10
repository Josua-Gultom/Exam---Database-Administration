--1)
SELECT m.MeatId, MeatName, TransactionDate, [Purchase Amount] = CAST(COUNT(DISTINCT dt.Qty) AS varchar) + ' time(s)'
FROM Meat m JOIN DetailTransaction dt ON m.MeatId= dt.MeatId JOIN HeaderTransaction h ON dt.TransactionId = h.TransactionId JOIN Customer c ON  c.CustomerId = h.CustomerId
GROUP BY m.MeatId, MeatName, TransactionDate

--2)
CREATE PROC DeleteMeat (@mid CHAR(5), @mname VARCHAR())
AS
	DECLARE @m


--3)
GO
CREATE PROCEDURE TransactionHistory @mid CHAR(5)
AS
	DECLARE @cName VARCHAR(255) = (SELECT CustomerName FROM Customer c JOIN HeaderTransaction ht ON c.CustomerId = ht.CustomerId
	WHERE ht.TransactionId = @mid)

	DECLARE @cEmail VARCHAR(255) =  (SELECT CustomerEmail FROM Customer c JOIN HeaderTransaction ht ON c.CustomerId = ht.CustomerId WHERE ht.TransactionId = @mid)

	DECLARE @date DATE = (SELECT TransactionDate FROM HeaderTransaction WHERE TransactionId = @mid)

	DECLARE @mName VARCHAR (255), @qty INT, @mPrice INT

	DECLARE th CURSOR FOR SELECT m.MeatName, m.MeatPrice, dt.Qty, MeatPrice*Qty AS TotalPrice FROM Meat m JOIN DetailTransaction dt ON m.MeatId = dt.MeatId
WHERE TransactionId = @mid
	
	OPEN th
	PRINT 'Name: ' + @cName
	PRINT 'Email: ' + @cEmail
	PRINT 'Transaction Date: ' + CAST (@date AS VARCHAR)
	PRINT ''
	PRINT 'Transaction History:' 
	PRINT '-------------------------------------------'
	FETCH NEXT FROM transHist INTO @mName, @qty, @mPrice
	WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT @mName
			PRINT CAST (@qty AS VARCHAR) 
			PRINT CAST (@mPrice AS VARCHAR)
			FETCH NEXT FROM transHist INTO @mName, @qty, @mPrice
		END
		
		CLOSE th
		DEALLOCATE th

EXEC transactionHistory 'TR001'



--4)
GO
ALTER TRIGGER InsertTrigger ON Meat
FOR INSERT AS
	DECLARE @mname varchar(30), @mprice int, @mcalory int, @mweight int, @mrating int
	BEGIN
		IF EXISTS (SELECT * FROM Meat WHERE MeatName = @mname)
			DELETE FROM Meat WHERE MeatName = @mname  
			PRINT 'Meat named '+ @mname +'already exist'	
		ELSE
			PRINT 'Succesfully inserted meat'
	END
INSERT INTO Meat VALUES('MT006', 'King Karubi', 1000, 1, 1, 1)


