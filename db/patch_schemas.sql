BEGIN;

DROP TABLE IF EXISTS song_languages;
CREATE TABLE song_languages (
    sn          INTEGER PRIMARY KEY,
    name        TEXT,
    priority    INTEGER,
    deleted     INTEGER
    );

DROP TABLE IF EXISTS song_categories;
CREATE TABLE song_categories (
    sn          INTEGER PRIMARY KEY,
    name        TEXT,
    priority    INTEGER,
    deleted     INTEGER
    );

DROP TABLE IF EXISTS artist_countries;
CREATE TABLE artist_countries (
    sn          INTEGER PRIMARY KEY,
    name        TEXT,
    priority    INTEGER,
    deleted     INTEGER
    );

DROP TABLE IF EXISTS artist_categories;
CREATE TABLE artist_categories (
    sn          INTEGER PRIMARY KEY,
    name        TEXT,
    priority    INTEGER,
    deleted     INTEGER
    );

DROP TABLE IF EXISTS songs;
CREATE TABLE songs(
    sn                  INTEGER PRIMARY KEY,
    name                TEXT,
    fuzzy_name          TEXT,
    word_count          INTEGER,
    kjbcode             TEXT,
    language            INTEGER,
    category            INTEGER,
    artist_sn           INTEGER,
    artist_name         TEXT,
    artist_fuzzy_name   TEXT,
    loudness            INTEGER,
    vocal_channel       INTEGER,
    deleted             INTEGER
    );

DROP TABLE IF EXISTS artists;
CREATE TABLE artists(
    sn          INTEGER PRIMARY KEY,
    name        TEXT,
    fuzzy_name  TEXT,
    word_count  INTEGER,
    category    INTEGER,
    country     INTEGER,
    deleted     INTEGER
    );

DROP TABLE IF EXISTS versions;
CREATE TABLE versions (
    name  TEXT PRIMARY KEY,
    major INTEGER,
    minor INTEGER,
    patch INTEGER
);

COMMIT;
