/* task 1 */
CREATE or replace VIEW children_owners(ФИО, Улица, Дом, Квартира, Лет, id)
AS SELECT c.fio, e.street, e.numbuilding, o.flat, (extract(years from age(current_date, c.born))), o.id
FROM adress e, owners c, ownership o
WHERE e.idbuiding = o.idbuilding and o.owner = c.id and extract( years from age(current_date, c.born))< 18;

/* task 2*/
create view owners_by_building(Номер_здания, Улица, Дом, Количество_Собственников)
as select o.idbuilding, a.street, a.numbuilding, count(o.idbuilding)
from adress a, ownership o
where a.idbuiding = o.idbuilding and o.endown is null
group by o.idbuilding, a.street, a.numbuilding;

/* task 3 */
create view current_owners(Номер_Здания, Квартира, Количество_Собственников)
as select idbuilding, flat, count(flat) filter ( where endown is null and startown is not null )
from ownership
group by idbuilding, flat;
