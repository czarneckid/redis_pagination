module RedisPagination
  # Configuration settings for redis_pagination.
  module Configuration
    # Redis instance.
    attr_accessor :redis

    # Page size to be used when peforming paging operations.
    attr_writer :page_size

    # Yield self to be able to configure redis_pagination with block-style configuration.
    #
    # Example:
    #
    #   RedisPagination.configure do |configuration|
    #     configuration.redis = Redis.new
    #     configuration.page_size = 25
    #   end
    def configure
      yield self
    end

    # Page size to be used when peforming paging operations.
    #
    # @return the page size to be used when peforming paging operations or the default of 25 if not set.
    def page_size
      @page_size ||= 25
    end
  end
end