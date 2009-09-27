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
    tags varchar(256) NOT NULL,
    answer_count INT NOT NULL,
    comment_count INT NOT NULL,
    favorite_count INT NOT NULL,
    created TIMESTAMP
);

CREATE INDEX post_parent_idx ON post(parent_id);
