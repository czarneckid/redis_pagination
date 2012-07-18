require 'rspec'
require 'redis_pagination'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:all) do
    RedisPagination.configure do |configuration|
      configuration.redis = Redis.new(:db => 15)
      configuration.page_size = 25
    end
  end

  config.before(:each) do
    RedisPagination.redis.flushdb
  end

  def add_items_to_list(key, items_to_add = RedisPagination.page_size)
    1.upto(items_to_add) do |index|
      RedisPagination.redis.rpush(key, "item_#{index}")
    end
  end

  def add_items_to_sorted_set(key, items_to_add = RedisPagination.page_size)
    1.upto(items_to_add) do |index|
      RedisPagination.redis.zadd(key, index, "item_#{index}")
    end
  end
end