require 'redis'

require 'redis_pagination/configuration'
require 'redis_pagination/paginator'
require 'redis_pagination/version'

module RedisPagination
  extend Configuration
  extend Paginator
end