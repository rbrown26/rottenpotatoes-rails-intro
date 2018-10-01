class Movie < ActiveRecord::Base
    def self.ratings
        select('rating').distinct.order('rating ASC')
    end
end
