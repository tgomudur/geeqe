CREATE TABLE badge
(
    id INT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(40) NULL,
    created TIMESTAMP
);

CREATE TABLE comment
(
    id INT NOT NULL PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    score INT NULL,
    comment_text text NULL,
    created TIMESTAMP
);

CREATE INDEX comment_post_idx ON comment(post_id);

CREATE TABLE vote
(
    id INT NOT NULL PRIMARY KEY,
    post_id INT NOT NULL,
    vote_type_id INT NOT NULL,
    created TIMESTAMP
);

CREATE TABLE so_user
(
    id INT NOT NULL PRIMARY KEY,
    reputation INT NOT NULL,
    display_name VARCHAR(40) NULL,
    last_access_date TIMESTAMP,
    website_url VARCHAR(256) NULL,
    location VARCHAR(256) NULL,
    age INT NOT NULL,
    about_me text NULL,
    views INT NOT NULL,
    up_votes INT NOT NULL,
    down_votes INT NOT NULL,
    gravatar_hash VARCHAR(256),
    gold_badge_count INT,
    silver_badge_count INT,
    bronze_badge_count INT,
    created TIMESTAMP
);


CREATE TABLE tag
(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(256) NOT NULL
);

CREATE INDEX tag_name_idx ON tag(name);

CREATE TABLE post
(
    id INT NOT NULL PRIMARY KEY,
    post_type_id INT NOT NULL,
    accepted_answer_id INT,
    parent_id INT,
    score INT NULL,
    view_count INT NULL,
    body_text text NULL,
    owner_id INT NOT NULL,
    last_editor_user_id INT,
    last_editor_display_name varchar(40),
    last_edit_date TIMESTAMP,
    last_activity_date TIMESTAMP,
    title varchar(256) NOT NULL,
    answer_count INT NOT NULL,
    comment_count INT NOT NULL,
    favorite_count INT NOT NULL,
    created TIMESTAMP
);

CREATE INDEX post_parent_idx ON post(parent_id);

CREATE TABLE post_to_tag
(
    post_id INT NOT NULL,
    tag_id INT NOT NULL
);

CREATE INDEX post_tag_idx ON post_to_tag(post_id,tag_id);

CREATE TABLE vote_type
(
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(40) NOT NULL
);
 
insert into vote_type(id, name) values(1, 'AcceptedByOriginator');
insert into vote_type(id, name) values(12, 'UpMod');
insert into vote_type(id, name) values(13, 'DownMod');
insert into vote_type(id, name) values(14, 'Offensive');
insert into vote_type(id, name) values(15, 'Favorite');
insert into vote_type(id, name) values(16, 'Close');
insert into vote_type(id, name) values(17, 'Reopen');
insert into vote_type(id, name) values(18, 'BountyStart');
insert into vote_type(id, name) values(19, 'BountyClose');
insert into vote_type(id, name) values(110, 'Deletion');
insert into vote_type(id, name) values(111, 'Undeletion');
insert into vote_type(id, name) values(112, 'Spam');
insert into vote_type(id, name) values(113, 'InformModerator');
