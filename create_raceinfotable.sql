use boat;

CREATE TABLE `race_info` (
  `race_id` varchar(12) NOT NULL,
  `boat_no` varchar(1) NOT NULL,
  `race_rank` varchar(1) DEFAULT NULL,
  `refund` varchar(8) DEFAULT NULL,
  `reg_no` varchar(4) DEFAULT NULL,
  `race_time` varchar(8) DEFAULT NULL,
  `h_course` varchar(1) DEFAULT NULL,
  `h_st` varchar(4) DEFAULT NULL,
  `h_st_no` varchar(1) DEFAULT NULL,
  `f` int(11) DEFAULT NULL,
  `l` int(11) DEFAULT NULL,
  `motor_no` int(11) DEFAULT NULL,
  `body_no` int(11) DEFAULT NULL,
  `t_course` varchar(1) DEFAULT NULL,
  `t_st` varchar(8) DEFAULT NULL,
  `t_st_no` varchar(1) DEFAULT NULL,
  `t_time` float(3,2) DEFAULT NULL,
  `tilt` float DEFAULT NULL,
  `weight` float(3,1) DEFAULT NULL,
  `parts_change` varchar(20) DEFAULT NULL,
  `pera_change` varchar(10) DEFAULT NULL,
  `piston_change` varchar(10) DEFAULT NULL,
  `carburetor_change` varchar(10) DEFAULT NULL,
  `gearcase_change` varchar(10) DEFAULT NULL,
  `pistonring_change` varchar(10) DEFAULT NULL,
  `crankshaft_change` varchar(10) DEFAULT NULL,
  `cylinder_change` varchar(10) DEFAULT NULL,
  `electrical_change` varchar(10) DEFAULT NULL,
  `carrierbody_change` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`race_id`,`boat_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


