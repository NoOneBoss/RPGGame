--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0
-- Dumped by pg_dump version 15.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: play; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA play;


ALTER SCHEMA play OWNER TO postgres;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA play;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: status; Type: TYPE; Schema: play; Owner: postgres
--

CREATE TYPE play.status AS ENUM (
    'MAIN_MENU',
    'ARENA',
    'NOT_IN_GAME'
);


ALTER TYPE play.status OWNER TO postgres;

--
-- Name: account_already_exist(character varying); Type: FUNCTION; Schema: play; Owner: postgres
--

CREATE FUNCTION play.account_already_exist(checklogin character varying) RETURNS boolean
    LANGUAGE sql
    AS $$select exists(select login from users where login = crypt_login(checkLogin))$$;


ALTER FUNCTION play.account_already_exist(checklogin character varying) OWNER TO postgres;

--
-- Name: auth(character varying, character varying); Type: FUNCTION; Schema: play; Owner: postgres
--

CREATE FUNCTION play.auth(inputlogin character varying, inputpassword character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    DECLARE loginVar boolean;
    BEGIN
        select (select exists(select login from users where login = inputLogin and password = crypt_password(inputPassword))) into loginVar;
        if loginVar then update users set last_login = now() where login = inputLogin; end if;
        return loginVar;
    END
    $$;


ALTER FUNCTION play.auth(inputlogin character varying, inputpassword character varying) OWNER TO postgres;

--
-- Name: crypt_login(character varying); Type: FUNCTION; Schema: play; Owner: postgres
--

CREATE FUNCTION play.crypt_login(login character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$select crypt(login, '$1$p214sdSa')$_$;


ALTER FUNCTION play.crypt_login(login character varying) OWNER TO postgres;

--
-- Name: crypt_password(character varying); Type: FUNCTION; Schema: play; Owner: postgres
--

CREATE FUNCTION play.crypt_password(password character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$select crypt(password, '$1$pNlHbFsc')$_$;


ALTER FUNCTION play.crypt_password(password character varying) OWNER TO postgres;

--
-- Name: crypt_password(character varying, character varying); Type: FUNCTION; Schema: play; Owner: postgres
--

CREATE FUNCTION play.crypt_password(password character varying, login character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$select crypt(password, '$1$pNlHbFsc')$_$;


ALTER FUNCTION play.crypt_password(password character varying, login character varying) OWNER TO postgres;

--
-- Name: log(uuid, uuid, character varying, character varying, boolean); Type: PROCEDURE; Schema: play; Owner: postgres
--

CREATE PROCEDURE play.log(IN executor uuid, IN charactor uuid, IN action character varying, IN ipaddress character varying, IN ispersistance boolean)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        insert into logs(executor, character,action, "ipAddress", "isPersistence")
        values(executor, charactor, action, ipAddress, isPersistance);
    END
    $$;


ALTER PROCEDURE play.log(IN executor uuid, IN charactor uuid, IN action character varying, IN ipaddress character varying, IN ispersistance boolean) OWNER TO postgres;

--
-- Name: register(character varying, character varying); Type: PROCEDURE; Schema: play; Owner: postgres
--

CREATE PROCEDURE play.register(IN inputlogin character varying, IN inputpassword character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        insert into users(login, password) values(inputLogin, crypt_password(inputPassword, inputLogin));
        --execute format('create role %I with login password ''%I''', inputLogin, inputPassword);
        --execute format('grant rpgtraderplayer to %I', inputLogin);
    END
    $$;


ALTER PROCEDURE play.register(IN inputlogin character varying, IN inputpassword character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: characters; Type: TABLE; Schema: play; Owner: postgres
--

CREATE TABLE play.characters (
    character_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    level integer DEFAULT 0 NOT NULL,
    money integer DEFAULT 0 NOT NULL,
    inventory uuid NOT NULL,
    character_skin uuid NOT NULL
);


ALTER TABLE play.characters OWNER TO postgres;

--
-- Name: chat; Type: TABLE; Schema: play; Owner: postgres
--

CREATE TABLE play.chat (
    sender uuid NOT NULL,
    send_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    message character varying(100) DEFAULT ''::character varying NOT NULL,
    message_id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE play.chat OWNER TO postgres;

--
-- Name: friends; Type: TABLE; Schema: play; Owner: postgres
--

CREATE TABLE play.friends (
    first uuid NOT NULL,
    second uuid NOT NULL,
    friend_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE play.friends OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: play; Owner: postgres
--

CREATE TABLE play.users (
    user_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    role character varying(10) DEFAULT 'player'::character varying NOT NULL,
    last_login timestamp without time zone,
    registration_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_status character varying(15) DEFAULT 'NOT_IN_GAME'::character varying,
    character_uuid uuid
);


ALTER TABLE play.users OWNER TO postgres;

--
-- Name: friendview; Type: VIEW; Schema: play; Owner: postgres
--

CREATE VIEW play.friendview AS
 SELECT friends.first AS user_uuid,
    friends.second AS friend_uuid,
    ( SELECT users.login AS user_name
           FROM play.users
          WHERE (users.user_uuid = friends.first)) AS user_name,
    ( SELECT users.login AS friend_name
           FROM play.users
          WHERE (users.user_uuid = friends.second)) AS friend_name,
    friends.friend_date
   FROM play.friends;


ALTER TABLE play.friendview OWNER TO postgres;

--
-- Name: logs; Type: TABLE; Schema: play; Owner: postgres
--

CREATE TABLE play.logs (
    executor uuid NOT NULL,
    "character" uuid,
    execution_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    action character varying(100),
    "ipAddress" character varying(15) DEFAULT 'Undefined'::character varying,
    "isPersistence" boolean DEFAULT false NOT NULL
);


ALTER TABLE play.logs OWNER TO postgres;

--
-- Data for Name: characters; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.characters (character_uuid, level, money, inventory, character_skin) FROM stdin;
\.


--
-- Data for Name: chat; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.chat (sender, send_time, message, message_id) FROM stdin;
968af0c6-957e-4e6e-bf30-22282660467b	2022-12-09 23:02:27.602	test	03ca1c41-bd42-4d36-948f-e5ea33b1c398
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:04:55.285	Hello, brim	91d1bdd1-430f-4795-87f3-b1b2625713c9
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:09:59.716	Hello, brim	962a5004-f262-4837-b14f-e2d65d0d6639
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:10:08.915	Hello, brim	08c46711-bf4f-4fba-9412-2fdb3bdf4944
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:15:49.55	Hello, brim	da25afbb-11e8-4ba7-b7f8-9073adc8363d
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:33:07.733	testik	ac926d0f-77c0-498b-b202-98b08eb9abda
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:35:02.659	testik	72444b12-59b6-49b9-a630-1b1b877beb56
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:35:09.172	testik	722c6501-7a57-4a62-a3fa-c94238896c02
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:35:09.862	testik	d84dfcc7-9950-402a-9d3f-65cf7ffcd568
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:35:10.69	testik	b5a9133f-2c20-4505-abfe-e89038166158
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:36:22.976	testik	1d3a3317-7a9f-4a8e-8871-790852c0a8dd
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 00:36:46.886	testik	185d58f3-1b27-42b4-a56a-aa47d103f64f
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 01:01:40.118	testik	01466be8-b358-4bce-97c5-48b8d501ab08
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 01:01:45.124	testik	c61627bc-adce-45bb-8d86-dfdd75d15816
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 01:02:33.331	testik	d9410d99-f1d4-4f5a-83d2-567e088c0df0
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 01:09:47.646	testik	6df7b1de-6c07-47c5-aad1-c2ffbdf1a603
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 22:23:23.097	testik	f38622ae-f794-4f80-a6a5-77cc50d57ff6
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 22:23:49.182	testik	423aae36-85ad-43b2-a0b0-0405caf61ccc
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 22:23:50.059	testik	2de1e4d8-5fca-4032-8f45-989a2c248ec8
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 22:23:57.869	testik	c2be3baf-3066-4ffd-a8f1-243b7eaa1463
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 22:36:43.164	testik	910a1fe4-cd2c-465b-9c22-8b9cc2774a4e
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 22:47:32.089	testik	15878d80-ca09-4c73-9c87-2c300974b292
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 22:48:13.019	testik	d6e858cc-141a-46c7-9ff5-386c39cbbe3b
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 22:48:32.046	testik	38a480d7-4646-4e23-9551-e6dbb1c8c275
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 22:49:09.366	testik	3c60435c-48c3-483a-ac3f-853805994e1a
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:02:36.139	testik	ff5401df-59b5-4155-9424-cb028ced44fd
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:02:56.134	testik	96e1c7de-2981-4086-bda3-fb8292f070f7
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:02:56.848	testik	23b59807-31df-4794-a21a-a7f26025e942
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:02:57.496	testik	c38dbb70-5b2e-4b53-b97b-e454b1c91311
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:18:11.26	213	22c003e4-515d-4b46-b4bf-46713ffb4b15
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:18:18.148	214	f53c7132-8b82-455a-b060-d322a2026024
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:20:08.384	dota	ad38b5d4-2f2b-476b-b5aa-5c882d866701
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:20:11.288	one 	4db3f476-17aa-42b9-ad22-681a8ff66bc6
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:20:13.654	lova	c470ec5b-6304-423d-a1a3-9086f0bd6285
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:20:16.617	asd	dd459c9b-73f1-4305-9202-8b4ab6a7c0f1
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:20:20.176	dfsg	182afe1d-1bce-4e3f-aa2f-3d1b083c58f2
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:38.583	1	0eba5e2a-d5e4-462b-afaf-3aa7245cb37b
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:39.581	1	aabaa9d5-012c-436c-a28a-776be77f3bd3
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:39.973	1	ee09f03e-c240-4fb3-8130-4a3d3682d7c2
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:40.324	1	98837572-803f-47f7-97f5-029da352b3af
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:40.661	1	4d25a782-ea54-4773-8361-9fa0c50ea26e
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:41.668	1	27f5b736-4691-4dce-bc7c-b79a49e02533
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:42.007	1	d069376e-b189-4ca5-bee9-ec1b6641603a
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:42.34	1	4de2327d-9c70-4b07-a631-9bd654c47826
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:42.668	1	39ca6ee8-011d-4508-9156-354f0fb7ef75
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:28:43.014	1	1b0983bf-9bd0-4150-9a79-d9d9b1be3047
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:31:16.175	dfs	acdeb377-2c26-42fa-af38-3661f6a2139b
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:31:28.662	f	c7de2cbf-e834-4635-b174-6937b139e1d9
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:52:38.042	q	e5232559-a0b7-44c1-aaa8-70888bac6fc8
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:52:41.382	как дела	2b2d6b94-c109-47eb-a45e-c762542c36b1
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:52:44.286	фы	46397d4e-fa3a-40be-8b93-99e5187b2234
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-10 23:52:46.524	в	fb6aa63d-1aa5-4e3b-a1d7-0bcacda16258
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-11 00:06:37.666	1	dbe6f3be-3f5c-4792-acbc-1799ce8d49b5
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-11 00:06:40.757	123	aa8dfc3a-bb25-41ae-b579-0a605217bfdb
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-11 00:33:56.52	test	616c4fd6-95f5-4989-bc72-c8ee5ee707e0
75af33fb-4c78-4199-946d-17723604c948	2022-12-11 00:38:01.584	testik	aec87363-02ad-4a10-bf88-90499e066f4c
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-11 00:38:05.034	привт	507a2225-372f-4aa7-b094-e4c258375148
75af33fb-4c78-4199-946d-17723604c948	2022-12-11 00:38:09.082	как дела	828209e3-d2c0-4687-a460-eec2780a47c8
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-11 17:32:33.59	test	88a45860-a2c8-48f6-870b-d0ca1d640c30
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-11 17:32:39.529	пишу в чат	65c806d6-4fb7-4f91-86e2-7cd2b96d0039
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-11 17:41:34.327	вааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааа	802ad5b7-d3da-4659-a298-0ccc2376ae46
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-11 17:45:18.342	aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa	2ab3a5b8-b889-4a67-9ac8-65bb8e65ddce
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-12 23:37:11.405	1	06095d3f-0675-4ece-9441-90101d40d34e
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-12 23:37:14.118	d	916b21a2-7941-4b9d-895f-4162930ac20f
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-12 23:37:14.901	d	ad8bfbc7-c576-4605-b404-b30c13c5fc97
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-12 23:37:15.328	d	b134a0f7-3300-464a-b0af-d1d8f28edc48
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-12 23:37:15.705	d	137564a2-8b8d-4fce-b614-b197c4303439
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-12 23:37:16.053	d	eb964c39-753f-4a8e-a7b2-44e33b8ed76f
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-12 23:37:16.416	d	8ee16c09-21ce-4083-802d-260cc52504f0
8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-12 23:37:16.869	d	b334e39b-8931-4bad-ba84-54fe4b89555d
f153040f-e6c6-4bf1-b208-0823393b3adb	2022-12-17 01:04:52.969	привет	cb48f576-e956-469f-a17e-b71118fa9920
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-17 15:56:23.138	здарова всем	5252e652-4cf7-4eb5-8c29-1e0e0dc50a8b
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-17 15:59:27.713	хех	1266fe6a-c6ac-4dd8-b21e-1da3ceac0d40
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-17 17:09:24.874	захарчик	e0588171-8de4-454d-9c91-3963554c2770
f153040f-e6c6-4bf1-b208-0823393b3adb	2022-12-17 19:53:24.942	asd123' UNION SELECT user_uuid from users	0ddaf73b-3054-4620-9a04-727af826b51f
f153040f-e6c6-4bf1-b208-0823393b3adb	2022-12-17 19:54:01.663	123' DELETE * from users	d8396487-1247-40ed-98ce-fc45e244949a
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-17 21:28:41.969	1	04547e5d-d494-4a37-b79b-d76323cb7099
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-17 21:28:47.252	32	6fd77052-2c85-4b05-bc15-f09bc0284453
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-17 21:28:50.874	35435	15153b9c-0b8c-4d97-a5a5-1d66532516f0
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-18 16:55:11.462	1	25536681-89bc-4911-8666-2dfd99d5d732
968af0c6-957e-4e6e-bf30-22282660467b	2022-12-18 16:55:23.28	здарова	f91502bd-6281-4aef-8861-fc0083723151
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-18 16:55:28.35	здарова	cc6c42ab-8eb0-4830-a997-0621bf123987
968af0c6-957e-4e6e-bf30-22282660467b	2022-12-18 16:55:32.915	че как	99ef1b6a-da00-4b32-aab2-315bdfc130a1
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-18 16:55:37.358	норм всё	369aafb8-8434-4d32-8218-84612098a1e4
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-18 22:17:26.066	всем ку	fab9c266-4897-48fa-a582-50d63a08ce45
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-18 22:17:26.074	тест новой системы сообщений	f8e2c429-944d-4d05-8eb3-d5956e5ecdb1
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-18 22:17:26.076	вроде всё норм	cd432eff-2ebb-4bce-9813-e22c32f7ddca
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-19 19:54:41.6	захар крут	9c8d9753-e270-47b1-9fa7-c36c02985e11
45c6e0b5-6f42-453a-90b7-8176abb1d68b	2022-12-19 23:53:00.359	ку	2c1aced4-63fb-42e5-8be1-73636c119e95
968af0c6-957e-4e6e-bf30-22282660467b	2022-12-19 23:53:00.365	саламалекум	1c11a197-8a42-4eca-ad99-f0f25ab99d4f
\.


--
-- Data for Name: friends; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.friends (first, second, friend_date) FROM stdin;
45c6e0b5-6f42-453a-90b7-8176abb1d68b	968af0c6-957e-4e6e-bf30-22282660467b	2022-12-19 23:51:08.70198
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.logs (executor, "character", execution_time, action, "ipAddress", "isPersistence") FROM stdin;
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 00:59:16.317524	Authenticate	127.0.0.1	t
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 01:00:57.491747	Authenticate	127.0.0.1	t
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 01:02:18.912876	Authenticate	127.0.0.1	t
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 01:04:40.815064	Authenticate	127.0.0.1	t
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 01:04:52.979311	Sent message: 'привет'	127.0.0.1	f
8698f040-5521-4baf-9652-7b45b2a1faac	\N	2022-12-17 13:34:59.58451	Failed login	127.0.0.1	t
8698f040-5521-4baf-9652-7b45b2a1faac	\N	2022-12-17 15:52:06.179765	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:56:07.06098	Registered	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:56:08.856167	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:56:13.550143	Sent message: ''	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:56:23.146253	Sent message: 'здарова всем'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:57:45.102385	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:59:22.026295	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:59:27.723546	Sent message: 'хех'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 16:02:12.459464	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 17:09:17.436605	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 17:09:24.882714	Sent message: 'захарчик'	127.0.0.1	f
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 19:52:45.710418	Authenticate	127.0.0.1	t
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 19:53:02.778242	Sent message: ''	127.0.0.1	f
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 19:53:07.193634	Sent message: ''	127.0.0.1	f
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 19:53:10.633059	Sent message: ''	127.0.0.1	f
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 19:53:24.947486	Sent message: 'asd123' UNION SELECT user_uuid from users'	127.0.0.1	f
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 19:54:01.669476	Sent message: '123' DELETE * from users'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:09:55.761264	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:10:44.558135	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:23:05.200811	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:23:22.743015	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:24:44.392188	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:25:21.316571	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:26:41.348368	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:28:00.859092	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:28:41.978771	Sent message: '1'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:28:45.162672	Sent message: ''	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:28:47.257861	Sent message: '32'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:28:50.882067	Sent message: '35435'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:33:27.387638	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:36:25.855771	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:39:51.483268	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:40:55.345622	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:41:32.834157	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:43:03.661434	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:44:58.390839	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:46:27.942621	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:07:30.993703	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:08:59.428046	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:09:54.865516	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:10:33.552907	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:11:45.504114	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:12:40.758443	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:13:54.089697	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:15:05.099343	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:36:51.176147	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:37:41.01092	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 22:45:08.943308	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:13:30.296336	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:15:56.821804	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:16:54.239923	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:18:06.475754	Authenticate	0:0:0:0:0:0:0:1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:19:17.647819	Authenticate	0:0:0:0:0:0:0:1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:20:11.026718	Authenticate	0:0:0:0:0:0:0:1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:22:02.00973	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:23:45.361	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:24:31.988736	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:24:51.445407	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:25:37.727856	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:28:54.962051	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:30:29.175133	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:35:44.077295	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:37:37.691485	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:39:33.653621	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:40:31.822848	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:45:47.515474	Authenticate	127.0.0.1	t
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-18 16:48:11.319699	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:48:21.880664	Authenticate	127.0.0.1	t
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-18 16:51:45.273927	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:51:50.383917	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:53:56.700109	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:55:11.469503	Sent message: '1'	127.0.0.1	f
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-18 16:55:18.113211	Authenticate	127.0.0.1	t
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-18 16:55:23.286448	Sent message: 'здарова'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:55:28.356407	Sent message: 'здарова'	127.0.0.1	f
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-18 16:55:32.921572	Sent message: 'че как'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 16:55:37.363899	Sent message: 'норм всё'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:24:23.242016	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:26:20.657289	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:29:11.809556	Authenticate	127.0.0.1	t
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-18 17:30:18.840792	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:30:33.292634	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:39:20.309086	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 19:19:22.051192	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 21:53:43.395302	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 21:54:10.956588	Sent message: 'проверка нового чата'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 21:54:18.976007	Sent message: 'как у вас дела вообще'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 21:54:22.46332	Sent message: '?)))'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 21:54:34.153076	Sent message: 'а чат хорош, теперь сразу сообщения отправляются'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 21:55:01.472288	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:06:22.237972	Authenticate	0:0:0:0:0:0:0:1	t
8698f040-5521-4baf-9652-7b45b2a1faac	\N	2022-12-18 22:08:24.047326	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:09:11.135271	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:09:19.909099	Sent message: 'приветик всем'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:09:29.770533	Sent message: 'тест новой системы сохранения сообщений'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:09:39.167341	Sent message: 'кайф, вроде работает'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:16:11.668678	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:16:20.062519	Sent message: 'всем ку'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:16:26.314252	Sent message: 'тест новой системы сообщений'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:16:31.640864	Sent message: 'вроде всё норм'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 19:35:06.886063	Authenticate	127.0.0.1	t
8698f040-5521-4baf-9652-7b45b2a1faac	\N	2022-12-19 19:52:34.502409	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 19:53:10.72005	Sent message: 'захар крут'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:03:05.308676	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:04:43.30014	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:06:23.677831	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:07:12.653039	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:11:41.458062	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:35:11.578303	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:43:51.99939	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:45:26.470689	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:46:37.419177	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:52:38.723508	Failed login	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:52:41.261548	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:54:35.10909	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:55:57.080024	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 20:59:17.981627	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:16:00.822356	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:20:01.82601	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:21:13.388481	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:22:01.138168	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:22:47.008289	Authenticate	0:0:0:0:0:0:0:1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:24:34.162224	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:24:58.544473	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:25:58.03183	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:26:52.394871	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:27:42.19192	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 21:29:47.557216	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:08:40.009254	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:10:02.181314	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:11:05.313151	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:11:52.307655	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:12:48.585754	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:13:39.356989	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:16:30.070838	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:17:33.384899	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:18:42.694594	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:40:07.517841	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:50:59.121074	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:52:17.405977	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:53:47.911025	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:57:23.557381	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:58:10.666237	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 22:58:49.926194	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:01:24.537097	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:02:47.208938	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:04:26.078547	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:05:49.783023	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:06:57.29311	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:07:44.858234	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:08:38.869366	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:10:08.12747	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:13:02.296932	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:13:54.54201	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:15:45.388611	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:38:18.233064	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:38:56.505589	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:40:17.799658	Authenticate	127.0.0.1	t
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-19 23:49:14.522124	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:49:33.835691	Authenticate	127.0.0.1	t
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-19 23:51:29.611844	Authenticate	127.0.0.1	t
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-19 23:51:54.082428	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:51:59.488798	Sent message: 'ку'	127.0.0.1	f
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-19 23:52:06.923953	Sent message: 'саламалекум'	127.0.0.1	f
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:53:43.844811	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-20 12:26:36.03296	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-20 21:32:57.331846	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-21 12:46:37.292625	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-21 12:46:50.523066	Authenticate	127.0.0.1	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.users (user_uuid, login, password, role, last_login, registration_time, last_status, character_uuid) FROM stdin;
45c6e0b5-6f42-453a-90b7-8176abb1d68b	q	$1$pNlHbFsc$CbsmKokwRD13GzLYeqnRI0	player	2022-12-21 12:48:08.937049	2022-12-17 12:56:06.941547	NOT_IN_GAME	\N
f153040f-e6c6-4bf1-b208-0823393b3adb	n	$1$pNlHbFsc$hDhYj3YtnQw81ek6v/IXj1	player	2022-12-17 17:01:59.7075	2022-11-28 18:02:16.204709	NOT_IN_GAME	\N
75af33fb-4c78-4199-946d-17723604c948	test1	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	2022-12-10 21:43:20.817146	2022-12-10 21:32:18.044284	NOT_IN_GAME	\N
968af0c6-957e-4e6e-bf30-22282660467b	boss	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	2022-12-19 23:55:06.553229	2022-12-03 17:14:28.888011	NOT_IN_GAME	\N
8698f040-5521-4baf-9652-7b45b2a1faac	brim	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	2022-12-19 19:52:40.398601	2022-12-09 20:29:49.3803	NOT_IN_GAME	\N
887cb12f-1239-420f-9b43-0af75764446d	test	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	\N	2022-12-10 21:31:38.964786	NOT_IN_GAME	\N
d469027f-8ee9-4a41-8e08-5202f7ef57ae	nooneboss	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	2022-12-01 11:12:15.285229	2022-12-01 11:11:53.281587	NOT_IN_GAME	\N
\.


--
-- Name: characters characters_pk; Type: CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.characters
    ADD CONSTRAINT characters_pk PRIMARY KEY (character_uuid);


--
-- Name: chat chat_pk; Type: CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.chat
    ADD CONSTRAINT chat_pk PRIMARY KEY (message_id);


--
-- Name: chat chat_upk; Type: CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.chat
    ADD CONSTRAINT chat_upk UNIQUE (message_id);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.users
    ADD CONSTRAINT users_pk PRIMARY KEY (user_uuid);


--
-- Name: chat chat_users_null_fk; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.chat
    ADD CONSTRAINT chat_users_null_fk FOREIGN KEY (sender) REFERENCES play.users(user_uuid);


--
-- Name: friends friends_users_null_fk; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.friends
    ADD CONSTRAINT friends_users_null_fk FOREIGN KEY (first) REFERENCES play.users(user_uuid);


--
-- Name: friends friends_users_null_fk2; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.friends
    ADD CONSTRAINT friends_users_null_fk2 FOREIGN KEY (second) REFERENCES play.users(user_uuid);


--
-- Name: logs logs_characters_character_uuid_fk; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.logs
    ADD CONSTRAINT logs_characters_character_uuid_fk FOREIGN KEY ("character") REFERENCES play.characters(character_uuid);


--
-- Name: logs logs_users_null_fk; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.logs
    ADD CONSTRAINT logs_users_null_fk FOREIGN KEY (executor) REFERENCES play.users(user_uuid);


--
-- Name: users users_characters_null_fk; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.users
    ADD CONSTRAINT users_characters_null_fk FOREIGN KEY (character_uuid) REFERENCES play.characters(character_uuid);


--
-- Name: users; Type: ROW SECURITY; Schema: play; Owner: postgres
--

ALTER TABLE play.users ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA play; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA play TO rpgtraderauth;
GRANT USAGE ON SCHEMA play TO rpgtraderplayer;
GRANT USAGE ON SCHEMA play TO rpgtraderlogs;


--
-- Name: FUNCTION account_already_exist(checklogin character varying); Type: ACL; Schema: play; Owner: postgres
--

GRANT ALL ON FUNCTION play.account_already_exist(checklogin character varying) TO rpgtraderauth;


--
-- Name: FUNCTION auth(inputlogin character varying, inputpassword character varying); Type: ACL; Schema: play; Owner: postgres
--

GRANT ALL ON FUNCTION play.auth(inputlogin character varying, inputpassword character varying) TO rpgtraderauth;


--
-- Name: FUNCTION crypt_password(password character varying, login character varying); Type: ACL; Schema: play; Owner: postgres
--

GRANT ALL ON FUNCTION play.crypt_password(password character varying, login character varying) TO rpgtraderauth;


--
-- Name: TABLE chat; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE play.chat TO rpgtraderplayer;


--
-- Name: TABLE friends; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT,INSERT,DELETE ON TABLE play.friends TO rpgtraderplayer;


--
-- Name: TABLE users; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE play.users TO rpgtraderauth;


--
-- Name: COLUMN users.user_uuid; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT(user_uuid) ON TABLE play.users TO rpgtraderplayer;


--
-- Name: COLUMN users.last_login; Type: ACL; Schema: play; Owner: postgres
--

GRANT UPDATE(last_login) ON TABLE play.users TO rpgtraderauth;


--
-- Name: COLUMN users.last_status; Type: ACL; Schema: play; Owner: postgres
--

GRANT UPDATE(last_status) ON TABLE play.users TO rpgtraderplayer;
GRANT UPDATE(last_status) ON TABLE play.users TO rpgtraderauth;


--
-- Name: TABLE friendview; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT ON TABLE play.friendview TO rpgtraderplayer;


--
-- Name: TABLE logs; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE play.logs TO rpgtraderlogs;


--
-- PostgreSQL database dump complete
--

