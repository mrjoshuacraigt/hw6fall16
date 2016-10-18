class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  
   
  Tmdb::Api.key('f4702b08c0ac6ea5b51425788bb26562')
  
  def self.find_in_tmdb(string)
    begin
      searchResults = []
      if !Tmdb::Movie.find(string).blank?
        Tmdb::Movie.find(string).each do |movie|
          movieRating = ''
          Tmdb::Movie.releases(movie.id)["countries"].each do |rating|
            if rating["iso_3166_1"] == "US"
              movieRating = rating["certification"]
            end
          end
          hash = {:tmdb_id => movie.id, :title => movie.title, :release_date => movie.release_date, :rating => movieRating}
          searchResults.push(hash)
        end
      end
      return searchResults
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.create_tmdb(tmdb_id)
    movie = Tmdb::Movie.detail(tmdb_id)
    movieRating = ''
    Tmdb::Movie.releases(tmdb_id)["countries"].each do |rating|
      if rating["iso_3166_1"] == "US"
        movieRating = rating["certification"]
      else
        movieRating = 'NR'
      end
    end
    Movie.create(title: movie["original_title"], rating: movieRating, release_date: movie["release_date"])
  end
    

end
