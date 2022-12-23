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
-- Name: rpgtrader; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE rpgtrader WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE rpgtrader OWNER TO postgres;

\connect rpgtrader

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: arena_states; Type: TABLE; Schema: play; Owner: postgres
--

CREATE TABLE play.arena_states (
    character_uuid uuid,
    health smallint,
    character_position jsonb,
    character_rotation jsonb,
    camera_position jsonb,
    camera_rotation jsonb,
    camera_pivot_rotation jsonb,
    picked_up_items text DEFAULT ''::text NOT NULL
);


ALTER TABLE play.arena_states OWNER TO postgres;

--
-- Name: character_skins; Type: TABLE; Schema: play; Owner: postgres
--

CREATE TABLE play.character_skins (
    character_uuid uuid NOT NULL,
    skin jsonb NOT NULL
);


ALTER TABLE play.character_skins OWNER TO postgres;

--
-- Name: characters; Type: TABLE; Schema: play; Owner: postgres
--

CREATE TABLE play.characters (
    character_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    level integer DEFAULT 0 NOT NULL,
    money integer DEFAULT 0 NOT NULL,
    owner uuid NOT NULL
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
    last_status character varying(15) DEFAULT 'NOT_IN_GAME'::character varying
);


ALTER TABLE play.users OWNER TO postgres;

--
-- Name: inventory; Type: TABLE; Schema: play; Owner: postgres
--

CREATE TABLE play.inventory (
    item_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    character_uuid uuid,
    item_name character varying,
    item_description text,
    item_category character varying,
    sprite_name character varying
);


ALTER TABLE play.inventory OWNER TO postgres;

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
-- Data for Name: arena_states; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.arena_states (character_uuid, health, character_position, character_rotation, camera_position, camera_rotation, camera_pivot_rotation, picked_up_items) FROM stdin;
604555c1-969d-48ef-a799-621cbfe48390	60	{"x": -7.756375789642334, "y": 0.07394790649414062, "z": 15.454036712646484}	{"x": 0.0, "y": 123.59294128417969, "z": 0.0}	{"x": -7.795169830322266, "y": 0.06198596954345703, "z": 15.490326881408691}	{"x": 0.0, "y": 25.191970825195312, "z": 0.0}	{"x": 325.0, "y": 25.191970825195312, "z": 0.0}	
30b2095f-20b9-4ca0-8bda-2def86108f72	70	{"x": -6.621641159057617, "y": 0.031106948852539062, "z": 14.872697830200195}	{"x": 0.0, "y": 280.3568115234375, "z": 0.0}	{"x": -6.619626522064209, "y": 0.030920982360839844, "z": 14.872597694396973}	{"x": 0.0, "y": 113.13398742675781, "z": 0.0}	{"x": 325.0, "y": 113.13398742675781, "z": 0.0}	
c459e00e-8016-4ad3-9812-9cdc1acd7b21	100	{"x": -8.220800399780273, "y": 0.16675567626953125, "z": 14.527183532714844}	{"x": 0.0, "y": 209.25010681152344, "z": 0.0}	{"x": -8.22079849243164, "y": 0.17067813873291016, "z": 14.527185440063477}	{"x": 0.0, "y": 199.6179962158203, "z": 0.0}	{"x": 23.585208892822266, "y": 199.61798095703125, "z": -0.00000046579665990975627}	ItemBag, XPOrb, GoldBag, ItemBag (1), ItemBag2, ItemBag1
e3f14673-a4b8-474a-97bd-7ed56935a4a6	90	{"x": -7.7896246910095215, "y": 0.05894279479980469, "z": 15.759645462036133}	{"x": 0.0, "y": 214.20449829101562, "z": 0.0}	{"x": -7.789623737335205, "y": 0.0628652572631836, "z": 15.759645462036133}	{"x": 0.0, "y": 39.3720588684082, "z": 0.0}	{"x": 13.643803596496582, "y": 39.37206268310547, "z": 0.0}	ItemBag1, XPOrb, ItemBag2, GoldBag
978fb330-9d3d-4b25-bdbc-8d19b542434c	20	{"x": -9.374170303344727, "y": 0.13823890686035156, "z": 17.473665237426758}	{"x": 0.0, "y": 146.9792938232422, "z": 0.0}	{"x": -9.390252113342285, "y": 0.13924789428710938, "z": 17.48027229309082}	{"x": 0.0, "y": 14.47544002532959, "z": 0.0}	{"x": 325.0, "y": 14.47544002532959, "z": -0.0000005211325628806662}	, GoldBag, XPOrb, ItemBag
\.


--
-- Data for Name: character_skins; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.character_skins (character_uuid, skin) FROM stdin;
338029be-242d-464b-b289-5ab92fa43008	{"leg": 0, "hair": 0, "hand": 0, "head": 0, "hips": 0, "knee": 0, "elbow": 0, "torso": 0, "gender": 1, "helmet": -1, "armLower": 0, "armUpper": 0, "backAttachment": 0, "hipsAttachment": 0, "shoulderAttachment": 0}
30b2095f-20b9-4ca0-8bda-2def86108f72	{"leg": 4, "hair": 0, "hand": 5, "head": 0, "hips": 5, "knee": 4, "elbow": 4, "torso": 4, "gender": 0, "helmet": 3, "armLower": 3, "armUpper": 4, "backAttachment": 3, "hipsAttachment": 4, "shoulderAttachment": 3}
7a9d7333-c605-46b3-a378-e8a14665860b	{"leg": 5, "hair": 0, "hand": 3, "head": 0, "hips": 5, "knee": 3, "elbow": 4, "torso": 2, "gender": 0, "helmet": 1, "armLower": 2, "armUpper": 0, "backAttachment": 4, "hipsAttachment": 2, "shoulderAttachment": 3}
604555c1-969d-48ef-a799-621cbfe48390	{"leg": 0, "hair": 0, "hand": 0, "head": 0, "hips": 0, "knee": 0, "elbow": 0, "torso": 0, "gender": 1, "helmet": -1, "armLower": 0, "armUpper": 0, "backAttachment": 0, "hipsAttachment": 0, "shoulderAttachment": 0}
978fb330-9d3d-4b25-bdbc-8d19b542434c	{"leg": 1, "hair": 0, "hand": 4, "head": 0, "hips": 1, "knee": 3, "elbow": 2, "torso": 2, "gender": 0, "helmet": 2, "armLower": 3, "armUpper": 5, "backAttachment": 14, "hipsAttachment": 2, "shoulderAttachment": 0}
c41e7ef3-1b70-4fad-acd3-22e9d1debd47	{"leg": 3, "hair": 0, "hand": 3, "head": 0, "hips": 5, "knee": 3, "elbow": 4, "torso": 2, "gender": 0, "helmet": 4, "armLower": 3, "armUpper": 2, "backAttachment": 4, "hipsAttachment": 2, "shoulderAttachment": 3}
fc1faca5-8605-4a7d-8df1-f264b233de4c	{"leg": 0, "hair": 0, "hand": 0, "head": 2, "hips": 0, "knee": 0, "elbow": 0, "torso": 0, "gender": 0, "helmet": -1, "armLower": 0, "armUpper": 0, "backAttachment": 3, "hipsAttachment": 0, "shoulderAttachment": 0}
f3e2accd-0daa-4a42-b5a2-40434c3681b5	{"leg": 0, "hair": 0, "hand": 0, "head": 0, "hips": 0, "knee": 0, "elbow": 0, "torso": 0, "gender": 0, "helmet": 2, "armLower": 0, "armUpper": 0, "backAttachment": 3, "hipsAttachment": 2, "shoulderAttachment": 2}
c459e00e-8016-4ad3-9812-9cdc1acd7b21	{"leg": 0, "hair": 0, "hand": 0, "head": 0, "hips": 0, "knee": 0, "elbow": 0, "torso": 0, "gender": 1, "helmet": 2, "armLower": 0, "armUpper": 0, "backAttachment": 0, "hipsAttachment": 0, "shoulderAttachment": 0}
e3f14673-a4b8-474a-97bd-7ed56935a4a6	{"leg": 4, "hair": 0, "hand": 2, "head": 0, "hips": 5, "knee": 2, "elbow": 2, "torso": 3, "gender": 0, "helmet": 4, "armLower": 2, "armUpper": 3, "backAttachment": 5, "hipsAttachment": 2, "shoulderAttachment": 2}
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.characters (character_uuid, level, money, owner) FROM stdin;
338029be-242d-464b-b289-5ab92fa43008	0	0	45c6e0b5-6f42-453a-90b7-8176abb1d68b
30b2095f-20b9-4ca0-8bda-2def86108f72	0	0	255d6fa0-0720-4089-8a83-cbd60a3037b1
7a9d7333-c605-46b3-a378-e8a14665860b	0	0	6b9a99e5-0d7c-4d79-bad3-8f7a6609505f
604555c1-969d-48ef-a799-621cbfe48390	0	0	07bda83f-1011-4c56-a5e9-0dc5651cecec
c41e7ef3-1b70-4fad-acd3-22e9d1debd47	0	0	5040a91e-e6bf-4833-8904-b6a34c03d127
978fb330-9d3d-4b25-bdbc-8d19b542434c	10	50	d469027f-8ee9-4a41-8e08-5202f7ef57ae
fc1faca5-8605-4a7d-8df1-f264b233de4c	0	0	e65034d2-472f-4019-9cf3-51e1033ce847
f3e2accd-0daa-4a42-b5a2-40434c3681b5	0	0	01d7a7c0-e15f-4f99-a8f6-f19b45972ef3
c459e00e-8016-4ad3-9812-9cdc1acd7b21	10	20	daaae747-0b15-4593-8234-e6b0b9dced6b
e3f14673-a4b8-474a-97bd-7ed56935a4a6	5	10	6938adf3-f783-4b07-a9d4-550dd299bcec
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
6b9a99e5-0d7c-4d79-bad3-8f7a6609505f	2022-12-23 16:06:50.834	здарова	a4995f05-e024-4fe5-9bcb-ed0b469d6342
07bda83f-1011-4c56-a5e9-0dc5651cecec	2022-12-23 16:16:50.837	захар реально крутой поставьте ему 5	be673a3b-e1cb-42c0-9a5a-4b05da485378
07bda83f-1011-4c56-a5e9-0dc5651cecec	2022-12-23 16:16:50.84	кстати где мои баллы за преакселератор	c1246a5b-bf55-462c-9c5e-e249d6ccedc5
07bda83f-1011-4c56-a5e9-0dc5651cecec	2022-12-23 16:16:50.841	так так так	83fffa0e-b7b8-49e2-b8cb-1e4f3445b1f0
d469027f-8ee9-4a41-8e08-5202f7ef57ae	2022-12-23 16:18:30.837	реально так так так	afef42c5-1db1-4304-9de0-5a38a8375efe
d469027f-8ee9-4a41-8e08-5202f7ef57ae	2022-12-23 16:18:30.838	за аниме и двор стреля в упор	609cd381-3fb8-4808-a96d-e1bea5af65cc
\.


--
-- Data for Name: friends; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.friends (first, second, friend_date) FROM stdin;
45c6e0b5-6f42-453a-90b7-8176abb1d68b	968af0c6-957e-4e6e-bf30-22282660467b	2022-12-19 23:51:08.70198
6b9a99e5-0d7c-4d79-bad3-8f7a6609505f	d469027f-8ee9-4a41-8e08-5202f7ef57ae	2022-12-23 16:05:57.34379
d469027f-8ee9-4a41-8e08-5202f7ef57ae	07bda83f-1011-4c56-a5e9-0dc5651cecec	2022-12-23 16:20:08.342355
d469027f-8ee9-4a41-8e08-5202f7ef57ae	255d6fa0-0720-4089-8a83-cbd60a3037b1	2022-12-23 16:20:14.117503
d469027f-8ee9-4a41-8e08-5202f7ef57ae	1a46712b-66ad-485f-beca-4cf5060b01df	2022-12-23 16:20:25.791411
d469027f-8ee9-4a41-8e08-5202f7ef57ae	887cb12f-1239-420f-9b43-0af75764446d	2022-12-23 16:21:07.224967
d469027f-8ee9-4a41-8e08-5202f7ef57ae	75af33fb-4c78-4199-946d-17723604c948	2022-12-23 16:21:10.685292
d469027f-8ee9-4a41-8e08-5202f7ef57ae	8698f040-5521-4baf-9652-7b45b2a1faac	2022-12-23 16:21:13.868809
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.inventory (item_uuid, character_uuid, item_name, item_description, item_category, sprite_name) FROM stdin;
5647845d-76fb-499f-bce6-258409197b1d	c459e00e-8016-4ad3-9812-9cdc1acd7b21	Крутой щит	Самый крутой щит в мире.	weapons	shield_43
ce23e211-9176-4fa2-8f5e-823821584796	c459e00e-8016-4ad3-9812-9cdc1acd7b21	Крутой щит	Самый крутой щит в мире.	weapons	shield_44
ce0c44a3-0f9a-436b-8b0d-d926b1a88e74	c459e00e-8016-4ad3-9812-9cdc1acd7b21	Прочный щит	Самый прочный щит в мире.	weapons	shield_42
26695a07-63f2-486a-ac06-4f429b0ef021	e3f14673-a4b8-474a-97bd-7ed56935a4a6	Прочный щит	Самый прочный щит в мире.	weapons	shield_42
876d81a8-ee33-4af4-820b-d943612bb6d7	e3f14673-a4b8-474a-97bd-7ed56935a4a6	Крутой щит	Самый крутой щит в мире.	weapons	shield_44
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.logs (executor, "character", execution_time, action, "ipAddress", "isPersistence") FROM stdin;
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 00:59:16.317524	Authenticate	127.0.0.1	t
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 01:00:57.491747	Authenticate	127.0.0.1	t
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 01:02:18.912876	Authenticate	127.0.0.1	t
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 01:04:40.815064	Authenticate	127.0.0.1	t
8698f040-5521-4baf-9652-7b45b2a1faac	\N	2022-12-17 13:34:59.58451	Failed login	127.0.0.1	t
8698f040-5521-4baf-9652-7b45b2a1faac	\N	2022-12-17 15:52:06.179765	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:56:08.856167	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:57:45.102385	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 15:59:22.026295	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 16:02:12.459464	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 17:09:17.436605	Authenticate	127.0.0.1	t
f153040f-e6c6-4bf1-b208-0823393b3adb	\N	2022-12-17 19:52:45.710418	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:09:55.761264	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:10:44.558135	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:23:05.200811	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:23:22.743015	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:24:44.392188	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:25:21.316571	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:26:41.348368	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-17 21:28:00.859092	Authenticate	127.0.0.1	t
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
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-18 16:55:18.113211	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:24:23.242016	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:26:20.657289	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:29:11.809556	Authenticate	127.0.0.1	t
968af0c6-957e-4e6e-bf30-22282660467b	\N	2022-12-18 17:30:18.840792	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:30:33.292634	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 17:39:20.309086	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 19:19:22.051192	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 21:53:43.395302	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 21:55:01.472288	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:06:22.237972	Authenticate	0:0:0:0:0:0:0:1	t
8698f040-5521-4baf-9652-7b45b2a1faac	\N	2022-12-18 22:08:24.047326	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:09:11.135271	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-18 22:16:11.668678	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 19:35:06.886063	Authenticate	127.0.0.1	t
8698f040-5521-4baf-9652-7b45b2a1faac	\N	2022-12-19 19:52:34.502409	Authenticate	127.0.0.1	t
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
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-19 23:53:43.844811	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-20 12:26:36.03296	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-20 21:32:57.331846	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-21 12:46:37.292625	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-21 12:46:50.523066	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 01:28:33.803641	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 01:32:59.435817	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 01:34:45.628143	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 01:35:33.119771	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 01:38:42.306366	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 01:46:30.105396	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 01:50:08.636919	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 01:51:27.68554	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 01:51:33.612364	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 11:49:28.971999	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 11:50:38.114476	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 11:51:29.684238	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 11:51:32.876546	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 11:51:33.451625	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 11:51:33.646689	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 11:51:34.048183	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 11:52:13.489207	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:09:45.004173	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:10:43.127672	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:11:07.347826	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:11:55.906885	Authenticate	0:0:0:0:0:0:0:1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:12:34.70291	Created character	0:0:0:0:0:0:0:1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:14:09.815909	Authenticate	0:0:0:0:0:0:0:1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:15:37.692289	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:16:06.6814	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:16:51.068509	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:19:32.022441	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:21:43.122252	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:24:45.981943	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:25:55.462184	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:26:31.949643	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:27:01.61929	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:29:07.882221	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:30:43.787048	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:31:34.866897	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:31:47.648774	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:31:48.615187	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:31:48.807997	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:31:48.986167	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:31:49.165154	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:32:13.132379	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:32:40.994182	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:35:17.837029	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:37:42.603185	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:40:12.772973	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:41:01.148614	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:48:58.071588	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:58:43.22987	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 12:59:10.335242	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 13:00:07.78946	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 13:07:11.864073	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 13:07:54.810762	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 13:10:33.529678	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 13:10:39.715743	Created character	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 13:15:57.73704	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 13:16:35.450546	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 13:21:39.664514	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 13:22:28.249226	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 21:19:33.994996	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 21:21:01.794096	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-22 21:40:36.029585	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 00:34:49.47216	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 00:41:00.980842	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 00:42:20.518861	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 00:43:22.887008	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 00:46:25.035688	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 00:47:50.740113	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 00:48:32.672976	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 00:49:03.060205	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:28:25.816017	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:30:54.80208	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:31:46.985571	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:32:06.600927	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:32:32.524862	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:32:56.850224	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:41:11.551239	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:45:20.380039	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:51:14.269274	Authenticate	127.0.0.1	t
45c6e0b5-6f42-453a-90b7-8176abb1d68b	\N	2022-12-23 13:52:15.623654	Authenticate	127.0.0.1	t
255d6fa0-0720-4089-8a83-cbd60a3037b1	\N	2022-12-23 14:43:25.082032	Authenticate	127.0.0.1	t
255d6fa0-0720-4089-8a83-cbd60a3037b1	\N	2022-12-23 14:43:50.309302	Created character	127.0.0.1	t
255d6fa0-0720-4089-8a83-cbd60a3037b1	\N	2022-12-23 14:45:48.970745	Authenticate	127.0.0.1	t
255d6fa0-0720-4089-8a83-cbd60a3037b1	\N	2022-12-23 14:49:06.295601	Authenticate	127.0.0.1	t
6b9a99e5-0d7c-4d79-bad3-8f7a6609505f	\N	2022-12-23 16:05:02.309808	Failed login	127.0.0.1	t
6b9a99e5-0d7c-4d79-bad3-8f7a6609505f	\N	2022-12-23 16:05:13.331521	Authenticate	127.0.0.1	t
6b9a99e5-0d7c-4d79-bad3-8f7a6609505f	\N	2022-12-23 16:05:36.269037	Created character	127.0.0.1	t
6b9a99e5-0d7c-4d79-bad3-8f7a6609505f	\N	2022-12-23 16:06:55.890305	Authenticate	127.0.0.1	t
6b9a99e5-0d7c-4d79-bad3-8f7a6609505f	\N	2022-12-23 16:10:52.638381	Authenticate	127.0.0.1	t
6b9a99e5-0d7c-4d79-bad3-8f7a6609505f	\N	2022-12-23 16:11:59.373727	Authenticate	127.0.0.1	t
07bda83f-1011-4c56-a5e9-0dc5651cecec	\N	2022-12-23 16:14:31.068535	Authenticate	127.0.0.1	t
07bda83f-1011-4c56-a5e9-0dc5651cecec	\N	2022-12-23 16:14:58.462829	Created character	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 16:16:09.341034	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 16:17:02.045428	Created character	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 16:18:52.695745	Authenticate	127.0.0.1	t
5040a91e-e6bf-4833-8904-b6a34c03d127	\N	2022-12-23 16:26:17.90221	Authenticate	0:0:0:0:0:0:0:1	t
5040a91e-e6bf-4833-8904-b6a34c03d127	c41e7ef3-1b70-4fad-acd3-22e9d1debd47	2022-12-23 16:26:36.695008	Created character	0:0:0:0:0:0:0:1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:29:57.460456	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:33:06.453981	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:34:13.356498	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:44:07.77945	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:47:37.859813	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:48:50.609541	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:49:13.485122	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:50:31.499779	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:51:55.111368	Authenticate	127.0.0.1	t
d469027f-8ee9-4a41-8e08-5202f7ef57ae	\N	2022-12-23 18:53:25.569054	Authenticate	127.0.0.1	t
6b39e2a7-a5cc-47d2-837c-8cda4ee10b6b	\N	2022-12-23 19:32:13.077642	Failed login	127.0.0.1	t
6b39e2a7-a5cc-47d2-837c-8cda4ee10b6b	\N	2022-12-23 19:32:19.322727	Failed login	127.0.0.1	t
e65034d2-472f-4019-9cf3-51e1033ce847	\N	2022-12-23 19:32:43.615268	Authenticate	127.0.0.1	t
e65034d2-472f-4019-9cf3-51e1033ce847	fc1faca5-8605-4a7d-8df1-f264b233de4c	2022-12-23 19:32:55.226119	Created character	127.0.0.1	t
01d7a7c0-e15f-4f99-a8f6-f19b45972ef3	\N	2022-12-23 19:33:36.157986	Authenticate	127.0.0.1	t
01d7a7c0-e15f-4f99-a8f6-f19b45972ef3	f3e2accd-0daa-4a42-b5a2-40434c3681b5	2022-12-23 19:33:42.813693	Created character	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:16:16.680407	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	c459e00e-8016-4ad3-9812-9cdc1acd7b21	2022-12-23 20:16:30.977114	Created character	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:19:14.942426	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:22:08.502918	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:23:06.174086	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:27:48.220252	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:30:19.743548	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:32:24.013422	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:38:07.822548	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:39:12.968549	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:40:19.817804	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:42:32.388193	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:43:55.051705	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:45:14.126383	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:45:54.297023	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:47:08.278684	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:49:08.728344	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:49:49.104474	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:50:16.063474	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:52:06.193671	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:53:17.569605	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:54:23.897457	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:55:14.249319	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 20:56:10.556825	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:07:38.945501	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:10:03.103057	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:12:47.850657	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:14:17.862315	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:18:15.971308	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:19:18.862849	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:22:07.747444	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:23:14.641848	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:23:58.966306	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:24:44.055838	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:25:45.32831	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:26:50.128114	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:28:23.433599	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:31:20.50957	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:31:55.035665	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:32:43.018458	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:33:30.643152	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:34:26.494656	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:35:01.399207	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:38:34.581403	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:39:14.98093	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:41:48.461493	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:45:21.595199	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:46:03.130869	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:46:24.644308	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:46:58.817104	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 21:50:45.862043	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 22:03:29.042615	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 22:06:17.535238	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 22:07:23.513742	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 22:08:06.120713	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 22:09:50.509485	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 22:12:27.315868	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 22:17:28.701276	Authenticate	127.0.0.1	t
daaae747-0b15-4593-8234-e6b0b9dced6b	\N	2022-12-23 22:18:55.486176	Authenticate	127.0.0.1	t
6938adf3-f783-4b07-a9d4-550dd299bcec	\N	2022-12-23 22:36:09.617412	Authenticate	127.0.0.1	t
6938adf3-f783-4b07-a9d4-550dd299bcec	e3f14673-a4b8-474a-97bd-7ed56935a4a6	2022-12-23 22:36:40.215593	Created character	127.0.0.1	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: play; Owner: postgres
--

COPY play.users (user_uuid, login, password, role, last_login, registration_time, last_status) FROM stdin;
6938adf3-f783-4b07-a9d4-550dd299bcec	dreamgod	$1$pNlHbFsc$pX3hHHNl7jHzLVYj1wcjH.	player	2022-12-23 22:37:48.716572	2022-12-23 22:36:05.882208	NOT_IN_GAME
968af0c6-957e-4e6e-bf30-22282660467b	bossihasd	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	2022-12-19 23:55:06.553229	2022-12-03 17:14:28.888011	NOT_IN_GAME
8698f040-5521-4baf-9652-7b45b2a1faac	dreambeast	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	2022-12-19 19:52:40.398601	2022-12-09 20:29:49.3803	NOT_IN_GAME
887cb12f-1239-420f-9b43-0af75764446d	testtesttest	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	\N	2022-12-10 21:31:38.964786	NOT_IN_GAME
255d6fa0-0720-4089-8a83-cbd60a3037b1	nooneboss2	$1$pNlHbFsc$Nfwr/4m2AeVy971pwtUKe/	player	2022-12-23 14:50:13.639781	2022-12-23 14:43:15.296358	NOT_IN_GAME
6b9a99e5-0d7c-4d79-bad3-8f7a6609505f	vadimkrasniy	$1$pNlHbFsc$A.B5oi9YaV48RySnEpjva/	player	2022-12-23 16:13:15.127393	2022-12-23 16:04:54.059667	NOT_IN_GAME
f4387f6f-a598-4ac4-b3e3-fe267fce0343	zahaudzumaha	$1$pNlHbFsc$kwY18sorQC0g.IeF1gsqh1	player	\N	2022-12-23 14:30:36.455743	NOT_IN_GAME
d469027f-8ee9-4a41-8e08-5202f7ef57ae	nooneboss	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	2022-12-23 18:53:42.798304	2022-12-01 11:11:53.281587	NOT_IN_GAME
07bda83f-1011-4c56-a5e9-0dc5651cecec	dotatrash	$1$pNlHbFsc$E1XX1dDv2NBETdw4d1ZxI.	player	2022-12-23 16:15:53.171518	2022-12-23 16:14:23.531078	NOT_IN_GAME
45c6e0b5-6f42-453a-90b7-8176abb1d68b	qqqqq123123	$1$pNlHbFsc$CbsmKokwRD13GzLYeqnRI0	player	2022-12-23 13:52:27.883166	2022-12-17 12:56:06.941547	NOT_IN_GAME
f153040f-e6c6-4bf1-b208-0823393b3adb	normilized	$1$pNlHbFsc$hDhYj3YtnQw81ek6v/IXj1	player	2022-12-17 17:01:59.7075	2022-11-28 18:02:16.204709	NOT_IN_GAME
1a46712b-66ad-485f-beca-4cf5060b01df	flugger322	$1$pNlHbFsc$WMAUavY.HJS68hO9ejWFL/	player	\N	2022-12-23 14:27:57.509309	NOT_IN_GAME
75af33fb-4c78-4199-946d-17723604c948	vacuntooo	$1$pNlHbFsc$qLk0lzrWpyQ.dO/MlkYe51	player	2022-12-10 21:43:20.817146	2022-12-10 21:32:18.044284	NOT_IN_GAME
5040a91e-e6bf-4833-8904-b6a34c03d127	ligalegend	$1$pNlHbFsc$Cvc22R4s5U6RotjHksoq40	player	2022-12-23 16:40:21.051724	2022-12-23 16:26:11.016168	NOT_IN_GAME
e65034d2-472f-4019-9cf3-51e1033ce847	testqwe2	$1$pNlHbFsc$.tIiVO39HkhMERj2GGOCp0	player	2022-12-23 19:33:07.338742	2022-12-23 19:32:36.835282	NOT_IN_GAME
01d7a7c0-e15f-4f99-a8f6-f19b45972ef3	vacuntogod	$1$pNlHbFsc$.tIiVO39HkhMERj2GGOCp0	player	2022-12-23 19:36:11.862674	2022-12-23 19:33:28.608856	NOT_IN_GAME
6b39e2a7-a5cc-47d2-837c-8cda4ee10b6b	testqwer	$1$pNlHbFsc$eEW47W2lqiyAsK2mcEOo0/	player	\N	2022-12-23 19:32:05.540823	NOT_IN_GAME
daaae747-0b15-4593-8234-e6b0b9dced6b	dota2dota2	$1$pNlHbFsc$wX3q45ZImhXBkzQFX84NI.	player	2022-12-23 22:19:22.422164	2022-12-23 20:16:14.485494	MAIN_MENU
\.


--
-- Name: arena_states arena_states_pk; Type: CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.arena_states
    ADD CONSTRAINT arena_states_pk UNIQUE (character_uuid);


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
-- Name: inventory inventory_pk; Type: CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.inventory
    ADD CONSTRAINT inventory_pk PRIMARY KEY (item_uuid);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.users
    ADD CONSTRAINT users_pk PRIMARY KEY (user_uuid);


--
-- Name: arena_states remove_dead_saves; Type: TRIGGER; Schema: play; Owner: postgres
--

CREATE TRIGGER remove_dead_saves AFTER INSERT OR UPDATE ON play.arena_states FOR EACH ROW EXECUTE FUNCTION play.remove_dead_save();


--
-- Name: arena_states arena_states_characters_null_fk; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.arena_states
    ADD CONSTRAINT arena_states_characters_null_fk FOREIGN KEY (character_uuid) REFERENCES play.characters(character_uuid);


--
-- Name: character_skins character_skins_characters_null_fk; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.character_skins
    ADD CONSTRAINT character_skins_characters_null_fk FOREIGN KEY (character_uuid) REFERENCES play.characters(character_uuid);


--
-- Name: characters characters_users_null_fk; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.characters
    ADD CONSTRAINT characters_users_null_fk FOREIGN KEY (owner) REFERENCES play.users(user_uuid);


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
-- Name: inventory inventory_characters_null_fk; Type: FK CONSTRAINT; Schema: play; Owner: postgres
--

ALTER TABLE ONLY play.inventory
    ADD CONSTRAINT inventory_characters_null_fk FOREIGN KEY (character_uuid) REFERENCES play.characters(character_uuid);


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
-- Name: users; Type: ROW SECURITY; Schema: play; Owner: postgres
--

ALTER TABLE play.users ENABLE ROW LEVEL SECURITY;

--
-- Name: DATABASE rpgtrader; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE,CONNECT ON DATABASE rpgtrader TO rpgtraderauth;
GRANT CONNECT ON DATABASE rpgtrader TO rpgtraderlogs;


--
-- Name: TABLE arena_states; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE play.arena_states TO rpgtraderplayer;


--
-- Name: TABLE character_skins; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE play.character_skins TO rpgtraderplayer;


--
-- Name: TABLE characters; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE play.characters TO rpgtraderplayer;


--
-- Name: COLUMN characters.level; Type: ACL; Schema: play; Owner: postgres
--

GRANT UPDATE(level) ON TABLE play.characters TO rpgtraderplayer;


--
-- Name: COLUMN characters.money; Type: ACL; Schema: play; Owner: postgres
--

GRANT UPDATE(money) ON TABLE play.characters TO rpgtraderplayer;


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
-- Name: TABLE inventory; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE play.inventory TO rpgtraderplayer;


--
-- Name: TABLE logs; Type: ACL; Schema: play; Owner: postgres
--

GRANT SELECT,INSERT,DELETE ON TABLE play.logs TO rpgtraderlogs;


--
-- PostgreSQL database dump complete
--

