module RedisPagination
  module Paginator
    class SortedSetPaginator
      def initialize(key, options = {})
        @key = key
      end

      def total_pages(page_size = RedisPagination.page_size)
        (RedisPagination.redis.zcard(@key) / page_size.to_f).ceil
      end

      def total_items
        RedisPagination.redis.zcard(@key)
      end

      def page(page, options = {})
        current_page = page < 1 ? 1 : page
        index_for_redis = current_page - 1
        starting_offset = index_for_redis * RedisPagination.page_size
        ending_offset = (starting_offset + RedisPagination.page_size) - 1

        with_scores = options.has_key?(:with_scores) ? options[:with_scores] : true
        reverse = options.has_key?(:reverse) ? options[:reverse] : true

        if reverse
          RedisPagination.redis.zrevrange(@key, starting_offset, ending_offset, :with_scores => with_scores)
        else
          RedisPagination.redis.zrange(@key, starting_offset, ending_offset, :with_scores => with_scores)
        end
      end
    end
  end
end