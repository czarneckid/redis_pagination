# CHANGELOG

## 1.2.0 (2014-05-15)

* Added `#all` method to `RedisPagination::Paginator::NonePaginator`.
* Ensure various `#all` methods return Hash containing
  `:current_page`, `:total_pages`, `:total_items` and `:items`.

## 1.1.0 (2014-05-14)

* Added `#all` method to `RedisPagination::Paginator::SortedSetPaginator` and
  `RedisPagination::Paginator::ListPaginator` to retrieve all elements
  from these data types for a given key.

## 1.0.0 (2012-07-27)

* Added `RedisPagination::Paginator::NonePaginator` to handle non-existent keys.

## 0.0.1 (2012-07-19)

* Initial release