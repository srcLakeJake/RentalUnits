create database @dbname;
use @dbname;

/*
TABLE - BUILDING

Name			Type		Length	Attributes							Description
-----------------------	--------------- ----------------------------------------------------------------------	------------------------------------------------------------------------
id			tinyint			auto_increment, not null, unsigned, primary key			unique 	identifier for buildings owned by landlord. automatically generated
street			varchar		40									street name and number building is located at
city			varchar		25									city building is located in
stateprov		varchar		20									state or province building is located in
postal			varchar		10									zip code or postal code building is located in
country			varchar		30									country the building is located in
latitude		decimal		2,8									decimal degree value for latitude of building (range: 0.0 - 90.0, negative is south of equator)
longitude		decimal		3,8									decimal degree value for longitude of building (range: 0.0 - 180.0, negative is west of prime 																meridian)
locationurl		varchar		500									Google maps link for location of building
directionsurl		varchar		500									Google maps link for directions to building
laundry			enum			('no','free','coin','hookups')					value indicating whether common area laundry facilities are available 
has_common_porch	tinyint		1									boolean value indicating whether building has a common use porch
has_offstreet_parking	tinyint		1									boolean value indicating whether building has offstreet parking
is_parking_plowed	tinyint		1									boolean value indicating whether parking area is plowed
has_garage		tinyint		1									boolean value indicating whether building has a garage
notes			blob											any other info about a given building
area_attractions	blob											notes, links, etc about places of interest in proximity to building
*/

create table if not exists building (id tinyint unsigned not null auto_increment, index idx_bldg_id_1 using btree (id), street varchar(40), city varchar(25), stateprov varchar(20), postal varchar(10), country varchar(30), latitude decimal(8,8), longitude decimal(8,8), locationurl varchar(500), directionsurl varchar(500), laundry enum('no','free','coin','hookups'), has_common_porch tinyint(1), has_offstreet_parking tinyint(1), is_parking_plowed tinyint(1), has_garage tinyint(1), notes blob, area_attractions blob, primary key (id)) comment='General information about an individual building owned by landlord', engine=innodb;

/*
TABLE - APARTMENT

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
building_id		tinyint			not null, unsigned, foreign key (building.id)			unique identifier for buildings owned by landlord. automatically generated
apartment_id		tinyint			not null, unsigned						identifier for apartments within a given building
bedrooms		bit		2									number of bedrooms in the apartment. 0 indicates apartment is a studio
bathrooms		bit		1									number of bathrooms in the apartment
sqft			decimal		5,2	unsigned							total square footage of apartment
handicap_accessible	tinyint		1	unsigned							boolean value indicating whether apartment unit is handicap accessible
storage_space		smallint		unsigned							square footage of storage unit. 0 indicates no storage unit available
has_dishwasher		tinyint		1	unsigned							boolean value indicating whether apartment has a dishwasher
has_porch		tinyint		1	unsigned							boolean value indicating whether apartment has a private porch
has_fireplace		tinyint		1	unsigned							boolean value indicating whether apartment has a fireplace
notes			blob
*/

create table if not exists apartment (building_id tinyint unsigned not null, index idx_bldg_id_2 using btree (building_id), apartment_id tinyint unsigned not null, index idx_apt_id_1 using btree (apartment_id), bedrooms bit(2), bathrooms bit(2), sqft decimal(5,2) unsigned, handicap_accessible tinyint(1) unsigned, storage_space smallint unsigned, has_dishwasher tinyint(1) unsigned, has_porch tinyint(1) unsigned, has_fireplace tinyint(1) unsigned, notes blob, primary key (building_id, apartment_id), foreign key (building_id) references building(id) on delete cascade on update cascade) comment='Information about specific apartments owned by landlord', engine=innodb;

/*
TABLE - ROOM

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
building_id		tinyint			not null, unsigned, foreign key (building.id)			unique identifier for buildings owned by landlord. automatically generated
apartment_id		tinyint			not null, unsigned, foreign key (apartment.apartment_id)	identifier for apartments within a given building
room_id			tinyint			not null, unsigned						sequential identifier for rooms within an apartment, within a building
type			enum			('bed','living','bath','kitchen','dining','other')		type of room
sqft			smallint		unsigned							area of room in square feet 
length			smallint		unsigned							distance from wall to wall of longest (greatest distance) span in room
width			smallint		unsigned							distance from wall to wall of shorter distance span in room
is_rectangular		tinyint		1	unsigned							boolean value indicating whether room is a standard rectangular shape
ceiling_height		smallnt			unsigned							height, in inches, of ceiling
notes			blob														
*/

create table if not exists room (building_id tinyint unsigned not null, index idx_bldg_id_3 using btree (building_id), apartment_id tinyint unsigned not null, index idx_apt_id_2 using btree (apartment_id), room_id tinyint unsigned not null, index idx_room_id_1 using btree (room_id), type enum('bed','living','bath','kitchen','dining','other'), sqft smallint unsigned, length smallint unsigned, width smallint unsigned, is_rectangular tinyint(1) unsigned, ceiling_height smallint unsigned, notes blob, primary key (building_id, apartment_id, room_id), foreign key (building_id) references building(id) on delete cascade on update cascade, foreign key (apartment_id) references apartment(apartment_id) on delete cascade on update cascade) comment='Information about specific rooms within an apartment', engine=innodb;

/* 
Errors creating tables with multiple foreign keys. Read this:
http://dev.mysql.com/doc/refman/5.1/en/innodb-foreign-key-constraints.html

InnoDB permits a foreign key to reference any index column or group of columns. However, in the referenced table, there must be an index where the referenced columns are listed as the first columns in the same order. 

****** I think the create statement for the apartment table needs to be amended to add an index for the apartment(apartment_id) column.
*/

/*
TABLE - AVAILABILITY

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
building_id		tinyint			not null, unsigned, foreign key (building.id)			unique identifier for buildings owned by landlord. automatically generated
apartment_id		tinyint			not null, unsigned, foreign key (apartment.id)			identifier for apartments within a given building
available_date		date			not null							date the apartment is scheduled to be vacant
rent_rate		smallint		unsigned							monthly rent rate in USD
includes_heat		tinyint		1	unsigned							boolean value indicating whether heat is included in price of rent
includes_electric	tinyint		1	unsigned							boolean value indicating whether electricity is included in price of rent
vacancy_filled		tinyint		1	unsigned							boolean value indicating whether the vacancy has been filled
*/

create table if not exists availability (building_id tinyint unsigned not null, index idx_bldg_id_4 using btree (building_id), apartment_id tinyint unsigned not null, index idx_apt_id_3 using btree (apartment_id), available_date date not null, rent_rate smallint unsigned,  includes_heat tinyint(1) unsigned, includes_electric tinyint(1) unsigned, vacancy_filled tinyint(1) unsigned, primary key (building_id, apartment_id, available_date), foreign key (building_id) references building(id) on delete cascade on update cascade, foreign key (apartment_id) references apartment(apartment_id) on delete cascade on update cascade) comment='Information about apartment availability', engine=innodb;

/*
TABLE - PERSON

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
id			smallint		not null, unsigned, primary key					unique identifier for each registered site visitor
last_signon		datetime										date and time of user's last signon (YYYY-MM-DD HH:MM:SS)
email			varchar		50	unique								email address for user
username		varchar		30	unique								unique username for user
password		varchar		40									MD5 encrypted password for user account
first_name		varchar		20									user's legal first name
middle_name		varchar		20									user's legal middle name	
last_name		varchar		30									user's legal last name
preferred_name		varchar		20									user's preferred name
primary_phone		varchar		20									user's primary phone number
primary_phone_type	enum			('home','work','cell','pager')					type of primary phone
secondary_phone		varchar		20									user's secondary phone number
secondary_phone_type	enum			('home','work','cell','pager')					type of secondary phone
contact_instructions	blob											any instructions user provides to indicate when/how to contact them
ssn			varchar		20	unique								MD5 encrypted social security number for user
former_names		blob											any former legal names for user
is_tenant		tinyint		1	unsigned							boolean value indicating whether person is or has been a tenant
is_reference		tinyint		1	unsigned							boolean value indicating whether person is a reference or not
*/

create table if not exists person (id smallint unsigned not null, index idx_usr_id_1 using btree (id), last_signon datetime, email varchar(50) unique, username varchar(30) unique, password varchar(40), first_name varchar(20), middle_name varchar(20), last_name varchar(30), preferred_name varchar(20), primary_phone varchar(20), primary_phone_type enum('home','work','cell','pager'), secondary_phone varchar(20), secondary_phone_type enum('home','work','cell','pager'), contact_instructions blob, ssn varchar(20) unique, former_names blob, is_tenant tinyint(1) unsigned, is_reference tinyint(1) unsigned, primary key (id)) comment='Information about site visitors', engine=innodb;

compare

/*
example 

delete 
from person p, application a, personal_reference pr
where p.id = a.person_id and a.app_id = pr.app_id
and (((a.create_date < ($today - $purge_threshold)) or (a.submit_date < ($today - $purge_threshold)));
*/

/*
TABLE - USERSEARCH

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
entry_id		smallint		not null, unsigned, primary key					unique identifier for search record
user_id			smallint		not null, unsigned, foreign key (person.id)			user id
where_clause		varchar		300									criteria specifications in where clause of search		
create_date		datetime										date and time search was created (YYYY-MM-DD HH:MM:SS)
*/

create table if not exists usersearch (entry_id smallint unsigned not null, index idx_entry_id_1 using btree (entry_id), user_id smallint unsigned not null, index idx_usr_id_2 using btree (user_id), where_clause varchar(300), create_date datetime, primary key (entry_id), foreign key (user_id) references person(id) on delete cascade on update cascade) comment='User custom searches', engine=innodb;

/*
TABLE - USERFAVORITE

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
user_id			smallint		not null, unsigned, foreign key (person.id)			unique identifier for each registered site visitor
fav_seq			tinyint		1	not null, unsigned						sequence number of favorite for given user
building_id		tinyint			unsigned, foreign key (building.id)				unique identifier for buildings owned by landlord. automatically generated
apt_id			tinyint			unsigned, foreign key (apartment.apartment_id)			identifier for apartments within a given building
*/

create table if not exists userfavorite (user_id smallint unsigned not null, index idx_usr_id_3 using btree (user_id), fav_seq tinyint(1) unsigned not null, building_id tinyint unsigned, index idx_bldg_id_5 using btree (building_id), apt_id tinyint unsigned, index idx_apt_id_4 using btree (apt_id), primary key (user_id, fav_seq), foreign key (user_id) references person(id) on delete cascade on update cascade, foreign key (building_id) references building(id) on delete cascade on update cascade, foreign key (apt_id) references apartment(apartment_id) on delete cascade on update cascade) comment='User favorite items', engine=innodb;

/*
TABLE - APPLICATION 

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
app_id			smallint		not null, unsigned, primary key
person_id		smallint		not null, unsigned						unique identifier for each registered site visitor
create_date		date			not null							date application was created
submit_date		date											date application was submitted
is_smoker		tinyint		1	unsigned							boolean value indicating whether the applicant is a smoker or not
has_broken_lease	tinyint		1	unsigned							boolean value indicating whether the applicant has broken a lease in the past
has_refused_rent	tinyint		1	unsigned							boolean value indicating whether the applicant has refused to pay rent in the past
been_evicted		tinyint		1	unsigned							boolean value indicating whether the applicant has ever been evicted or asked to leave apartment
filed_bankruptcy	tinyint		1	unsigned							boolean value indicating whether the applicant has ever filed for bankruptcy
been_convicted		tinyint		1	unsigned							boolean value indicating whether the applicant has ever been convicted of a crime
criminal_check_auth	tinyint		1	unsigned							boolean value indicating whether the applicant agrees to a criminal background check
credit_check_auth	tinyint		1	unsigned							boolean value indicating whether the applicant agrees to a credit check
reason_no_utils		varchar		200									reason applicant cannot place utilities in their name
reason_no_rent		varchar		200									reason applicant may have for interruption to rent payment
*/

create table if not exists application (app_id smallint unsigned not null, index idx_app_id_1 using btree (app_id), person_id smallint unsigned not null, index idx_usr_id_4 using btree (person_id), create_date date not null, submit_date date, is_smoker tinyint(1) unsigned, has_broken_lease tinyint(1) unsigned, has_refused_rent tinyint(1) unsigned, been_evicted tinyint(1) unsigned, filed_bankruptcy tinyint(1) unsigned, been_convicted tinyint(1) unsigned, criminal_check_auth tinyint(1) unsigned, credit_check_auth tinyint(1) unsigned, reason_no_utils varchar(200), reason_no_rent varchar(200), primary key (app_id)) comment='Record of each rental application created', engine=innodb;

/*
TABLE - RESIDENCE_HISTORY

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
app_id			smallint		unsigned,foreign key (application.app_id)			application id
sequence_id		tinyint		1	unsigned							sequence number for residence in context of rental application
person_id		smallint		not null, unsigned						unique identifier for each registered site visitor
address_street		varchar		50									street name and number of building 
address_apt		varchar		10									apartment number or identifier
address_city		varchar		30									city residence is located in
address_state		varchar		30									state residence is located in
address_postal		varchar		10									zip code/postal code residence is located in
address_country		varchar		30									country residence is located in
startdate		date											first date of residence at address
enddate			date											last date of residence at address
occupancy_type		enum			('own','rent','occupy')						indicates whether individual owned, rented, or just lived at address
landlord_name		varchar		100
landlord_phone		varchar		15
rent			smallint
late_payments		tinyint		2
late_pay_reason		varchar		200
paid_in_full		tinyint		1
move_notice_given	tinyint		1
reason_for_move		varchar		200
full_deposit_refund	tinyint		1
deposit_refund_reason	varchar		200
*/

create table if not exists residence_history (app_id smallint unsigned, index idx_app_id_2 using btree (app_id), sequence_id tinyint(1) unsigned, person_id smallint unsigned not null, address_street varchar(50), address_apt varchar(10), address_city varchar(30), address_state varchar(30), address_postal varchar(10), address_country varchar(30), startdate date, enddate date, occupancy_type enum('own','rent','occupy'), landlord_name varchar(100), landlord_phone varchar(15), rent smallint, late_payments tinyint(2), late_pay_reason varchar(200), paid_in_full tinyint(1), move_notice_given tinyint(1), reason_for_move varchar(200), full_deposit_refund tinyint(1), deposit_refund_reason varchar(200), primary key (app_id, sequence_id), foreign key (app_id) references application(app_id) on delete cascade on update cascade) comment='Record of each previous address supplied in rental application', engine=innodb;

/*
TABLE - PERSONAL_REFERENCE

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
app_id			smallint		unsigned, foreign key (application.app_id)			application id
ref_seq			tinyint		1	unsigned							reference sequence (within application)
person_id		smallint		not null, unsigned, foreign key (person.id)									
relationship		varchar		30									reference's relationship to applicant
*/

create table if not exists personal_reference (app_id smallint unsigned, index idx_app_id_3 using btree (app_id), ref_seq tinyint(1) unsigned, person_id smallint unsigned not null, relationship varchar(30), primary key (app_id, ref_seq), foreign key (app_id) references application(app_id) on delete cascade on update cascade, foreign key (person_id) references person(id) on delete cascade on update cascade) comment='Record of personal references submitted in a rental application', engine=innodb;

/*
TABLE - PET

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
id			smallint		not null, unsigned						id for pet within scope of rental application
app_id			smallint		unsigned, foreign key (application.app_id)			application id
type			enum			('cat','dog','other')						type of pet
other_comment		varchar		200									if pet type is other than cat or dog, explanation goes here
is_fixed		tinyint		1	unsigned							boolean value indicating whether the pet has been spayed or neutered
is_vaccinated		tinyint		1	unsigned							boolean value indicating whether the pet's vaccinations are current
age			decimal		2,2									pet's age in years (years before decimal, months after)
name			varchar		20									pet's name
notes			varchar		500
*/

create table if not exists pet (id smallint unsigned not null, index idx_pet_id_1 using btree (id), app_id smallint unsigned, index idx_app_id_4 using btree (app_id), type enum('cat','dog','other'), other_comment varchar(200), is_fixed tinyint(1) unsigned, is_vaccinated tinyint(1) unsigned, age decimal(2,2), name varchar(20), notes varchar(500), primary key (id, app_id), foreign key (app_id) references application(app_id) on delete cascade on update cascade) comment='Record for each pet entered on application', engine=innodb;

/*
TABLE - CORRESPONDENCE

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------

*/

/*
TABLE - IMAGE

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------
url			varchar		75	not null, primary key						relative URL of the image
building_id		tinyint			foreign key (building.id)					id of the building the image depicts
apartment_id		tinyint			foreign key (apartment.apartment_id)				id of the apartment the image depicts	
room_id			tinyint			foreign key (room.room_id)					id of the room the image depicts
alt_text		varchar		100									alternate text for the image
height			smallint		unsigned							height, in pixels, of the image
width			smallint		unsigned							width, in pixels, of the image
is_thumbnail		tinyint		1	unsigned							boolean value indicating whether image is a thumbnail
full_size_url		varchar		75	foreign key (image.url)						relative URL of the full size image
*/

create table if not exists image (url varchar(75) not null, index idx_imgurl_1 using btree (url), building_id tinyint unsigned, apartment_id tinyint unsigned, room_id tinyint unsigned, alt_text varchar(100), height smallint unsigned, width smallint unsigned, is_thumbnail tinyint(1) unsigned, full_size_url varchar(75), primary key (url), foreign key (building_id) references building(id) on delete cascade on update cascade, foreign key (apartment_id) references apartment(apartment_id) on delete cascade on update cascade, foreign key (room_id) references room(room_id) on delete cascade on update cascade) comment='Record of each image on site', engine=innodb;

/*
TABLE - EXTERNALLINK

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------

*/

/*
TABLE - ADVERTISEMENT

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------

*/

/*
TABLE - POLICY

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------

*/

/*
TABLE - TESTIMONIAL

Name			Type		Length	Attributes							Description
-----------------------	--------------- ------- -------------------------------------------------------------- 	-------------------------------------------------------------------------------------------------

*/


/********************************************************************************************************************
*                                            USERS
*********************************************************************************************************************/
create user 'ruadmin@localhost' identified by '$pr1nNgItwo';
create user 'cmsadmin@localhost' identified by '';
create user 'authenticated@localhost' identified by 'p3nNtnn5';
create user 'logon@localhost' identified by '';
create user 'public@localhost' identified by 'h1lLbjorN';

/********************************************************************************************************************
*                                            GRANTS
*********************************************************************************************************************/

grant select on @dbname.apartment to 'public'@'localhost';
grant select on @dbname.application to 'public'@'localhost'; /* row level security? */
grant select on @dbname.availability to 'public'@'localhost'; /* row level security? */
grant select on @dbname.building to 'public'@'localhost';
grant select on @dbname.image to 'public'@'localhost';
grant select on @dbname.room to 'public'@'localhost';


