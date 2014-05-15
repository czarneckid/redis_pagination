module RedisPagination
  module Paginator
    class NonePaginator
      # Initialize a new instance with a given Redis +key+ and options.
      #
      # @param key [String] Redis key.
      # @param options [Hash] Options for paginator.
      def initialize(key, options = {})
      end

      # Return the total number of pages for +key+.
      #
      # @param page_size [int] Page size to calculate total number of pages.
      #
      # @return the total number of pages for +key+.
      def total_pages(page_size = RedisPagination.page_size)
        0
      end

      # Return the total number of items for +key+.
      #
      # @return the total number of items for +key+.
      def total_items
        0
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

        {
          :current_page => current_page,
          :total_pages => 0,
          :total_items => 0,
          :items => []
        }
      end

      # Retrieve all items for +key+.
      #
      # @return a +Hash+ containing +:current_page+, +:total_pages+, +:total_items+ and +:items+.
      def all(options = {})
        {
          :current_page => 1,
          :total_pages => 0,
          :total_items => 0,
          :items => []
        }
      end
    end
  end
end