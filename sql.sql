###################################### 1 ##########################################

#Найдите номер модели, скорость и размер жесткого диска
#для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd

SELECT PC.model AS model, PC.speed AS speed, PC.hd AS hd FROM PC WHERE PC.price<500

###################################### 2 ##########################################

#Найдите производителей принтеров. Вывести: maker

SELECT maker FROM Product WHERE type='Printer' GROUP BY maker

###################################### 3 ##########################################

#Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых
#превышает 1000 дол.

SELECT model, ram, screen FROM Laptop WHERE price>1000 ORDER BY model

###################################### 4 ##########################################

#Найдите все записи таблицы Printer для цветных принтеров.

SELECT * FROM Printer WHERE color='y'

###################################### 5 ##########################################

#Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x
#CD и цену менее 600 дол.

SELECT model, speed, hd FROM PC WHERE price < 600 AND (cd='12x' OR cd = '24x')
    ORDER BY model,speed

###################################### 6 ##########################################

#Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска
#не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель,
#скорость.

SELECT DISTINCT Product.maker AS Maker, Laptop.speed AS speed FROM Product
	LEFT OUTER JOIN Laptop ON Laptop.hd >= 10
	WHERE Product.model=Laptop.model AND Product.type='Laptop'
	ORDER BY Laptop.speed

###################################### 7 ##########################################

#Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа)
#производителя B (латинская буква).

SELECT DISTINCT Product.model, PC.price FROM PC
	INNER JOIN Product ON Product.maker='B'
	WHERE Product.model=PC.model
UNION
SELECT DISTINCT Product.model, Laptop.price FROM Laptop
	INNER JOIN Product ON Product.maker='B'
	WHERE Product.model=Laptop.model	
UNION
SELECT DISTINCT Product.model, Printer.price FROM Printer
	INNER JOIN Product ON Product.maker='B'
	WHERE Product.model=Printer.model

###################################### 8 ##########################################

#Найдите производителя, выпускающего ПК, но не ПК-блокноты.

SELECT maker FROM Product
	WHERE type='PC' 
EXCEPT 
SELECT maker FROM Product
	WHERE type='Laptop'

###################################### 9 ##########################################

#Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker

SELECT Product.maker FROM Product
	INNER JOIN PC ON PC.speed >= 450
	WHERE PC.model=Product.model
	GROUP BY Product.maker

###################################### 10 ##########################################

#Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price

SELECT model, price FROM Printer
	WHERE price = (SELECT max(price) FROM Printer)
	ORDER BY model

###################################### 11 ##########################################

#Найдите среднюю скорость ПК.

SELECT AVG(speed) FROM PC

###################################### 12 ##########################################

#Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

SELECT AVG(speed) AS Avg_speed FROM Laptop WHERE price>1000

###################################### 13 ##########################################

#Найдите среднюю скорость ПК, выпущенных производителем A.

SELECT AVG(PC.speed) AS Avg_speed FROM PC
	INNER JOIN Product ON Product.maker='A'
	WHERE Product.model=PC.model

###################################### 14 ##########################################

#Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

SELECT Classes.class, Ships.name, Classes.country FROM Ships
	INNER JOIN Classes ON Classes.numGuns >=10
	WHERE Classes.class=Ships.class

###################################### 15 ##########################################

#Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD

SELECT hd FROM PC
	GROUP BY hd
	HAVING COUNT(hd)>1

###################################### 16 ##########################################

#Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая
#пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель
#с большим номером, модель с меньшим номером, скорость и RAM.

SELECT DISTINCT p1.model, p2.model, p1.speed, p1.ram FROM PC AS p1, PC AS p2
	WHERE p1.speed=p2.speed AND p1.ram=p2.ram AND p1.model > p2.model
	ORDER BY p1.model

###################################### 17 ##########################################

#Найдите модели ПК-блокнотов, скорость которых меньше скорости любого из ПК.
#Вывести: type, model, speed

SELECT DISTINCT p.type, p.model, l.speed FROM Product p
	INNER JOIN Laptop l ON l.speed < ALL (SELECT speed FROM PC)
	WHERE l.model = p.model AND p.type='Laptop'

###################################### 18 ##########################################

#Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price

SELECT DISTINCT  p.maker, r.price FROM Printer r 
	INNER JOIN Product p ON p.type='Printer'
	WHERE r.price = (SELECT MIN(price) FROM Printer WHERE color='y') AND 
    p.model=r.model AND r.color='y'

###################################### 19 ##########################################

#Для каждого производителя, имеющего модели в таблице Laptop, найдите средний
#размер экрана выпускаемых им ПК-блокнотов.
#Вывести: maker, средний размер экрана.

SELECT p.maker, AVG(l.screen) FROM Product p
	INNER JOIN Laptop l ON p.model=l.model
	WHERE p.type='Laptop'
	GROUP BY p.maker

###################################### 20 ##########################################

#Найдите производителей, выпускающих по меньшей мере три различных модели ПК.
#Вывести: Maker, число моделей ПК.

SELECT p.maker, COUNT(p.model) AS Count_Model FROM Product p
	WHERE p.type='PC'
	GROUP BY p.maker
	HAVING COUNT(p.model)>2

###################################### 21 ##########################################

#Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого
#есть модели в таблице PC.
#Вывести: maker, максимальная цена.

SELECT p.maker, MAX(pc.price) FROM Product p
	INNER JOIN PC pc ON p.model=pc.model
	WHERE p.type='PC'
	GROUP BY p.maker

###################################### 22 ##########################################

#Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену
#ПК с такой же скоростью. Вывести: speed, средняя цена.

SELECT pc.speed, AVG(pc.price) AS Avg_price FROM PC pc
	WHERE pc.speed > 600
	GROUP BY pc.speed

###################################### 23 ##########################################

#Найдите производителей, которые производили бы как ПК
#со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
#Вывести: Maker

SELECT DISTINCT p.maker FROM Product p
	INNER JOIN PC pc ON pc.speed >= 750
	WHERE p.type='PC' AND p.model=pc.model
INTERSECT
SELECT DISTINCT p.maker FROM Product p
	INNER JOIN laptop l ON l.speed >= 750
	WHERE p.type='Laptop' AND p.model=l.model

###################################### 24 ##########################################

#Перечислите номера моделей любых типов, имеющих самую высокую цену по всей
#имеющейся в базе данных продукции.

SELECT TOP 1 WITH TIES model FROM  ( SELECT price, model FROM PC
		UNION 
		SELECT price, model FROM Laptop
		UNION
		SELECT price, model FROM Printer ) X
ORDER BY price
DESC

###################################### 25 ##########################################

#Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM
#и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM.
#Вывести: Maker

SELECT maker FROM Product
	WHERE model IN (SELECT model FROM PC
		WHERE speed = (SELECT MAX(speed) FROM PC
            WHERE ram = (SELECT MIN(ram) FROM PC))
		AND ram = (SELECT MIN(ram) FROM PC))
 	AND maker IN (SELECT p.maker FROM Product p WHERE p.type='Printer')
GROUP BY maker
