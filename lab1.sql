/* задание 1 выборка единоличных владельцев помещений (доля которых равна 1) с указанием адреса
квартиры, которой он владеет*/
SELECT o.fio AS ФИО, a.street AS Улица, a.numbuilding AS Номер_Дома, b.flat AS Кв, b.part AS Часть
FROM owners o, adress a, ownership b
WHERE a.idbuiding = b.idbuilding AND o.id = b.owner AND b.endown IS null AND b.part = '1'
ORDER BY a.numbuilding;

/*
   сначала соединяем owners и docs через full outer join чтобы заполнить null там,
   где нет документов;
   далее соединяем ownership и owners так, чтобы были совпадения в обеих таблицах по условию
   выбираем тех, у кого endown is null */
/*задание 2 (только текущие собственники) */
SELECT distinct o.fio , i.ser, i.numb, i.date_and_provider
FROM   owners o
LEFT JOIN docs i ON i.owner = o.id
INNER JOIN ownership o2 ON o.id = o2.owner
WHERE (o2.endown IS null);

/* задание 3.1 выборка квартир, у которых более 10 собственников;*/
SELECT distinct a.street AS Улица, a.numbuilding AS Номер_дома, flat AS Кв, count(flat) AS КолСобств
FROM adress a, ownership o
WHERE (SELECT COUNT(flat) FROM ownership p WHERE a.idbuiding = p.idbuilding AND o.flat = p.flat AND p.endown IS null)>=10
group by a.street, a.numbuilding, flat;

/* задание 3.2 через подзапрос (выполняется быстрее)*/
SELECT  a.street AS Улица, a.numbuilding AS Номер_дома, flat AS Кв, number_of_owners AS Количество_собственников
FROM adress a,
(SELECT ownership.flat, ownership.idbuilding, count(flat) AS number_of_owners from ownership
WHERE ownership.endown IS null
GROUP BE ownership.flat, ownership.idbuilding) m
WHERE m.number_of_owners >= 10 AND m.idbuilding=a.idbuiding;

/* задание 4 выборка текущих собственников квартир по улице Чкалова;
 без повторений*/
SELECT distinct a.street AS Улица, t.fio AS ФИО
FROM owners t, adress a, ownership b
WHERE b.endown IS null AND a.idbuiding = b.idbuilding AND t.id = b.owner
ORDER BY a.street, t.fio;

/* задание 5 выборка квартир, у которых в настоящее время нет собственников */
SELECT a.street AS улица, a.numbuilding AS номер_дома, b.flat AS квартира
FROM adress a, ownership b WHERE b.idbuilding = a.idbuiding
except (
SELECT a.street, a.numbuilding, b.flat
FROM adress a, ownership b
WHERE b.idbuilding = a.idbuiding AND b.endown IS null);
