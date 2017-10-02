/*use test;*/
use boat;

create table race_info(
        race_id varchar(12) not null,
        boat_no varchar(1) not null,
        primary key(race_id,boat_no),
        race_rank varchar(1),
        refund varchar(8),
        reg_no varchar(4),
        race_time varchar(8), /*floatにしたい*/
        h_course varchar(1),
        h_st varchar(4),
        h_st_no varchar(1),

        /*直前情報*/
        t_course varchar(1),
        t_st varchar(8),
        t_st_no varchar(1),
        t_time float(3,2),
        tilt float,
        weight float(3,1),
        parts_change varchar(20),
        pera_change varchar(2)

) engine=InnoDB;

create table round_info(
        race_id varchar(12),/*place + round_no + day*/
        primary key(race_id),
        place varchar(8),
        round_no int,
        day varchar(10),
        host_time time,
        race_type varchar(20),
        stabilizer varchar(8),
        
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

        foreign key(race_id) references race_info(race_id)
) engine=InnoDB;


/*登録番号	選手名	身長	支部	出身地	登録期	血液型	生年月日	級別(A2とか)半年に一回変わる*/

create table boatracer(
	reg_no		int,
	primary key(reg_no), 
	name		varchar(10),
	height		int,
	branch		varchar(8),
	birthplace	varchar(8),
	reg_time	int,
	bloodtype	varchar(1),
	birthday	date,
	grade		varchar(4)
) engine=InnoDB;

