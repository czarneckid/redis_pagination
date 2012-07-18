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
      items = items_paginator.page(1)
      items.length.should == RedisPagination.page_size
      items[0].should == 'item_1'
      items[-1].should == 'item_25'

      items = items_paginator.page(2)
      items.length.should == 2
      items[-1].should == 'item_27'
    end
  end
end