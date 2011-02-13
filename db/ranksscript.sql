update ranks set ranks.from='0', ranks.to='24', rank='Private', image='rank_1.png' where id=1;

update ranks set ranks.from='25', ranks.to='49', rank='Private first class', image='rank_2.png' where id=2;

update ranks set ranks.from='50', ranks.to='74', rank='Corporal', image='rank_3.png' where id=3;

update ranks set ranks.from='75', ranks.to='99', rank='Sergeant', image='rank_4.png' where id=4;

update ranks set ranks.from='100', ranks.to='124', rank='Staff Sergeant', image='rank_5.png' where id=5;

insert into ranks (ranks.from,ranks.to,ranks.rank,ranks.image) values ('125',
'149', 'Sergeant first class', 'rank_6.png');

insert into ranks (ranks.from,ranks.to,ranks.rank,ranks.image) values ('150', '174', 'Master sergeant', 'rank_7.png');

insert into ranks (ranks.from,ranks.to,ranks.rank,ranks.image) values ('175', '199', 'First sergeant', 'rank_8.png');

insert into ranks (ranks.from,ranks.to,ranks.rank,ranks.image) values ('200', '224', 'Sergeant major', 'rank_9.png');

insert into ranks (ranks.from,ranks.to,ranks.rank,ranks.image) values ('225', '249', 'Command sergeant major', 'rank_10.png');

insert into ranks (ranks.from,ranks.to,ranks.rank,ranks.image) values ('250', '999999', 'Sergeant major of the army', 'rank_11.png');
