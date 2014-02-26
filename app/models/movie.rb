class Movie < ActiveRecord::Base
	@@all_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']

	def self.all_ratings
		@@all_ratings
	end
end
