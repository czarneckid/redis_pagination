module RedisPagination
  module Paginator
    class ListPaginator
      # Initialize a new instance with a given Redis +key+ and options.
      #
      # @param key [String] Redis list key.
      # @param options [Hash] Options for paginator.
      def initialize(key, options = {})
        @key = key
      end

      # Return the total number of pages for +key+.
      #
      # @param page_size [int] Page size to calculate total number of pages.
      # 
      # @return the total number of pages for +key+.
      def total_pages(page_size = RedisPagination.page_size)
        (RedisPagination.redis.llen(@key) / page_size.to_f).ceil
      end

      # Return the total number of items for +key+.
      #
      # @return the total number of items for +key+.
      def total_items
        RedisPagination.redis.llen(@key)
      end

      # Retrieve a page of items for +key+.
      #
      # @param page [int] Page of items to retrieve.
      # @param options [Hash] Options.
      #
      # @return a page of items for +key+.
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