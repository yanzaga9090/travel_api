-- Travel системийн өгөгдөл (travel_db сангаас гаргасан).
-- Docker-ийн db контейнер АНХ асахад автоматаар ачаалагдана.

--
-- PostgreSQL database dump
--


-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.6 (Debian 18.6-1.pgdg13+2)

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
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    admin_id integer NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(100) NOT NULL
);


--
-- Name: admins_admin_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_admin_id_seq OWNED BY public.admins.admin_id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookings (
    booking_id integer NOT NULL,
    tour_id integer NOT NULL,
    customer_id integer NOT NULL,
    people integer,
    booked_at date DEFAULT CURRENT_DATE,
    status character varying(20) DEFAULT 'pending'::character varying,
    CONSTRAINT bookings_people_check CHECK ((people > 0))
);


--
-- Name: bookings_booking_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookings_booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookings_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookings_booking_id_seq OWNED BY public.bookings.booking_id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    country character varying(50),
    email character varying(100)
);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: guides; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guides (
    guide_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    language character varying(30),
    experience_years integer,
    CONSTRAINT guides_experience_years_check CHECK ((experience_years >= 0))
);


--
-- Name: guides_guide_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.guides_guide_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: guides_guide_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.guides_guide_id_seq OWNED BY public.guides.guide_id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    booking_id integer NOT NULL,
    amount numeric(12,2),
    paid_at date,
    method character varying(20),
    CONSTRAINT payments_amount_check CHECK ((amount > (0)::numeric))
);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- Name: tours; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tours (
    tour_id integer NOT NULL,
    name character varying(100) NOT NULL,
    destination character varying(50),
    days integer,
    price numeric(12,2),
    start_date date,
    guide_id integer,
    CONSTRAINT tours_days_check CHECK ((days > 0)),
    CONSTRAINT tours_price_check CHECK ((price > (0)::numeric))
);


--
-- Name: tours_tour_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tours_tour_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tours_tour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tours_tour_id_seq OWNED BY public.tours.tour_id;


--
-- Name: admins admin_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN admin_id SET DEFAULT nextval('public.admins_admin_id_seq'::regclass);


--
-- Name: bookings booking_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings ALTER COLUMN booking_id SET DEFAULT nextval('public.bookings_booking_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: guides guide_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guides ALTER COLUMN guide_id SET DEFAULT nextval('public.guides_guide_id_seq'::regclass);


--
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- Name: tours tour_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tours ALTER COLUMN tour_id SET DEFAULT nextval('public.tours_tour_id_seq'::regclass);


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admins (admin_id, email, password_hash) FROM stdin;
1	admin@travel.mn	$2b$12$VVUN.X692K6z5pJ5jxpfNOLpjoo563I0savN3rZnucpiZ9DXtm8Ou
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bookings (booking_id, tour_id, customer_id, people, booked_at, status) FROM stdin;
1	1	1	2	2026-03-05	confirmed
2	1	2	4	2026-04-12	confirmed
3	4	3	1	2026-02-20	confirmed
4	2	4	3	2026-05-01	pending
5	2	5	2	2026-05-03	cancelled
6	5	3	2	2026-04-28	pending
7	6	4	2	2026-01-10	confirmed
8	3	1	5	2026-05-20	pending
9	42	75	1	2023-01-01	confirmed
10	42	4	2	2023-01-12	confirmed
11	42	161	6	2023-01-15	confirmed
12	42	262	3	2023-01-19	confirmed
13	42	444	3	2023-01-24	confirmed
14	42	104	6	2023-01-27	confirmed
15	42	192	2	2023-01-30	confirmed
16	42	411	2	2023-02-01	confirmed
17	139	285	5	2023-02-06	confirmed
18	139	210	1	2023-02-07	confirmed
19	26	225	3	2023-02-08	confirmed
20	139	304	2	2023-02-08	confirmed
21	26	105	5	2023-02-11	confirmed
22	26	64	4	2023-02-11	confirmed
23	26	255	2	2023-02-11	confirmed
24	26	85	6	2023-02-12	confirmed
25	26	274	3	2023-02-15	confirmed
26	118	239	2	2023-02-15	confirmed
27	85	213	2	2023-02-18	confirmed
28	118	80	5	2023-02-18	confirmed
29	118	229	1	2023-02-18	confirmed
30	85	369	3	2023-02-19	confirmed
31	85	431	3	2023-02-20	confirmed
32	85	17	2	2023-02-24	confirmed
33	85	115	2	2023-02-25	confirmed
34	85	95	5	2023-02-26	confirmed
35	85	425	4	2023-02-27	confirmed
36	85	481	2	2023-02-28	confirmed
37	85	385	5	2023-03-05	confirmed
38	126	443	2	2023-03-09	confirmed
39	126	139	2	2023-03-10	confirmed
40	126	52	1	2023-03-13	confirmed
41	126	337	2	2023-03-15	confirmed
42	126	231	2	2023-03-16	confirmed
43	126	92	3	2023-03-18	confirmed
44	126	233	2	2023-03-19	confirmed
45	126	237	2	2023-03-19	confirmed
46	126	50	1	2023-03-21	confirmed
47	126	181	4	2023-03-24	confirmed
48	18	340	2	2023-03-30	confirmed
49	18	448	1	2023-04-01	confirmed
50	75	55	2	2023-04-01	confirmed
51	75	275	2	2023-04-02	confirmed
52	75	292	5	2023-04-02	confirmed
53	75	146	3	2023-04-02	confirmed
54	75	373	2	2023-04-04	confirmed
55	75	28	1	2023-04-06	confirmed
56	75	88	2	2023-04-06	cancelled
57	75	16	2	2023-04-07	confirmed
58	75	292	6	2023-04-08	confirmed
59	75	305	2	2023-04-09	confirmed
60	75	51	2	2023-04-10	confirmed
61	75	176	2	2023-04-12	confirmed
62	75	482	2	2023-04-13	cancelled
63	75	17	4	2023-04-14	confirmed
64	75	348	2	2023-04-15	confirmed
65	75	105	3	2023-04-20	confirmed
66	75	35	3	2023-04-21	confirmed
67	75	399	1	2023-04-22	confirmed
68	75	321	2	2023-04-23	confirmed
69	60	368	4	2023-04-24	cancelled
70	60	412	3	2023-04-25	confirmed
71	60	356	2	2023-04-25	confirmed
72	60	411	5	2023-04-27	confirmed
73	60	402	4	2023-04-30	confirmed
74	60	404	2	2023-05-03	confirmed
75	60	235	2	2023-05-08	confirmed
76	60	402	1	2023-05-08	confirmed
77	98	45	4	2023-05-09	confirmed
78	98	3	4	2023-05-09	confirmed
79	98	450	1	2023-05-10	confirmed
80	98	235	4	2023-05-10	confirmed
81	98	182	6	2023-05-10	confirmed
82	98	46	1	2023-05-11	confirmed
83	98	276	5	2023-05-14	confirmed
84	98	22	2	2023-05-14	confirmed
85	98	491	4	2023-05-15	confirmed
86	98	456	2	2023-05-16	confirmed
87	119	449	5	2023-05-16	confirmed
88	119	1	4	2023-05-17	confirmed
89	119	415	2	2023-05-17	confirmed
90	119	377	2	2023-05-18	confirmed
91	119	39	3	2023-05-20	confirmed
92	119	186	3	2023-05-21	confirmed
93	119	31	6	2023-05-22	confirmed
94	119	10	3	2023-05-22	confirmed
95	110	160	6	2023-05-23	confirmed
96	110	248	1	2023-05-23	confirmed
97	110	301	3	2023-05-23	confirmed
98	110	329	2	2023-05-24	confirmed
99	110	14	3	2023-05-24	confirmed
100	110	347	2	2023-05-26	confirmed
101	110	143	3	2023-05-26	confirmed
102	110	407	5	2023-05-27	confirmed
103	110	450	2	2023-05-28	confirmed
104	110	88	3	2023-05-30	confirmed
105	110	398	3	2023-06-02	confirmed
106	110	484	3	2023-06-03	confirmed
107	79	207	3	2023-06-04	confirmed
108	79	198	3	2023-06-04	confirmed
109	79	466	2	2023-06-05	confirmed
110	79	162	2	2023-06-05	confirmed
111	79	241	3	2023-06-05	confirmed
112	79	368	3	2023-06-06	confirmed
113	79	395	2	2023-06-06	confirmed
114	79	291	6	2023-06-07	confirmed
115	79	125	3	2023-06-07	confirmed
116	79	365	4	2023-06-07	confirmed
117	79	496	2	2023-06-08	confirmed
118	123	405	4	2023-06-08	confirmed
119	123	173	4	2023-06-10	confirmed
120	123	267	2	2023-06-11	confirmed
121	121	350	2	2023-06-12	confirmed
122	132	437	2	2023-06-12	confirmed
123	132	374	4	2023-06-12	confirmed
124	132	436	2	2023-06-13	confirmed
125	132	381	3	2023-06-15	confirmed
126	132	449	2	2023-06-16	confirmed
127	132	310	2	2023-06-17	confirmed
128	132	185	2	2023-06-19	confirmed
129	132	37	1	2023-06-19	confirmed
130	132	323	2	2023-06-20	cancelled
131	132	258	2	2023-06-20	confirmed
132	132	17	6	2023-06-20	confirmed
133	132	151	2	2023-06-21	confirmed
134	132	112	6	2023-06-23	confirmed
135	132	115	6	2023-06-23	confirmed
136	132	192	6	2023-06-26	confirmed
137	132	205	2	2023-06-26	confirmed
138	132	452	2	2023-06-27	confirmed
139	46	129	6	2023-06-28	confirmed
140	46	497	2	2023-06-28	confirmed
141	132	58	3	2023-06-28	confirmed
142	132	40	3	2023-06-28	confirmed
143	46	381	2	2023-06-30	confirmed
144	46	360	2	2023-07-01	confirmed
145	46	106	1	2023-07-01	cancelled
146	46	443	4	2023-07-02	cancelled
147	46	182	6	2023-07-02	confirmed
148	46	23	3	2023-07-03	confirmed
149	46	412	4	2023-07-03	confirmed
150	46	79	3	2023-07-04	confirmed
151	77	467	5	2023-07-04	confirmed
152	77	500	5	2023-07-04	confirmed
153	77	261	6	2023-07-05	confirmed
154	77	11	3	2023-07-05	confirmed
155	77	375	6	2023-07-06	confirmed
156	77	7	4	2023-07-06	confirmed
157	77	5	6	2023-07-07	confirmed
158	77	294	1	2023-07-07	confirmed
159	77	454	3	2023-07-08	confirmed
160	77	105	2	2023-07-09	cancelled
161	77	54	3	2023-07-09	confirmed
162	77	293	2	2023-07-09	confirmed
163	77	87	1	2023-07-10	confirmed
164	77	242	5	2023-07-12	confirmed
165	77	33	5	2023-07-12	confirmed
166	77	404	1	2023-07-12	confirmed
167	142	500	2	2023-07-13	cancelled
168	142	20	2	2023-07-13	confirmed
169	142	477	4	2023-07-13	confirmed
170	142	471	6	2023-07-14	confirmed
171	101	10	1	2023-07-15	confirmed
172	101	414	2	2023-07-16	confirmed
173	101	490	2	2023-07-16	confirmed
174	101	285	2	2023-07-16	confirmed
175	101	315	1	2023-07-17	confirmed
176	101	287	4	2023-07-17	confirmed
177	101	416	2	2023-07-17	confirmed
178	101	377	2	2023-07-17	confirmed
179	101	45	2	2023-07-19	confirmed
180	101	436	2	2023-07-19	confirmed
181	101	159	3	2023-07-19	confirmed
182	38	172	5	2023-07-20	confirmed
183	38	59	2	2023-07-21	cancelled
184	38	234	2	2023-07-21	confirmed
185	38	429	2	2023-07-21	confirmed
186	90	221	2	2023-07-22	confirmed
187	90	362	3	2023-07-22	confirmed
188	90	15	3	2023-07-22	confirmed
189	90	84	2	2023-07-23	confirmed
190	90	7	3	2023-07-23	confirmed
191	90	454	3	2023-07-23	confirmed
192	67	397	1	2023-07-24	confirmed
193	67	54	2	2023-07-25	confirmed
194	67	188	4	2023-07-25	confirmed
195	67	272	5	2023-07-26	confirmed
196	122	266	4	2023-07-26	confirmed
197	122	465	2	2023-07-26	confirmed
198	122	486	4	2023-07-27	confirmed
199	122	382	2	2023-07-27	confirmed
200	122	492	2	2023-07-28	confirmed
201	122	317	2	2023-07-28	confirmed
202	122	156	2	2023-07-29	confirmed
203	122	38	2	2023-07-29	confirmed
204	122	370	2	2023-07-29	confirmed
205	122	52	5	2023-07-30	confirmed
206	122	354	4	2023-07-31	confirmed
207	144	236	2	2023-07-31	confirmed
208	144	425	2	2023-07-31	cancelled
209	144	107	2	2023-07-31	confirmed
210	144	433	3	2023-07-31	confirmed
211	107	338	2	2023-08-01	confirmed
212	107	247	2	2023-08-01	cancelled
213	144	30	2	2023-08-01	confirmed
214	144	115	2	2023-08-01	confirmed
215	144	437	3	2023-08-01	cancelled
216	107	182	2	2023-08-02	confirmed
217	107	378	2	2023-08-03	confirmed
218	107	340	3	2023-08-04	confirmed
219	107	195	2	2023-08-04	confirmed
220	107	391	2	2023-08-04	confirmed
221	28	242	2	2023-08-05	confirmed
222	28	194	1	2023-08-05	cancelled
223	28	16	3	2023-08-06	confirmed
224	28	236	5	2023-08-07	confirmed
225	28	246	4	2023-08-08	confirmed
226	28	61	4	2023-08-08	confirmed
227	28	241	3	2023-08-09	confirmed
228	28	261	6	2023-08-10	cancelled
229	28	111	2	2023-08-11	confirmed
230	28	269	1	2023-08-12	confirmed
231	28	443	6	2023-08-12	confirmed
232	28	136	2	2023-08-13	cancelled
233	17	236	5	2023-08-14	confirmed
234	17	51	5	2023-08-14	confirmed
235	28	361	3	2023-08-14	cancelled
236	17	93	5	2023-08-15	confirmed
237	64	17	5	2023-08-15	confirmed
238	64	75	2	2023-08-15	confirmed
239	64	189	1	2023-08-16	confirmed
240	64	462	1	2023-08-17	confirmed
241	64	147	2	2023-08-17	confirmed
242	64	161	2	2023-08-18	confirmed
243	64	85	4	2023-08-18	cancelled
244	64	248	1	2023-08-19	confirmed
245	64	437	5	2023-08-19	confirmed
246	64	241	2	2023-08-19	confirmed
247	64	500	5	2023-08-19	confirmed
248	64	212	4	2023-08-20	confirmed
249	64	429	2	2023-08-20	confirmed
250	64	244	3	2023-08-21	confirmed
251	64	62	3	2023-08-21	confirmed
252	64	268	2	2023-08-21	confirmed
253	129	217	1	2023-08-21	confirmed
254	129	130	5	2023-08-22	confirmed
255	129	365	3	2023-08-22	confirmed
256	129	420	1	2023-08-23	confirmed
257	129	386	3	2023-08-24	cancelled
258	129	216	2	2023-08-25	confirmed
259	129	335	3	2023-08-25	confirmed
260	129	272	2	2023-08-26	confirmed
261	129	460	4	2023-08-26	cancelled
262	129	93	3	2023-08-26	confirmed
263	63	269	4	2023-08-27	confirmed
264	129	242	1	2023-08-27	confirmed
265	63	175	1	2023-08-28	confirmed
266	63	120	3	2023-08-29	confirmed
267	63	206	2	2023-08-29	confirmed
268	63	185	3	2023-08-29	confirmed
269	63	114	3	2023-08-30	confirmed
270	63	70	2	2023-09-01	cancelled
271	63	331	4	2023-09-01	confirmed
272	63	296	5	2023-09-02	confirmed
273	63	416	4	2023-09-02	confirmed
274	63	60	2	2023-09-03	confirmed
275	10	495	2	2023-09-04	confirmed
276	10	84	3	2023-09-04	confirmed
277	10	8	1	2023-09-04	confirmed
278	10	3	1	2023-09-04	cancelled
279	10	128	2	2023-09-05	cancelled
280	10	90	1	2023-09-05	confirmed
281	10	43	1	2023-09-07	cancelled
282	10	77	2	2023-09-07	confirmed
283	10	164	2	2023-09-07	confirmed
284	10	171	5	2023-09-08	confirmed
285	10	47	3	2023-09-08	confirmed
286	10	445	3	2023-09-09	confirmed
287	10	97	6	2023-09-09	confirmed
288	73	368	4	2023-09-10	confirmed
289	73	411	3	2023-09-10	confirmed
290	73	98	2	2023-09-11	confirmed
291	73	423	2	2023-09-12	confirmed
292	73	478	2	2023-09-13	cancelled
293	73	325	2	2023-09-13	confirmed
294	73	268	3	2023-09-13	confirmed
295	73	13	1	2023-09-13	confirmed
296	73	354	2	2023-09-13	confirmed
297	14	160	2	2023-09-14	confirmed
298	14	238	2	2023-09-14	cancelled
299	73	367	3	2023-09-14	confirmed
300	14	157	3	2023-09-15	confirmed
301	14	167	2	2023-09-16	confirmed
302	14	450	2	2023-09-16	confirmed
303	14	62	1	2023-09-16	confirmed
304	14	39	6	2023-09-17	confirmed
305	14	35	4	2023-09-18	confirmed
306	14	245	5	2023-09-18	confirmed
307	14	475	6	2023-09-19	confirmed
308	14	45	2	2023-09-19	confirmed
309	14	484	1	2023-09-21	confirmed
310	14	18	5	2023-09-22	confirmed
311	14	44	3	2023-09-22	confirmed
312	19	377	2	2023-09-24	confirmed
313	19	344	3	2023-09-24	confirmed
314	19	420	2	2023-09-25	confirmed
315	19	392	2	2023-09-25	confirmed
316	19	125	3	2023-09-25	confirmed
317	19	380	2	2023-09-25	confirmed
318	103	310	2	2023-09-26	confirmed
319	103	376	4	2023-09-29	confirmed
320	103	417	5	2023-09-29	confirmed
321	66	241	1	2023-09-30	confirmed
322	66	382	3	2023-09-30	confirmed
323	103	1	4	2023-09-30	cancelled
324	66	6	2	2023-10-02	confirmed
325	66	168	1	2023-10-04	confirmed
326	66	155	3	2023-10-09	confirmed
327	66	57	4	2023-10-09	confirmed
328	66	395	4	2023-10-12	confirmed
329	66	417	2	2023-10-12	confirmed
330	66	195	6	2023-10-14	confirmed
331	66	366	2	2023-10-17	confirmed
332	66	89	3	2023-10-19	confirmed
333	66	25	6	2023-10-23	confirmed
334	66	401	5	2023-10-25	confirmed
335	66	52	3	2023-10-25	confirmed
336	23	14	1	2023-10-29	confirmed
337	23	255	2	2023-10-30	confirmed
338	23	160	5	2023-11-04	confirmed
339	23	455	3	2023-11-06	confirmed
340	23	160	3	2023-11-06	confirmed
341	23	229	6	2023-11-08	cancelled
342	23	490	4	2023-11-09	cancelled
343	23	186	2	2023-11-09	confirmed
344	23	292	1	2023-11-11	confirmed
345	111	48	2	2023-11-16	confirmed
346	111	183	6	2023-11-19	confirmed
347	111	453	1	2023-11-19	confirmed
348	106	40	4	2023-11-21	confirmed
349	106	169	3	2023-12-04	confirmed
350	106	6	6	2023-12-11	confirmed
351	106	85	6	2023-12-12	confirmed
352	106	58	6	2023-12-24	confirmed
353	106	12	1	2023-12-24	confirmed
354	106	74	2	2023-12-28	confirmed
355	114	309	1	2023-12-30	confirmed
356	114	263	2	2023-12-31	confirmed
357	114	411	2	2023-12-31	confirmed
358	114	119	2	2023-12-31	confirmed
359	114	104	2	2024-01-04	confirmed
360	114	430	2	2024-01-04	confirmed
361	114	227	5	2024-01-06	confirmed
362	114	73	6	2024-01-06	confirmed
363	114	279	2	2024-01-06	confirmed
364	57	117	2	2024-01-13	confirmed
365	57	156	3	2024-01-15	confirmed
366	57	73	2	2024-01-17	confirmed
367	57	95	2	2024-01-20	confirmed
368	57	304	5	2024-01-21	confirmed
369	57	102	3	2024-01-23	confirmed
370	57	38	6	2024-01-23	confirmed
371	57	182	2	2024-01-24	confirmed
372	57	431	3	2024-01-26	confirmed
373	78	294	5	2024-01-29	confirmed
374	78	323	5	2024-02-01	confirmed
375	78	335	3	2024-02-04	confirmed
376	78	205	3	2024-02-05	confirmed
377	78	81	3	2024-02-07	confirmed
378	78	460	3	2024-02-08	confirmed
379	78	141	5	2024-02-09	confirmed
380	78	406	3	2024-02-14	confirmed
381	55	199	2	2024-02-15	confirmed
382	78	35	3	2024-02-15	confirmed
383	55	148	3	2024-02-16	confirmed
384	55	99	4	2024-02-18	cancelled
385	55	413	2	2024-02-21	cancelled
386	55	117	2	2024-02-21	confirmed
387	55	376	4	2024-02-21	confirmed
388	55	499	6	2024-02-22	confirmed
389	58	21	4	2024-02-25	confirmed
390	58	447	4	2024-02-29	cancelled
391	58	155	2	2024-02-29	confirmed
392	89	20	1	2024-03-11	confirmed
393	89	83	2	2024-03-18	confirmed
394	89	345	2	2024-03-18	confirmed
395	89	223	2	2024-03-21	confirmed
396	89	120	4	2024-03-21	confirmed
397	89	458	2	2024-03-21	confirmed
398	89	319	1	2024-03-21	confirmed
399	89	295	6	2024-03-22	confirmed
400	89	308	5	2024-03-25	confirmed
401	89	441	6	2024-03-25	confirmed
402	89	197	5	2024-03-27	confirmed
403	89	403	6	2024-03-27	confirmed
404	89	97	4	2024-03-29	confirmed
405	89	490	3	2024-03-30	confirmed
406	89	463	4	2024-03-31	confirmed
407	143	388	3	2024-04-01	confirmed
408	143	280	2	2024-04-01	confirmed
409	143	425	2	2024-04-05	confirmed
410	143	294	4	2024-04-06	confirmed
411	143	478	6	2024-04-06	confirmed
412	143	142	2	2024-04-07	confirmed
413	143	415	5	2024-04-07	confirmed
414	143	50	5	2024-04-08	confirmed
415	68	336	3	2024-04-12	confirmed
416	68	261	3	2024-04-12	confirmed
417	68	163	5	2024-04-12	confirmed
418	68	429	2	2024-04-15	cancelled
419	68	152	2	2024-04-15	confirmed
420	68	193	3	2024-04-16	confirmed
421	68	245	6	2024-04-17	cancelled
422	68	436	1	2024-04-18	cancelled
423	68	308	1	2024-04-18	confirmed
424	68	478	3	2024-04-18	confirmed
425	68	430	2	2024-04-18	confirmed
426	99	477	2	2024-04-19	confirmed
427	99	468	2	2024-04-21	confirmed
428	99	314	2	2024-04-22	confirmed
429	99	438	4	2024-04-22	confirmed
430	99	241	2	2024-04-23	confirmed
431	27	238	4	2024-04-25	confirmed
432	27	351	3	2024-04-26	confirmed
433	27	469	4	2024-04-27	confirmed
434	27	138	5	2024-04-27	confirmed
435	27	499	6	2024-04-29	confirmed
436	27	189	3	2024-04-30	confirmed
437	27	145	2	2024-05-01	confirmed
438	27	395	6	2024-05-01	confirmed
439	27	490	2	2024-05-01	confirmed
440	27	486	3	2024-05-01	confirmed
441	91	442	2	2024-05-02	confirmed
442	91	154	2	2024-05-02	confirmed
443	91	108	2	2024-05-03	confirmed
444	91	61	6	2024-05-04	confirmed
445	91	99	3	2024-05-04	confirmed
446	91	45	1	2024-05-06	confirmed
447	91	180	1	2024-05-07	confirmed
448	91	464	2	2024-05-09	confirmed
449	91	137	2	2024-05-10	confirmed
450	133	14	4	2024-05-11	confirmed
451	133	457	2	2024-05-13	confirmed
452	133	339	4	2024-05-14	confirmed
453	133	320	1	2024-05-15	confirmed
454	133	283	3	2024-05-15	confirmed
455	133	73	3	2024-05-15	confirmed
456	133	302	2	2024-05-15	confirmed
457	133	295	3	2024-05-15	confirmed
458	133	385	4	2024-05-16	confirmed
459	133	122	2	2024-05-21	confirmed
460	133	48	3	2024-05-23	confirmed
461	133	392	4	2024-05-24	confirmed
462	109	258	1	2024-05-25	confirmed
463	109	134	2	2024-05-25	confirmed
464	109	41	2	2024-05-25	confirmed
465	109	480	2	2024-05-26	confirmed
466	109	222	2	2024-05-27	confirmed
467	109	85	6	2024-05-27	confirmed
468	109	377	2	2024-05-28	confirmed
469	109	172	3	2024-06-01	confirmed
470	109	367	6	2024-06-02	confirmed
471	109	108	2	2024-06-02	confirmed
472	128	463	5	2024-06-03	cancelled
473	128	115	5	2024-06-04	cancelled
474	128	209	4	2024-06-05	confirmed
475	128	137	3	2024-06-05	confirmed
476	128	353	1	2024-06-05	confirmed
477	128	30	2	2024-06-06	cancelled
478	128	135	6	2024-06-07	confirmed
479	54	130	6	2024-06-09	confirmed
480	128	230	5	2024-06-09	confirmed
481	54	35	5	2024-06-10	confirmed
482	54	13	2	2024-06-11	confirmed
483	54	165	2	2024-06-12	confirmed
484	54	371	2	2024-06-12	confirmed
485	120	188	2	2024-06-12	confirmed
486	120	225	2	2024-06-13	confirmed
487	120	372	2	2024-06-14	cancelled
488	120	327	4	2024-06-15	confirmed
489	33	195	2	2024-06-17	confirmed
490	33	448	1	2024-06-18	confirmed
491	33	163	3	2024-06-20	confirmed
492	33	248	3	2024-06-20	confirmed
493	33	287	3	2024-06-20	confirmed
494	33	12	6	2024-06-21	confirmed
495	33	151	2	2024-06-21	cancelled
496	33	322	3	2024-06-22	confirmed
497	33	361	6	2024-06-23	confirmed
498	33	363	3	2024-06-25	confirmed
499	33	350	5	2024-06-25	confirmed
500	33	233	3	2024-06-26	confirmed
501	33	107	3	2024-06-26	confirmed
502	33	356	3	2024-06-26	confirmed
503	145	185	6	2024-06-27	cancelled
504	145	493	4	2024-06-27	cancelled
505	145	445	6	2024-06-27	confirmed
506	145	56	3	2024-06-28	confirmed
507	145	139	2	2024-06-28	confirmed
508	145	435	2	2024-06-28	confirmed
509	145	161	3	2024-06-28	confirmed
510	49	32	2	2024-06-29	confirmed
511	145	457	1	2024-06-29	confirmed
512	145	396	4	2024-06-29	confirmed
513	145	226	2	2024-06-29	confirmed
514	49	96	1	2024-06-30	confirmed
515	49	165	3	2024-06-30	confirmed
516	49	97	1	2024-06-30	confirmed
517	49	103	2	2024-07-01	confirmed
518	49	295	5	2024-07-01	confirmed
519	43	265	1	2024-07-02	confirmed
520	43	226	2	2024-07-02	confirmed
521	43	117	3	2024-07-02	cancelled
522	43	205	2	2024-07-02	confirmed
523	43	124	2	2024-07-04	confirmed
524	43	415	6	2024-07-04	confirmed
525	43	246	5	2024-07-04	confirmed
526	43	237	1	2024-07-05	confirmed
527	43	199	5	2024-07-06	confirmed
528	43	383	3	2024-07-06	confirmed
529	43	109	3	2024-07-06	confirmed
530	43	95	2	2024-07-06	confirmed
531	65	234	4	2024-07-07	confirmed
532	65	366	6	2024-07-08	confirmed
533	65	59	6	2024-07-08	confirmed
534	65	450	6	2024-07-08	confirmed
535	65	287	3	2024-07-08	confirmed
536	65	367	2	2024-07-09	confirmed
537	65	273	3	2024-07-10	confirmed
538	65	59	3	2024-07-10	confirmed
539	65	460	4	2024-07-11	cancelled
540	65	2	3	2024-07-11	confirmed
541	65	208	6	2024-07-11	confirmed
542	65	235	2	2024-07-11	confirmed
543	65	113	1	2024-07-11	cancelled
544	82	346	3	2024-07-11	confirmed
545	82	102	6	2024-07-12	confirmed
546	82	133	2	2024-07-12	confirmed
547	82	149	6	2024-07-14	confirmed
548	82	159	2	2024-07-14	confirmed
549	82	404	6	2024-07-14	confirmed
550	48	386	3	2024-07-15	confirmed
551	48	85	5	2024-07-15	confirmed
552	82	17	2	2024-07-15	confirmed
553	48	424	2	2024-07-18	confirmed
554	48	426	2	2024-07-18	confirmed
555	48	461	2	2024-07-18	confirmed
556	86	34	2	2024-07-18	confirmed
557	86	360	2	2024-07-19	cancelled
558	86	154	3	2024-07-19	confirmed
559	86	498	5	2024-07-19	confirmed
560	86	117	1	2024-07-19	confirmed
561	86	308	6	2024-07-20	confirmed
562	86	403	6	2024-07-20	confirmed
563	86	382	2	2024-07-21	confirmed
564	86	115	3	2024-07-21	confirmed
565	86	189	5	2024-07-21	confirmed
566	86	320	6	2024-07-22	confirmed
567	86	255	2	2024-07-22	confirmed
568	147	218	6	2024-07-22	confirmed
569	147	485	6	2024-07-23	confirmed
570	147	462	3	2024-07-24	confirmed
571	147	63	3	2024-07-24	confirmed
572	147	431	4	2024-07-25	confirmed
573	147	447	4	2024-07-25	confirmed
574	147	308	2	2024-07-25	confirmed
575	147	49	3	2024-07-26	confirmed
576	147	366	4	2024-07-26	confirmed
577	53	89	2	2024-07-27	confirmed
578	147	223	2	2024-07-27	confirmed
579	59	370	2	2024-07-28	cancelled
580	59	301	2	2024-07-28	confirmed
581	59	51	6	2024-07-29	confirmed
582	59	393	5	2024-07-30	cancelled
583	59	112	2	2024-07-30	confirmed
584	59	191	2	2024-07-31	confirmed
585	59	81	2	2024-07-31	confirmed
586	59	376	3	2024-08-01	confirmed
587	59	106	1	2024-08-02	confirmed
588	59	135	3	2024-08-02	confirmed
589	59	470	3	2024-08-03	cancelled
590	115	125	5	2024-08-05	confirmed
591	115	59	2	2024-08-06	confirmed
592	115	400	5	2024-08-06	confirmed
593	72	161	2	2024-08-07	confirmed
594	72	160	6	2024-08-07	confirmed
595	115	347	6	2024-08-07	confirmed
596	115	209	3	2024-08-07	confirmed
597	131	237	1	2024-08-08	confirmed
598	131	461	2	2024-08-08	confirmed
599	131	250	1	2024-08-08	confirmed
600	131	448	5	2024-08-08	confirmed
601	131	202	2	2024-08-09	confirmed
602	131	369	1	2024-08-09	confirmed
603	131	25	3	2024-08-10	cancelled
604	12	405	2	2024-08-11	confirmed
605	12	84	6	2024-08-11	confirmed
606	131	154	2	2024-08-11	confirmed
607	131	326	2	2024-08-11	confirmed
608	12	154	2	2024-08-12	confirmed
609	12	474	4	2024-08-12	confirmed
610	12	331	2	2024-08-13	confirmed
611	12	143	6	2024-08-13	confirmed
612	12	474	5	2024-08-14	confirmed
613	12	313	5	2024-08-15	confirmed
614	12	88	2	2024-08-15	confirmed
615	12	122	3	2024-08-16	confirmed
616	12	315	4	2024-08-16	cancelled
617	138	405	5	2024-08-16	confirmed
618	138	410	2	2024-08-17	confirmed
619	138	419	3	2024-08-17	confirmed
620	138	243	3	2024-08-17	confirmed
621	138	114	1	2024-08-17	confirmed
622	138	266	6	2024-08-17	confirmed
623	138	214	3	2024-08-17	confirmed
624	138	494	2	2024-08-18	confirmed
625	138	210	6	2024-08-18	confirmed
626	117	33	2	2024-08-20	confirmed
627	138	295	5	2024-08-20	confirmed
628	117	167	3	2024-08-21	confirmed
629	117	411	6	2024-08-21	cancelled
630	117	118	6	2024-08-21	confirmed
631	117	258	3	2024-08-21	confirmed
632	117	468	3	2024-08-23	confirmed
633	117	132	4	2024-08-23	confirmed
634	117	415	6	2024-08-23	confirmed
635	117	90	3	2024-08-24	confirmed
636	117	90	2	2024-08-24	confirmed
637	117	329	2	2024-08-24	confirmed
638	117	201	2	2024-08-25	confirmed
639	40	357	2	2024-08-26	confirmed
640	40	97	4	2024-08-26	confirmed
641	40	285	6	2024-08-26	confirmed
642	117	381	2	2024-08-26	confirmed
643	117	138	3	2024-08-26	confirmed
644	117	189	3	2024-08-26	confirmed
645	40	457	2	2024-08-27	cancelled
646	127	173	6	2024-08-27	confirmed
647	127	115	2	2024-08-28	confirmed
648	127	106	3	2024-08-29	cancelled
649	127	486	4	2024-08-29	confirmed
650	127	226	4	2024-08-29	confirmed
651	127	117	2	2024-08-30	confirmed
652	127	51	2	2024-08-31	cancelled
653	127	298	5	2024-08-31	confirmed
654	127	497	5	2024-09-01	confirmed
655	127	64	1	2024-09-01	confirmed
656	127	205	6	2024-09-01	confirmed
657	127	83	3	2024-09-01	confirmed
658	127	473	3	2024-09-02	confirmed
659	127	257	3	2024-09-02	cancelled
660	127	20	3	2024-09-04	confirmed
661	127	480	3	2024-09-04	confirmed
662	127	389	5	2024-09-05	confirmed
663	105	128	2	2024-09-06	confirmed
664	105	342	2	2024-09-06	confirmed
665	105	229	3	2024-09-06	confirmed
666	105	30	2	2024-09-07	confirmed
667	105	16	2	2024-09-08	cancelled
668	105	381	1	2024-09-08	confirmed
669	105	71	4	2024-09-09	confirmed
670	105	323	2	2024-09-10	confirmed
671	105	452	4	2024-09-10	cancelled
672	105	20	6	2024-09-11	cancelled
673	105	172	4	2024-09-11	confirmed
674	105	437	2	2024-09-11	confirmed
675	105	429	5	2024-09-11	confirmed
676	105	197	3	2024-09-11	cancelled
677	105	491	3	2024-09-11	confirmed
678	148	54	6	2024-09-11	confirmed
679	148	255	4	2024-09-12	confirmed
680	148	241	2	2024-09-13	confirmed
681	148	142	4	2024-09-13	confirmed
682	148	240	2	2024-09-13	confirmed
683	148	309	3	2024-09-15	confirmed
684	137	476	3	2024-09-16	confirmed
685	148	283	4	2024-09-16	confirmed
686	148	274	3	2024-09-16	confirmed
687	137	364	1	2024-09-17	confirmed
688	137	85	1	2024-09-17	confirmed
689	137	382	4	2024-09-17	confirmed
690	104	265	2	2024-09-18	confirmed
691	104	90	2	2024-09-19	confirmed
692	104	408	1	2024-09-19	confirmed
693	104	431	2	2024-09-19	confirmed
694	104	383	6	2024-09-19	confirmed
695	104	195	3	2024-09-20	cancelled
696	104	278	2	2024-09-20	confirmed
697	104	74	5	2024-09-20	confirmed
698	104	79	2	2024-09-21	confirmed
699	104	468	1	2024-09-21	cancelled
700	104	393	3	2024-09-21	cancelled
701	104	325	2	2024-09-21	confirmed
702	34	350	2	2024-09-22	confirmed
703	34	129	5	2024-09-22	confirmed
704	34	125	3	2024-09-23	confirmed
705	34	393	2	2024-09-23	confirmed
706	34	145	3	2024-09-23	cancelled
707	34	277	5	2024-09-23	confirmed
708	34	206	2	2024-09-24	cancelled
709	34	38	2	2024-09-24	confirmed
710	34	127	4	2024-09-25	cancelled
711	34	448	5	2024-09-25	confirmed
712	34	175	2	2024-09-25	cancelled
713	34	404	2	2024-09-26	confirmed
714	34	359	5	2024-09-27	confirmed
715	34	145	2	2024-09-27	confirmed
716	51	228	2	2024-09-27	confirmed
717	51	319	5	2024-09-28	confirmed
718	51	228	5	2024-09-28	cancelled
719	51	133	4	2024-09-29	confirmed
720	51	394	2	2024-09-29	confirmed
721	51	247	2	2024-09-30	confirmed
722	51	286	4	2024-10-10	confirmed
723	51	264	2	2024-10-11	confirmed
724	51	240	3	2024-10-13	confirmed
725	51	131	2	2024-10-14	confirmed
726	16	275	1	2024-10-15	confirmed
727	16	11	2	2024-10-15	confirmed
728	16	350	2	2024-10-15	confirmed
729	51	104	2	2024-10-15	confirmed
730	16	188	5	2024-10-18	confirmed
731	16	266	2	2024-10-24	cancelled
732	52	229	2	2024-10-25	confirmed
733	52	123	4	2024-10-26	confirmed
734	52	253	3	2024-10-29	confirmed
735	52	106	5	2024-10-29	confirmed
736	52	401	1	2024-10-30	confirmed
737	52	153	2	2024-10-30	confirmed
738	52	375	6	2024-11-02	cancelled
739	52	107	2	2024-11-02	confirmed
740	52	420	2	2024-11-03	confirmed
741	52	167	2	2024-11-22	confirmed
742	52	250	2	2024-11-26	cancelled
743	52	378	3	2024-11-28	cancelled
744	52	143	4	2024-12-02	confirmed
745	52	240	2	2024-12-04	confirmed
746	130	462	5	2024-12-04	confirmed
747	130	34	4	2024-12-05	confirmed
748	130	273	3	2024-12-05	confirmed
749	130	119	6	2024-12-07	confirmed
750	130	445	1	2024-12-09	confirmed
751	130	294	3	2024-12-10	confirmed
752	130	180	2	2024-12-10	confirmed
753	130	444	4	2024-12-10	cancelled
754	130	386	1	2024-12-12	confirmed
755	130	223	3	2024-12-13	confirmed
756	130	456	1	2024-12-15	confirmed
757	112	356	5	2024-12-20	confirmed
758	112	227	2	2024-12-23	confirmed
759	112	95	6	2024-12-25	confirmed
760	112	50	4	2024-12-26	confirmed
761	112	89	2	2024-12-29	confirmed
762	112	302	2	2024-12-30	confirmed
763	124	264	3	2024-12-31	confirmed
764	124	146	5	2025-01-02	confirmed
765	124	118	1	2025-01-02	confirmed
766	124	176	4	2025-01-06	confirmed
767	124	461	3	2025-01-06	cancelled
768	124	188	3	2025-01-07	confirmed
769	124	93	3	2025-01-08	confirmed
770	124	229	2	2025-01-12	confirmed
771	124	397	3	2025-01-12	confirmed
772	124	406	4	2025-01-13	confirmed
773	124	468	5	2025-01-15	confirmed
774	124	51	3	2025-01-15	confirmed
775	124	359	2	2025-01-16	cancelled
776	124	275	6	2025-01-16	confirmed
777	102	30	5	2025-01-18	confirmed
778	102	244	4	2025-01-18	confirmed
779	102	141	3	2025-01-22	cancelled
780	102	77	3	2025-01-22	confirmed
781	102	441	6	2025-01-25	confirmed
782	102	392	3	2025-01-26	confirmed
783	102	174	2	2025-01-28	confirmed
784	88	252	3	2025-01-31	cancelled
785	102	280	5	2025-01-31	confirmed
786	88	52	2	2025-02-02	confirmed
787	88	287	2	2025-02-08	confirmed
788	88	385	2	2025-02-11	confirmed
789	88	237	4	2025-02-13	confirmed
790	25	280	3	2025-02-15	confirmed
791	25	105	5	2025-02-15	confirmed
792	25	485	2	2025-02-15	confirmed
793	88	373	6	2025-02-15	confirmed
794	76	250	1	2025-02-16	confirmed
795	76	211	3	2025-02-17	confirmed
796	76	107	3	2025-02-17	confirmed
797	76	326	2	2025-02-17	cancelled
798	76	212	3	2025-02-20	confirmed
799	76	30	4	2025-02-21	confirmed
800	76	70	1	2025-02-24	confirmed
801	76	263	2	2025-02-28	confirmed
802	76	216	6	2025-02-28	confirmed
803	76	236	2	2025-03-02	confirmed
804	76	94	6	2025-03-04	confirmed
805	94	119	1	2025-03-07	cancelled
806	94	25	3	2025-03-09	confirmed
807	94	245	1	2025-03-11	cancelled
808	94	337	5	2025-03-12	confirmed
809	94	325	3	2025-03-14	confirmed
810	94	238	6	2025-03-14	confirmed
811	94	423	1	2025-03-18	confirmed
812	94	226	2	2025-03-19	confirmed
813	94	400	3	2025-03-19	confirmed
814	94	253	3	2025-03-21	confirmed
815	94	322	2	2025-03-21	confirmed
816	35	266	4	2025-03-29	confirmed
817	35	191	2	2025-03-29	confirmed
818	35	370	5	2025-03-31	cancelled
819	29	230	2	2025-04-01	confirmed
820	29	290	3	2025-04-02	cancelled
821	29	27	1	2025-04-03	confirmed
822	29	466	3	2025-04-03	confirmed
823	29	358	5	2025-04-03	confirmed
824	29	96	4	2025-04-04	confirmed
825	29	362	3	2025-04-05	confirmed
826	29	111	1	2025-04-05	confirmed
827	29	480	5	2025-04-05	confirmed
828	29	128	1	2025-04-05	confirmed
829	29	294	5	2025-04-06	confirmed
830	29	433	5	2025-04-06	confirmed
831	29	311	2	2025-04-09	confirmed
832	7	320	3	2025-04-10	confirmed
833	7	165	1	2025-04-10	confirmed
834	7	77	3	2025-04-10	confirmed
835	29	372	3	2025-04-10	confirmed
836	7	109	3	2025-04-13	confirmed
837	7	110	5	2025-04-13	confirmed
838	7	157	4	2025-04-15	confirmed
839	7	187	4	2025-04-15	confirmed
840	7	470	3	2025-04-17	confirmed
841	7	423	4	2025-04-18	confirmed
842	7	420	3	2025-04-19	confirmed
843	61	173	2	2025-04-19	confirmed
844	61	493	4	2025-04-19	confirmed
845	61	152	2	2025-04-19	confirmed
846	61	423	2	2025-04-20	confirmed
847	61	454	1	2025-04-20	confirmed
848	61	133	1	2025-04-21	confirmed
849	61	279	2	2025-04-22	confirmed
850	61	157	1	2025-04-24	confirmed
851	61	183	4	2025-04-24	confirmed
852	61	437	2	2025-04-25	confirmed
853	61	45	3	2025-04-26	confirmed
854	61	180	2	2025-04-28	confirmed
855	61	127	3	2025-04-28	confirmed
856	61	459	2	2025-04-30	confirmed
857	61	264	1	2025-04-30	confirmed
858	61	215	6	2025-05-01	confirmed
859	74	45	1	2025-05-02	confirmed
860	74	31	2	2025-05-02	cancelled
861	74	151	2	2025-05-03	confirmed
862	74	278	4	2025-05-03	confirmed
863	74	85	2	2025-05-04	confirmed
864	74	198	2	2025-05-04	confirmed
865	74	190	6	2025-05-05	confirmed
866	74	472	5	2025-05-05	confirmed
867	74	78	3	2025-05-05	confirmed
868	74	51	4	2025-05-07	cancelled
869	141	480	2	2025-05-08	confirmed
870	141	384	3	2025-05-09	cancelled
871	141	191	3	2025-05-10	confirmed
872	141	234	2	2025-05-11	confirmed
873	141	364	3	2025-05-13	confirmed
874	141	356	1	2025-05-13	confirmed
875	141	186	6	2025-05-13	confirmed
876	141	411	2	2025-05-13	confirmed
877	141	221	2	2025-05-14	confirmed
878	141	470	6	2025-05-14	confirmed
879	69	69	6	2025-05-16	confirmed
880	141	227	2	2025-05-16	confirmed
881	141	371	1	2025-05-16	confirmed
882	69	395	4	2025-05-17	confirmed
883	69	389	6	2025-05-17	confirmed
884	69	429	3	2025-05-17	cancelled
885	69	156	2	2025-05-17	confirmed
886	69	65	3	2025-05-19	confirmed
887	69	334	6	2025-05-20	confirmed
888	69	77	6	2025-05-20	confirmed
889	22	422	5	2025-05-21	confirmed
890	69	24	1	2025-05-21	confirmed
891	22	205	2	2025-05-25	cancelled
892	22	336	3	2025-05-27	confirmed
893	22	430	5	2025-05-27	confirmed
894	22	178	6	2025-05-28	confirmed
895	22	64	4	2025-05-28	cancelled
896	22	65	6	2025-05-29	confirmed
897	22	114	2	2025-05-30	confirmed
898	22	29	4	2025-05-30	confirmed
899	22	404	3	2025-05-31	confirmed
900	21	238	2	2025-06-01	confirmed
901	22	486	1	2025-06-01	cancelled
902	21	441	3	2025-06-02	confirmed
903	21	190	2	2025-06-02	confirmed
904	21	469	1	2025-06-04	confirmed
905	134	453	2	2025-06-04	confirmed
906	134	73	3	2025-06-05	confirmed
907	134	376	2	2025-06-06	confirmed
908	134	192	6	2025-06-07	confirmed
909	134	170	6	2025-06-07	confirmed
910	134	136	2	2025-06-08	confirmed
911	134	485	6	2025-06-10	confirmed
912	134	13	1	2025-06-11	confirmed
913	134	298	1	2025-06-12	confirmed
914	134	335	6	2025-06-13	confirmed
915	134	357	3	2025-06-13	cancelled
916	134	74	3	2025-06-13	confirmed
917	134	497	5	2025-06-14	confirmed
918	134	420	6	2025-06-14	confirmed
919	134	294	4	2025-06-14	confirmed
920	13	439	1	2025-06-15	confirmed
921	134	210	5	2025-06-15	confirmed
922	13	350	4	2025-06-16	confirmed
923	13	414	2	2025-06-17	confirmed
924	13	187	1	2025-06-18	confirmed
925	13	122	1	2025-06-19	confirmed
926	13	39	5	2025-06-19	confirmed
927	13	225	2	2025-06-20	confirmed
928	13	244	4	2025-06-21	confirmed
929	149	166	5	2025-06-21	confirmed
930	149	348	2	2025-06-22	confirmed
931	149	54	6	2025-06-25	confirmed
932	149	43	3	2025-06-25	confirmed
933	149	71	5	2025-06-26	confirmed
934	149	148	2	2025-06-26	confirmed
935	149	306	3	2025-06-27	confirmed
936	149	440	5	2025-06-27	confirmed
937	100	404	4	2025-06-28	confirmed
938	149	170	2	2025-06-28	confirmed
939	149	93	3	2025-06-28	confirmed
940	100	297	1	2025-06-29	confirmed
941	100	270	2	2025-07-01	cancelled
942	100	439	2	2025-07-01	confirmed
943	20	184	3	2025-07-02	confirmed
944	100	3	2	2025-07-02	confirmed
945	100	342	6	2025-07-02	cancelled
946	100	363	3	2025-07-02	cancelled
947	20	493	2	2025-07-03	cancelled
948	20	428	4	2025-07-03	confirmed
949	20	471	3	2025-07-03	confirmed
950	20	81	2	2025-07-04	confirmed
951	20	443	3	2025-07-04	confirmed
952	20	179	3	2025-07-04	confirmed
953	20	418	2	2025-07-04	confirmed
954	20	246	2	2025-07-04	confirmed
955	20	48	3	2025-07-04	cancelled
956	20	265	6	2025-07-05	confirmed
957	20	167	2	2025-07-06	confirmed
958	20	397	2	2025-07-07	confirmed
959	20	116	2	2025-07-07	confirmed
960	20	441	3	2025-07-08	confirmed
961	96	257	4	2025-07-08	confirmed
962	96	393	3	2025-07-08	confirmed
963	96	231	4	2025-07-08	confirmed
964	96	378	1	2025-07-08	confirmed
965	96	198	4	2025-07-08	confirmed
966	96	278	2	2025-07-09	confirmed
967	96	45	1	2025-07-09	confirmed
968	96	423	1	2025-07-09	confirmed
969	96	177	4	2025-07-10	confirmed
970	96	89	5	2025-07-10	confirmed
971	96	439	6	2025-07-11	confirmed
972	96	155	6	2025-07-11	confirmed
973	62	65	6	2025-07-12	confirmed
974	62	328	2	2025-07-12	confirmed
975	62	4	2	2025-07-12	confirmed
976	96	248	4	2025-07-12	confirmed
977	80	70	2	2025-07-13	confirmed
978	80	76	3	2025-07-13	confirmed
979	80	333	5	2025-07-14	confirmed
980	80	106	5	2025-07-16	confirmed
981	80	233	2	2025-07-17	confirmed
982	80	278	3	2025-07-17	confirmed
983	36	9	6	2025-07-18	cancelled
984	80	443	2	2025-07-18	confirmed
985	80	178	2	2025-07-18	confirmed
986	36	102	4	2025-07-19	confirmed
987	36	120	2	2025-07-19	confirmed
988	83	408	4	2025-07-20	confirmed
989	83	77	2	2025-07-20	confirmed
990	83	87	5	2025-07-20	confirmed
991	83	40	2	2025-07-20	confirmed
992	83	45	3	2025-07-20	confirmed
993	71	346	6	2025-07-21	cancelled
994	83	491	2	2025-07-21	confirmed
995	71	302	3	2025-07-22	confirmed
996	71	203	3	2025-07-22	confirmed
997	71	411	6	2025-07-23	confirmed
998	71	292	2	2025-07-23	confirmed
999	71	241	2	2025-07-23	confirmed
1000	71	212	5	2025-07-23	confirmed
1001	71	136	4	2025-07-24	confirmed
1002	24	257	5	2025-07-25	confirmed
1003	24	158	2	2025-07-25	confirmed
1004	24	37	5	2025-07-26	confirmed
1005	24	245	5	2025-07-26	confirmed
1006	24	235	4	2025-07-27	confirmed
1007	24	181	3	2025-07-27	confirmed
1008	24	408	4	2025-07-27	confirmed
1009	11	464	2	2025-07-28	confirmed
1010	11	67	4	2025-07-28	confirmed
1011	24	19	2	2025-07-28	confirmed
1012	24	330	3	2025-07-28	confirmed
1013	11	189	4	2025-07-30	confirmed
1014	11	114	6	2025-07-30	confirmed
1015	11	281	2	2025-07-30	confirmed
1016	11	39	5	2025-07-31	confirmed
1017	11	456	2	2025-07-31	confirmed
1018	11	242	5	2025-07-31	confirmed
1019	8	78	3	2025-08-01	confirmed
1020	11	358	1	2025-08-01	confirmed
1021	11	137	2	2025-08-01	confirmed
1022	8	370	2	2025-08-02	confirmed
1023	8	305	2	2025-08-02	confirmed
1024	8	330	2	2025-08-02	confirmed
1025	8	73	2	2025-08-02	confirmed
1026	8	477	3	2025-08-03	confirmed
1027	8	199	5	2025-08-03	cancelled
1028	8	132	3	2025-08-04	confirmed
1029	8	496	2	2025-08-04	confirmed
1030	8	234	2	2025-08-05	confirmed
1031	8	144	2	2025-08-05	confirmed
1032	8	385	5	2025-08-05	cancelled
1033	8	474	2	2025-08-06	confirmed
1034	8	25	2	2025-08-08	confirmed
1035	95	495	2	2025-08-08	confirmed
1036	95	65	1	2025-08-08	confirmed
1037	95	48	5	2025-08-09	confirmed
1038	95	173	2	2025-08-09	confirmed
1039	95	285	3	2025-08-10	confirmed
1040	95	406	3	2025-08-10	confirmed
1041	95	111	5	2025-08-10	confirmed
1042	87	440	2	2025-08-11	confirmed
1043	95	135	2	2025-08-11	confirmed
1044	95	173	2	2025-08-11	cancelled
1045	95	312	2	2025-08-11	confirmed
1046	95	395	2	2025-08-11	confirmed
1047	87	335	2	2025-08-12	confirmed
1048	87	375	2	2025-08-12	confirmed
1049	87	17	3	2025-08-12	confirmed
1050	87	189	5	2025-08-12	confirmed
1051	87	327	4	2025-08-13	confirmed
1052	87	165	1	2025-08-13	confirmed
1053	87	260	2	2025-08-13	cancelled
1054	87	307	3	2025-08-13	confirmed
1055	136	132	2	2025-08-14	confirmed
1056	136	198	6	2025-08-14	confirmed
1057	136	70	3	2025-08-14	confirmed
1058	136	301	2	2025-08-14	confirmed
1059	136	227	3	2025-08-14	confirmed
1060	136	118	2	2025-08-14	confirmed
1061	136	265	2	2025-08-15	confirmed
1062	136	294	3	2025-08-15	confirmed
1063	136	216	6	2025-08-15	confirmed
1064	37	17	6	2025-08-16	confirmed
1065	136	165	5	2025-08-16	confirmed
1066	136	261	2	2025-08-16	confirmed
1067	136	45	2	2025-08-16	confirmed
1068	37	306	3	2025-08-17	confirmed
1069	37	267	1	2025-08-18	confirmed
1070	37	348	1	2025-08-18	confirmed
1071	37	474	2	2025-08-19	confirmed
1072	37	211	5	2025-08-20	confirmed
1073	15	361	2	2025-08-21	confirmed
1074	15	286	2	2025-08-21	cancelled
1075	37	54	5	2025-08-21	confirmed
1076	81	461	3	2025-08-21	confirmed
1077	81	394	2	2025-08-21	confirmed
1078	81	185	6	2025-08-21	confirmed
1079	81	89	3	2025-08-21	confirmed
1080	15	340	6	2025-08-22	confirmed
1081	92	471	5	2025-08-23	confirmed
1082	92	81	6	2025-08-23	confirmed
1083	92	35	3	2025-08-24	confirmed
1084	92	396	1	2025-08-24	confirmed
1085	92	77	2	2025-08-26	cancelled
1086	92	361	3	2025-08-27	cancelled
1087	92	341	4	2025-08-27	confirmed
1088	92	66	2	2025-08-28	confirmed
1089	92	262	2	2025-08-28	confirmed
1090	140	283	2	2025-08-28	confirmed
1091	140	261	4	2025-08-29	cancelled
1092	140	82	2	2025-08-29	confirmed
1093	140	59	3	2025-08-30	confirmed
1094	140	278	3	2025-08-31	confirmed
1095	140	186	1	2025-08-31	confirmed
1096	140	262	5	2025-09-01	confirmed
1097	140	352	1	2025-09-01	confirmed
1098	140	431	5	2025-09-02	confirmed
1099	140	320	3	2025-09-02	cancelled
1100	93	264	3	2025-09-03	confirmed
1101	93	39	2	2025-09-03	confirmed
1102	93	142	2	2025-09-03	confirmed
1103	93	355	2	2025-09-05	confirmed
1104	93	190	4	2025-09-06	confirmed
1105	93	399	2	2025-09-06	cancelled
1106	93	336	6	2025-09-06	confirmed
1107	93	369	2	2025-09-07	confirmed
1108	93	326	1	2025-09-07	confirmed
1109	113	379	3	2025-09-08	confirmed
1110	113	405	3	2025-09-08	confirmed
1111	113	423	2	2025-09-09	confirmed
1112	113	440	2	2025-09-09	confirmed
1113	113	31	5	2025-09-09	confirmed
1114	113	40	5	2025-09-10	confirmed
1115	113	36	4	2025-09-10	confirmed
1116	113	491	6	2025-09-10	confirmed
1117	113	272	2	2025-09-10	confirmed
1118	30	209	4	2025-09-11	cancelled
1119	113	361	2	2025-09-11	confirmed
1120	113	56	3	2025-09-11	confirmed
1121	30	411	4	2025-09-12	confirmed
1122	30	68	6	2025-09-12	confirmed
1123	30	347	3	2025-09-12	cancelled
1124	30	481	3	2025-09-13	confirmed
1125	30	274	2	2025-09-13	confirmed
1126	30	363	5	2025-09-13	confirmed
1127	30	286	2	2025-09-14	confirmed
1128	30	58	4	2025-09-14	cancelled
1129	30	95	5	2025-09-15	confirmed
1130	30	120	2	2025-09-15	confirmed
1131	30	350	5	2025-09-16	confirmed
1132	30	220	2	2025-09-16	confirmed
1133	30	478	3	2025-09-16	confirmed
1134	30	397	2	2025-09-17	cancelled
1135	30	192	2	2025-09-17	confirmed
1136	30	11	6	2025-09-17	confirmed
1137	108	261	2	2025-09-18	confirmed
1138	108	430	5	2025-09-18	confirmed
1139	108	192	2	2025-09-19	confirmed
1140	108	218	3	2025-09-19	confirmed
1141	108	144	3	2025-09-19	confirmed
1142	108	39	3	2025-09-19	cancelled
1143	108	80	2	2025-09-20	confirmed
1144	108	479	2	2025-09-20	confirmed
1145	108	100	2	2025-09-20	confirmed
1146	50	17	2	2025-09-21	confirmed
1147	50	243	3	2025-09-21	confirmed
1148	50	355	6	2025-09-21	cancelled
1149	108	198	6	2025-09-21	confirmed
1150	50	396	3	2025-09-22	confirmed
1151	50	277	6	2025-09-22	confirmed
1152	50	259	2	2025-09-22	confirmed
1153	50	114	1	2025-09-22	confirmed
1154	31	210	6	2025-09-23	confirmed
1155	31	244	2	2025-09-23	confirmed
1156	50	39	2	2025-09-23	confirmed
1157	50	89	1	2025-09-23	confirmed
1158	31	487	2	2025-09-24	confirmed
1159	31	458	1	2025-09-24	confirmed
1160	31	497	5	2025-09-25	confirmed
1161	31	8	3	2025-09-25	confirmed
1162	31	222	4	2025-09-26	confirmed
1163	31	310	1	2025-09-27	confirmed
1164	31	303	2	2025-09-29	cancelled
1165	31	192	2	2025-09-29	cancelled
1166	135	14	4	2025-09-29	confirmed
1167	135	96	6	2025-09-29	confirmed
1168	135	227	2	2025-09-29	confirmed
1169	135	313	3	2025-09-30	confirmed
1170	135	414	3	2025-09-30	confirmed
1171	135	96	2	2025-10-01	confirmed
1172	135	124	6	2025-10-03	confirmed
1173	135	255	3	2025-10-04	confirmed
1174	150	450	4	2025-10-04	confirmed
1175	150	340	5	2025-10-06	confirmed
1176	150	148	2	2025-10-07	confirmed
1177	150	48	2	2025-10-12	confirmed
1178	150	47	2	2025-10-15	confirmed
1179	150	166	3	2025-10-18	confirmed
1180	150	228	2	2025-10-18	confirmed
1181	84	6	2	2025-10-21	confirmed
1182	150	457	3	2025-10-21	confirmed
1183	84	361	4	2025-10-24	confirmed
1184	84	145	6	2025-10-27	confirmed
1185	84	317	6	2025-10-27	confirmed
1186	84	363	5	2025-10-28	cancelled
1187	84	430	2	2025-10-28	confirmed
1188	84	370	3	2025-10-29	confirmed
1189	84	18	2	2025-10-30	confirmed
1190	84	4	2	2025-10-31	confirmed
1191	84	259	3	2025-11-01	confirmed
1192	84	58	3	2025-11-02	confirmed
1193	84	34	2	2025-11-03	confirmed
1194	84	64	2	2025-11-04	confirmed
1195	84	167	3	2025-11-05	confirmed
1196	84	434	3	2025-11-06	cancelled
1197	41	324	3	2025-11-08	confirmed
1198	41	154	3	2025-11-08	confirmed
1199	84	43	6	2025-11-08	confirmed
1200	41	286	5	2025-11-10	confirmed
1201	41	359	3	2025-11-11	confirmed
1202	9	239	2	2025-11-12	confirmed
1203	9	386	3	2025-11-15	confirmed
1204	9	241	6	2025-11-16	confirmed
1205	9	255	2	2025-11-24	confirmed
1206	9	441	3	2025-11-25	confirmed
1207	9	131	2	2025-11-25	confirmed
1208	9	239	6	2025-11-26	confirmed
1209	9	344	2	2025-11-27	confirmed
1210	9	111	6	2025-12-01	confirmed
1211	9	358	2	2025-12-02	confirmed
1212	9	93	6	2025-12-03	confirmed
1213	9	106	3	2025-12-12	confirmed
1214	9	131	1	2025-12-14	cancelled
1215	9	17	5	2025-12-16	confirmed
1216	9	477	2	2025-12-18	confirmed
1217	45	487	6	2025-12-22	confirmed
1218	45	372	2	2025-12-27	cancelled
1219	45	40	3	2025-12-27	confirmed
1220	45	462	3	2025-12-30	confirmed
1221	6	12	2	2026-11-02	pending
1222	3	25	4	2026-11-04	pending
1223	1	33	2	2026-11-05	pending
1224	6	40	3	2026-11-07	pending
1225	5	18	2	2026-11-08	pending
1226	2	51	1	2026-11-10	pending
1227	6	7	2	2026-11-11	pending
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customers (customer_id, full_name, country, email) FROM stdin;
1	Бат	Монгол	bat@example.com
2	Сараа	Монгол	saraa@example.com
3	John Smith	АНУ	john@example.com
4	Kim Minji	Солонгос	minji@example.com
5	Wang Li	Хятад	wangli@example.com
6	Emma Müller	Герман	emma@example.com
7	Сараа Ц.	Монгол	user7@example.mn
8	Ivan Brown	Орос	user8@example.com
9	Цэцэг С.	Монгол	user9@example.mn
10	Olga Jisoo	Орос	user10@example.com
11	Lukas Minho	Герман	user11@example.com
12	Дорж Ц.	Монгол	user12@example.mn
13	Emily Min	Их Британи	user13@example.com
14	Lee Sato	Солонгос	user14@example.com
15	Төгөлдөр Н.	Монгол	user15@example.mn
16	Энхжин Ц.	Монгол	user16@example.mn
17	Kim Min	Солонгос	user17@example.com
18	Анужин Э.	Монгол	user18@example.mn
19	Энхжин Х.	Монгол	user19@example.mn
20	Сүхээ Д.	Монгол	user20@example.mn
21	Lee Brown	Солонгос	user21@example.com
22	John Dubois	АНУ	user22@example.com
23	Ivan Sato	Орос	user23@example.com
24	Hiro Petrov	Япон	user24@example.com
25	Sarah Wei	АНУ	user25@example.com
26	Anna Tanaka	Герман	user26@example.com
27	Kim Wei	Солонгос	user27@example.com
28	Дорж Ц.	Монгол	user28@example.mn
29	Хулан Ж.	Монгол	user29@example.mn
30	Оюун Д.	Монгол	user30@example.mn
31	John Wei	АНУ	user31@example.com
32	Lee Wei	Солонгос	user32@example.com
33	Ivan Weber	Орос	user33@example.com
34	Olga Min	Орос	user34@example.com
35	Lukas Smith	Герман	user35@example.com
36	Мөнх Ц.	Монгол	user36@example.mn
37	Chen Schmidt	Хятад	user37@example.com
38	Болд Д.	Монгол	user38@example.mn
39	Hiro Dubois	Япон	user39@example.com
40	Болд Б.	Монгол	user40@example.mn
41	Lee Brown	Солонгос	user41@example.com
42	Yuki Minho	Япон	user42@example.com
43	Мөнх Ц.	Монгол	user43@example.mn
44	Дорж Ц.	Монгол	user44@example.mn
45	Emily Jisoo	Их Британи	user45@example.com
46	Оюун Л.	Монгол	user46@example.mn
47	Номин Г.	Монгол	user47@example.mn
48	Ivan Dubois	Орос	user48@example.com
49	Chen Wei	Хятад	user49@example.com
50	John Dubois	АНУ	user50@example.com
51	Olga Min	Орос	user51@example.com
52	Hiro Sato	Япон	user52@example.com
53	Yuki Petrov	Япон	user53@example.com
54	Emily Smith	Их Британи	user54@example.com
55	Нараа Б.	Монгол	user55@example.mn
56	Оюун Д.	Монгол	user56@example.mn
57	Номин Б.	Монгол	user57@example.mn
58	Anna Minho	Герман	user58@example.com
59	Ганзориг М.	Монгол	user59@example.mn
60	Yuki Dubois	Япон	user60@example.com
61	Ivan Weber	Орос	user61@example.com
62	Мөнх Г.	Монгол	user62@example.mn
63	Болд Л.	Монгол	user63@example.mn
64	Lukas Schmidt	Герман	user64@example.com
65	Ариунаа Л.	Монгол	user65@example.mn
66	Sarah Petrov	АНУ	user66@example.com
67	Emily Minho	Их Британи	user67@example.com
68	Lee Minho	Солонгос	user68@example.com
69	Sarah Min	АНУ	user69@example.com
70	Olga Petrov	Орос	user70@example.com
71	Lee Petrov	Солонгос	user71@example.com
72	Хангай М.	Монгол	user72@example.mn
73	Anna Schmidt	Герман	user73@example.com
74	Lee Dubois	Солонгос	user74@example.com
75	Olga Minho	Орос	user75@example.com
76	Төгөлдөр Б.	Монгол	user76@example.mn
77	Оюун Ч.	Монгол	user77@example.mn
78	Emily Petrov	Их Британи	user78@example.com
79	Park Tanaka	Солонгос	user79@example.com
80	Оюун Э.	Монгол	user80@example.mn
81	Anna Petrov	Герман	user81@example.com
82	Ivan Schmidt	Орос	user82@example.com
83	Ivan Schmidt	Орос	user83@example.com
84	Ivan Smith	Орос	user84@example.com
85	Гэрэл О.	Монгол	user85@example.mn
86	Lee Minho	Солонгос	user86@example.com
87	Эрдэнэ Г.	Монгол	user87@example.mn
88	Emily Jisoo	Их Британи	user88@example.com
89	Номин Г.	Монгол	user89@example.mn
90	Emily Min	Их Британи	user90@example.com
91	Lukas Smith	Герман	user91@example.com
92	Тэмүүлэн Л.	Монгол	user92@example.mn
93	John Petrov	АНУ	user93@example.com
94	Болд Г.	Монгол	user94@example.mn
95	Marie Min	Франц	user95@example.com
96	Нараа Х.	Монгол	user96@example.mn
97	Батзаяа Э.	Монгол	user97@example.mn
98	Ганзориг О.	Монгол	user98@example.mn
99	Болд Ч.	Монгол	user99@example.mn
100	Marie Dubois	Франц	user100@example.com
101	Хангай Х.	Монгол	user101@example.mn
102	Номин Д.	Монгол	user102@example.mn
103	Хангай О.	Монгол	user103@example.mn
104	Хулан Э.	Монгол	user104@example.mn
105	Дорж С.	Монгол	user105@example.mn
106	John Petrov	АНУ	user106@example.com
107	Olga Min	Орос	user107@example.com
108	Hiro Schmidt	Япон	user108@example.com
109	Lee Weber	Солонгос	user109@example.com
110	Marie Tanaka	Франц	user110@example.com
111	Төгөлдөр Ж.	Монгол	user111@example.mn
112	Цэцэг Л.	Монгол	user112@example.mn
113	Эрдэнэ О.	Монгол	user113@example.mn
114	Ivan Brown	Орос	user114@example.com
115	Lee Jisoo	Солонгос	user115@example.com
116	Төгөлдөр О.	Монгол	user116@example.mn
117	Болд Б.	Монгол	user117@example.mn
118	Номин Н.	Монгол	user118@example.mn
119	Ivan Jisoo	Орос	user119@example.com
120	Hiro Min	Япон	user120@example.com
121	Yuki Wei	Япон	user121@example.com
122	Emily Wei	Их Британи	user122@example.com
123	Lukas Minho	Герман	user123@example.com
124	Sarah Dubois	АНУ	user124@example.com
125	Wang Petrov	Хятад	user125@example.com
126	Sarah Dubois	АНУ	user126@example.com
127	Номин Э.	Монгол	user127@example.mn
128	Olga Petrov	Орос	user128@example.com
129	Хангай Б.	Монгол	user129@example.mn
130	Мөнх С.	Монгол	user130@example.mn
131	Нараа М.	Монгол	user131@example.mn
132	Хангай О.	Монгол	user132@example.mn
133	Emily Schmidt	Их Британи	user133@example.com
134	Lukas Weber	Герман	user134@example.com
135	Kim Weber	Солонгос	user135@example.com
136	Тэмүүлэн Ч.	Монгол	user136@example.mn
137	Anna Schmidt	Герман	user137@example.com
138	Emily Sato	Их Британи	user138@example.com
139	Энхжин Ц.	Монгол	user139@example.mn
140	Хулан Н.	Монгол	user140@example.mn
141	Lukas Minho	Герман	user141@example.com
142	Lee Wei	Солонгос	user142@example.com
143	Ivan Weber	Орос	user143@example.com
144	Тэмүүлэн О.	Монгол	user144@example.mn
145	Hiro Schmidt	Япон	user145@example.com
146	Оюун Т.	Монгол	user146@example.mn
147	Lee Petrov	Солонгос	user147@example.com
148	Emily Dubois	Их Британи	user148@example.com
149	Сүхээ Д.	Монгол	user149@example.mn
150	Marie Wei	Франц	user150@example.com
151	Chen Wei	Хятад	user151@example.com
152	Хангай Г.	Монгол	user152@example.mn
153	Сүхээ Н.	Монгол	user153@example.mn
154	Сүхээ Ч.	Монгол	user154@example.mn
155	Lukas Minho	Герман	user155@example.com
156	Anna Wei	Герман	user156@example.com
157	Emily Wei	Их Британи	user157@example.com
158	Chen Smith	Хятад	user158@example.com
159	Olga Tanaka	Орос	user159@example.com
160	Hiro Petrov	Япон	user160@example.com
161	Ivan Minho	Орос	user161@example.com
162	Anna Dubois	Герман	user162@example.com
163	Ivan Minho	Орос	user163@example.com
164	Anna Brown	Герман	user164@example.com
165	Kim Wei	Солонгос	user165@example.com
166	Sarah Tanaka	АНУ	user166@example.com
167	Сүхээ Л.	Монгол	user167@example.mn
168	Emily Wei	Их Британи	user168@example.com
169	Wang Sato	Хятад	user169@example.com
170	Ариунаа М.	Монгол	user170@example.mn
171	Olga Jisoo	Орос	user171@example.com
172	Kim Smith	Солонгос	user172@example.com
173	Цэцэг Г.	Монгол	user173@example.mn
174	Нараа О.	Монгол	user174@example.mn
175	Ганзориг М.	Монгол	user175@example.mn
176	Эрдэнэ Н.	Монгол	user176@example.mn
177	Lukas Sato	Герман	user177@example.com
178	Anna Min	Герман	user178@example.com
179	Chen Petrov	Хятад	user179@example.com
180	Park Dubois	Солонгос	user180@example.com
181	Төгөлдөр Ж.	Монгол	user181@example.mn
182	Lukas Weber	Герман	user182@example.com
183	Болд С.	Монгол	user183@example.mn
184	Сүхээ Б.	Монгол	user184@example.mn
185	Ариунаа Э.	Монгол	user185@example.mn
186	Anna Min	Герман	user186@example.com
187	Sarah Minho	АНУ	user187@example.com
188	Сүхээ М.	Монгол	user188@example.mn
189	Marie Tanaka	Франц	user189@example.com
190	Emily Jisoo	Их Британи	user190@example.com
191	Sarah Dubois	АНУ	user191@example.com
192	Хангай М.	Монгол	user192@example.mn
193	Ivan Jisoo	Орос	user193@example.com
194	Хангай Ч.	Монгол	user194@example.mn
195	Ivan Tanaka	Орос	user195@example.com
196	Lee Schmidt	Солонгос	user196@example.com
197	Marie Sato	Франц	user197@example.com
198	Оюун С.	Монгол	user198@example.mn
199	Anna Wei	Герман	user199@example.com
200	Anna Jisoo	Герман	user200@example.com
201	Marie Petrov	Франц	user201@example.com
202	Kim Minho	Солонгос	user202@example.com
203	Kim Sato	Солонгос	user203@example.com
204	Hiro Dubois	Япон	user204@example.com
205	Дорж Д.	Монгол	user205@example.mn
206	Ivan Tanaka	Орос	user206@example.com
207	Эрдэнэ Т.	Монгол	user207@example.mn
208	Emily Schmidt	Их Британи	user208@example.com
209	Anna Weber	Герман	user209@example.com
210	Бат О.	Монгол	user210@example.mn
211	Anna Wei	Герман	user211@example.com
212	Номин Ц.	Монгол	user212@example.mn
213	Оюун Д.	Монгол	user213@example.mn
214	Kim Jisoo	Солонгос	user214@example.com
215	Сүхээ Ж.	Монгол	user215@example.mn
216	Hiro Petrov	Япон	user216@example.com
217	Marie Brown	Франц	user217@example.com
218	Olga Schmidt	Орос	user218@example.com
219	Ivan Wei	Орос	user219@example.com
220	Батзаяа О.	Монгол	user220@example.mn
221	Lukas Sato	Герман	user221@example.com
222	Sarah Schmidt	АНУ	user222@example.com
223	Ариунаа О.	Монгол	user223@example.mn
224	Wang Sato	Хятад	user224@example.com
225	Wang Sato	Хятад	user225@example.com
226	Lukas Sato	Герман	user226@example.com
227	Анужин М.	Монгол	user227@example.mn
228	Lukas Smith	Герман	user228@example.com
229	Хулан Н.	Монгол	user229@example.mn
230	Wang Dubois	Хятад	user230@example.com
231	Билгүүн Т.	Монгол	user231@example.mn
232	Уянга Г.	Монгол	user232@example.mn
233	Дорж Х.	Монгол	user233@example.mn
234	John Weber	АНУ	user234@example.com
235	Гэрэл Т.	Монгол	user235@example.mn
236	Sarah Schmidt	АНУ	user236@example.com
237	Marie Jisoo	Франц	user237@example.com
238	Батзаяа Э.	Монгол	user238@example.mn
239	Kim Brown	Солонгос	user239@example.com
240	Kim Min	Солонгос	user240@example.com
241	Yuki Schmidt	Япон	user241@example.com
242	Park Wei	Солонгос	user242@example.com
243	Ариунаа С.	Монгол	user243@example.mn
244	Ivan Wei	Орос	user244@example.com
245	Цэцэг Э.	Монгол	user245@example.mn
246	Энхжин Ч.	Монгол	user246@example.mn
247	Park Dubois	Солонгос	user247@example.com
248	Sarah Min	АНУ	user248@example.com
249	Батзаяа С.	Монгол	user249@example.mn
250	Хангай Г.	Монгол	user250@example.mn
251	John Tanaka	АНУ	user251@example.com
252	Olga Tanaka	Орос	user252@example.com
253	John Tanaka	АНУ	user253@example.com
254	Бат Б.	Монгол	user254@example.mn
255	Цэцэг Ц.	Монгол	user255@example.mn
256	John Schmidt	АНУ	user256@example.com
257	Hiro Tanaka	Япон	user257@example.com
258	Anna Dubois	Герман	user258@example.com
259	Hiro Dubois	Япон	user259@example.com
260	Болд Х.	Монгол	user260@example.mn
261	Anna Jisoo	Герман	user261@example.com
262	Анужин Ч.	Монгол	user262@example.mn
263	Номин Х.	Монгол	user263@example.mn
264	Тэмүүлэн Ж.	Монгол	user264@example.mn
265	Батзаяа С.	Монгол	user265@example.mn
266	Emily Tanaka	Их Британи	user266@example.com
267	Бат Э.	Монгол	user267@example.mn
268	Hiro Smith	Япон	user268@example.com
269	Yuki Smith	Япон	user269@example.com
270	Marie Tanaka	Франц	user270@example.com
271	Olga Tanaka	Орос	user271@example.com
272	Бат Х.	Монгол	user272@example.mn
273	Эрдэнэ Х.	Монгол	user273@example.mn
274	Wang Tanaka	Хятад	user274@example.com
275	Sarah Dubois	АНУ	user275@example.com
276	Olga Jisoo	Орос	user276@example.com
277	Chen Smith	Хятад	user277@example.com
278	Уянга Г.	Монгол	user278@example.mn
279	Ivan Brown	Орос	user279@example.com
280	Номин Д.	Монгол	user280@example.mn
281	Lee Petrov	Солонгос	user281@example.com
282	Wang Petrov	Хятад	user282@example.com
283	Olga Smith	Орос	user283@example.com
284	Гэрэл Л.	Монгол	user284@example.mn
285	Emily Petrov	Их Британи	user285@example.com
286	Lee Dubois	Солонгос	user286@example.com
287	Wang Sato	Хятад	user287@example.com
288	Olga Wei	Орос	user288@example.com
289	John Petrov	АНУ	user289@example.com
290	Болд Б.	Монгол	user290@example.mn
291	Anna Weber	Герман	user291@example.com
292	Мөнх С.	Монгол	user292@example.mn
293	Emily Sato	Их Британи	user293@example.com
294	Kim Min	Солонгос	user294@example.com
295	Lukas Sato	Герман	user295@example.com
296	Emily Jisoo	Их Британи	user296@example.com
297	Sarah Min	АНУ	user297@example.com
298	Emily Dubois	Их Британи	user298@example.com
299	Wang Tanaka	Хятад	user299@example.com
300	Wang Wei	Хятад	user300@example.com
301	Hiro Min	Япон	user301@example.com
302	Болд Ц.	Монгол	user302@example.mn
303	Lukas Weber	Герман	user303@example.com
304	Солонго Л.	Монгол	user304@example.mn
305	Ivan Jisoo	Орос	user305@example.com
306	Lee Weber	Солонгос	user306@example.com
307	Оюун Э.	Монгол	user307@example.mn
308	Сүхээ Ц.	Монгол	user308@example.mn
309	Park Sato	Солонгос	user309@example.com
310	Бат Т.	Монгол	user310@example.mn
311	Ариунаа Д.	Монгол	user311@example.mn
312	Ivan Smith	Орос	user312@example.com
313	Тэмүүлэн Ж.	Монгол	user313@example.mn
314	Hiro Jisoo	Япон	user314@example.com
315	Нараа Х.	Монгол	user315@example.mn
316	Wang Min	Хятад	user316@example.com
317	Yuki Schmidt	Япон	user317@example.com
318	Chen Minho	Хятад	user318@example.com
319	Lukas Minho	Герман	user319@example.com
320	Болд Х.	Монгол	user320@example.mn
321	Батзаяа О.	Монгол	user321@example.mn
322	Hiro Smith	Япон	user322@example.com
323	Wang Schmidt	Хятад	user323@example.com
324	Дорж Ж.	Монгол	user324@example.mn
325	Сүхээ Ц.	Монгол	user325@example.mn
326	Lee Schmidt	Солонгос	user326@example.com
327	Төгөлдөр Ц.	Монгол	user327@example.mn
328	Ганзориг О.	Монгол	user328@example.mn
329	Батзаяа С.	Монгол	user329@example.mn
330	Эрдэнэ Т.	Монгол	user330@example.mn
331	Төгөлдөр Ч.	Монгол	user331@example.mn
332	Болд Н.	Монгол	user332@example.mn
333	Номин Т.	Монгол	user333@example.mn
334	Marie Brown	Франц	user334@example.com
335	Солонго Б.	Монгол	user335@example.mn
336	Төгөлдөр Ц.	Монгол	user336@example.mn
337	Болд О.	Монгол	user337@example.mn
338	Ivan Weber	Орос	user338@example.com
339	Hiro Minho	Япон	user339@example.com
340	Энхжин Э.	Монгол	user340@example.mn
341	Билгүүн Ж.	Монгол	user341@example.mn
342	Hiro Jisoo	Япон	user342@example.com
343	Болд Т.	Монгол	user343@example.mn
344	Анужин Э.	Монгол	user344@example.mn
345	Болд Б.	Монгол	user345@example.mn
346	Ivan Petrov	Орос	user346@example.com
347	Ivan Brown	Орос	user347@example.com
348	Anna Tanaka	Герман	user348@example.com
349	Lukas Brown	Герман	user349@example.com
350	Эрдэнэ О.	Монгол	user350@example.mn
351	Olga Dubois	Орос	user351@example.com
352	Emily Sato	Их Британи	user352@example.com
353	Kim Minho	Солонгос	user353@example.com
354	Park Jisoo	Солонгос	user354@example.com
355	Энхжин Т.	Монгол	user355@example.mn
356	Нараа Б.	Монгол	user356@example.mn
357	John Wei	АНУ	user357@example.com
358	Lukas Petrov	Герман	user358@example.com
359	Wang Smith	Хятад	user359@example.com
360	Хулан Ж.	Монгол	user360@example.mn
361	Ганзориг Х.	Монгол	user361@example.mn
362	Hiro Weber	Япон	user362@example.com
363	Хангай Г.	Монгол	user363@example.mn
364	Kim Wei	Солонгос	user364@example.com
365	Дорж Н.	Монгол	user365@example.mn
366	Билгүүн О.	Монгол	user366@example.mn
367	Olga Dubois	Орос	user367@example.com
368	Wang Petrov	Хятад	user368@example.com
369	Marie Smith	Франц	user369@example.com
370	Оюун Г.	Монгол	user370@example.mn
371	Ivan Min	Орос	user371@example.com
372	Emily Sato	Их Британи	user372@example.com
373	Olga Tanaka	Орос	user373@example.com
374	Anna Brown	Герман	user374@example.com
375	Kim Min	Солонгос	user375@example.com
376	Wang Brown	Хятад	user376@example.com
377	Emily Min	Их Британи	user377@example.com
378	Болд Д.	Монгол	user378@example.mn
379	Yuki Jisoo	Япон	user379@example.com
380	Тэмүүлэн С.	Монгол	user380@example.mn
381	Оюун Д.	Монгол	user381@example.mn
382	Эрдэнэ Ч.	Монгол	user382@example.mn
383	Анужин С.	Монгол	user383@example.mn
384	Kim Sato	Солонгос	user384@example.com
385	Sarah Jisoo	АНУ	user385@example.com
386	John Dubois	АНУ	user386@example.com
387	Anna Minho	Герман	user387@example.com
388	Ivan Wei	Орос	user388@example.com
389	Ганзориг Т.	Монгол	user389@example.mn
390	Энхжин О.	Монгол	user390@example.mn
391	Sarah Tanaka	АНУ	user391@example.com
392	Анужин Б.	Монгол	user392@example.mn
393	Lee Jisoo	Солонгос	user393@example.com
394	John Sato	АНУ	user394@example.com
395	Kim Schmidt	Солонгос	user395@example.com
396	Бат Ж.	Монгол	user396@example.mn
397	Yuki Wei	Япон	user397@example.com
398	Ариунаа Б.	Монгол	user398@example.mn
399	Park Wei	Солонгос	user399@example.com
400	Emily Jisoo	Их Британи	user400@example.com
401	Park Petrov	Солонгос	user401@example.com
402	Солонго Г.	Монгол	user402@example.mn
403	Olga Weber	Орос	user403@example.com
404	Marie Wei	Франц	user404@example.com
405	Тэмүүлэн Ц.	Монгол	user405@example.mn
406	Anna Minho	Герман	user406@example.com
407	Park Smith	Солонгос	user407@example.com
408	Гэрэл М.	Монгол	user408@example.mn
409	Гэрэл Б.	Монгол	user409@example.mn
410	Kim Min	Солонгос	user410@example.com
411	Хангай Ч.	Монгол	user411@example.mn
412	Sarah Smith	АНУ	user412@example.com
413	Цэцэг Д.	Монгол	user413@example.mn
414	Lee Minho	Солонгос	user414@example.com
415	Дорж Б.	Монгол	user415@example.mn
416	Дорж Ц.	Монгол	user416@example.mn
417	John Min	АНУ	user417@example.com
418	Wang Schmidt	Хятад	user418@example.com
419	Дорж Л.	Монгол	user419@example.mn
420	Хулан Ж.	Монгол	user420@example.mn
421	Chen Weber	Хятад	user421@example.com
422	John Wei	АНУ	user422@example.com
423	Lukas Sato	Герман	user423@example.com
424	Бат М.	Монгол	user424@example.mn
425	Emily Smith	Их Британи	user425@example.com
426	Сараа О.	Монгол	user426@example.mn
427	Emily Brown	Их Британи	user427@example.com
428	Нараа Ч.	Монгол	user428@example.mn
429	John Brown	АНУ	user429@example.com
430	Lukas Minho	Герман	user430@example.com
431	Солонго Х.	Монгол	user431@example.mn
432	Yuki Minho	Япон	user432@example.com
433	Sarah Min	АНУ	user433@example.com
434	Lukas Jisoo	Герман	user434@example.com
435	Номин Н.	Монгол	user435@example.mn
436	Yuki Wei	Япон	user436@example.com
437	Номин Э.	Монгол	user437@example.mn
438	Yuki Weber	Япон	user438@example.com
439	Оюун Д.	Монгол	user439@example.mn
440	Wang Petrov	Хятад	user440@example.com
441	Бат Х.	Монгол	user441@example.mn
442	Ариунаа Ц.	Монгол	user442@example.mn
443	Yuki Smith	Япон	user443@example.com
444	Болд Ж.	Монгол	user444@example.mn
445	Сүхээ О.	Монгол	user445@example.mn
446	Lukas Tanaka	Герман	user446@example.com
447	Hiro Min	Япон	user447@example.com
448	Ivan Schmidt	Орос	user448@example.com
449	Төгөлдөр Д.	Монгол	user449@example.mn
450	Olga Min	Орос	user450@example.com
451	Ариунаа Х.	Монгол	user451@example.mn
452	Kim Brown	Солонгос	user452@example.com
453	Sarah Min	АНУ	user453@example.com
454	Төгөлдөр Х.	Монгол	user454@example.mn
455	Тэмүүлэн Э.	Монгол	user455@example.mn
456	Marie Sato	Франц	user456@example.com
457	Marie Smith	Франц	user457@example.com
458	Хангай Ц.	Монгол	user458@example.mn
459	Уянга Ц.	Монгол	user459@example.mn
460	Нараа Ж.	Монгол	user460@example.mn
461	Hiro Brown	Япон	user461@example.com
462	Төгөлдөр Б.	Монгол	user462@example.mn
463	Болд С.	Монгол	user463@example.mn
464	Дорж Х.	Монгол	user464@example.mn
465	Болд Ц.	Монгол	user465@example.mn
466	Olga Schmidt	Орос	user466@example.com
467	Sarah Sato	АНУ	user467@example.com
468	Olga Jisoo	Орос	user468@example.com
469	Төгөлдөр Д.	Монгол	user469@example.mn
470	Olga Tanaka	Орос	user470@example.com
471	Lee Minho	Солонгос	user471@example.com
472	Lukas Schmidt	Герман	user472@example.com
473	Билгүүн Ц.	Монгол	user473@example.mn
474	Park Dubois	Солонгос	user474@example.com
475	Нараа Л.	Монгол	user475@example.mn
476	Нараа С.	Монгол	user476@example.mn
477	Wang Wei	Хятад	user477@example.com
478	Хулан О.	Монгол	user478@example.mn
479	Нараа Э.	Монгол	user479@example.mn
480	Chen Smith	Хятад	user480@example.com
481	Emily Minho	Их Британи	user481@example.com
482	Хулан Н.	Монгол	user482@example.mn
483	Ганзориг С.	Монгол	user483@example.mn
484	Бат Д.	Монгол	user484@example.mn
485	Hiro Min	Япон	user485@example.com
486	Болд М.	Монгол	user486@example.mn
487	Билгүүн Т.	Монгол	user487@example.mn
488	Sarah Schmidt	АНУ	user488@example.com
489	Уянга Л.	Монгол	user489@example.mn
490	Chen Min	Хятад	user490@example.com
491	Emily Dubois	Их Британи	user491@example.com
492	Солонго Ч.	Монгол	user492@example.mn
493	Төгөлдөр Г.	Монгол	user493@example.mn
494	Lukas Sato	Герман	user494@example.com
495	Хангай Л.	Монгол	user495@example.mn
496	Lukas Jisoo	Герман	user496@example.com
497	Номин Б.	Монгол	user497@example.mn
498	Нараа Ц.	Монгол	user498@example.mn
499	Сүхээ Ц.	Монгол	user499@example.mn
500	Энхжин Ч.	Монгол	user500@example.mn
\.


--
-- Data for Name: guides; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guides (guide_id, full_name, language, experience_years) FROM stdin;
1	Ганбат	Англи	8
2	Мөнхзул	Хятад	3
3	Тэмүүлэн	Солонгос	6
4	Ариунаа	Япон	2
5	Хулан Д.	Япон	20
6	Болд Г.	Англи	11
7	Эрдэнэ Б.	Хятад	1
8	Сараа Э.	Герман	2
9	Оюун Г.	Герман	1
10	Эрдэнэ Г.	Хятад	20
11	Хангай Ц.	Англи	18
12	Эрдэнэ Э.	Англи	7
13	Болд М.	Англи	9
14	Ариунаа Д.	Англи	18
15	Мөнх М.	Хятад	3
16	Эрдэнэ Ц.	Хятад	11
17	Номин М.	Англи	18
18	Болд Ц.	Хятад	15
19	Уянга М.	Герман	10
20	Билгүүн Ц.	Орос	11
21	Мөнх О.	Хятад	7
22	Сараа Ц.	Солонгос	16
23	Цэцэг Т.	Орос	9
24	Солонго Г.	Англи	16
25	Ариунаа Д.	Солонгос	4
26	Цэцэг Э.	Англи	2
27	Нараа Ц.	Солонгос	10
28	Батзаяа Т.	Франц	18
29	Билгүүн Г.	Англи	8
30	Цэцэг Л.	Англи	1
31	Гэрэл Л.	Солонгос	20
32	Эрдэнэ Х.	Орос	9
33	Батзаяа Э.	Япон	0
34	Билгүүн Т.	Хятад	19
35	Номин Н.	Англи	6
36	Мөнх Д.	Хятад	12
37	Сүхээ Ч.	Франц	2
38	Анужин Н.	Япон	17
39	Энхжин Д.	Герман	17
40	Энхжин Л.	Герман	11
41	Уянга Э.	Хятад	4
42	Сараа Д.	Англи	7
43	Уянга О.	Англи	15
44	Эрдэнэ Д.	Солонгос	9
45	Бат Д.	Герман	17
46	Дорж Ц.	Солонгос	4
47	Батзаяа Ч.	Англи	14
48	Уянга Ж.	Япон	12
49	Сүхээ Э.	Англи	15
50	Хангай Э.	Англи	6
51	Сараа О.	Орос	5
52	Номин Т.	Англи	3
53	Бат Ц.	Англи	17
54	Номин Т.	Англи	2
55	Ганзориг Ц.	Япон	4
56	Хангай С.	Япон	19
57	Дорж Н.	Англи	3
58	Цэцэг Н.	Франц	15
59	Мөнх Г.	Англи	3
60	Гэрэл Т.	Солонгос	15
61	Батзаяа Д.	Англи	6
62	Төгөлдөр Т.	Англи	17
63	Бат Ж.	Солонгос	20
64	Сараа Л.	Солонгос	16
65	Дорж Д.	Япон	7
66	Нараа М.	Солонгос	20
67	Оюун Ц.	Хятад	7
68	Сүхээ Л.	Хятад	6
69	Төгөлдөр Н.	Япон	0
70	Бат Ж.	Солонгос	15
71	Энхжин О.	Япон	14
72	Гэрэл Т.	Япон	2
73	Оюун Г.	Хятад	15
74	Ганзориг Т.	Хятад	15
75	Солонго Ц.	Англи	15
76	Хангай Т.	Англи	3
77	Сүхээ Ж.	Хятад	15
78	Анужин Э.	Солонгос	2
79	Гэрэл Э.	Орос	12
80	Гэрэл Г.	Хятад	5
81	Тэмүүлэн Б.	Англи	18
82	Билгүүн Ж.	Англи	19
83	Солонго Н.	Япон	4
84	Нараа М.	Англи	0
85	Бат Ж.	Англи	16
86	Гэрэл Д.	Герман	6
87	Ганзориг Б.	Солонгос	6
88	Мөнх М.	Хятад	18
89	Хулан С.	Герман	4
90	Болд Л.	Япон	14
91	Уянга Ц.	Герман	16
92	Тэмүүлэн М.	Англи	16
93	Төгөлдөр Б.	Орос	5
94	Солонго Б.	Англи	5
95	Тэмүүлэн Н.	Англи	17
96	Болд Т.	Франц	3
97	Нараа Б.	Хятад	6
98	Энхжин Б.	Англи	16
99	Билгүүн М.	Англи	2
100	Билгүүн Т.	Хятад	8
101	Билгүүн М.	Франц	16
102	Оюун Л.	Солонгос	17
103	Ганзориг Ч.	Орос	4
104	Ариунаа Г.	Япон	14
105	Хулан Г.	Хятад	13
106	Сараа О.	Солонгос	3
107	Тэмүүлэн Л.	Япон	4
108	Энхжин Д.	Орос	7
109	Гэрэл Г.	Япон	15
110	Анужин Х.	Хятад	5
111	Батзаяа Э.	Япон	10
112	Ариунаа О.	Япон	10
113	Сараа Л.	Япон	0
114	Хулан М.	Орос	14
115	Батзаяа Б.	Япон	10
116	Төгөлдөр Ц.	Солонгос	16
117	Сараа Г.	Хятад	3
118	Сараа С.	Солонгос	1
119	Анужин С.	Англи	13
120	Уянга Ч.	Солонгос	12
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payments (payment_id, booking_id, amount, paid_at, method) FROM stdin;
1	1	2500000.00	2026-03-06	card
2	2	5000000.00	2026-04-13	qpay
3	3	2900000.00	2026-02-21	card
4	7	2200000.00	2026-01-11	qpay
5	9	1440000.00	2023-01-03	qpay
6	10	2880000.00	2023-01-13	qpay
7	11	8640000.00	2023-01-18	qpay
8	12	4320000.00	2023-01-22	card
9	13	4320000.00	2023-01-27	cash
10	14	8640000.00	2023-01-28	card
11	15	2880000.00	2023-02-02	cash
12	16	2880000.00	2023-02-03	qpay
13	17	11700000.00	2023-02-06	qpay
14	18	2340000.00	2023-02-09	card
15	19	5460000.00	2023-02-10	qpay
16	20	4680000.00	2023-02-11	cash
17	21	9100000.00	2023-02-11	qpay
18	22	7280000.00	2023-02-11	qpay
19	23	3640000.00	2023-02-12	card
20	24	10920000.00	2023-02-15	qpay
21	25	5460000.00	2023-02-16	qpay
22	26	2500000.00	2023-02-15	qpay
23	27	3080000.00	2023-02-19	qpay
24	28	6250000.00	2023-02-18	qpay
25	29	1250000.00	2023-02-20	qpay
26	30	4620000.00	2023-02-20	qpay
27	31	4620000.00	2023-02-21	qpay
28	32	3080000.00	2023-02-26	cash
29	33	3080000.00	2023-02-25	qpay
30	34	7700000.00	2023-03-01	qpay
31	35	6160000.00	2023-03-01	card
32	36	3080000.00	2023-02-28	qpay
33	37	7700000.00	2023-03-08	card
34	38	1820000.00	2023-03-11	card
35	39	1820000.00	2023-03-11	qpay
36	40	910000.00	2023-03-13	qpay
37	41	1820000.00	2023-03-17	card
38	42	1820000.00	2023-03-19	qpay
39	43	2730000.00	2023-03-18	qpay
40	44	1820000.00	2023-03-19	card
41	45	1820000.00	2023-03-19	card
42	46	910000.00	2023-03-24	qpay
43	47	3640000.00	2023-03-24	qpay
44	48	3620000.00	2023-03-30	qpay
45	49	1810000.00	2023-04-04	qpay
46	50	1320000.00	2023-04-02	card
47	51	1320000.00	2023-04-02	qpay
48	52	3300000.00	2023-04-02	qpay
49	53	1980000.00	2023-04-05	qpay
50	54	1320000.00	2023-04-05	card
51	55	660000.00	2023-04-09	qpay
52	57	1320000.00	2023-04-10	cash
53	58	3960000.00	2023-04-08	card
54	59	1320000.00	2023-04-09	qpay
55	60	1320000.00	2023-04-10	qpay
56	61	1320000.00	2023-04-12	cash
57	63	2640000.00	2023-04-14	qpay
58	64	1320000.00	2023-04-16	qpay
59	65	1980000.00	2023-04-21	qpay
60	66	1980000.00	2023-04-21	cash
61	67	660000.00	2023-04-24	card
62	68	1320000.00	2023-04-23	qpay
63	70	2220000.00	2023-04-28	cash
64	71	1480000.00	2023-04-27	card
65	72	3700000.00	2023-04-28	cash
66	73	2960000.00	2023-05-02	card
67	74	1480000.00	2023-05-05	qpay
68	75	1480000.00	2023-05-09	cash
69	76	740000.00	2023-05-11	qpay
70	77	6320000.00	2023-05-10	qpay
71	78	6320000.00	2023-05-11	cash
72	79	1580000.00	2023-05-13	cash
73	80	6320000.00	2023-05-11	qpay
74	81	9480000.00	2023-05-13	cash
75	82	1580000.00	2023-05-13	qpay
76	83	7900000.00	2023-05-15	card
77	84	3160000.00	2023-05-17	qpay
78	85	6320000.00	2023-05-16	qpay
79	86	3160000.00	2023-05-19	qpay
80	87	13200000.00	2023-05-17	qpay
81	88	10560000.00	2023-05-18	card
82	89	5280000.00	2023-05-19	qpay
83	90	5280000.00	2023-05-21	qpay
84	91	7920000.00	2023-05-22	cash
85	92	7920000.00	2023-05-23	cash
86	93	15840000.00	2023-05-25	cash
87	94	7920000.00	2023-05-22	card
88	95	6600000.00	2023-05-24	cash
89	96	1100000.00	2023-05-24	card
90	97	3300000.00	2023-05-23	cash
91	98	2200000.00	2023-05-26	qpay
92	99	3300000.00	2023-05-27	cash
93	100	2200000.00	2023-05-29	cash
94	101	3300000.00	2023-05-28	qpay
95	102	5500000.00	2023-05-29	qpay
96	103	2200000.00	2023-05-28	qpay
97	104	3300000.00	2023-06-01	card
98	105	3300000.00	2023-06-04	qpay
99	106	3300000.00	2023-06-06	qpay
100	107	2190000.00	2023-06-04	qpay
101	108	2190000.00	2023-06-07	qpay
102	109	1460000.00	2023-06-08	cash
103	110	1460000.00	2023-06-05	qpay
104	111	2190000.00	2023-06-08	card
105	112	2190000.00	2023-06-09	qpay
106	113	1460000.00	2023-06-06	card
107	114	4380000.00	2023-06-09	qpay
108	115	2190000.00	2023-06-07	card
109	116	2920000.00	2023-06-07	qpay
110	117	1460000.00	2023-06-08	cash
111	118	15680000.00	2023-06-10	cash
112	119	15680000.00	2023-06-12	qpay
113	120	7840000.00	2023-06-14	qpay
114	121	6660000.00	2023-06-12	cash
115	122	1040000.00	2023-06-13	cash
116	123	2080000.00	2023-06-14	qpay
117	124	1040000.00	2023-06-14	card
118	125	1560000.00	2023-06-18	qpay
119	126	1040000.00	2023-06-19	qpay
120	127	1040000.00	2023-06-19	qpay
121	128	1040000.00	2023-06-19	qpay
122	129	520000.00	2023-06-19	qpay
123	131	1040000.00	2023-06-20	cash
124	132	3120000.00	2023-06-20	cash
125	133	1040000.00	2023-06-23	qpay
126	134	3120000.00	2023-06-24	qpay
127	135	3120000.00	2023-06-24	card
128	136	3120000.00	2023-06-26	qpay
129	137	1040000.00	2023-06-29	cash
130	138	1040000.00	2023-06-27	qpay
131	139	6540000.00	2023-06-28	cash
132	140	2180000.00	2023-07-01	qpay
133	141	1560000.00	2023-07-01	qpay
134	142	1560000.00	2023-06-28	cash
135	143	2180000.00	2023-07-01	qpay
136	144	2180000.00	2023-07-03	card
137	147	6540000.00	2023-07-03	qpay
138	148	3270000.00	2023-07-04	qpay
139	149	4360000.00	2023-07-06	card
140	150	3270000.00	2023-07-06	cash
141	151	4200000.00	2023-07-06	qpay
142	152	4200000.00	2023-07-05	card
143	153	5040000.00	2023-07-08	qpay
144	154	2520000.00	2023-07-06	qpay
145	155	5040000.00	2023-07-09	qpay
146	156	3360000.00	2023-07-06	qpay
147	157	5040000.00	2023-07-07	cash
148	158	840000.00	2023-07-07	qpay
149	159	2520000.00	2023-07-11	cash
150	161	2520000.00	2023-07-09	qpay
151	162	1680000.00	2023-07-12	card
152	163	840000.00	2023-07-13	qpay
153	164	4200000.00	2023-07-13	card
154	165	4200000.00	2023-07-13	qpay
155	166	840000.00	2023-07-13	card
156	168	6500000.00	2023-07-16	card
157	169	13000000.00	2023-07-14	card
158	170	19500000.00	2023-07-17	qpay
159	171	1820000.00	2023-07-18	card
160	172	3640000.00	2023-07-17	qpay
161	173	3640000.00	2023-07-19	card
162	174	3640000.00	2023-07-16	card
163	175	1820000.00	2023-07-19	cash
164	176	7280000.00	2023-07-18	card
165	177	3640000.00	2023-07-20	qpay
166	178	3640000.00	2023-07-18	cash
167	179	3640000.00	2023-07-21	card
168	180	3640000.00	2023-07-19	card
169	181	5460000.00	2023-07-21	qpay
170	182	21550000.00	2023-07-21	card
171	184	8620000.00	2023-07-24	qpay
172	185	8620000.00	2023-07-21	card
173	186	4380000.00	2023-07-22	qpay
174	187	6570000.00	2023-07-23	qpay
175	188	6570000.00	2023-07-24	cash
176	189	4380000.00	2023-07-26	qpay
177	190	6570000.00	2023-07-26	card
178	191	6570000.00	2023-07-25	qpay
179	192	660000.00	2023-07-25	qpay
180	193	1320000.00	2023-07-25	qpay
181	194	2640000.00	2023-07-25	card
182	195	3300000.00	2023-07-26	qpay
183	196	1160000.00	2023-07-26	qpay
184	197	580000.00	2023-07-26	qpay
185	198	1160000.00	2023-07-28	cash
186	199	580000.00	2023-07-29	cash
187	200	580000.00	2023-07-28	card
188	201	580000.00	2023-07-29	card
189	202	580000.00	2023-07-29	card
190	203	580000.00	2023-07-31	card
191	204	580000.00	2023-08-01	qpay
192	205	1450000.00	2023-08-01	qpay
193	206	1160000.00	2023-08-01	cash
194	207	2680000.00	2023-08-02	qpay
195	209	2680000.00	2023-08-02	qpay
196	210	4020000.00	2023-08-01	card
197	211	3680000.00	2023-08-03	qpay
198	213	2680000.00	2023-08-04	qpay
199	214	2680000.00	2023-08-01	card
200	216	3680000.00	2023-08-04	qpay
201	217	3680000.00	2023-08-05	qpay
202	218	5520000.00	2023-08-04	qpay
203	219	3680000.00	2023-08-04	qpay
204	220	3680000.00	2023-08-07	qpay
205	221	1840000.00	2023-08-07	card
206	223	2760000.00	2023-08-09	cash
207	224	4600000.00	2023-08-10	card
208	225	3680000.00	2023-08-09	qpay
209	226	3680000.00	2023-08-09	card
210	227	2760000.00	2023-08-10	qpay
211	229	1840000.00	2023-08-14	card
212	230	920000.00	2023-08-12	qpay
213	231	5520000.00	2023-08-14	qpay
214	233	14100000.00	2023-08-15	card
215	234	14100000.00	2023-08-15	qpay
216	236	14100000.00	2023-08-15	card
217	237	5250000.00	2023-08-16	cash
218	238	2100000.00	2023-08-18	qpay
219	239	1050000.00	2023-08-17	qpay
220	240	1050000.00	2023-08-17	cash
221	241	2100000.00	2023-08-20	qpay
222	242	2100000.00	2023-08-19	card
223	244	1050000.00	2023-08-20	card
224	245	5250000.00	2023-08-22	qpay
225	246	2100000.00	2023-08-20	qpay
226	247	5250000.00	2023-08-21	card
227	248	4200000.00	2023-08-20	qpay
228	249	2100000.00	2023-08-20	qpay
229	250	3150000.00	2023-08-24	qpay
230	251	3150000.00	2023-08-23	cash
231	252	2100000.00	2023-08-22	qpay
232	253	1160000.00	2023-08-22	card
233	254	5800000.00	2023-08-23	qpay
234	255	3480000.00	2023-08-25	card
235	256	1160000.00	2023-08-23	card
236	258	2320000.00	2023-08-25	cash
237	259	3480000.00	2023-08-25	cash
238	260	2320000.00	2023-08-28	qpay
239	262	3480000.00	2023-08-28	qpay
240	263	4520000.00	2023-08-29	card
241	264	1160000.00	2023-08-28	qpay
242	265	1130000.00	2023-08-29	cash
243	266	3390000.00	2023-09-01	card
244	267	2260000.00	2023-08-30	qpay
245	268	3390000.00	2023-09-01	cash
246	269	3390000.00	2023-08-31	qpay
247	271	4520000.00	2023-09-01	cash
248	272	5650000.00	2023-09-04	qpay
249	273	4520000.00	2023-09-05	card
250	274	2260000.00	2023-09-05	qpay
251	275	1140000.00	2023-09-05	qpay
252	276	1710000.00	2023-09-04	cash
253	277	570000.00	2023-09-07	qpay
254	280	570000.00	2023-09-07	qpay
255	282	1140000.00	2023-09-10	qpay
256	283	1140000.00	2023-09-09	cash
257	284	2850000.00	2023-09-08	card
258	285	1710000.00	2023-09-08	card
259	286	1710000.00	2023-09-11	qpay
260	287	3420000.00	2023-09-09	qpay
261	288	7760000.00	2023-09-10	qpay
262	289	5820000.00	2023-09-13	card
263	290	3880000.00	2023-09-14	cash
264	291	3880000.00	2023-09-15	cash
265	293	3880000.00	2023-09-16	qpay
266	294	5820000.00	2023-09-15	card
267	295	1940000.00	2023-09-14	qpay
268	296	3880000.00	2023-09-16	qpay
269	297	1000000.00	2023-09-16	qpay
270	299	5820000.00	2023-09-16	cash
271	300	1500000.00	2023-09-15	qpay
272	301	1000000.00	2023-09-17	qpay
273	302	1000000.00	2023-09-17	cash
274	303	500000.00	2023-09-18	cash
275	304	3000000.00	2023-09-17	card
276	305	2000000.00	2023-09-20	qpay
277	306	2500000.00	2023-09-21	qpay
278	307	3000000.00	2023-09-21	card
279	308	1000000.00	2023-09-21	qpay
280	309	500000.00	2023-09-22	card
281	310	2500000.00	2023-09-24	card
282	311	1500000.00	2023-09-23	cash
283	312	3180000.00	2023-09-24	card
284	313	4770000.00	2023-09-25	card
285	314	3180000.00	2023-09-28	qpay
286	315	3180000.00	2023-09-28	qpay
287	316	4770000.00	2023-09-28	card
288	317	3180000.00	2023-09-28	cash
289	318	1220000.00	2023-09-28	cash
290	319	2440000.00	2023-09-30	qpay
291	320	3050000.00	2023-10-01	qpay
292	321	970000.00	2023-10-01	qpay
293	322	2910000.00	2023-10-02	qpay
294	324	1940000.00	2023-10-04	card
295	325	970000.00	2023-10-05	qpay
296	326	2910000.00	2023-10-11	qpay
297	327	3880000.00	2023-10-10	card
298	328	3880000.00	2023-10-13	card
299	329	1940000.00	2023-10-14	qpay
300	330	5820000.00	2023-10-17	qpay
301	331	1940000.00	2023-10-19	card
302	332	2910000.00	2023-10-21	qpay
303	333	5820000.00	2023-10-26	qpay
304	334	4850000.00	2023-10-26	qpay
305	335	2910000.00	2023-10-25	qpay
306	336	1640000.00	2023-10-30	qpay
307	337	3280000.00	2023-10-30	qpay
308	338	8200000.00	2023-11-07	cash
309	339	4920000.00	2023-11-09	qpay
310	340	4920000.00	2023-11-08	card
311	343	3280000.00	2023-11-11	card
312	344	1640000.00	2023-11-14	card
313	345	1740000.00	2023-11-17	qpay
314	346	5220000.00	2023-11-19	qpay
315	347	870000.00	2023-11-22	qpay
316	348	5120000.00	2023-11-24	qpay
317	349	3840000.00	2023-12-05	cash
318	350	7680000.00	2023-12-12	cash
319	351	7680000.00	2023-12-13	card
320	352	7680000.00	2023-12-26	card
321	353	1280000.00	2023-12-25	cash
322	354	2560000.00	2023-12-29	cash
323	355	1060000.00	2024-01-01	qpay
324	356	2120000.00	2024-01-03	card
325	357	2120000.00	2024-01-02	qpay
326	358	2120000.00	2024-01-01	qpay
327	359	2120000.00	2024-01-04	cash
328	360	2120000.00	2024-01-07	card
329	361	5300000.00	2024-01-06	card
330	362	6360000.00	2024-01-08	cash
331	363	2120000.00	2024-01-08	cash
332	364	3840000.00	2024-01-14	cash
333	365	5760000.00	2024-01-17	qpay
334	366	3840000.00	2024-01-18	qpay
335	367	3840000.00	2024-01-23	cash
336	368	9600000.00	2024-01-24	cash
337	369	5760000.00	2024-01-26	qpay
338	370	11520000.00	2024-01-25	cash
339	371	3840000.00	2024-01-27	qpay
340	372	5760000.00	2024-01-29	qpay
341	373	10300000.00	2024-01-29	card
342	374	10300000.00	2024-02-04	cash
343	375	6180000.00	2024-02-04	qpay
344	376	6180000.00	2024-02-07	qpay
345	377	6180000.00	2024-02-10	qpay
346	378	6180000.00	2024-02-08	qpay
347	379	10300000.00	2024-02-11	card
348	380	6180000.00	2024-02-16	cash
349	381	2340000.00	2024-02-17	card
350	382	6180000.00	2024-02-17	card
351	383	3510000.00	2024-02-19	qpay
352	386	2340000.00	2024-02-22	card
353	387	4680000.00	2024-02-21	qpay
354	388	7020000.00	2024-02-22	qpay
355	389	4720000.00	2024-02-28	cash
356	391	2360000.00	2024-02-29	card
357	392	1780000.00	2024-03-11	qpay
358	393	3560000.00	2024-03-18	qpay
359	394	3560000.00	2024-03-19	qpay
360	395	3560000.00	2024-03-23	cash
361	396	7120000.00	2024-03-24	card
362	397	3560000.00	2024-03-22	qpay
363	398	1780000.00	2024-03-21	cash
364	399	10680000.00	2024-03-22	cash
365	400	8900000.00	2024-03-27	cash
366	401	10680000.00	2024-03-25	qpay
367	402	8900000.00	2024-03-28	card
368	403	10680000.00	2024-03-27	qpay
369	404	7120000.00	2024-04-01	cash
370	405	5340000.00	2024-03-31	qpay
371	406	7120000.00	2024-04-01	card
372	407	7650000.00	2024-04-03	qpay
373	408	5100000.00	2024-04-04	qpay
374	409	5100000.00	2024-04-05	qpay
375	410	10200000.00	2024-04-09	qpay
376	411	15300000.00	2024-04-06	card
377	412	5100000.00	2024-04-07	cash
378	413	12750000.00	2024-04-09	card
379	414	12750000.00	2024-04-08	cash
380	415	3090000.00	2024-04-14	qpay
381	416	3090000.00	2024-04-15	qpay
382	417	5150000.00	2024-04-15	cash
383	419	2060000.00	2024-04-15	qpay
384	420	3090000.00	2024-04-17	qpay
385	423	1030000.00	2024-04-21	card
386	424	3090000.00	2024-04-19	qpay
387	425	2060000.00	2024-04-20	qpay
388	426	2100000.00	2024-04-20	cash
389	427	2100000.00	2024-04-21	qpay
390	428	2100000.00	2024-04-24	card
391	429	4200000.00	2024-04-25	qpay
392	430	2100000.00	2024-04-25	card
393	431	2120000.00	2024-04-28	qpay
394	432	1590000.00	2024-04-26	qpay
395	433	2120000.00	2024-04-28	cash
396	434	2650000.00	2024-04-29	card
397	435	3180000.00	2024-05-01	qpay
398	436	1590000.00	2024-05-03	card
399	437	1060000.00	2024-05-03	cash
400	438	3180000.00	2024-05-01	qpay
401	439	1060000.00	2024-05-03	cash
402	440	1590000.00	2024-05-03	cash
403	441	1800000.00	2024-05-03	qpay
404	442	1800000.00	2024-05-04	qpay
405	443	1800000.00	2024-05-03	qpay
406	444	5400000.00	2024-05-05	card
407	445	2700000.00	2024-05-04	qpay
408	446	900000.00	2024-05-08	qpay
409	447	900000.00	2024-05-08	card
410	448	1800000.00	2024-05-10	card
411	449	1800000.00	2024-05-12	cash
412	450	2280000.00	2024-05-11	cash
413	451	1140000.00	2024-05-15	qpay
414	452	2280000.00	2024-05-14	card
415	453	570000.00	2024-05-18	qpay
416	454	1710000.00	2024-05-16	qpay
417	455	1710000.00	2024-05-16	qpay
418	456	1140000.00	2024-05-15	qpay
419	457	1710000.00	2024-05-15	cash
420	458	2280000.00	2024-05-16	card
421	459	1140000.00	2024-05-21	qpay
422	460	1710000.00	2024-05-26	cash
423	461	2280000.00	2024-05-24	qpay
424	462	990000.00	2024-05-26	card
425	463	1980000.00	2024-05-25	qpay
426	464	1980000.00	2024-05-28	qpay
427	465	1980000.00	2024-05-29	qpay
428	466	1980000.00	2024-05-29	card
429	467	5940000.00	2024-05-27	cash
430	468	1980000.00	2024-05-29	card
431	469	2970000.00	2024-06-01	card
432	470	5940000.00	2024-06-03	cash
433	471	1980000.00	2024-06-05	qpay
434	474	6280000.00	2024-06-05	qpay
435	475	4710000.00	2024-06-07	qpay
436	476	1570000.00	2024-06-08	card
437	478	9420000.00	2024-06-07	cash
438	479	13260000.00	2024-06-10	card
439	480	7850000.00	2024-06-11	card
440	481	11050000.00	2024-06-13	cash
441	482	4420000.00	2024-06-12	card
442	483	4420000.00	2024-06-13	card
443	484	4420000.00	2024-06-14	qpay
444	485	3720000.00	2024-06-15	qpay
445	486	3720000.00	2024-06-14	card
446	488	7440000.00	2024-06-16	qpay
447	489	860000.00	2024-06-17	qpay
448	490	430000.00	2024-06-20	card
449	491	1290000.00	2024-06-23	qpay
450	492	1290000.00	2024-06-22	qpay
451	493	1290000.00	2024-06-21	qpay
452	494	2580000.00	2024-06-24	cash
453	496	1290000.00	2024-06-25	qpay
454	497	2580000.00	2024-06-26	qpay
455	498	1290000.00	2024-06-25	qpay
456	499	2150000.00	2024-06-26	cash
457	500	1290000.00	2024-06-28	card
458	501	1290000.00	2024-06-27	cash
459	502	1290000.00	2024-06-26	qpay
460	505	14340000.00	2024-06-29	qpay
461	506	7170000.00	2024-06-29	cash
462	507	4780000.00	2024-07-01	card
463	508	4780000.00	2024-07-01	cash
464	509	7170000.00	2024-06-29	qpay
465	510	2040000.00	2024-06-30	qpay
466	511	2390000.00	2024-06-29	cash
467	512	9560000.00	2024-07-01	card
468	513	4780000.00	2024-07-02	qpay
469	514	1020000.00	2024-07-03	card
470	515	3060000.00	2024-07-02	qpay
471	516	1020000.00	2024-07-01	card
472	517	2040000.00	2024-07-02	qpay
473	518	5100000.00	2024-07-03	card
474	519	1270000.00	2024-07-02	cash
475	520	2540000.00	2024-07-04	cash
476	522	2540000.00	2024-07-03	cash
477	523	2540000.00	2024-07-07	card
478	524	7620000.00	2024-07-06	qpay
479	525	6350000.00	2024-07-07	card
480	526	1270000.00	2024-07-06	qpay
481	527	6350000.00	2024-07-07	card
482	528	3810000.00	2024-07-09	card
483	529	3810000.00	2024-07-06	card
484	530	2540000.00	2024-07-08	card
485	531	3000000.00	2024-07-09	qpay
486	532	4500000.00	2024-07-09	card
487	533	4500000.00	2024-07-10	qpay
488	534	4500000.00	2024-07-11	qpay
489	535	2250000.00	2024-07-10	qpay
490	536	1500000.00	2024-07-11	card
491	537	2250000.00	2024-07-12	qpay
492	538	2250000.00	2024-07-12	qpay
493	540	2250000.00	2024-07-12	qpay
494	541	4500000.00	2024-07-13	qpay
495	542	1500000.00	2024-07-12	qpay
496	544	6180000.00	2024-07-11	cash
497	545	12360000.00	2024-07-13	card
498	546	4120000.00	2024-07-13	qpay
499	547	12360000.00	2024-07-15	cash
500	548	4120000.00	2024-07-16	qpay
501	549	12360000.00	2024-07-15	cash
502	550	9990000.00	2024-07-17	cash
503	551	16650000.00	2024-07-15	card
504	552	4120000.00	2024-07-16	qpay
505	553	6660000.00	2024-07-18	card
506	554	6660000.00	2024-07-21	qpay
507	555	6660000.00	2024-07-20	card
508	556	1120000.00	2024-07-18	card
509	558	1680000.00	2024-07-19	qpay
510	559	2800000.00	2024-07-21	card
511	560	560000.00	2024-07-21	card
512	561	3360000.00	2024-07-21	cash
513	562	3360000.00	2024-07-23	qpay
514	563	1120000.00	2024-07-22	qpay
515	564	1680000.00	2024-07-21	qpay
516	565	2800000.00	2024-07-24	qpay
517	566	3360000.00	2024-07-24	cash
518	567	1120000.00	2024-07-25	qpay
519	568	8460000.00	2024-07-23	cash
520	569	8460000.00	2024-07-24	qpay
521	570	4230000.00	2024-07-24	qpay
522	571	4230000.00	2024-07-27	qpay
523	572	5640000.00	2024-07-26	qpay
524	573	5640000.00	2024-07-27	qpay
525	574	2820000.00	2024-07-26	qpay
526	575	4230000.00	2024-07-29	cash
527	576	5640000.00	2024-07-29	qpay
528	577	2520000.00	2024-07-28	qpay
529	578	2820000.00	2024-07-30	qpay
530	580	3480000.00	2024-07-29	cash
531	581	10440000.00	2024-07-29	qpay
532	583	3480000.00	2024-08-01	qpay
533	584	3480000.00	2024-07-31	cash
534	585	3480000.00	2024-08-02	qpay
535	586	5220000.00	2024-08-01	card
536	587	1740000.00	2024-08-02	qpay
537	588	5220000.00	2024-08-05	qpay
538	590	6400000.00	2024-08-08	card
539	591	2560000.00	2024-08-08	card
540	592	6400000.00	2024-08-06	qpay
541	593	4120000.00	2024-08-10	cash
542	594	12360000.00	2024-08-10	card
543	595	7680000.00	2024-08-10	cash
544	596	3840000.00	2024-08-10	qpay
545	597	1090000.00	2024-08-09	card
546	598	2180000.00	2024-08-11	card
547	599	1090000.00	2024-08-09	qpay
548	600	5450000.00	2024-08-10	cash
549	601	2180000.00	2024-08-09	qpay
550	602	1090000.00	2024-08-11	qpay
551	604	1580000.00	2024-08-13	qpay
552	605	4740000.00	2024-08-11	card
553	606	2180000.00	2024-08-11	qpay
554	607	2180000.00	2024-08-14	card
555	608	1580000.00	2024-08-15	cash
556	609	3160000.00	2024-08-13	cash
557	610	1580000.00	2024-08-16	cash
558	611	4740000.00	2024-08-13	card
559	612	3950000.00	2024-08-15	qpay
560	613	3950000.00	2024-08-17	qpay
561	614	1580000.00	2024-08-18	qpay
562	615	2370000.00	2024-08-16	card
563	617	11050000.00	2024-08-18	cash
564	618	4420000.00	2024-08-17	cash
565	619	6630000.00	2024-08-17	cash
566	620	6630000.00	2024-08-17	card
567	621	2210000.00	2024-08-17	card
568	622	13260000.00	2024-08-17	qpay
569	623	6630000.00	2024-08-20	qpay
570	624	4420000.00	2024-08-18	card
571	625	13260000.00	2024-08-20	card
572	626	1100000.00	2024-08-21	qpay
573	627	11050000.00	2024-08-23	card
574	628	1650000.00	2024-08-23	qpay
575	630	3300000.00	2024-08-23	card
576	631	1650000.00	2024-08-23	qpay
577	632	1650000.00	2024-08-25	qpay
578	633	2200000.00	2024-08-24	qpay
579	634	3300000.00	2024-08-23	card
580	635	1650000.00	2024-08-26	qpay
581	636	1100000.00	2024-08-24	qpay
582	637	1100000.00	2024-08-27	card
583	638	1100000.00	2024-08-28	cash
584	639	1860000.00	2024-08-28	cash
585	640	3720000.00	2024-08-29	qpay
586	641	5580000.00	2024-08-29	card
587	642	1100000.00	2024-08-26	qpay
588	643	1650000.00	2024-08-29	cash
589	644	1650000.00	2024-08-27	qpay
590	646	8520000.00	2024-08-27	qpay
591	647	2840000.00	2024-08-30	qpay
592	649	5680000.00	2024-09-01	qpay
593	650	5680000.00	2024-09-01	card
594	651	2840000.00	2024-09-02	qpay
595	653	7100000.00	2024-08-31	qpay
596	654	7100000.00	2024-09-01	qpay
597	655	1420000.00	2024-09-01	cash
598	656	8520000.00	2024-09-02	cash
599	657	4260000.00	2024-09-02	card
600	658	4260000.00	2024-09-03	qpay
601	660	4260000.00	2024-09-06	qpay
602	661	4260000.00	2024-09-07	cash
603	662	7100000.00	2024-09-07	card
604	663	740000.00	2024-09-07	qpay
605	664	740000.00	2024-09-08	qpay
606	665	1110000.00	2024-09-09	card
607	666	740000.00	2024-09-08	cash
608	668	370000.00	2024-09-11	card
609	669	1480000.00	2024-09-09	cash
610	670	740000.00	2024-09-13	cash
611	673	1480000.00	2024-09-11	card
612	674	740000.00	2024-09-14	cash
613	675	1850000.00	2024-09-11	cash
614	677	1110000.00	2024-09-11	cash
615	678	14820000.00	2024-09-14	card
616	679	9880000.00	2024-09-15	card
617	680	4940000.00	2024-09-15	card
618	681	9880000.00	2024-09-13	cash
619	682	4940000.00	2024-09-16	card
620	683	7410000.00	2024-09-15	qpay
621	684	9240000.00	2024-09-19	card
622	685	9880000.00	2024-09-17	cash
623	686	7410000.00	2024-09-16	qpay
624	687	3080000.00	2024-09-17	qpay
625	688	3080000.00	2024-09-19	qpay
626	689	12320000.00	2024-09-19	qpay
627	690	3540000.00	2024-09-21	qpay
628	691	3540000.00	2024-09-21	qpay
629	692	1770000.00	2024-09-22	card
630	693	3540000.00	2024-09-19	cash
631	694	10620000.00	2024-09-19	qpay
632	696	3540000.00	2024-09-20	card
633	697	8850000.00	2024-09-23	card
634	698	3540000.00	2024-09-23	qpay
635	701	3540000.00	2024-09-23	qpay
636	702	900000.00	2024-09-25	qpay
637	703	2250000.00	2024-09-23	qpay
638	704	1350000.00	2024-09-23	card
639	705	900000.00	2024-09-23	qpay
640	707	2250000.00	2024-09-24	cash
641	709	900000.00	2024-09-24	card
642	711	2250000.00	2024-09-28	cash
643	713	900000.00	2024-09-29	qpay
644	714	2250000.00	2024-09-28	cash
645	715	900000.00	2024-09-29	card
646	716	2440000.00	2024-09-29	qpay
647	717	6100000.00	2024-09-28	card
648	719	4880000.00	2024-10-02	card
649	720	2440000.00	2024-09-30	cash
650	721	2440000.00	2024-10-03	qpay
651	722	4880000.00	2024-10-10	cash
652	723	2440000.00	2024-10-12	qpay
653	724	3660000.00	2024-10-15	cash
654	725	2440000.00	2024-10-14	cash
655	726	3650000.00	2024-10-18	qpay
656	727	7300000.00	2024-10-18	cash
657	728	7300000.00	2024-10-15	card
658	729	2440000.00	2024-10-18	qpay
659	730	18250000.00	2024-10-21	card
660	732	2740000.00	2024-10-28	qpay
661	733	5480000.00	2024-10-29	qpay
662	734	4110000.00	2024-11-01	card
663	735	6850000.00	2024-10-29	qpay
664	736	1370000.00	2024-10-30	qpay
665	737	2740000.00	2024-11-02	cash
666	739	2740000.00	2024-11-02	cash
667	740	2740000.00	2024-11-05	qpay
668	741	2740000.00	2024-11-25	qpay
669	744	5480000.00	2024-12-04	cash
670	745	2740000.00	2024-12-05	qpay
671	746	6400000.00	2024-12-06	qpay
672	747	5120000.00	2024-12-06	qpay
673	748	3840000.00	2024-12-06	card
674	749	7680000.00	2024-12-09	card
675	750	1280000.00	2024-12-12	qpay
676	751	3840000.00	2024-12-11	qpay
677	752	2560000.00	2024-12-13	qpay
678	754	1280000.00	2024-12-12	cash
679	755	3840000.00	2024-12-14	cash
680	756	1280000.00	2024-12-16	qpay
681	757	14400000.00	2024-12-22	qpay
682	758	5760000.00	2024-12-24	qpay
683	759	17280000.00	2024-12-26	qpay
684	760	11520000.00	2024-12-28	qpay
685	761	5760000.00	2025-01-01	qpay
686	762	5760000.00	2024-12-31	card
687	763	2580000.00	2025-01-03	qpay
688	764	4300000.00	2025-01-04	qpay
689	765	860000.00	2025-01-04	qpay
690	766	3440000.00	2025-01-06	qpay
691	768	2580000.00	2025-01-07	qpay
692	769	2580000.00	2025-01-11	qpay
693	770	1720000.00	2025-01-15	qpay
694	771	2580000.00	2025-01-12	qpay
695	772	3440000.00	2025-01-15	qpay
696	773	4300000.00	2025-01-16	qpay
697	774	2580000.00	2025-01-16	qpay
698	776	5160000.00	2025-01-19	qpay
699	777	5600000.00	2025-01-19	qpay
700	778	4480000.00	2025-01-19	card
701	780	3360000.00	2025-01-23	card
702	781	6720000.00	2025-01-28	qpay
703	782	3360000.00	2025-01-28	cash
704	783	2240000.00	2025-01-31	qpay
705	785	5600000.00	2025-01-31	cash
706	786	4660000.00	2025-02-04	qpay
707	787	4660000.00	2025-02-10	qpay
708	788	4660000.00	2025-02-11	qpay
709	789	9320000.00	2025-02-16	qpay
710	790	6510000.00	2025-02-15	qpay
711	791	10850000.00	2025-02-17	cash
712	792	4340000.00	2025-02-15	card
713	793	13980000.00	2025-02-15	qpay
714	794	750000.00	2025-02-19	qpay
715	795	2250000.00	2025-02-19	card
716	796	2250000.00	2025-02-18	qpay
717	798	2250000.00	2025-02-22	card
718	799	3000000.00	2025-02-21	cash
719	800	750000.00	2025-02-27	cash
720	801	1500000.00	2025-03-03	qpay
721	802	4500000.00	2025-03-02	qpay
722	803	1500000.00	2025-03-04	card
723	804	4500000.00	2025-03-05	qpay
724	806	2460000.00	2025-03-12	qpay
725	808	4100000.00	2025-03-13	cash
726	809	2460000.00	2025-03-15	qpay
727	810	4920000.00	2025-03-17	qpay
728	811	820000.00	2025-03-19	qpay
729	812	1640000.00	2025-03-19	card
730	813	2460000.00	2025-03-20	card
731	814	2460000.00	2025-03-24	card
732	815	1640000.00	2025-03-24	card
733	816	9600000.00	2025-03-31	cash
734	817	4800000.00	2025-03-31	card
735	819	2840000.00	2025-04-02	card
736	821	1420000.00	2025-04-05	cash
737	822	4260000.00	2025-04-04	qpay
738	823	7100000.00	2025-04-06	cash
739	824	5680000.00	2025-04-06	card
740	825	4260000.00	2025-04-08	qpay
741	826	1420000.00	2025-04-05	cash
742	827	7100000.00	2025-04-06	card
743	828	1420000.00	2025-04-05	qpay
744	829	7100000.00	2025-04-08	card
745	830	7100000.00	2025-04-07	qpay
746	831	2840000.00	2025-04-09	card
747	832	5820000.00	2025-04-11	qpay
748	833	1940000.00	2025-04-11	qpay
749	834	5820000.00	2025-04-12	qpay
750	835	4260000.00	2025-04-11	qpay
751	836	5820000.00	2025-04-14	qpay
752	837	9700000.00	2025-04-15	qpay
753	838	7760000.00	2025-04-18	cash
754	839	7760000.00	2025-04-15	cash
755	840	5820000.00	2025-04-19	qpay
756	841	7760000.00	2025-04-19	qpay
757	842	5820000.00	2025-04-22	qpay
758	843	2080000.00	2025-04-21	card
759	844	4160000.00	2025-04-21	card
760	845	2080000.00	2025-04-22	qpay
761	846	2080000.00	2025-04-22	qpay
762	847	1040000.00	2025-04-20	card
763	848	1040000.00	2025-04-21	cash
764	849	2080000.00	2025-04-24	cash
765	850	1040000.00	2025-04-26	card
766	851	4160000.00	2025-04-26	card
767	852	2080000.00	2025-04-27	qpay
768	853	3120000.00	2025-04-27	card
769	854	2080000.00	2025-04-29	cash
770	855	3120000.00	2025-04-29	qpay
771	856	2080000.00	2025-04-30	qpay
772	857	1040000.00	2025-05-03	qpay
773	858	6240000.00	2025-05-04	qpay
774	859	1970000.00	2025-05-02	qpay
775	861	3940000.00	2025-05-03	qpay
776	862	7880000.00	2025-05-05	qpay
777	863	3940000.00	2025-05-07	cash
778	864	3940000.00	2025-05-05	qpay
779	865	11820000.00	2025-05-05	qpay
780	866	9850000.00	2025-05-05	card
781	867	5910000.00	2025-05-07	qpay
782	869	1980000.00	2025-05-11	qpay
783	871	2970000.00	2025-05-12	qpay
784	872	1980000.00	2025-05-14	card
785	873	2970000.00	2025-05-13	qpay
786	874	990000.00	2025-05-16	qpay
787	875	5940000.00	2025-05-16	qpay
788	876	1980000.00	2025-05-15	card
789	877	1980000.00	2025-05-14	card
790	878	5940000.00	2025-05-15	cash
791	879	15480000.00	2025-05-17	card
792	880	1980000.00	2025-05-16	qpay
793	881	990000.00	2025-05-17	qpay
794	882	10320000.00	2025-05-18	qpay
795	883	15480000.00	2025-05-20	cash
796	885	5160000.00	2025-05-20	card
797	886	7740000.00	2025-05-22	qpay
798	887	15480000.00	2025-05-20	cash
799	888	15480000.00	2025-05-20	qpay
800	889	4200000.00	2025-05-24	qpay
801	890	2580000.00	2025-05-21	cash
802	892	2520000.00	2025-05-30	card
803	893	4200000.00	2025-05-30	qpay
804	894	5040000.00	2025-05-31	qpay
805	896	5040000.00	2025-06-01	qpay
806	897	1680000.00	2025-06-01	card
807	898	3360000.00	2025-05-30	cash
808	899	2520000.00	2025-06-03	qpay
809	900	3960000.00	2025-06-03	cash
810	902	5940000.00	2025-06-02	cash
811	903	3960000.00	2025-06-02	qpay
812	904	1980000.00	2025-06-06	cash
813	905	2100000.00	2025-06-06	qpay
814	906	3150000.00	2025-06-06	card
815	907	2100000.00	2025-06-08	qpay
816	908	6300000.00	2025-06-08	cash
817	909	6300000.00	2025-06-09	card
818	910	2100000.00	2025-06-10	card
819	911	6300000.00	2025-06-13	qpay
820	912	1050000.00	2025-06-13	qpay
821	913	1050000.00	2025-06-12	qpay
822	914	6300000.00	2025-06-16	card
823	916	3150000.00	2025-06-13	cash
824	917	5250000.00	2025-06-15	qpay
825	918	6300000.00	2025-06-17	qpay
826	919	4200000.00	2025-06-15	card
827	920	2170000.00	2025-06-15	qpay
828	921	5250000.00	2025-06-18	qpay
829	922	8680000.00	2025-06-16	qpay
830	923	4340000.00	2025-06-18	card
831	924	2170000.00	2025-06-20	card
832	925	2170000.00	2025-06-20	card
833	926	10850000.00	2025-06-20	card
834	927	4340000.00	2025-06-20	qpay
835	928	8680000.00	2025-06-22	cash
836	929	2900000.00	2025-06-24	cash
837	930	1160000.00	2025-06-22	cash
838	931	3480000.00	2025-06-25	qpay
839	932	1740000.00	2025-06-28	cash
840	933	2900000.00	2025-06-29	cash
841	934	1160000.00	2025-06-26	qpay
842	935	1740000.00	2025-06-28	qpay
843	936	2900000.00	2025-06-30	cash
844	937	1920000.00	2025-06-29	qpay
845	938	1160000.00	2025-06-28	card
846	939	1740000.00	2025-07-01	cash
847	940	480000.00	2025-06-29	cash
848	942	960000.00	2025-07-03	cash
849	943	3990000.00	2025-07-03	qpay
850	944	960000.00	2025-07-03	qpay
851	948	5320000.00	2025-07-06	cash
852	949	3990000.00	2025-07-03	cash
853	950	2660000.00	2025-07-07	qpay
854	951	3990000.00	2025-07-07	card
855	952	3990000.00	2025-07-04	card
856	953	2660000.00	2025-07-04	cash
857	954	2660000.00	2025-07-04	card
858	956	7980000.00	2025-07-06	cash
859	957	2660000.00	2025-07-06	cash
860	958	2660000.00	2025-07-07	card
861	959	2660000.00	2025-07-08	qpay
862	960	3990000.00	2025-07-08	qpay
863	961	5760000.00	2025-07-11	qpay
864	962	4320000.00	2025-07-09	qpay
865	963	5760000.00	2025-07-09	qpay
866	964	1440000.00	2025-07-11	qpay
867	965	5760000.00	2025-07-08	card
868	966	2880000.00	2025-07-09	cash
869	967	1440000.00	2025-07-09	qpay
870	968	1440000.00	2025-07-10	cash
871	969	5760000.00	2025-07-11	qpay
872	970	7200000.00	2025-07-13	qpay
873	971	8640000.00	2025-07-13	qpay
874	972	8640000.00	2025-07-13	card
875	973	10620000.00	2025-07-12	card
876	974	3540000.00	2025-07-13	card
877	975	3540000.00	2025-07-14	qpay
878	976	5760000.00	2025-07-12	qpay
879	977	960000.00	2025-07-16	qpay
880	978	1440000.00	2025-07-13	qpay
881	979	2400000.00	2025-07-15	card
882	980	2400000.00	2025-07-19	qpay
883	981	960000.00	2025-07-17	card
884	982	1440000.00	2025-07-18	cash
885	984	960000.00	2025-07-20	card
886	985	960000.00	2025-07-18	qpay
887	986	2760000.00	2025-07-21	cash
888	987	1380000.00	2025-07-21	cash
889	988	4720000.00	2025-07-21	qpay
890	989	2360000.00	2025-07-21	qpay
891	990	5900000.00	2025-07-21	qpay
892	991	2360000.00	2025-07-23	qpay
893	992	3540000.00	2025-07-21	card
894	994	2360000.00	2025-07-21	card
895	995	7080000.00	2025-07-25	qpay
896	996	7080000.00	2025-07-25	qpay
897	997	14160000.00	2025-07-23	qpay
898	998	4720000.00	2025-07-26	cash
899	999	4720000.00	2025-07-24	card
900	1000	11800000.00	2025-07-25	qpay
901	1001	9440000.00	2025-07-27	card
902	1002	8950000.00	2025-07-25	cash
903	1003	3580000.00	2025-07-27	card
904	1004	8950000.00	2025-07-27	cash
905	1005	8950000.00	2025-07-28	qpay
906	1006	7160000.00	2025-07-27	card
907	1007	5370000.00	2025-07-29	qpay
908	1008	7160000.00	2025-07-27	qpay
909	1009	2340000.00	2025-07-30	qpay
910	1010	4680000.00	2025-07-31	card
911	1011	3580000.00	2025-07-29	card
912	1012	5370000.00	2025-07-31	qpay
913	1013	4680000.00	2025-07-31	qpay
914	1014	7020000.00	2025-08-02	qpay
915	1015	2340000.00	2025-07-30	qpay
916	1016	5850000.00	2025-08-03	qpay
917	1017	2340000.00	2025-07-31	qpay
918	1018	5850000.00	2025-07-31	cash
919	1019	2730000.00	2025-08-04	qpay
920	1020	1170000.00	2025-08-02	cash
921	1021	2340000.00	2025-08-04	card
922	1022	1820000.00	2025-08-03	qpay
923	1023	1820000.00	2025-08-02	qpay
924	1024	1820000.00	2025-08-03	cash
925	1025	1820000.00	2025-08-03	qpay
926	1026	2730000.00	2025-08-03	qpay
927	1028	2730000.00	2025-08-04	qpay
928	1029	1820000.00	2025-08-05	cash
929	1030	1820000.00	2025-08-07	cash
930	1031	1820000.00	2025-08-08	card
931	1033	1820000.00	2025-08-07	qpay
932	1034	1820000.00	2025-08-10	card
933	1035	3600000.00	2025-08-10	card
934	1036	1800000.00	2025-08-08	cash
935	1037	9000000.00	2025-08-11	card
936	1038	3600000.00	2025-08-09	qpay
937	1039	5400000.00	2025-08-10	qpay
938	1040	5400000.00	2025-08-13	qpay
939	1041	9000000.00	2025-08-11	card
940	1042	2920000.00	2025-08-11	card
941	1043	3600000.00	2025-08-13	qpay
942	1045	3600000.00	2025-08-11	qpay
943	1046	3600000.00	2025-08-11	card
944	1047	2920000.00	2025-08-12	card
945	1048	2920000.00	2025-08-15	cash
946	1049	4380000.00	2025-08-13	card
947	1050	7300000.00	2025-08-15	cash
948	1051	5840000.00	2025-08-16	qpay
949	1052	1460000.00	2025-08-16	card
950	1054	4380000.00	2025-08-16	cash
951	1055	800000.00	2025-08-15	card
952	1056	2400000.00	2025-08-17	qpay
953	1057	1200000.00	2025-08-16	qpay
954	1058	800000.00	2025-08-14	card
955	1059	1200000.00	2025-08-16	qpay
956	1060	800000.00	2025-08-14	cash
957	1061	800000.00	2025-08-17	card
958	1062	1200000.00	2025-08-18	cash
959	1063	2400000.00	2025-08-18	card
960	1064	10080000.00	2025-08-19	card
961	1065	2000000.00	2025-08-18	qpay
962	1066	800000.00	2025-08-19	qpay
963	1067	800000.00	2025-08-19	card
964	1068	5040000.00	2025-08-17	card
965	1069	1680000.00	2025-08-18	qpay
966	1070	1680000.00	2025-08-18	qpay
967	1071	3360000.00	2025-08-19	qpay
968	1072	8400000.00	2025-08-22	qpay
969	1073	4820000.00	2025-08-23	card
970	1075	8400000.00	2025-08-23	qpay
971	1076	8490000.00	2025-08-24	card
972	1077	5660000.00	2025-08-21	card
973	1078	16980000.00	2025-08-24	card
974	1079	8490000.00	2025-08-22	cash
975	1080	14460000.00	2025-08-24	qpay
976	1081	4950000.00	2025-08-26	qpay
977	1082	5940000.00	2025-08-25	cash
978	1083	2970000.00	2025-08-26	cash
979	1084	990000.00	2025-08-26	card
980	1087	3960000.00	2025-08-28	qpay
981	1088	1980000.00	2025-08-30	qpay
982	1089	1980000.00	2025-08-31	cash
983	1090	3140000.00	2025-08-28	qpay
984	1092	3140000.00	2025-09-01	qpay
985	1093	4710000.00	2025-08-31	qpay
986	1094	4710000.00	2025-09-01	qpay
987	1095	1570000.00	2025-08-31	qpay
988	1096	7850000.00	2025-09-04	card
989	1097	1570000.00	2025-09-02	card
990	1098	7850000.00	2025-09-03	card
991	1100	4620000.00	2025-09-04	card
992	1101	3080000.00	2025-09-03	cash
993	1102	3080000.00	2025-09-03	qpay
994	1103	3080000.00	2025-09-06	cash
995	1104	6160000.00	2025-09-08	qpay
996	1106	9240000.00	2025-09-06	cash
997	1107	3080000.00	2025-09-09	cash
998	1108	1540000.00	2025-09-08	card
999	1109	3600000.00	2025-09-09	qpay
1000	1110	3600000.00	2025-09-09	qpay
1001	1111	2400000.00	2025-09-10	qpay
1002	1112	2400000.00	2025-09-10	qpay
1003	1113	6000000.00	2025-09-09	card
1004	1114	6000000.00	2025-09-11	qpay
1005	1115	4800000.00	2025-09-11	cash
1006	1116	7200000.00	2025-09-12	cash
1007	1117	2400000.00	2025-09-10	cash
1008	1119	2400000.00	2025-09-11	qpay
1009	1120	3600000.00	2025-09-14	cash
1010	1121	1480000.00	2025-09-14	card
1011	1122	2220000.00	2025-09-14	qpay
1012	1124	1110000.00	2025-09-15	cash
1013	1125	740000.00	2025-09-13	qpay
1014	1126	1850000.00	2025-09-15	qpay
1015	1127	740000.00	2025-09-16	cash
1016	1129	1850000.00	2025-09-16	qpay
1017	1130	740000.00	2025-09-16	qpay
1018	1131	1850000.00	2025-09-18	card
1019	1132	740000.00	2025-09-19	card
1020	1133	1110000.00	2025-09-18	card
1021	1135	740000.00	2025-09-19	qpay
1022	1136	2220000.00	2025-09-18	qpay
1023	1137	5080000.00	2025-09-19	qpay
1024	1138	12700000.00	2025-09-21	card
1025	1139	5080000.00	2025-09-21	qpay
1026	1140	7620000.00	2025-09-20	cash
1027	1141	7620000.00	2025-09-22	qpay
1028	1143	5080000.00	2025-09-22	card
1029	1144	5080000.00	2025-09-21	cash
1030	1145	5080000.00	2025-09-20	qpay
1031	1146	5780000.00	2025-09-21	cash
1032	1147	8670000.00	2025-09-23	cash
1033	1149	15240000.00	2025-09-23	card
1034	1150	8670000.00	2025-09-25	card
1035	1151	17340000.00	2025-09-22	qpay
1036	1152	5780000.00	2025-09-22	cash
1037	1153	2890000.00	2025-09-22	cash
1038	1154	9300000.00	2025-09-26	card
1039	1155	3100000.00	2025-09-23	qpay
1040	1156	5780000.00	2025-09-26	qpay
1041	1157	2890000.00	2025-09-26	cash
1042	1158	3100000.00	2025-09-26	cash
1043	1159	1550000.00	2025-09-25	qpay
1044	1160	7750000.00	2025-09-25	qpay
1045	1161	4650000.00	2025-09-28	cash
1046	1162	6200000.00	2025-09-27	card
1047	1163	1550000.00	2025-09-27	qpay
1048	1166	8480000.00	2025-10-01	card
1049	1167	12720000.00	2025-10-02	qpay
1050	1168	4240000.00	2025-09-29	cash
1051	1169	6360000.00	2025-09-30	qpay
1052	1170	6360000.00	2025-10-01	cash
1053	1171	4240000.00	2025-10-02	qpay
1054	1172	12720000.00	2025-10-06	cash
1055	1173	6360000.00	2025-10-07	card
1056	1174	7360000.00	2025-10-07	cash
1057	1175	9200000.00	2025-10-09	card
1058	1176	3680000.00	2025-10-09	qpay
1059	1177	3680000.00	2025-10-13	qpay
1060	1178	3680000.00	2025-10-16	card
1061	1179	5520000.00	2025-10-19	qpay
1062	1180	3680000.00	2025-10-19	card
1063	1181	2280000.00	2025-10-21	cash
1064	1182	5520000.00	2025-10-22	qpay
1065	1183	4560000.00	2025-10-25	card
1066	1184	6840000.00	2025-10-30	card
1067	1185	6840000.00	2025-10-30	qpay
1068	1187	2280000.00	2025-10-29	card
1069	1188	3420000.00	2025-10-31	card
1070	1189	2280000.00	2025-10-30	qpay
1071	1190	2280000.00	2025-10-31	qpay
1072	1191	3420000.00	2025-11-04	qpay
1073	1192	3420000.00	2025-11-05	card
1074	1193	2280000.00	2025-11-04	qpay
1075	1194	2280000.00	2025-11-05	qpay
1076	1195	3420000.00	2025-11-05	qpay
1077	1197	6630000.00	2025-11-09	cash
1078	1198	6630000.00	2025-11-08	qpay
1079	1199	6840000.00	2025-11-10	card
1080	1200	11050000.00	2025-11-10	qpay
1081	1201	6630000.00	2025-11-13	cash
1082	1202	4640000.00	2025-11-14	card
1083	1203	6960000.00	2025-11-15	card
1084	1204	13920000.00	2025-11-18	cash
1085	1205	4640000.00	2025-11-25	qpay
1086	1206	6960000.00	2025-11-28	card
1087	1207	4640000.00	2025-11-26	card
1088	1208	13920000.00	2025-11-29	qpay
1089	1209	4640000.00	2025-11-30	cash
1090	1210	13920000.00	2025-12-03	cash
1091	1211	4640000.00	2025-12-04	card
1092	1212	13920000.00	2025-12-03	cash
1093	1213	6960000.00	2025-12-14	cash
1094	1215	11600000.00	2025-12-18	cash
1095	1216	4640000.00	2025-12-21	qpay
1096	1217	8340000.00	2025-12-24	card
1097	1219	4170000.00	2025-12-28	qpay
1098	1220	4170000.00	2025-12-30	card
\.


--
-- Data for Name: tours; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tours (tour_id, name, destination, days, price, start_date, guide_id) FROM stdin;
1	Хөвсгөлийн аялал	Хөвсгөл	5	1250000.00	2027-07-10	1
2	Говийн аялал	Өмнөговь	7	1800000.00	2027-08-01	2
3	Тэрэлжийн амралт	Төв	2	450000.00	2027-06-15	1
4	Алтайн экспедиц	Баян-Өлгий	10	2900000.00	2027-07-20	3
5	Хархорины түүх	Өвөрхангай	3	650000.00	2027-06-25	3
6	Мөсөн баяр	Хөвсгөл	4	1100000.00	2027-03-01	\N
7	Төв: гэрэл зургийн аялал	Төв	10	1940000.00	2025-05-24	74
8	Хөвсгөл: гэрэл зургийн аялал	Хөвсгөл	4	910000.00	2025-08-29	10
9	Хөвсгөл: майхан кемп	Хөвсгөл	12	2320000.00	2026-01-02	34
10	Өвөрхангай: загасчлал	Өвөрхангай	3	570000.00	2023-10-08	44
11	Хэнтий: майхан кемп	Хэнтий	6	1170000.00	2025-08-08	6
12	Төв: гэрэл зургийн аялал	Төв	6	790000.00	2024-08-31	26
13	Өвөрхангай: гэрэл зургийн аялал	Өвөрхангай	10	2170000.00	2025-07-27	38
14	Архангай: морин аялал	Архангай	2	500000.00	2023-10-18	5
15	Хөвсгөл: од ажиглалт	Хөвсгөл	10	2410000.00	2025-09-27	25
16	Өмнөговь: наадам аялал	Өмнөговь	12	3650000.00	2024-11-27	56
17	Завхан: гэр бүлийн амралт	Завхан	10	2820000.00	2023-09-07	51
18	Баян-Өлгий: дугуйн аялал	Баян-Өлгий	7	1810000.00	2023-04-22	113
19	Төв: наадам аялал	Төв	8	1590000.00	2023-10-30	7
20	Өвөрхангай: наадам аялал	Өвөрхангай	8	1330000.00	2025-08-14	11
21	Хэнтий: морин аялал	Хэнтий	10	1980000.00	2025-06-12	37
22	Завхан: морин аялал	Завхан	4	840000.00	2025-07-09	58
23	Өвөрхангай: гэрэл зургийн аялал	Өвөрхангай	7	1640000.00	2023-12-13	71
24	Баян-Өлгий: нүүдэлчдийн амьдрал	Баян-Өлгий	7	1790000.00	2025-09-05	43
25	Өмнөговь: морин аялал	Өмнөговь	9	2170000.00	2025-02-26	84
26	Өмнөговь: нүүдэлчдийн амьдрал	Өмнөговь	6	1820000.00	2023-03-24	19
27	Увс: экспедиц	Увс	2	530000.00	2024-05-29	39
28	Дорнод: экспедиц	Дорнод	4	920000.00	2023-08-30	92
29	Хэнтий: наадам аялал	Хэнтий	7	1420000.00	2025-04-22	64
30	Төв: загасчлал	Төв	2	370000.00	2025-09-24	92
31	Хэнтий: морин аялал	Хэнтий	10	1550000.00	2025-11-04	68
32	Увс: гэр бүлийн амралт	Увс	12	3990000.00	2025-08-30	83
33	Өмнөговь: од ажиглалт	Өмнөговь	2	430000.00	2024-07-06	82
34	Дорнод: загасчлал	Дорнод	2	450000.00	2024-10-22	81
35	Баян-Өлгий: загасчлал	Баян-Өлгий	9	2400000.00	2025-04-11	59
36	Дорнод: дугуйн аялал	Дорнод	3	690000.00	2025-08-20	9
37	Завхан: гэр бүлийн амралт	Завхан	6	1680000.00	2025-09-18	109
38	Баян-Өлгий: нүүдэлчдийн амьдрал	Баян-Өлгий	12	4310000.00	2023-08-17	64
39	Өмнөговь: наадам аялал	Өмнөговь	9	2830000.00	2023-11-29	37
40	Баян-Өлгий: гэрэл зургийн аялал	Баян-Өлгий	3	930000.00	2024-09-26	43
41	Өвөрхангай: наадам аялал	Өвөрхангай	11	2210000.00	2025-12-14	2
42	Өмнөговь: дугуйн аялал	Өмнөговь	5	1440000.00	2023-02-24	38
43	Дорнод: загасчлал	Дорнод	6	1270000.00	2024-07-30	60
44	Баян-Өлгий: од ажиглалт	Баян-Өлгий	6	2160000.00	2023-07-12	120
45	Хөвсгөл: гэрэл зургийн аялал	Хөвсгөл	6	1390000.00	2026-02-01	105
46	Хэнтий: гэр бүлийн амралт	Хэнтий	5	1090000.00	2023-07-26	120
47	Өмнөговь: соёлын аялал	Өмнөговь	11	2400000.00	2024-10-05	96
48	Увс: майхан кемп	Увс	12	3330000.00	2024-08-09	114
49	Архангай: морин аялал	Архангай	5	1020000.00	2024-07-27	113
50	Завхан: дугуйн аялал	Завхан	12	2890000.00	2025-10-13	39
51	Төв: явган аялал	Төв	8	1220000.00	2024-11-17	41
52	Архангай: гэр бүлийн амралт	Архангай	8	1370000.00	2025-01-02	119
53	Хөвсгөл: экспедиц	Хөвсгөл	6	1260000.00	2024-08-08	9
54	Өмнөговь: гэрэл зургийн аялал	Өмнөговь	7	2210000.00	2024-06-19	97
55	Хөвсгөл: соёлын аялал	Хөвсгөл	6	1170000.00	2024-03-23	107
56	Баян-Өлгий: гэр бүлийн амралт	Баян-Өлгий	6	1730000.00	2023-01-22	41
57	Архангай: загасчлал	Архангай	8	1920000.00	2024-03-06	104
58	Дорнод: дугуйн аялал	Дорнод	5	1180000.00	2024-04-07	7
59	Хэнтий: морин аялал	Хэнтий	9	1740000.00	2024-09-12	18
60	Дорнод: явган аялал	Дорнод	4	740000.00	2023-05-19	54
61	Өвөрхангай: наадам аялал	Өвөрхангай	6	1040000.00	2025-06-01	95
62	Баян-Өлгий: нүүдэлчдийн амьдрал	Баян-Өлгий	6	1770000.00	2025-07-23	86
63	Өмнөговь: од ажиглалт	Өмнөговь	4	1130000.00	2023-10-03	10
64	Дорнод: од ажиглалт	Дорнод	5	1050000.00	2023-09-21	43
65	Хэнтий: майхан кемп	Хэнтий	4	750000.00	2024-08-07	32
66	Архангай: экспедиц	Архангай	5	970000.00	2023-11-18	104
67	Баян-Өлгий: гэр бүлийн амралт	Баян-Өлгий	2	660000.00	2023-08-25	53
68	Хэнтий: од ажиглалт	Хэнтий	6	1030000.00	2024-05-18	8
69	Өвөрхангай: гэр бүлийн амралт	Өвөрхангай	11	2580000.00	2025-06-23	17
70	Өмнөговь: нүүдэлчдийн амьдрал	Өмнөговь	6	1880000.00	2024-11-17	50
71	Завхан: соёлын аялал	Завхан	8	2360000.00	2025-08-08	109
72	Хөвсгөл: од ажиглалт	Хөвсгөл	8	2060000.00	2024-08-19	115
73	Увс: загасчлал	Увс	9	1940000.00	2023-10-24	51
74	Завхан: гэр бүлийн амралт	Завхан	9	1970000.00	2025-06-08	14
75	Төв: дугуйн аялал	Төв	4	660000.00	2023-05-09	88
76	Завхан: морин аялал	Завхан	3	750000.00	2025-03-24	6
77	Төв: соёлын аялал	Төв	5	840000.00	2023-07-30	5
78	Өвөрхангай: майхан кемп	Өвөрхангай	10	2060000.00	2024-03-02	90
79	Өмнөговь: экспедиц	Өмнөговь	3	730000.00	2023-06-28	75
80	Хөвсгөл: гэрэл зургийн аялал	Хөвсгөл	2	480000.00	2025-08-22	59
81	Архангай: гэр бүлийн амралт	Архангай	12	2830000.00	2025-09-21	32
82	Хөвсгөл: морин аялал	Хөвсгөл	8	2060000.00	2024-08-07	40
83	Хөвсгөл: гэр бүлийн амралт	Хөвсгөл	5	1180000.00	2025-08-28	87
84	Хэнтий: дугуйн аялал	Хэнтий	7	1140000.00	2025-11-18	5
85	Архангай: дугуйн аялал	Архангай	8	1540000.00	2023-04-14	51
86	Дорнод: гэрэл зургийн аялал	Дорнод	3	560000.00	2024-08-14	26
87	Баян-Өлгий: экспедиц	Баян-Өлгий	5	1460000.00	2025-09-14	34
88	Завхан: од ажиглалт	Завхан	11	2330000.00	2025-03-17	29
89	Хэнтий: гэр бүлийн амралт	Хэнтий	12	1780000.00	2024-05-10	77
90	Хөвсгөл: дугуйн аялал	Хөвсгөл	11	2190000.00	2023-08-23	7
91	Хөвсгөл: майхан кемп	Хөвсгөл	4	900000.00	2024-06-10	115
92	Өмнөговь: наадам аялал	Өмнөговь	4	990000.00	2025-09-11	24
93	Дорнод: явган аялал	Дорнод	9	1540000.00	2025-09-28	86
94	Завхан: гэрэл зургийн аялал	Завхан	4	820000.00	2025-04-18	11
95	Өмнөговь: гэр бүлийн амралт	Өмнөговь	7	1800000.00	2025-08-30	114
96	Хэнтий: нүүдэлчдийн амьдрал	Хэнтий	7	1440000.00	2025-07-30	40
97	Өмнөговь: гэр бүлийн амралт	Өмнөговь	2	580000.00	2023-03-17	26
98	Архангай: морин аялал	Архангай	7	1580000.00	2023-06-25	61
99	Хэнтий: од ажиглалт	Хэнтий	5	1050000.00	2024-06-02	99
100	Өмнөговь: майхан кемп	Өмнөговь	2	480000.00	2025-08-04	96
101	Увс: гэрэл зургийн аялал	Увс	7	1820000.00	2023-07-28	43
102	Архангай: экспедиц	Архангай	6	1120000.00	2025-02-19	93
103	Өмнөговь: нүүдэлчдийн амьдрал	Өмнөговь	2	610000.00	2023-10-12	14
104	Өвөрхангай: од ажиглалт	Өвөрхангай	8	1770000.00	2024-09-30	17
105	Төв: соёлын аялал	Төв	2	370000.00	2024-10-16	95
106	Увс: од ажиглалт	Увс	5	1280000.00	2024-02-03	41
107	Архангай: нүүдэлчдийн амьдрал	Архангай	11	1840000.00	2023-09-06	26
108	Өмнөговь: загасчлал	Өмнөговь	12	2540000.00	2025-10-04	71
109	Архангай: экспедиц	Архангай	4	990000.00	2024-06-10	114
110	Өмнөговь: дугуйн аялал	Өмнөговь	5	1100000.00	2023-07-13	64
111	Завхан: гэр бүлийн амралт	Завхан	4	870000.00	2023-12-24	54
112	Дорнод: гэрэл зургийн аялал	Дорнод	12	2880000.00	2025-01-30	100
113	Өвөрхангай: од ажиглалт	Өвөрхангай	6	1200000.00	2025-09-22	48
114	Баян-Өлгий: гэрэл зургийн аялал	Баян-Өлгий	4	1060000.00	2024-01-24	20
115	Увс: загасчлал	Увс	5	1280000.00	2024-09-14	51
116	Баян-Өлгий: од ажиглалт	Баян-Өлгий	12	4050000.00	2024-12-19	84
117	Хөвсгөл: явган аялал	Хөвсгөл	3	550000.00	2024-09-20	114
118	Хөвсгөл: гэр бүлийн амралт	Хөвсгөл	6	1250000.00	2023-03-19	7
119	Увс: од ажиглалт	Увс	11	2640000.00	2023-06-21	10
120	Увс: морин аялал	Увс	6	1860000.00	2024-07-08	86
121	Өмнөговь: явган аялал	Өмнөговь	12	3330000.00	2023-06-29	80
122	Төв: морин аялал	Төв	2	290000.00	2023-09-03	33
123	Увс: наадам аялал	Увс	12	3920000.00	2023-07-21	105
124	Архангай: гэр бүлийн амралт	Архангай	4	860000.00	2025-01-31	10
125	Хөвсгөл: наадам аялал	Хөвсгөл	9	2170000.00	2024-06-04	9
126	Дорнод: наадам аялал	Дорнод	4	910000.00	2023-04-30	12
127	Төв: нүүдэлчдийн амьдрал	Төв	8	1420000.00	2024-09-14	53
128	Хөвсгөл: явган аялал	Хөвсгөл	6	1570000.00	2024-06-28	114
129	Хэнтий: гэр бүлийн амралт	Хэнтий	8	1160000.00	2023-09-09	99
130	Хэнтий: нүүдэлчдийн амьдрал	Хэнтий	8	1280000.00	2025-01-06	1
131	Төв: од ажиглалт	Төв	8	1090000.00	2024-08-30	12
132	Төв: соёлын аялал	Төв	4	520000.00	2023-07-28	71
133	Хэнтий: соёлын аялал	Хэнтий	3	570000.00	2024-06-16	119
134	Архангай: майхан кемп	Архангай	6	1050000.00	2025-06-28	22
135	Өмнөговь: гэрэл зургийн аялал	Өмнөговь	8	2120000.00	2025-11-01	104
136	Төв: явган аялал	Төв	2	400000.00	2025-08-25	62
137	Хөвсгөл: дугуйн аялал	Хөвсгөл	11	3080000.00	2024-10-17	50
138	Төв: экспедиц	Төв	12	2210000.00	2024-09-23	29
139	Хэнтий: морин аялал	Хэнтий	11	2340000.00	2023-03-03	107
140	Хэнтий: майхан кемп	Хэнтий	10	1570000.00	2025-09-14	46
141	Төв: загасчлал	Төв	5	990000.00	2025-06-25	105
142	Хөвсгөл: нүүдэлчдийн амьдрал	Хөвсгөл	12	3250000.00	2023-08-01	16
143	Увс: гэрэл зургийн аялал	Увс	9	2550000.00	2024-04-30	81
144	Увс: явган аялал	Увс	5	1340000.00	2023-08-15	85
145	Завхан: од ажиглалт	Завхан	10	2390000.00	2024-07-17	3
146	Баян-Өлгий: од ажиглалт	Баян-Өлгий	9	2980000.00	2024-12-26	100
147	Төв: майхан кемп	Төв	9	1410000.00	2024-08-31	9
148	Завхан: морин аялал	Завхан	10	2470000.00	2024-10-17	6
149	Төв: морин аялал	Төв	3	580000.00	2025-08-01	41
150	Дорнод: соёлын аялал	Дорнод	8	1840000.00	2025-11-27	101
\.


--
-- Name: admins_admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.admins_admin_id_seq', 1, true);


--
-- Name: bookings_booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bookings_booking_id_seq', 1234, true);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 503, true);


--
-- Name: guides_guide_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.guides_guide_id_seq', 123, true);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1098, true);


--
-- Name: tours_tour_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tours_tour_id_seq', 153, true);


--
-- Name: admins admins_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (admin_id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (booking_id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: guides guides_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guides
    ADD CONSTRAINT guides_pkey PRIMARY KEY (guide_id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: tours tours_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tours
    ADD CONSTRAINT tours_pkey PRIMARY KEY (tour_id);


--
-- Name: bookings bookings_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: bookings bookings_tour_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_tour_id_fkey FOREIGN KEY (tour_id) REFERENCES public.tours(tour_id);


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id);


--
-- Name: tours tours_guide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tours
    ADD CONSTRAINT tours_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.guides(guide_id);


--
-- PostgreSQL database dump complete
--


