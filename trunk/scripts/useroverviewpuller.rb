#!/usr/bin/ruby
# 
# This script is used to fill in the gravitar and badge information for a 
# user profile. It uses http://stackoverflow.com/users so that it can pull
# in the information without tons of hits to the server.
#

require 'rubygems'
require 'hpricot'
require 'mechanize'
require "mysql"
require 'pp'

def parse_page(body)
  my = Mysql::new("localhost", "username", "password", "so_database")
  st = my.prepare("update so_user set gravatar_hash = ?, gold_badge_count = ?, silver_badge_count = ?, bronze_badge_count = ? where id = ?")

  user_page = Hpricot(body)
  (user_page/"div[@class='user-info']").each do |user_info|

    user_link = (user_info/"div[@class='user-gravatar32']/a")
    user_id = user_link != nil ? user_link[0][:href].split('/')[2] : "NA"
 
    gravitar_img = (user_info/"div[@class='user-gravatar32']/a/img")
    gravitar_hash = gravitar_img[0][:src].split('/')[4].split('?')[0] if gravitar_img != nil
  
    user_rep = (user_info/"div[@class='user-details']/span[@class='reputation-score']")
    user_repf = user_rep[0].inner_html if user_rep != nil
  
    user_bc = (user_info/"div[@class='user-details']/span[@title~=gold]/span[@class='badgecount']")
    user_gold = user_bc != nil && user_bc[0] != nil ? user_bc[0].inner_html : 0

    user_bc = (user_info/"div[@class='user-details']/span[@title~=silver]/span[@class='badgecount']")
    user_silver = user_bc != nil && user_bc[0] != nil ? user_bc[0].inner_html : 0

    user_bc = (user_info/"div[@class='user-details']/span[@title~=bronze]/span[@class='badgecount']")
    user_bronze = user_bc != nil && user_bc[0] != nil ? user_bc[0].inner_html : 0

    puts "#{user_id}: #{gravitar_hash}, #{user_repf}, #{user_gold}, #{user_silver}, #{user_bronze}"
    st.execute(gravitar_hash, user_gold, user_silver, user_bronze, user_id)
  end
end

def get_next_url(body)
  user_page = Hpricot(body)
  (user_page/"div[@class='pager']/a").each do |pager|
    pager_span = (pager/"span[@class='page-numbers next']")
    if pager_span != nil && pager_span[0] != nil
      return pager[:href]
    end
  end
  return nil
end

mech = WWW::Mechanize.new
mech.user_agent_alias = 'GeeQE V1.0'

base_url = 'http://stackoverflow.com'
url = base_url + '/users'

while url != nil
  puts "Pulling: #{url}"

  body = mech.get(url).body()
  parse_page(body)
  url = base_url + get_next_url(body)

  sleep rand(20) + 1
end
