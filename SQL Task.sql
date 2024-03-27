use AdventureWorks
--Задача 1
--Да се изведе списък с номерата на поръчките направени на 1-ви октомври 2011 г., както и
--имената на продуктите в тях.

SELECT S.SalesOrderNumber, P.Name
FROM Sales.SalesOrderDetail O
JOIN Production.Product P ON P.ProductID=O.ProductID
JOIN Sales.SalesOrderHeader S ON S.SalesOrderID = O.SalesOrderID
WHERE O.ModifiedDate = '2011-10-01'

--Задача 2
--Да се изведе списък с номерата на поръчките направени на 1-ви октомври 2011 г., както и
--бройката на поръчаните продукти във всяка от тях.

SELECT S.SalesOrderNumber, SUM(OrderQty) AS OrderedProductsQuantity
FROM Sales.SalesOrderDetail D
JOIN Sales.SalesOrderHeader S ON S.SalesOrderID = D.SalesOrderID
WHERE S.OrderDate = '2011-10-01'
GROUP BY S.SalesOrderNumber

--Задача 3
--Да се изведе списък с номерата на поръчките направени на 1-ви октомври 2011 г., с които са
--поръчани между 3 и 9 на брой продукта, както и бройката на поръчаните продукти във всяка от
--тях.

SELECT SalesOrderID, SUM(OrderQty) AS OrderedProductsQuantity
FROM Sales.SalesOrderDetail 
WHERE ModifiedDate = '2011-10-01'
GROUP BY SalesOrderID
HAVING SUM(OrderQty) BETWEEN 3 AND 9

--Задача 4
--Да се напише заявка, която на база данните в колонката SalesOrderNumber да показва какъв би
--бил номерът на следващата въведена поръчка. Има ли по-подходящ начин за да се изведе
--същата информация?

SELECT CONCAT('SO',MAX(SalesOrderID) + 1) AS NextSalesOrderNumber
FROM Sales.SalesOrderHeader;

--Задача 5
--Да се напише заявка, която връща имената на клиентите, направили поръчки преди 30.09.2012
--г. и след 30.06.2013 г.

SELECT DISTINCT P.FirstName, P.LastName
FROM (
    SELECT DISTINCT CustomerID 
	FROM Sales.SalesOrderHeader
    WHERE OrderDate < '2012-09-30'
	) AS t
JOIN Sales.SalesOrderHeader AS S ON t.CustomerID= S.CustomerID
JOIN Sales.Customer AS C ON C.CustomerID = t.CustomerID
JOIN Person.Person AS P ON P.BusinessEntityID = C.PersonID
WHERE S.OrderDate> '2013-06-30'

--Задача 6
--Да се изведе списък с номерата и датите на поръчките направени от Aaron Con, техния номер
--по ред, като за всяка от тях се покажат и номера и датата на предходната и следващата му
--поръчки.

SELECT CONCAT(P.FirstName,P.LastName) AS Name, S.SalesOrderNumber, S.OrderDate,ROW_NUMBER() OVER (ORDER BY OrderDate) AS RowNumber
FROM Person.Person P
JOIN Sales.Customer C ON C.PersonID = P.BusinessEntityID
JOIN Sales.SalesOrderHeader S ON S.CustomerID = C.CustomerID
WHERE P.FirstName = 'Aaron' AND P.LastName = 'Con'



