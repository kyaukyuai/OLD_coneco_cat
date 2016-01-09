require_relative '../../app/models/instagram_cat.rb'
require 'net/http'
require 'uri'
require 'json'
require 'logger'
$log = Logger.new(STDOUT)

# constant variable
CLIENTID = '9ad0d13ba1bc4af68fd60217ad853471'

class Tasks::FetchInstagramCats
  def self.execute
    tag_array = %w(ねこ 猫 kitty instacat ネコ neko cat lovecats cats ilovecat)
    tag = tag_array.sample
    $log.info(%Q{#{tag}})
    instagram_uri = URI.parse(URI.escape(%Q(https://api.instagram.com/v1/tags/#{tag}/media/recent?client_id=#{CLIENTID})))
    res = Net::HTTP.get_response(instagram_uri)
    results = JSON.parse(res.body)
    insert_cat(results)
    while (results['pagination']['next_url'].present?) do
      sleep 10
      $log.info(%Q{#{results['pagination']['next_url']}})
      res = Net::HTTP.get_response(URI.parse(results['pagination']['next_url']))
      results = JSON.parse(res.body)
      insert_cat(results)
    end
  end

  def self.insert_cat(results)
    if results['data'].present?
      results['data'].each do |item|
        InstagramCat.find_or_create_by(instagram_id: item['id']) do |instagram_cat|
          instagram_cat.instagram_id = item['id']
          instagram_cat.text         = (item.has_key?('caption') and item['caption'].has_key?('text')) ? item['caption']['text'] : ''
          instagram_cat.image_url    = (item.has_key?('images') and item['images'].has_key?('standard_resolution')) ? item['images']['standard_resolution']['url'] : ''
          instagram_cat.tags         = item['tags'].join(',')
          instagram_cat.userid       = item['user']['id']
          instagram_cat.username     = item['user']['username']
          instagram_cat.userpic      = item['user']['profile_picture']
          instagram_cat.link         = item['link']
          instagram_cat.save!
        end
      end
    end
  end
end

__END__

bundle exec rails runner Tasks::FetchInstagramCats.execute

mysql> desc instagram_cats;
+--------------+--------------+------+-----+---------+----------------+
| Field        | Type         | Null | Key | Default | Extra          |
+--------------+--------------+------+-----+---------+----------------+
| id           | int(11)      | NO   | PRI | NULL    | auto_increment |
| instagram_id | int(11)      | YES  | UNI | NULL    |                |
| text         | varchar(255) | YES  |     | NULL    |                |
| image_url    | varchar(255) | YES  |     | NULL    |                |
| tags         | varchar(255) | YES  |     | NULL    |                |
| userid       | int(11)      | YES  |     | NULL    |                |
| username     | varchar(255) | YES  |     | NULL    |                |
| userpic      | varchar(255) | YES  |     | NULL    |                |
| created_at   | datetime     | NO   |     | NULL    |                |
| updated_at   | datetime     | NO   |     | NULL    |                |
+--------------+--------------+------+-----+---------+----------------+
10 rows in set (0.00 sec)
