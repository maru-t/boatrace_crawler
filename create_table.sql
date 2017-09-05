/*use test;*/
use boat;

create table raceresult(
        zyo varchar(8) not null,
        raundo int not null,
        day varchar(10) not null,
        primary key(zyo,raundo,day),
        no1_boat int,
        no1_racer_no int,
        no1_time varchar(8),
        no2_boat int,
        no2_racer_no int,
        no2_time varchar(8),
        no3_boat int,
        no3_racer_no int,
        no3_time varchar(8),
        no4_boat int,
        no4_racer_no int,
        no4_time varchar(8),
        no5_boat int,
        no5_racer_no int,
        no5_time varchar(8),
        no6_boat int,
        no6_racer_no int,
        no6_time varchar(8),

/*start*/
        course1 int,
        st_time1 varchar(4),
        course2 int,
        st_time2 varchar(4),
        course3 int,
        st_time3 varchar(4),
        course4 int,
        st_time4 varchar(4),
        course5 int,
        st_time5 varchar(4),
        course6 int,
        st_time6 varchar(4),

/*weathe*/
        temp float(3,1),
        sky varchar(8),
        wind int,
        water_temp float(3,1),
        wave int,

/*payback*/
        3tan_kumi varchar(10),
        3tan_money int,
        3tan_pop int,
        3puku_kumi varchar(10),
        3puku_money int,
        3puku_pop int,
        2tan_kumi varchar(10),
        2tan_money int,
        2tan_pop int,
        2puku_kumi varchar(10),
        2puku_money int,
        2puku_pop int,
        kaku1_kumi varchar(10),
        kaku1_money int,
        kaku1_pop int,
        kaku2_kumi varchar(10),
        kaku2_money int,
        kaku2_pop int,
        kaku3_kumi varchar(10),
        kaku3_money int,
        kaku3_pop int,
        tan_kumi varchar(10),
        tan_money int,
        fuku1_kumi varchar(10),
        fuku1_money int,
        fuku2_kumi varchar(10),
        fuku2_money int, 

/*kimarite*/
        kimarite varchar(8)
)


/*
create table playerdata(
);
*/
