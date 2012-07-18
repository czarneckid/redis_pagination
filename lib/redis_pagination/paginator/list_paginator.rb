module RedisPagination
  module Paginator
    class ListPaginator
      def initialize(key, options = {})
        @key = key
      end

      def total_pages(page_size = RedisPagination.page_size)
        (RedisPagination.redis.llen(@key) / page_size.to_f).ceil
      end

      def total_items
        RedisPagination.redis.llen(@key)
      end

      def page(page, options = {})
        current_page = page < 1 ? 1 : page
        index_for_redis = current_page - 1
        starting_offset = index_for_redis * RedisPagination.page_size
        ending_offset = (starting_offset + RedisPagination.page_size) - 1

        RedisPagination.redis.lrange(@key, starting_offset, ending_offset)
      end
    end
  end
end