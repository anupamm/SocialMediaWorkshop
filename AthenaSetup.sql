#1 : Creating the database

create database socialanalyticsblog;

--------------------------
#2 : Create Raw Data Table

CREATE EXTERNAL TABLE socialanalyticsblog.tweets (
	coordinates STRUCT<
		type: STRING,
		coordinates: ARRAY<
			DOUBLE
		>
	>,
	retweeted BOOLEAN,
	source STRING,
	entities STRUCT<
		hashtags: ARRAY<
			STRUCT<
				text: STRING,
				indices: ARRAY<
					BIGINT
				>
			>
		>,
		urls: ARRAY<
			STRUCT<
				url: STRING,
				expanded_url: STRING,
				display_url: STRING,
				indices: ARRAY<
					BIGINT
				>
			>
		>
	>,
	reply_count BIGINT,
	favorite_count BIGINT,
	geo STRUCT<
		type: STRING,
		coordinates: ARRAY<
			DOUBLE
		>
	>,
	id_str STRING,
	timestamp_ms BIGINT,
	truncated BOOLEAN,
	text STRING,
	retweet_count BIGINT,
	id BIGINT,
	possibly_sensitive BOOLEAN,
	filter_level STRING,
	created_at STRING,
	place STRUCT<
		id: STRING,
		url: STRING,
		place_type: STRING,
		name: STRING,
		full_name: STRING,
		country_code: STRING,
		country: STRING,
		bounding_box: STRUCT<
			type: STRING,
			coordinates: ARRAY<
				ARRAY<
					ARRAY<
						FLOAT
					>
				>
			>
		>
	>,
	favorited BOOLEAN,
	lang STRING,
	in_reply_to_screen_name STRING,
	is_quote_status BOOLEAN,
	in_reply_to_user_id_str STRING,
	user STRUCT<
		id: BIGINT,
		id_str: STRING,
		name: STRING,
		screen_name: STRING,
		location: STRING,
		url: STRING,
		description: STRING,
		translator_type: STRING,
		protected: BOOLEAN,
		verified: BOOLEAN,
		followers_count: BIGINT,
		friends_count: BIGINT,
		listed_count: BIGINT,
		favourites_count: BIGINT,
		statuses_count: BIGINT,
		created_at: STRING,
		utc_offset: BIGINT,
		time_zone: STRING,
		geo_enabled: BOOLEAN,
		lang: STRING,
		contributors_enabled: BOOLEAN,
		is_translator: BOOLEAN,
		profile_background_color: STRING,
		profile_background_image_url: STRING,
		profile_background_image_url_https: STRING,
		profile_background_tile: BOOLEAN,
		profile_link_color: STRING,
		profile_sidebar_border_color: STRING,
		profile_sidebar_fill_color: STRING,
		profile_text_color: STRING,
		profile_use_background_image: BOOLEAN,
		profile_image_url: STRING,
		profile_image_url_https: STRING,
		profile_banner_url: STRING,
		default_profile: BOOLEAN,
		default_profile_image: BOOLEAN
	>,
	quote_count BIGINT
) ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION '<TwitterRawLocation>';

-----------------
#3 Create Tweet Entities Table

CREATE EXTERNAL TABLE socialanalyticsblog.tweet_entities (
	tweetid BIGINT,
	entity STRING,
	type STRING,
	score DOUBLE
) ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION '<TwitterEntitiesLocation>';


-----------------
#4 Create Tweet Entities Table

CREATE EXTERNAL TABLE socialanalyticsblog.tweet_sentiments (
	tweetid BIGINT,
	text STRING,
	originalText STRING,
	sentiment STRING,
	sentimentPosScore DOUBLE,
	sentimentNegScore DOUBLE,
	sentimentNeuScore DOUBLE,
	sentimentMixedScore DOUBLE
) ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION '<TwitterSentimentLocation>'


-----------------
#5 Select Tweets

select * from socialanalyticsblog.tweets limit 20;

-----------------
#6 Select Tweet Entities

select type, count(*) cnt from socialanalyticsblog.tweet_entities
group by type order by cnt desc


-----------------
#7 Select Top Commercial Items

select entity, type, count(*) cnt from socialanalyticsblog.tweet_entities
where type = 'COMMERCIAL_ITEM'
group by entity, type order by cnt desc limit 20;

-----------------
#8 Select Top positive Sentiment Tweets 

select * from socialanalyticsblog.tweet_sentiments where sentiment = 'POSITIVE' limit 20;

-----------------
#9 Select Languages of Tweets 

select lang, count(*) cnt from socialanalyticsblog.tweets group by lang order by cnt desc


-----------------
#10 Select German language tweets referring to Shoes

select ts.text, ts.originaltext from socialanalyticsblog.tweet_sentiments ts
join socialanalyticsblog.tweets t on (ts.tweetid = t.id)
where lang = 'de' and ts.text like '%Shoe%'


