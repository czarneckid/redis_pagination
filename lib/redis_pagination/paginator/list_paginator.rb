module RedisPagination
  module Paginator
    class ListPaginator
      # Initialize a new instance with a given Redis +key+ and options.
      #
      # @param key [String] Redis list key.
      # @param options [Hash] Options for paginator.
      def initialize(key, options = {})
        unless key.is_a?Array
          @key = key
        else
          @keys = key
        end
      end

      # Return the total number of pages for +key+.
      #
      # @param page_size [int] Page size to calculate total number of pages.
      #
      # @return the total number of pages for +key+.
      def total_pages(page_size = RedisPagination.page_size)
        ((@keys ? @keys.map{|k| RedisPagination.redis.llen(k)}.reduce(:+) : RedisPagination.redis.llen(@key)) / page_size.to_f).ceil
      end

      # Return the total number of items for +key+.
      #
      # @return the total number of items for +key+.
      def total_items
        (@keys ? @keys.map{|k| RedisPagination.redis.llen(k)}.reduce(:+) : RedisPagination.redis.llen(@key))
      end

      # Retrieve a page of items for +key+.
      #
      # @param page [int] Page of items to retrieve.
      # @param options [Hash] Options. Valid options are :page_size.
      #   :page_size controls the page size for the call. Default is +RedisPagination.page_size+.
      #
      # @return a +Hash+ containing +:current_page+, +:total_pages+, +:total_items+ and +:items+.
      def page(page, options = {})
        current_page = page < 1 ? 1 : page
        index_for_redis = current_page - 1
        page_size = options[:page_size] || RedisPagination.page_size
        starting_offset = index_for_redis * page_size
        ending_offset = (starting_offset + page_size) - 1
        
        items = if @keys
          @keys.map{|k| RedisPagination.redis.lrange(k, 0, -1) }.flatten(1)
        else
          RedisPagination.redis.lrange(@key, starting_offset, ending_offset)
        end

        {
          :current_page => current_page,
          :total_pages => total_pages(page_size),
          :total_items => total_items,
          :items => items[starting_offset..ending_offset]
        }
      end

      # Retrieve all items for +key+.
      #
      # @return a +Hash+ containing +:current_page+, +:total_pages+, +:total_items+ and +:items+.
      def all(options = {})
        {
          :current_page => 1,
          :total_pages => 1,
          :total_items => total_items,
          :items => if @keys
            @keys.map{|k| RedisPagination.redis.lrange(k, 0, -1) }.flatten(1)
          else
            RedisPagination.redis.lrange(@key, 0, -1)
          end
        }
      end
    end
  end
end
