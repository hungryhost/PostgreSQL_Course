/*
 * 1) Департаменты - DONE
 * 2) Сотрудники - DONE
 * 3) Телефоны сотрудников - DONE
 * 4) Должность-оклад - DONE
 * 5) Рейсы - DONE
 * 6) Типы рейсов - DONE
 * 7) Обслуживание - DONE
 * 8) Самолеты - DONE
 * 9) Модели - DONE
 * 10) Аэропорты - DONE
 * 11) Страны - DONE
 * 12) Города - DONE
 * 13) Авиакомпании - DONE
 */
/*
 * Таблица "Страны"
 */
create table countries(c_name varchar(50) primary key);

/*
 * Таблица "Города"
 */
create table cities(g_city varchar(50), g_country varchar(50), primary key(g_city, g_country),
foreign key(g_country) references countries);

/*
 * Таблица "Аэропорты"
 */
create table airports(ap_code char(3) primary key, ap_name varchar(50) not null,
 ap_city varchar(50) not null, ap_country varchar(50) not null, foreign key(ap_city, ap_country)
     references cities(g_city, g_country));

/*
 * Таблица "Департаменты"
*/
 create table departments(d_id numeric(4) primary key, d_name varchar(100) not null, d_type varchar(10)
     check (d_type in ('внутренний', 'внешний')), d_income numeric(9,2) not null);

/*
 * Таблица "Авиакомпании"
 */
create table airlines(al_id varchar(20) primary key, al_name varchar(50) not null unique);

/*
 * Таблица "Должность-оклад"
 */
create table postSalary(ps_post varchar(50) primary key, ps_salary numeric(8,2) not null check (ps_salary >= 15000));

/*
 * Таблица "Модели"
 */
create table models(m_name varchar(50) primary key);

/*
 * Табилца "Типы рейсов"
 */
create table flightTypes(ft_name varchar(30) primary key);

/*
 * Таблица "Самолеты"
 */
create table airplanes(s_av varchar(20), s_num varchar(20),
 s_model varchar(50) references models(m_name), s_date date not null, s_lastcheck date not null,
 primary key(s_av, s_num), foreign key(s_av) references airlines(al_id));

/*
 * Таблица "Сотрудники
 */
 create table employees(e_dep numeric(4) references departments(d_id), e_id numeric(8) primary key, e_fam varchar(20) not null,
 e_name varchar(20) not null, e_patr varchar(20) not null, e_gender char(1) check (e_gender in ('м', 'ж')),
  e_dob date not null, e_pass char(10) not null unique, e_given char(12) not null,
 e_date date not null, e_inn char(12) not null unique, e_post varchar(50) references postSalary(ps_post));

/*
 * Таблица "Телефоны сотрудников"
 */
 create table phones(t_emp numeric(8) references employees(e_id), t_num varchar(20) primary key);

/*
 * Таблица "Рейсы"
 */
create table flights(f_id INTEGER primary key, f_numb numeric(10) not null, f_ser varchar(20) not null,
f_plane varchar(20) not null, f_airport char(3) not null, f_start timestamp not null, f_end timestamp not null,
f_type varchar(30) not null, f_incoming boolean not null,
foreign key(f_ser, f_plane) references airplanes(s_num, s_av),
foreign key (f_type) references flightTypes(ft_name),
foreign key (f_airport) references airports(ap_code));
 /*
  * Таблица "Обслуживание"
  */

create table service(serv_emp numeric(8), serv_flight
    INTEGER, PRIMARY KEY(serv_emp, serv_flight),
    foreign key(serv_emp) references employees(e_id),
    foreign key (serv_flight) references flights(f_id));