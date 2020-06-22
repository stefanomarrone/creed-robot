-- User Section
insert into department values
(1,'Rep_A',1),
(2,'Rep_B',2);

insert into dbuser values
(1,'stefano.marrone@unicampania.it','Stefano','0000',1),
(2,NULL,'Francesco','0001',2);

insert into plc_masking values
('A06',0),
('A07',1),
('A08',2),
('B06',3),
('B07',4),
('B08',5),
('C06',6),
('C07',7),
('C08',8),
('D01',9),
('D02',10);

-- Drug Section
-- inserire misure nell'ordine h,l,d 
insert into drug values
('1','A012745093','Tachipirina',55,110,25,0),
('2','A020582019','Flumicil',95,104,22,0),
('3','A034972265','Nexium',75,110,30,0),
('4','A023853031','Cefazolina',75,47,32,0),
('5','A041220017','Vancomicina',80,42,40,0),
('6','A033998030','Tramadolo',75,81,32,0),
('7','A038554010','Ketorolac',83,98,21,0),
('8','A037464587','Ciprofloxacina',49,100,21,0),
('9','A026458012','Targosid',46,86,30,0),
('10','A038186110','Ranitidina',76,140,21,0),
('11','A026738070','Seleparina',55,156,70,0),
('12','A019954015','Aldomet',48,116,30,0),
('13','A035810011','Domperidone',56,115,20,0),
('14','A035748019','Acido Tranexamico',85,116,22,0);

insert into closet values
('NUL'),
('A06'),
('A07'),
('A08'),
('B06'),
('B07'),
('B08'),
('C06'),
('C07'),
('C08');

-- Medicine cassetti
insert into closetmap values
('2','A06'),
('7','A07'),
('8','B06'),
('10','B08'),
('11','B07'),
('12','C06'),
('14','C07');

--- postazione nei cassetti
--- (numero,cassetto,x,y)
insert into buffer values
(0,'NUL',0,0),
(1,'A06',270,120),
(2,'A06',270,240),
(3,'A06',270,360),
(4,'A07',270,120),
(5,'A07',270,240),
(6,'A07',270,360),
(7,'A08',270,120),
(8,'A08',270,240),
(9,'A08',270,360),
(10,'B06',270,120),
(11,'B06',270,240),
(12,'B06',270,360),
(13,'B07',270,120),
(14,'B07',270,240),
(15,'B07',270,360),
(16,'B08',270,120),
(17,'B08',270,240),
(18,'B08',270,360),
(19,'C06',270,120),
(20,'C06',270,240),
(21,'C06',270,360),
(22,'C07',270,120),
(23,'C07',270,240),
(24,'C07',270,360),
(25,'C08',270,120),
(26,'C08',270,240),
(27,'C08',270,360),
(34,'A06',270,120),
(35,'A06',270,240),
(36,'A06',270,360),
(37,'A07',270,120),
(38,'A07',270,240),
(39,'A07',270,360),
(40,'A08',270,120),
(41,'A08',270,240),
(42,'A08',270,360),
(43,'B06',270,120),
(44,'B06',270,240),
(45,'B06',270,360),
(46,'B07',270,120),
(47,'B07',270,240),
(48,'B07',270,360),
(49,'B08',270,120),
(50,'B08',270,240),
(51,'B08',270,360),
(52,'C06',270,120),
(53,'C06',270,240),
(54,'C06',270,360),
(55,'C07',270,120),
(56,'C07',270,240),
(57,'C07',270,360),
(58,'C08',270,120),
(59,'C08',270,240),
(60,'C08',270,360);

insert into outbox values
('NULL','nullo'),
('N02','primo cesto');

insert into dates values
('expire',now(),1*7),
('report',now(),1*7);

insert into ccs values
('stefano.marrone@unicampania.it');
