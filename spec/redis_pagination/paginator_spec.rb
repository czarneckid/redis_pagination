require 'spec_helper'

describe RedisPagination::Paginator do
  describe '#paginate' do
    it 'should return a RedisPagination::Paginator::ListPaginator' do
      redis = RedisPagination.redis
      redis.lpush("items", "item_1")

      RedisPagination.paginate("items").should be_a_kind_of(RedisPagination::Paginator::ListPaginator)
    end

    it 'should return a RedisPagination::Paginator::SortedSetPaginator' do
      redis = RedisPagination.redis
      redis.zadd("items", 1, "item_1")

      RedisPagination.paginate("items").should be_a_kind_of(RedisPagination::Paginator::SortedSetPaginator)
    end

    it 'should raise an exception if trying to paginate a Redis type that cannot be paginated' do
      redis = RedisPagination.redis
      redis.set("items", "item_1")

      lambda { RedisPagination.paginate("items") }.should raise_error
    end
  end
end