-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.1
-- PostgreSQL version: 9.6
-- Project Site: pgmodeler.io
-- Model Author: ---


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: sampledb | type: DATABASE --
-- -- DROP DATABASE IF EXISTS sampledb;
-- CREATE DATABASE sampledb;
-- -- ddl-end --
-- 

-- object: usr_member | type: TABLE --
-- DROP TABLE IF EXISTS usr_member CASCADE;
CREATE TABLE usr_member(
	usr_member_id serial NOT NULL,
	type_id smallint NOT NULL,
	req_id smallint NOT NULL,
	usr_name varchar(64) NOT NULL,
	birthday date NOT NULL,
	CONSTRAINT usr_member_pk PRIMARY KEY (usr_member_id)

);

-- object: usr_image | type: TABLE --
-- DROP TABLE IF EXISTS usr_image CASCADE;
CREATE TABLE usr_image(
	img_id serial NOT NULL,
	image_div smallint NOT NULL,
	file_name varchar(2048) NOT NULL,
	usr_id integer NOT NULL,
	CONSTRAINT usr_image_pk PRIMARY KEY (img_id,image_div)

);

-- object: usr_member_fk | type: CONSTRAINT --
-- ALTER TABLE usr_image DROP CONSTRAINT IF EXISTS usr_member_fk CASCADE;
ALTER TABLE usr_image ADD CONSTRAINT usr_member_fk FOREIGN KEY (usr_id)
REFERENCES usr_member (usr_member_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: usr_age_view | type: VIEW --
-- DROP VIEW IF EXISTS usr_age_view CASCADE;
CREATE VIEW usr_age_view
AS 

SELECT
   usr_member.usr_member_id AS uid,
   CAST(date_part('year', age(birthday)) as INT) as age
FROM
   usr_member;


