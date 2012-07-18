require 'redis_pagination/paginator/list_paginator'
require 'redis_pagination/paginator/sorted_set_paginator'

module RedisPagination
  module Paginator
    def paginate(key, options = {})
      type = RedisPagination.redis.type(key)

      case type
      when 'list'
        RedisPagination::Paginator::ListPaginator.new(key, options)
      when 'zset'
        RedisPagination::Paginator::SortedSetPaginator.new(key, options)
      else
        raise "Pagination is not supported for #{type}"
      end
    end
  end
end