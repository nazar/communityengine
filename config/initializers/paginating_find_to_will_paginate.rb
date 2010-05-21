#monkey patch will_paginate to add paginating_find enumerators
module WillPaginate
  class Collection

    def page_count
      @total_pages
    end

    def first_item
      ((current_page-1) * per_page) + 1
    end

    def last_item
      [current_page * per_page, @total_entries].min
    end

  end
end