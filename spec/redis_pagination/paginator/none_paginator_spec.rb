require 'spec_helper'

describe RedisPagination::Paginator::NonePaginator do
  describe '#total_pages' do
    it 'should return the correct number of pages' do
      items_paginator = RedisPagination.paginate('unknown-key-in-redis')
      items_paginator.total_pages.should == 0
    end

    it 'should return the correct number of pages using a different page size' do
      items_paginator = RedisPagination.paginate('unknown-key-in-redis')
      items_paginator.total_pages(5).should == 0
    end
  end

  describe '#total_items' do
    it 'should return the correct number of items' do
      items_paginator = RedisPagination.paginate('unknown-key-in-redis')
      items_paginator.total_items.should == 0
    end
  end

  describe '#page' do
    it 'should return the correct page of items' do
      items_paginator = RedisPagination.paginate('unknown-key-in-redis')
      result = items_paginator.page(1)
      result[:items].length.should == 0
      result[:current_page].should == 1
      result[:total_pages].should == 0
      result[:total_items].should == 0

      result = items_paginator.page(2)
      result[:items].length.should == 0
      result[:current_page].should == 2
    end

    it 'should return the correct page of items with the options set' do
      items_paginator = RedisPagination.paginate('unknown-key-in-redis')
      result = items_paginator.page(1, :page_size => 5)
      result[:items].length.should == 0
      result[:current_page].should == 1
      result[:total_pages].should == 0
    end
  end

  describe '#all' do
    it 'should return all the items with the default options' do
      items_paginator = RedisPagination.paginate('unknown-key-in-redis')
      items_paginator.all.tap do |all_items|
        all_items[:total_items].should == 0
        all_items[:items].length.should == 0
      end
    end
  end
end