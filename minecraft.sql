drop table Achieve;
drop table Achievement;
drop table RecipeCraft2;
drop table RecipeCraft1;
drop table Build;
drop table Store;
drop table Mob2;
drop table Mob1;
drop table PlacedBlock2;
drop table PlacedBlock1;
drop table InventoryItem2;
drop table InventoryItem1;
drop table Saved;
drop table Play;
drop table WorldOpensHosts2;
drop table WorldOpensHosts1;
drop table Joined;
drop table Participant;
drop table Host;
drop table PlayerHas;
drop table Servers;
drop table Inventory;

CREATE TABLE Inventory(
	iid			INTEGER 	PRIMARY KEY,
	remaining_slots	INTEGER	NOT NULL
);

CREATE TABLE Servers (
	IPaddress		VARCHAR(15)	PRIMARY KEY,
	sname			VARCHAR(255),
	player_capacity	INTEGER
);

CREATE TABLE PlayerHas (
	username		VARCHAR(16)	PRIMARY KEY,
	user_credentials	VARCHAR(255)	NOT NULL,
	xp			INTEGER,
	email			VARCHAR(255)	NOT NULL	UNIQUE,
	skin			INTEGER,
	iid			INTEGER		NOT NULL	UNIQUE,
	FOREIGN KEY (iid) REFERENCES Inventory(iid)
		ON DELETE CASCADE
);

CREATE TABLE Host (
	username	VARCHAR(16)	PRIMARY KEY,
	FOREIGN KEY (username) REFERENCES PlayerHas(username)
		ON DELETE CASCADE
);

CREATE TABLE Participant (
	username	VARCHAR(16)	PRIMARY KEY,
	FOREIGN KEY (username) REFERENCES PlayerHas(username)
		ON DELETE CASCADE
);

CREATE TABLE Joined (
	username			VARCHAR(16),
	IPaddress			VARCHAR(15),
	participant_permissions	VARCHAR(255),
	PRIMARY KEY (username, IPaddress),
	FOREIGN KEY (username) REFERENCES PlayerHas(username)
		ON DELETE CASCADE,
	FOREIGN KEY (IPaddress) REFERENCES Servers(IPaddress)
		ON DELETE CASCADE
);

CREATE TABLE WorldOpensHosts1 (
	seed		INTEGER	PRIMARY KEY,
	difficulty	VARCHAR(255)
);

CREATE TABLE WorldOpensHosts2 (
	join_code		VARCHAR(255)	PRIMARY KEY,
	settings		VARCHAR(255),
	host_permissions	VARCHAR(255),
	wname			VARCHAR(255),
	seed			INTEGER,
	username		VARCHAR(16)	NOT NULL,
	IPaddress		VARCHAR(15)		NOT NULL,
	FOREIGN KEY (seed) REFERENCES WorldOpensHosts1(seed)
		ON DELETE CASCADE,
	FOREIGN KEY (username) REFERENCES PlayerHas(username)
		ON DELETE CASCADE,
	FOREIGN KEY (IPaddress) REFERENCES Servers(IPaddress)
		ON DELETE CASCADE
);

CREATE TABLE Play(
	username 	VARCHAR(16)	PRIMARY KEY,
	join_code	VARCHAR(255),
	start_time	TIMESTAMP(0),
	end_time	TIMESTAMP(0),
	FOREIGN KEY (username) REFERENCES PlayerHas(username)
		ON DELETE CASCADE,
	FOREIGN KEY (join_code) REFERENCES WorldOpensHosts2(join_code)
		ON DELETE SET NULL
);

CREATE TABLE Saved (
	join_code	VARCHAR(255)	NOT NULL,
	username	VARCHAR(16),
	PRIMARY KEY (join_code, username),
	FOREIGN KEY (join_code) REFERENCES WorldOpensHosts2(join_code)
		ON DELETE CASCADE,
	FOREIGN KEY (username) REFERENCES PlayerHas(username)
		ON DELETE CASCADE
);

CREATE TABLE InventoryItem1 (
	bname			VARCHAR(255)	PRIMARY KEY,
	thumbnail		INTEGER,
	stacking_capacity	INTEGER
);

CREATE TABLE InventoryItem2 (
	bid		INTEGER	PRIMARY KEY,
	bname		VARCHAR(255),
	btype		VARCHAR(255),
	FOREIGN KEY (bname) REFERENCES InventoryItem1(bname)
		ON DELETE CASCADE
);

CREATE TABLE PlacedBlock1 (
	bname			VARCHAR(255)	PRIMARY KEY,
	ptexture		INTEGER,
	block_physics		VARCHAR(255)
);

CREATE TABLE PlacedBlock2 (
	bid		INTEGER	PRIMARY KEY,
	bname		VARCHAR(255),
	ptype		VARCHAR(255),
	FOREIGN KEY (bname) REFERENCES PlacedBlock1(bname)
		ON DELETE CASCADE
);

CREATE TABLE Mob1 (
	mname		VARCHAR(255)	PRIMARY KEY,
	mtexture		INTEGER,
	position		VARCHAR(255),
	max_health		INTEGER,
	current_health		INTEGER,
	movement_speed	DECIMAL
);

CREATE TABLE Mob2 (
	mid		INTEGER	PRIMARY KEY,
	mname	VARCHAR(255),
	FOREIGN KEY (mname) REFERENCES Mob1(mname)
		ON DELETE CASCADE
);

CREATE TABLE Store (
	bid	INTEGER,
	iid	INTEGER,
	PRIMARY KEY (bid, iid),
	FOREIGN KEY (bid) REFERENCES InventoryItem2(bid)
		ON DELETE CASCADE,
	FOREIGN KEY (iid) REFERENCES Inventory(iid)
		ON DELETE CASCADE
);

CREATE TABLE Build (
	join_code	VARCHAR(255),
	bid		INTEGER,
	mid		INTEGER,
	PRIMARY KEY (join_code, bid, mid),
	FOREIGN KEY (join_code) REFERENCES WorldOpensHosts2(join_code)
		ON DELETE CASCADE,
	FOREIGN KEY (bid) REFERENCES PlacedBlock2(bid)
		ON DELETE CASCADE,
	FOREIGN KEY (mid) REFERENCES Mob2(mid)
		ON DELETE CASCADE
);

CREATE TABLE RecipeCraft1 (
	resulting_block	VARCHAR(255)	PRIMARY KEY,
	ingredient_blocks	VARCHAR(255),
	FOREIGN KEY (resulting_block) REFERENCES InventoryItem1(bname)
		ON DELETE CASCADE
);

CREATE TABLE RecipeCraft2 (
	rname			VARCHAR(255)	PRIMARY KEY,
	resulting_block	VARCHAR(255)	NOT NULL	UNIQUE,
	FOREIGN KEY (resulting_block) REFERENCES RecipeCraft1(resulting_block)
		ON DELETE CASCADE
);

CREATE TABLE Achievement (
	aname		VARCHAR(255)	PRIMARY KEY,
	criteria		VARCHAR(255)
);

CREATE TABLE Achieve (
	username		VARCHAR(16),
	aname			VARCHAR(255),
	date_received		DATE,
	progress		DECIMAL,
	PRIMARY KEY (username, aname),
	FOREIGN KEY (username) REFERENCES PlayerHas(username)
		ON DELETE CASCADE,
	FOREIGN KEY (aname) REFERENCES Achievement(aname)
		ON DELETE CASCADE
);

INSERT INTO	Inventory(iid, remaining_slots) VALUES (1, 17);
INSERT INTO	Inventory(iid, remaining_slots) VALUES (2, 37);
INSERT INTO	Inventory(iid, remaining_slots) VALUES (3, 0);
INSERT INTO	Inventory(iid, remaining_slots) VALUES (4, 27);
INSERT INTO	Inventory(iid, remaining_slots) VALUES (5, 1);
INSERT INTO	Inventory(iid, remaining_slots) VALUES (6, 9);
INSERT INTO     Inventory(iid, remaining_slots) VALUES (7, 1);

INSERT INTO	Servers(IPaddress, sname, player_capacity)
VALUES	('123.456.1.1', 'server1', 100000);
INSERT INTO	Servers(IPaddress, sname, player_capacity)
VALUES	('123.654.1.1', 'server2', 65000);
INSERT INTO	Servers(IPaddress, sname, player_capacity)
VALUES	('123.655.1.1', NULL, 65000);
INSERT INTO	Servers(IPaddress, sname, player_capacity)
VALUES	('123.656.1.1', NULL, 75000);
INSERT INTO	Servers(IPaddress, sname, player_capacity)
VALUES	('123.657.1.1', 'server', 75000);

INSERT INTO	PlayerHas(username, user_credentials, xp, email, skin, iid)
VALUES	('Liv', 'iloveCPSC304', 999999, 'livia@student.ubc.ca', NULL, 1);
INSERT INTO	PlayerHas(username, user_credentials, xp, email, skin, iid)
VALUES	('Alexi', 'iloveCPSC304', 1000000, 'alexi3@student.ubc.ca', 100, 2);
INSERT INTO	PlayerHas(username, user_credentials, xp, email, skin, iid)
VALUES	('Ruby', 'iloveCPSC304!', 1000010, 'ruby@student.ubc.ca', 200, 3);
INSERT INTO	PlayerHas(username, user_credentials, xp, email, skin, iid)
VALUES	('Someone', 'loveCPSC304!', 161, 'someone@student.ubc.ca', 177, 4);
INSERT INTO	PlayerHas(username, user_credentials, xp, email, skin, iid)
VALUES	('Somebody', 'loveCPSC304!', 10000000, 'yo@student.ubc.ca', NULL, 5);
INSERT INTO	PlayerHas(username, user_credentials, xp, email, skin, iid)
VALUES	('MineCraftGenius', 'genius', 15000000, 'genius@student.ubc.ca', 1000, 6);

INSERT INTO Host(username) VALUES ('Liv');
INSERT INTO Host(username) VALUES ('Alexi');
INSERT INTO	Host(username) VALUES ('Ruby');
INSERT INTO	Host(username) VALUES('Someone');
INSERT INTO	Host(username) VALUES ('Somebody');

INSERT INTO Participant(username) VALUES ('Liv');
INSERT INTO Participant(username) VALUES ('Alexi');
INSERT INTO	Participant(username) VALUES ('Ruby');
INSERT INTO	Participant(username) VALUES ('Someone');
INSERT INTO	Participant(username) VALUES ('MineCraftGenius');

INSERT INTO	Joined(username, IPaddress, participant_permissions)
VALUES ('Liv', '123.456.1.1', '1');

INSERT INTO	Joined(username, IPaddress, participant_permissions)
VALUES ('Alexi', '123.654.1.1', '2');
INSERT INTO	Joined(username, IPaddress, participant_permissions)
VALUES ('Ruby', '123.655.1.1', '3');
INSERT INTO	Joined(username, IPaddress, participant_permissions)
VALUES ('Someone', '123.656.1.1', '4');
INSERT INTO	Joined(username, IPaddress, participant_permissions)
VALUES ('MineCraftGenius', '123.657.1.1', '5');

INSERT INTO WorldOpensHosts1(seed, difficulty)
VALUES (-1106759604738884840, 'Easy');
INSERT INTO	WorldOpensHosts1(seed, difficulty)
VALUES (-5584399987456711267, 'Peaceful');
INSERT INTO	WorldOpensHosts1(seed, difficulty)
VALUES (-1754216045272489466, 'Normal');
INSERT INTO	WorldOpensHosts1(seed, difficulty)
VALUES (5101553622029575588, 'Hard');
INSERT INTO	WorldOpensHosts1(seed, difficulty)
VALUES (4025804172371830787, 'Very Hard');

INSERT INTO	WorldOpensHosts2(join_code, settings, host_permissions, wname, seed,
IPaddress, username)
VALUES ('candyy', 'Creative Mode', '1', 'Giant Pale Garden', -1106759604738884840,
'123.456.1.1', 'Liv');
INSERT INTO	WorldOpensHosts2(join_code, settings, host_permissions, wname, seed,
IPaddress, username)
VALUES ('ballooon', 'Peaceful Mode', '2', 'Sakura Season', -5584399987456711267,
'123.654.1.1', 'Alexi');
INSERT INTO	WorldOpensHosts2(join_code, settings, host_permissions, wname, seed,
IPaddress, username)
VALUES ('ffish', 'Exploration Mode', '3', 'Frozen Edge Of The World',
-1754216045272489466, '123.655.1.1', 'Ruby');
INSERT INTO	WorldOpensHosts2(join_code, settings, host_permissions, wname, seed,
IPaddress, username)
VALUES ('bannaa', 'Adventure Mode', '4', 'Savanna Plateau River', 5101553622029575588,
'123.656.1.1', 'Someone');
INSERT INTO	WorldOpensHosts2(join_code, settings, host_permissions, wname, seed,
IPaddress, username)
VALUES ('geniuss', 'Hardcore Mode', '5', 'Giant Mangrove Swamp', 4025804172371830787,
'123.657.1.1', 'MineCraftGenius');

INSERT INTO	Play(username, join_code, start_time, end_time)
VALUES ('Liv', 'candyy', TO_TIMESTAMP('2025-02-28 10:49:00', 'YYYY-MM-DD
HH24:MI:SS'), TO_TIMESTAMP('2025-02-28 11:01:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO	Play(username, join_code, start_time, end_time)
VALUES ('Alexi', 'ballooon', TO_TIMESTAMP('2025-02-28 10:48:00', 'YYYY-MM-DD
HH24:MI:SS'), TO_TIMESTAMP('2025-02-28 11:05:00', 'YYYY-MM-DD HH24:MI:SS'));


INSERT INTO	Play(username, join_code, start_time, end_time)
VALUES ('Ruby', 'ffish', TO_TIMESTAMP('2025-03-17 20:43:01', 'YYYY-MM-DD
HH24:MI:SS'), TO_TIMESTAMP('2025-03-17 23:53:22', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO	Play(username, join_code, start_time, end_time)
VALUES ('Someone', 'bannaa', TO_TIMESTAMP('2025-03-02 22:00:00', 'YYYY-MM-DD
HH24:MI:SS'), TO_TIMESTAMP('2025-03-28 23:57:59', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO	Play(username, join_code, start_time, end_time)
VALUES ('Somebody', 'bannaa', TO_TIMESTAMP('2025-02-28 10:20:00', 'YYYY-MM-DD
HH24:MI:SS'), TO_TIMESTAMP('2025-03-01 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO	Play(username, join_code, start_time, end_time)
VALUES ('MineCraftGenius', 'geniuss', TO_TIMESTAMP('2025-04-07 23:30:00',
'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-04-08 07:59:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO	Saved(join_code, username) VALUES ('candyy', 'Liv');
INSERT INTO	Saved(join_code, username) VALUES ('candyy', 'Ruby');

INSERT INTO	Saved(join_code, username) VALUES ('ballooon', 'Alexi');
INSERT INTO	Saved(join_code, username) VALUES ('ballooon', 'Liv');
INSERT INTO	Saved(join_code, username) VALUES ('ballooon', 'Ruby');
INSERT INTO	Saved(join_code, username) VALUES ('ballooon', 'MineCraftGenius');
INSERT INTO	Saved(join_code, username) VALUES ('ballooon', 'Somebody');

INSERT INTO	Saved(join_code, username) VALUES ('ffish', 'Alexi');
INSERT INTO	Saved(join_code, username) VALUES ('ffish', 'Ruby');

INSERT INTO	Saved(join_code, username) VALUES ('bannaa', 'Ruby');
INSERT INTO	Saved(join_code, username) VALUES ('bannaa', 'Alexi');
INSERT INTO	Saved(join_code, username) VALUES ('bannaa', 'Liv');
INSERT INTO	Saved(join_code, username) VALUES ('bannaa', 'Someone');

INSERT INTO	Saved(join_code, username) VALUES ('geniuss', 'MineCraftGenius');
INSERT INTO	Saved(join_code, username) VALUES ('geniuss', 'Someone');
INSERT INTO	Saved(join_code, username) VALUES ('geniuss', 'Somebody');

INSERT INTO	InventoryItem1(bname, thumbnail, stacking_capacity)
VALUES ('Golden Apple', 260, 64);
INSERT INTO	InventoryItem1(bname, thumbnail, stacking_capacity)
VALUES ('Diamond Block', 264, 64);
INSERT INTO	InventoryItem1(bname, thumbnail, stacking_capacity)
VALUES ('Bow', 261, 1);
INSERT INTO	InventoryItem1(bname, thumbnail, stacking_capacity)
VALUES ('Bucket', 325, 64);
INSERT INTO	InventoryItem1(bname, thumbnail, stacking_capacity)
VALUES ('Bread', 295, 64);

INSERT INTO	InventoryItem2(bid, bname, btype)
VALUES (260, 'Golden Apple', 'Food');
INSERT INTO	InventoryItem2(bid, bname, btype)
VALUES (264, 'Diamond Block', 'Mineral Block');
INSERT INTO	InventoryItem2(bid, bname, btype)
VALUES (261, 'Bow', 'Weapons');
INSERT INTO	InventoryItem2(bid, bname, btype)
VALUES (325, 'Bucket', 'Utility');
INSERT INTO	InventoryItem2(bid, bname, btype)
VALUES (295, 'Bread', 'Food');

INSERT INTO	PlacedBlock1(bname, ptexture, block_physics)
VALUES	('Crafting Table', 58, 'Flammable');
INSERT INTO	PlacedBlock1(bname, ptexture, block_physics)
VALUES	('Anvil', 58, 'Falling');
INSERT INTO	PlacedBlock1(bname, ptexture, block_physics)
VALUES	('Chipped Anvil', 145, 'Falling');
INSERT INTO	PlacedBlock1(bname, ptexture, block_physics)
VALUES	('Clay', 82, NULL);
INSERT INTO	PlacedBlock1(bname, ptexture, block_physics)
VALUES	('Red Tulip', 1088, 'Transparent');

INSERT INTO	PlacedBlock2(bid, bname, ptype) VALUES (145, 'Anvil', 'Utility');
INSERT INTO	PlacedBlock2(bid, bname, ptype) VALUES (2, 'Clay', 'Build');
INSERT INTO	PlacedBlock2(bid, bname, ptype) VALUES (3, 'Clay', 'Build');
INSERT INTO	PlacedBlock2(bid, bname, ptype) VALUES (58, 'Crafting Table', 'Utility');
INSERT INTO	PlacedBlock2(bid, bname, ptype) VALUES (10, 'Chipped Anvil', 'Utility');


INSERT
INTO	Mob1(mname, mtexture, position, max_health, current_health, movement_speed)
VALUES	('Creeper', 3, '155, 200, 145', 20, 20, 35.1);
INSERT
INTO	Mob1(mname, mtexture, position, max_health, current_health, movement_speed)
VALUES	('Ocelot', 3, '156, 201, 0', 10, 10, 15.0);
INSERT
INTO	Mob1(mname, mtexture, position, max_health, current_health, movement_speed)
VALUES	('Enderman', 10, '8, 0, 100', 40, 10, 10.5);
INSERT
INTO	Mob1(mname, mtexture, position, max_health, current_health, movement_speed)
VALUES	('Villager', 115, '15, 20, 45', 20, 1, 5.2);
INSERT
INTO	Mob1(mname, mtexture, position, max_health, current_health, movement_speed)
VALUES	('Cow', NULL, '156, 201, 0', 10, 10, 2.5);

INSERT INTO	Mob2(mid, mname) VALUES	(92, 'Cow');
INSERT INTO	Mob2(mid, mname) VALUES	(93, 'Cow');
INSERT INTO	Mob2(mid, mname) VALUES	(120, 'Villager');
INSERT INTO	Mob2(mid, mname) VALUES	(58, 'Enderman');
INSERT INTO	Mob2(mid, mname) VALUES	(59, 'Enderman');

INSERT INTO	Store(bid, iid) VALUES (260, 1);
INSERT INTO	Store(bid, iid) VALUES (264, 2);
INSERT INTO	Store(bid, iid) VALUES (261, 3);
INSERT INTO	Store(bid, iid) VALUES (325, 5);
INSERT INTO	Store(bid, iid) VALUES (295, 6);

INSERT INTO	Build(join_code, bid, mid) VALUES ('candyy', 145, 92);
INSERT INTO	Build(join_code, bid, mid) VALUES ('ballooon', 2, 93);
INSERT INTO	Build(join_code, bid, mid) VALUES ('ffish', 3, 120);
INSERT INTO	Build(join_code, bid, mid) VALUES ('bannaa', 58, 58);
INSERT INTO	Build(join_code, bid, mid) VALUES ('geniuss', 10, 59);

INSERT INTO RecipeCraft1(resulting_block, ingredient_blocks)
VALUES ('Golden Apple', 'Apple, Gold Nuggetx8');
INSERT INTO RecipeCraft1(resulting_block, ingredient_blocks)
VALUES ('Diamond Block', 'Diamondx9');
INSERT INTO RecipeCraft1(resulting_block, ingredient_blocks)
VALUES ('Bow', 'Stringx3, Stickx3');
INSERT INTO RecipeCraft1(resulting_block, ingredient_blocks)
VALUES ('Bucket', 'Iron Ingotx3');
INSERT INTO RecipeCraft1(resulting_block, ingredient_blocks)
VALUES ('Bread', 'Wheatx3');

INSERT INTO RecipeCraft2(rname, resulting_block)
VALUES ('Golden Apple Recipe', 'Golden Apple');
INSERT INTO RecipeCraft2(rname, resulting_block)
VALUES ('Diamond Block Recipe', 'Diamond Block');
INSERT INTO RecipeCraft2(rname, resulting_block)
VALUES ('Bow Recipe', 'Bow');
INSERT INTO RecipeCraft2(rname, resulting_block)
VALUES ('Bucket Recipe', 'Bucket');
INSERT INTO RecipeCraft2(rname, resulting_block)
VALUES ('Bread Recipe', 'Bread');

INSERT INTO	Achievement(aname, criteria)
VALUES	 ('Taking Inventory', 'Open your inventory.');
INSERT INTO	Achievement(aname, criteria)
VALUES	('Getting Wood', 'Punch a tree until a block of wood pops out.');
INSERT INTO	Achievement(aname, criteria)
VALUES	('Playing Minecraft', NULL);
INSERT INTO	Achievement(aname, criteria)
VALUES	('Acquire Hardware', 'Smelt an iron ingot.');
INSERT INTO	Achievement(aname, criteria)
VALUES	('Bake Bread', 'Turn wheat into bread.');

INSERT INTO	Achieve(username, aname, date_received, progress)
VALUES	('Liv', 'Getting Wood', TO_DATE('2025-03-02', 'YYYY-MM-DD'), 100.00);
INSERT INTO	Achieve(username, aname, date_received, progress)
VALUES	('Liv', 'Playing Minecraft', TO_DATE('2025-03-02', 'YYYY-MM-DD'), NULL);
INSERT INTO	Achieve(username, aname, date_received, progress)
VALUES	('Alexi', 'Getting Wood', NULL, 0.0);
INSERT INTO	Achieve(username, aname, date_received, progress)
VALUES	('Someone', 'Bake Bread', NULL, 98.01);
INSERT INTO	Achieve(username, aname, date_received, progress)
VALUES	('Someone', 'Getting Wood', NULL, 98.01);
INSERT INTO	Achieve(username, aname, date_received, progress)
VALUES	('Ruby', 'Acquire Hardware', TO_DATE('2025-03-02', 'YYYY-MM-DD'), 100.0);
INSERT INTO	Achieve(username, aname, date_received, progress)
VALUES	('Ruby', 'Getting Wood', TO_DATE('2025-03-17', 'YYYY-MM-DD'), 100.0);
INSERT INTO	Achieve(username, aname, date_received, progress)
VALUES	('Somebody', 'Getting Wood', TO_DATE('2025-03-16', 'YYYY-MM-DD'), 100.0);
INSERT INTO	Achieve(username, aname, date_received, progress)
VALUES	('MineCraftGenius', 'Getting Wood', TO_DATE('2025-03-16', 'YYYY-MM-DD'), 100.0);
