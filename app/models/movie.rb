class Movie < ActiveRecord::Base
    order(:sort)
end
