/* задание 1 выборка единоличных владельцев помещений (доля которых равна 1) с указанием адреса
квартиры, которой он владеет*/
select o.fio as ФИО, a.street as Улица, a.numbuilding as Номер_Дома, b.flat as Кв, b.part as Часть
from owners o, adress a, ownership b
where a.idbuiding = b.idbuilding and o.id = b.owner and b.endown is null and b.part = '1'
order by a.numbuilding;
/*
   сначала соединяем owners и docs через full outer join чтобы заполнить null там,
   где нет документов;
   далее соединяем ownership и owners так, чтобы были совпадения в обеих таблицах по условию
   выбираем тех, у кого endown is null */
/*задание 2 (только текущие собственники) */
SELECT distinct o.fio , i.ser, i.numb, i.date_and_provider
FROM   owners o
left join docs i on i.owner = o.id
inner JOIN ownership o2 on o.id = o2.owner
WHERE (o2.endown is null);
/* задание 3.1 выборка квартир, у которых более 10 собственников;*/
select distinct a.street as Улица, a.numbuilding as Номер_дома, flat as Кв, count(flat) as КолСобств
from adress a, ownership o
where (select count(flat) from ownership p where a.idbuiding = p.idbuilding and o.flat = p.flat and p.endown is null)>=10
group by a.street, a.numbuilding, flat;
/* задание 3.2 через подзапрос (выполняется быстрее)*/
select  a.street as Улица, a.numbuilding as Номер_дома, flat as Кв, number_of_owners as Количество_собственников
from adress a,
(select ownership.flat, ownership.idbuilding, count(flat) as number_of_owners from ownership
where ownership.endown is null
group by ownership.flat, ownership.idbuilding) m
where m.number_of_owners >= 10 and m.idbuilding=a.idbuiding;
/* задание 4 выборка текущих собственников квартир по улице Чкалова;
 без повторений*/
select distinct a.street as Улица, t.fio as ФИО
from owners t, adress a, ownership b
where b.endown is null and a.idbuiding = b.idbuilding and t.id = b.owner
order by a.street, t.fio;
/* задание 5 выборка квартир, у которых в настоящее время нет собственников */
select a.street as улица, a.numbuilding as номер_дома, b.flat as квартира
from adress a, ownership b where b.idbuilding = a.idbuiding
except (
select a.street, a.numbuilding, b.flat
from adress a, ownership b
where b.idbuilding = a.idbuiding and b.endown is null);
