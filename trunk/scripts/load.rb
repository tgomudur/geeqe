require 'rubygems'
require 'libxml'
require "mysql"
require "pp"

include LibXML

class BadgeCallbacks
  include XML::SaxParser::Callbacks

  @my
  @st

  def initialize(my)
    @my = my
    @st = @my.prepare("insert into badge(id, user_id, name, created) values(?, ?, ?, ?)")
  end

  def on_start_element(element, attributes)
    if element == 'row'
      @st.execute(attributes['Id'], attributes['UserId'], attributes['Name'], attributes['Date'])
    end
  end
end

class CommentCallbacks
  include XML::SaxParser::Callbacks

  @my
  @st

  def initialize(my)
    @my = my
    @st = @my.prepare("insert into comment(id, post_id, user_id, score, comment_text, created) values(?, ?, ?, ?, ?, ?)")
  end

  def on_start_element(element, attributes)
    if element == 'row'
      @st.execute(attributes['Id'], attributes['PostId'], attributes['UserId'] == nil ? -1 : attributes['UserId'], attributes['Score'], attributes['Text'], attributes['CreationDate'])
    end
  end
end

class VoteCallbacks
  include XML::SaxParser::Callbacks

  @my
  @st

  def initialize(my)
    @my = my
    @st = @my.prepare("insert into vote(id, post_id, vote_type_id, created) values(?, ?, ?, ?)")
  end

  def on_start_element(element, attributes)
    if element == 'row'
      @st.execute(attributes['Id'], attributes['PostId'], attributes['VoteTypeId'], attributes['CreationDate'])
    end
  end
end

class UserCallbacks
  include XML::SaxParser::Callbacks

  @my
  @st

  def initialize(my)
    @my = my
    @st = @my.prepare("insert into so_user(id, reputation, display_name, last_access_date, website_url, location, age, about_me, views, up_votes, down_votes, created) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
  end

  def on_start_element(element, attributes)
    if element == 'row'
      @st.execute(attributes['Id'], attributes['Reputation'], attributes['DisplayName'], attributes['LastAccessDate'], attributes['WebsiteUrl'], attributes['Location'], attributes['Age'] == nil ? -1 : attributes['Age'], attributes['AboutMe'], attributes['Views'], attributes['UpVotes'], attributes['DownVotes'], attributes['CreationDate'])
    end
  end
end


class PostCallbacks
  include XML::SaxParser::Callbacks

  @my
  @st

  def initialize(my)
    @my = my
    @st = @my.prepare("insert into post(id, post_type_id, accepted_answer_id, parent_id, score, view_count, body_text, owner_id, last_editor_user_id, last_editor_display_name, last_edit_date, last_activity_date, title, tags, answer_count, comment_count, favorite_count, created) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
  end

  def on_start_element(element, attributes)
    if element == 'row'
      @st.execute(attributes['Id'], attributes['PostTypeId'], attributes['AcceptedAnswerId'], attributes['ParentId'], attributes['Score'], attributes['ViewCount'], attributes['Body'], attributes['OwnerUserId'] == nil ? -1 : attributes['OwnerUserId'], attributes['LastEditorUserId'], attributes['LastEditorDisplayName'], attributes['LastEditDate'], attributes['LastActivityDate'], attributes['Title'] == nil ? '' : attributes['Title'], attributes['Tags'] == nil ? '' : attributes['Tags'], attributes['AnswerCount'] == nil ? 0 : attributes['AnswerCount'], attributes['CommentCount'] == nil ? 0 : attributes['CommentCount'], attributes['FavoriteCount'] == nil ? 0 : attributes['FavoriteCount'], attributes['CreationDate'])
    end
  end
end


my = Mysql::new("localhost", "username", "password", "so_database")

parser = XML::SaxParser.file('badges.xml')
parser.callbacks = BadgeCallbacks.new(my)
parser.parse

parser = XML::SaxParser.file('comments.xml')
parser.callbacks = CommentCallbacks.new(my)
parser.parse

parser = XML::SaxParser.file('votes.xml')
parser.callbacks = VoteCallbacks.new(my)
parser.parse

parser = XML::SaxParser.file('users.xml')
parser.callbacks = UserCallbacks.new(my)
parser.parse

parser = XML::SaxParser.file('posts.xml')
parser.callbacks = PostCallbacks.new(my)
parser.parse
