# RedisPagination

Simple pagination for Redis lists and sorted sets.

Make sure your redis server is running! Redis configuration is outside the scope of this README, but 
check out the [Redis documentation](http://redis.io/documentation) for more information.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis_pagination'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install redis_pagination
```

## Usage

Configure redis_pagination:

```ruby
RedisPaginations.configure do |configuration|
  configuration.redis = Redis.new
  configuration.page_size = 25
end
```

Use redis_pagination:

```ruby
require 'redis_pagination'

RedisPagination.configure do |configuration|
  configuration.redis = Redis.new(:db => 15)
  configuration.page_size = 25
end

# List
add_items_to_list('items', RedisPagination.page_size + 2)
 => 1 
items_paginator = RedisPagination.paginate('items')
 => #<RedisPagination::Paginator::ListPaginator:0x007f8109b08ba0 @key="items"> 
items_paginator.total_items
 => 27 
items_paginator.total_pages
 => 2 
items_paginator.total_pages(5)
 => 6 
items = items_paginator.page(1)
 => {:current_page=>1, :total_pages=>2, :total_items=>27, :items=>["item_1", "item_2", "item_3", "item_4", "item_5", "item_6", "item_7", "item_8", "item_9", "item_10", "item_11", "item_12", "item_13", "item_14", "item_15", "item_16", "item_17", "item_18", "item_19", "item_20", "item_21", "item_22", "item_23", "item_24", "item_25"]}
items = items_paginator.page(2)
 => {:current_page=>2, :total_pages=>2, :total_items=>27, :items=>["item_26", "item_27"]}

# Sorted Set
add_items_to_sorted_set('items', RedisPagination.page_size + 2)
 => 1 
items_paginator = RedisPagination.paginate('items')
 => #<RedisPagination::Paginator::SortedSetPaginator:0x007f8109a25828 @key="items"> 
items_paginator.total_items
 => 27 
items_paginator.total_pages
 => 2 
items_paginator.total_pages(5)
 => 6 
items = items_paginator.page(1)
 => {:current_page=>1, :total_pages=>2, :total_items=>27, :items=>[["item_27", 27.0], ["item_26", 26.0], ["item_25", 25.0], ["item_24", 24.0], ["item_23", 23.0], ["item_22", 22.0], ["item_21", 21.0], ["item_20", 20.0], ["item_19", 19.0], ["item_18", 18.0], ["item_17", 17.0], ["item_16", 16.0], ["item_15", 15.0], ["item_14", 14.0], ["item_13", 13.0], ["item_12", 12.0], ["item_11", 11.0], ["item_10", 10.0], ["item_9", 9.0], ["item_8", 8.0], ["item_7", 7.0], ["item_6", 6.0], ["item_5", 5.0], ["item_4", 4.0], ["item_3", 3.0]]}
items = items_paginator.page(2)
 => {:current_page=>2, :total_pages=>2, :total_items=>27, :items=>[["item_2", 2.0], ["item_1", 1.0]]}
items = items_paginator.page(1, :with_scores => false, :reverse => false)
 => {:current_page=>1, :total_pages=>2, :total_items=>27, :items=>["item_1", "item_2", "item_3", "item_4", "item_5", "item_6", "item_7", "item_8", "item_9", "item_10", "item_11", "item_12", "item_13", "item_14", "item_15", "item_16", "item_17", "item_18", "item_19", "item_20", "item_21", "item_22", "item_23", "item_24", "item_25"]}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
