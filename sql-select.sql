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

###################################### 26 ##########################################

#Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A
#(латинская буква). Вывести: одна общая средняя цена.

SELECT AVG(price) AS AVG_price FROM (
	SELECT price FROM Product p 
		INNER JOIN PC ON p.model=PC.model
		WHERE  p.maker = 'A'
	UNION ALL
	SELECT price FROM Product p
		INNER JOIN Laptop l ON p.model=l.model
		WHERE p.maker = 'A') X
	
###################################### 27 ##########################################

#Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и
#принтеры. Вывести: maker, средний размер HD.

SELECT p.maker AS Maker, AVG(pc.hd) AS Avg_hd FROM Product p
	INNER JOIN PC pc ON pc.model = p.model
	WHERE p.maker IN (SELECT p.maker FROM Product p
		WHERE p.type='Printer')
	GROUP BY p.maker

###################################### 28 ##########################################

#Используя таблицу Product, определить количество производителей, выпускающих по
#одной модели.

SELECT DISTINCT COUNT(maker) AS qty FROM(
	SELECT maker FROM Product
		GROUP BY maker
		HAVING COUNT(DISTINCT model) = 1) X

###################################### 31 ##########################################

#Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и
#страну.

SELECT class, country FROM Classes
	WHERE bore >= 16

###################################### 33 ##########################################

#Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic).
#Вывод: ship..

SELECT ship FROM Outcomes 
	WHERE result='sunk' AND battle='North Atlantic'

###################################### 34 ##########################################

#По Вашингтонскому международному договору от начала 1922 г. запрещалось строить
#линейные корабли водоизмещением более 35 тыс.тонн.
#Укажите корабли, нарушившие этот договор (учитывать только корабли c известным
#годом спуска на воду). Вывести названия кораблей.

SELECT DISTINCT s.name FROM Ships s
	INNER JOIN Classes c ON c.type='bb'
	WHERE c.class=s.class AND c.displacement > 35000
						AND s.launched>=1922
						AND s.launched IS NOT NULL

###################################### 36 ##########################################

#Перечислите названия головных кораблей, имеющихся в базе данных
#(учесть корабли в Outcomes).

SELECT name FROM Ships
	WHERE name=class
UNION
SELECT ship AS name FROM Outcomes 
	WHERE ship IN (SELECT class FROM Classes)

###################################### 38 ##########################################

#Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb')
#и имевшие когда-либо классы крейсеров ('bc').

SELECT country FROM Classes
	WHERE type='bb'
INTERSECT
SELECT country FROM Classes
	WHERE type='bc'

###################################### 42 ##########################################

#Найдите названия кораблей, потопленных в сражениях, и название сражения,
#в котором они были потоплены.

SELECT ship, battle FROM Outcomes
	WHERE result='sunk'

###################################### 44 ##########################################

#Найдите названия всех кораблей в базе данных, начинающихся с буквы R.

SELECT name FROM Ships
	WHERE name LIKE 'R%'
UNION
SELECT ship AS name FROM Outcomes
	WHERE ship LIKE 'R%'

###################################### 45 ##########################################

#Найдите названия всех кораблей в базе данных, состоящие из трех и более слов
#(например, King George V).
#Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.

SELECT name FROM Ships
	WHERE name LIKE '% % %'
UNION
SELECT ship AS name FROM Outcomes
	WHERE ship LIKE '% % %'

###################################### 48 ##########################################

#Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении.

SELECT c.class FROM Classes c
	INNER JOIN Outcomes o ON o.ship=c.class
	WHERE o.result = 'sunk'
UNION
SELECT c.class FROM Classes c
	INNER JOIN Ships s ON s.class=c.class
	INNER JOIN Outcomes o ON s.name=o.ship
	WHERE o.result = 'sunk'

###################################### 49 ##########################################

#Найдите названия кораблей с орудиями калибра 16 дюймов
#(учесть корабли из таблицы Outcomes).

SELECT s.name FROM Ships s
	INNER JOIN Classes c ON c.class = s.class
	WHERE c.bore=16
UNION
SELECT o.ship AS name FROM Outcomes o
	INNER JOIN Classes c ON c.class = o.ship
	WHERE c.bore=16

###################################### 50 ##########################################

#Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

SELECT DISTINCT o.battle FROM Outcomes o
	INNER JOIN Ships s ON s.name = o.ship
	WHERE s.class='Kongo'

###################################### 52 ##########################################

#Определить названия всех кораблей из таблицы Ships, которые могут быть линейным
#японским кораблем, имеющим число главных орудий не менее девяти, калибр орудий
#менее 19 дюймов и водоизмещение не более 65 тыс.тонн

SELECT s.name FROM Ships s
	INNER JOIN Classes c ON c.class=s.class
	WHERE (c.country = 'Japan' OR c.country IS NULL)
		AND c.type='bb'
		AND (c.numGuns>=9 OR c.numGuns IS NULL)
		AND (c.bore <19 OR c.bore IS NULL)
		AND (c.displacement<=65000 OR c.displacement IS NULL)

###################################### 53 ##########################################

#Определите среднее число орудий для классов линейных кораблей.
#Получить результат с точностью до 2-х десятичных знаков.

SELECT CAST(AVG(CAST(numGuns AS numeric(4,2))) AS numeric(6,2))
AS AvgnumGuns FROM Classes
	WHERE type='bb'

###################################### 55 ##########################################

#Для каждого класса определите год, когда был спущен на воду первый корабль этого
#класса. Если год спуска на воду головного корабля неизвестен, определите
#минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

SELECT c.class, MIN(s.launched) FROM Ships s
	RIGHT JOIN Classes c ON c.class=s.class
	GROUP BY c.class