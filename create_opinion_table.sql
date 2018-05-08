use boat;

create table opinion(
	id				MEDIUMINT	NOT	NULL	AUTO_INCREMENT,
	opinion_text	varchar(200),
	date			datetime,
	ip_address		varchar(15),
	PRIMARY KEY (id)
) engine=InnoDB;

