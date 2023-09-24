

--1st block----------------------------------
--delete objects
drop table DEMO_CUSTOMERS cascade constraints;
drop sequence DEMO_CUSTOMERS_SEQ;
--End of deleting objects--------------------


--2nd block------------------------
--create sequence for CUSTOMER_ID 
create sequence DEMO_CUSTOMERS_SEQ;
	start with 1
    increment by 1
    minvalue 10
    maxvalue 9000
    nocache 
    nocycle
    nokeep
    order 
    ;
--end of creating sequence---------


--3rd block-----------------------------------------------------------------------------------------------------
--create table
create table DEMO_CUSTOMERS 
   (	
		CUSTOMER_ID 			number,
		CUST_FIRST_NAME 		varchar2(20 char) not null,  --not null constraint can be write inline like this
		CUST_LAST_NAME 			varchar2(20 char) not null, 
		CUST_STREET_ADDRESS1 	varchar2(60 char), 
		CUST_STREET_ADDRESS2 	varchar2(60 char), 
		CUST_CITY 				varchar2(30 char), 
		CUST_STATE				varchar2( 2 char), 
		CUST_POSTAL_CODE 		varchar2(10 char), 
		CUST_EMAIL 				varchar2(30 char), 
		PHONE_number1 			varchar2(15 char), 
		PHONE_number2 			varchar2(15 char), 
		URL 					varchar2(100 char), 
		CREDIT_LIMIT 			number  (11,2), 
		TAGS 					varchar2(4000 char),
		CREATED					timestamps (6) with local timezone,
		CREATED_BY				varchar2(255) not null,
		MODIFIED				timestamps (6) with local timezone,
		CREATED_BY				varchar2(255) not null,
		constraint DEMO_CUSTOMERS_PK primary key (CUSTOMER_ID) --assigning CUSTOMER_ID field as primary key
		using index  enable
   ) ;

comment on table DEMO_CUSTOMERS  is 'TABLE FOR STORING CUSTOMERS DATA'; 
--end of creating table--------------------------------------------------------------------------------------------
   
--4th block-----------------------------------------------------------------------------------------------------------------
--create triggers
create or replace editionable trigger DEMO_CUSTOMERS_BIU
    before insert or update 
    on DEMO_CUSTOMERS
    for each row
begin
    if inserting and :new.CUSTOMERS_ID is null 
		then
			:new.CUSTOMERS_ID :=DEMO_CUSTOMERS_SEQ.nextval;  --this is using sequence object that we build in 2nd code block
    end if;
    if inserting then
        :new.CREATED := sysdate;
        :new.CREATED_BY := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.UPDATED := sysdate;
    :new.UPDATED_BY := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end DEMO_CUSTOMERS_BIU;
--end of creating trigger----------------------------------------------------------------------------------------------------