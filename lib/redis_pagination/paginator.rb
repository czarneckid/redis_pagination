require 'redis_pagination/paginator/list_paginator'
require 'redis_pagination/paginator/sorted_set_paginator'

module RedisPagination
  module Paginator
    # Retrieve a paginator class appropriate for the +key+ in Redis.
    # +key+ must be one of +list+ or +zset+, otherwise an exception 
    # will be raised.
    #
    # @params key [String] Redis key
    # @params options [Hash] Options to be passed to the individual paginator class.
    #
    # @return Returns either a +RedisPagination::Paginator::ListPaginator+ or 
    #   a +RedisPagination::Paginator::SortedSetPaginator+ depending on the 
    #   type of +key+.
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