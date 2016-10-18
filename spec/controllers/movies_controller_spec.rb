require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do

    before :each do
      @fake_results = [double('movie1'), double('movie2')]
      @empty_results = [];
    end
    it 'should call the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
          and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      allow(Movie).to receive(:find_in_tmdb).and_return (@fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(@fake_results)
    end
    it 'return to homepage if seach has 0 results' do
      expect(Movie).to receive(:find_in_tmdb).with('Tdasd').
      and_return('')
      post :search_tmdb, {:search_terms => 'Tdasd'}
      expect(response).to redirect_to('/movies')
    end
    it 'should redirct to home page with invalid seach request' do
      allow(MoviesController).to receive(:find_in_tmdb).with('')
      post :search_tmdb, {:search_terms => ''}
      expect(response).to redirect_to('/movies')
    end
    describe 'after valid search' do
      before :each do 
        allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
        post :search_tmdb, {:search_terms => 'hardward'}
      end
      it 'makes the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@fake_results)
      end
      

    end 
  end
end
