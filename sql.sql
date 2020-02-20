#Найдите номер модели, скорость и размер жесткого диска
#для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd

SELECT PC.model AS model, PC.speed AS speed, PC.hd AS hd FROM PC WHERE PC.price<500

###################################################################################

#Найдите производителей принтеров. Вывести: maker

SELECT maker FROM Product WHERE type='Printer' GROUP BY maker

###################################################################################

#Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых
#превышает 1000 дол.

SELECT model, ram, screen FROM Laptop WHERE price>1000 ORDER BY model

###################################################################################

#Найдите все записи таблицы Printer для цветных принтеров.

SELECT * FROM Printer WHERE color='y'

###################################################################################

#Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x
#CD и цену менее 600 дол.

SELECT model, speed, hd FROM PC WHERE price < 600 AND (cd='12x' OR cd = '24x')
    ORDER BY model,speed

###################################################################################

#Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска
#не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель,
#скорость.

SELECT DISTINCT Product.maker AS Maker, Laptop.speed AS speed FROM Product
	LEFT OUTER JOIN Laptop ON Laptop.hd >= 10
	WHERE Product.model=Laptop.model AND Product.type='Laptop'
	ORDER BY Laptop.speed

###################################################################################

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

###################################################################################

#Найдите производителя, выпускающего ПК, но не ПК-блокноты.

SELECT maker FROM Product
	WHERE type='PC' 
EXCEPT 
SELECT maker FROM Product
	WHERE type='Laptop'

###################################################################################

#Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker

SELECT Product.maker FROM Product
	INNER JOIN PC ON PC.speed >= 450
	WHERE PC.model=Product.model
	GROUP BY Product.maker

###################################################################################

#Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price

SELECT model, price FROM Printer
	WHERE price = (SELECT max(price) FROM Printer)
	ORDER BY model

###################################################################################

#Найдите среднюю скорость ПК.

SELECT AVG(speed) FROM PC

###################################################################################

#Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

SELECT AVG(speed) AS Avg_speed FROM Laptop WHERE price>1000

###################################################################################

#Найдите среднюю скорость ПК, выпущенных производителем A.

SELECT AVG(PC.speed) AS Avg_speed FROM PC
	INNER JOIN Product ON Product.maker='A'
	WHERE Product.model=PC.model

###################################################################################

#Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

SELECT Classes.class, Ships.name, Classes.country FROM Ships
	INNER JOIN Classes ON Classes.numGuns >=10
	WHERE Classes.class=Ships.class

###################################################################################

#Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD

SELECT hd FROM PC
	GROUP BY hd
	HAVING COUNT(hd)>1

###################################################################################

#Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая
#пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель
#с большим номером, модель с меньшим номером, скорость и RAM.

SELECT DISTINCT p1.model, p2.model, p1.speed, p1.ram FROM PC AS p1, PC AS p2
	WHERE p1.speed=p2.speed AND p1.ram=p2.ram AND p1.model > p2.model
	ORDER BY p1.model

###################################################################################

#Найдите модели ПК-блокнотов, скорость которых меньше скорости любого из ПК.
#Вывести: type, model, speed

SELECT DISTINCT p.type, p.model, l.speed FROM Product p
	INNER JOIN Laptop l ON l.speed < ALL (SELECT speed FROM PC)
	WHERE l.model = p.model AND p.type='Laptop'

###################################################################################

#Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price

SELECT DISTINCT  p.maker, r.price FROM Printer r 
	INNER JOIN Product p ON p.type='Printer'
	WHERE r.price = (SELECT MIN(price) FROM Printer WHERE color='y') AND  p.model=r.model AND r.color='y'

###################################################################################

#Для каждого производителя, имеющего модели в таблице Laptop, найдите средний
#размер экрана выпускаемых им ПК-блокнотов.
#Вывести: maker, средний размер экрана.

SELECT p.maker, AVG(l.screen) FROM Product p
	INNER JOIN Laptop l ON p.model=l.model
	WHERE p.type='Laptop'
	GROUP BY p.maker

###################################################################################

#Найдите производителей, выпускающих по меньшей мере три различных модели ПК.
#Вывести: Maker, число моделей ПК.

SELECT p.maker, COUNT(p.model) AS Count_Model FROM Product p
	WHERE p.type='PC'
	GROUP BY p.maker
	HAVING COUNT(p.model)>2
