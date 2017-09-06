/*use test;*/
use boat;

create table round_info(
        race_id varchar(12) not null,/*place + round_no + day*/
        primary key(race_id),
        place varchar(8),
        round_no int,
        day varchar(10),
        
        /*気象条件*/
        temp float(3,1),
        sky varchar(8),
        wind int,
        water_temp float(3,1),
        wave int,

        /*払い戻し*/
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

        /*決まり手*/
        kimarite varchar(12),

        /*返還*/
        return_money varchar(1)

) engine=InnoDB;

create table race_info(
        race_id varchar(12),
        primary key(race_id),
        boat_no varchar(1),
        race_rank varchar(1),
        racer_no varchar(4),
        race_time varchar(8),
        course varchar(1),
        st_time varchar(4),

        foreign key(race_id) references round_info(race_id)
) engine=InnoDB;



/*
create table playerdata(
);
*/
