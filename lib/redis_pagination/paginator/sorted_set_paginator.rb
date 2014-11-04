module RedisPagination
  module Paginator
    class SortedSetPaginator
      # Initialize a new instance with a given Redis +key+ and options.
      #
      # @param key [String] Redis sorted set key.
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
        ((@keys ? @keys.map{|k| RedisPagination.redis.zcard(k)}.reduce(:+) : RedisPagination.redis.zcard(@key)) / page_size.to_f).ceil
      end

      # Return the total number of items for +key+.
      #
      # @return the total number of items for +key+.
      def total_items
        (@keys ? @keys.map{|k| RedisPagination.redis.zcard(k)}.reduce(:+) : RedisPagination.redis.zcard(@key))
      end

      # Retrieve a page of items for +key+.
      #
      # @param page [int] Page of items to retrieve.
      # @param options [Hash] Options. Valid options are :page_size, :with_scores and :reverse.
      #   :page_size controls the page size for the call. Default is +RedisPagination.page_size+.
      #   :with_scores controls whether the score is returned along with the item. Default is +true+.
      #   :reverse controls whether to return items in highest-to-lowest (+true+) or loweest-to-highest order (+false+). Default is +true+.
      #
      # @return a +Hash+ containing +:current_page+, +:total_pages+, +:total_items+ and +:items+.
      def page(page, options = {})
        current_page = page < 1 ? 1 : page
        index_for_redis = current_page - 1
        page_size = options[:page_size] || RedisPagination.page_size
        starting_offset = index_for_redis * page_size
        ending_offset = (starting_offset + page_size) - 1

        with_scores = options.has_key?(:with_scores) ? options[:with_scores] : true
        reverse = options.has_key?(:reverse) ? options[:reverse] : true
        
        items = if reverse
          if @keys
            @keys.map{|k| RedisPagination.redis.zrevrange(k, 0, -1, :with_scores => with_scores) }.flatten(1).sort {|a,b| b[1] <=> a[1]}
          else
            RedisPagination.redis.zrevrange(@key, starting_offset, ending_offset, :with_scores => with_scores)
          end
        else
          if @keys
            @keys.map{|k| RedisPagination.redis.zrange(k, 0, -1, :with_scores => with_scores) }.flatten(1).sort {|a,b| a[1] <=> b[1]}
          else
            RedisPagination.redis.zrange(@key, starting_offset, ending_offset, :with_scores => with_scores)
          end
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
      # @param options [Hash] Options. Valid options are :with_scores and :reverse.
      #   :with_scores controls whether the score is returned along with the item. Default is +true+.
      #   :reverse controls whether to return items in highest-to-lowest (+true+) or loweest-to-highest order (+false+). Default is +true+.
      #
      # @return a +Hash+ containing +:current_page+, +:total_pages+, +:total_items+ and +:items+.
      def all(options = {})
        with_scores = options.has_key?(:with_scores) ? options[:with_scores] : true
        reverse = options.has_key?(:reverse) ? options[:reverse] : true
        
        items = if reverse
          if @keys
            @keys.map{|k| RedisPagination.redis.zrevrange(k, 0, -1, :with_scores => with_scores) }.flatten(1).sort {|a,b| b[1] <=> a[1]}
          else
            RedisPagination.redis.zrevrange(@key, 0, -1, :with_scores => with_scores)
          end
        else
          if @keys
            @keys.map{|k| RedisPagination.redis.zrange(k, 0, -1, :with_scores => with_scores) }.flatten(1).sort {|a,b| a[1] <=> b[1]}
          else
            RedisPagination.redis.zrange(@key, 0, -1, :with_scores => with_scores)
          end
        end
        
        {
          :current_page => 1,
          :total_pages => 1,
          :total_items => total_items,
          :items => items
        }
      end
    end
  end
end
