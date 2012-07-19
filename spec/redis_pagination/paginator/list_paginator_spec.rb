require 'spec_helper'

describe RedisPagination::Paginator::ListPaginator do
  describe '#total_pages' do
    it 'should return the correct number of pages' do
      add_items_to_list('items', RedisPagination.page_size + 2)

      items_paginator = RedisPagination.paginate('items')
      items_paginator.total_pages.should == 2
    end

    it 'should return the correct number of pages using a different page size' do
      add_items_to_list('items', 25)

      items_paginator = RedisPagination.paginate('items')
      items_paginator.total_pages(5).should == 5
    end
  end

  describe '#total_items' do
    it 'should return the correct number of items' do
      add_items_to_list('items', RedisPagination.page_size)

      items_paginator = RedisPagination.paginate('items')
      items_paginator.total_items.should == RedisPagination.page_size
    end
  end

  describe '#page' do
    it 'should return the correct page of items' do
      add_items_to_list('items', RedisPagination.page_size + 2)

      items_paginator = RedisPagination.paginate('items')
      result = items_paginator.page(1)
      result[:items].length.should == RedisPagination.page_size
      result[:items][0].should == 'item_1'
      result[:items][-1].should == 'item_25'
      result[:current_page].should == 1
      result[:total_pages].should == 2
      result[:total_items].should == RedisPagination.page_size + 2

      result = items_paginator.page(2)
      result[:items].length.should == 2
      result[:items][-1].should == 'item_27'
      result[:current_page].should == 2
    end

    it 'should return the correct page of items with the options set' do
      add_items_to_list('items', RedisPagination.page_size + 2)

      items_paginator = RedisPagination.paginate('items')
      result = items_paginator.page(1, :page_size => 5)
      result[:items].length.should == 5
      result[:items][-1].should == 'item_5'
      result[:current_page].should == 1
      result[:total_pages].should == 6
    end
  end
end