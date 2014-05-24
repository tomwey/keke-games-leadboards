# coding: utf-8
module KeKeGameLeaderboard
  class LeaderboardsAPI < Grape::API
    format :json
    
    resources 'games' do
      segment ':game_id' do
        resources 'leaderboards' do
          get '/' do
            @game = Game.find_by_game_key(params[:game_id])
            unless @game
              return { code: 404, message: 'Not Found Game' }
            end
            page = params[:page] ? params[:page].to_i : 1
            @leaderboards = @game.leaderboards.page(page)
            { code: 0, message: 'ok', data: @leaderboards }
          end # end get '/'
          
          get ':id' do
            @game = Game.find_by_game_key(params[:game_id])
            unless @game
              return { code: 404, message: 'Not Found Game' }
            end
            @leaderboard = @game.leaderboards.find(params[:id])
            { code: 0, message: 'ok', data: @leaderboard }
          end # end get :id
          
          post '/' do
            @game = Game.find_by_game_key(params[:game_id])
            unless @game
              return { code: 404, message: 'Not Found Game' }
            end
            
            @leaderboard = @game.leaderboards.create!(name: params[:name])
            if @leaderboard
              { code: 0, message: 'ok', data: @leaderboard }
            else
              { code: 21001, message: 'created failure.' }
            end
            
          end # end post
          
          put ':id' do #, jbuilder: 'leaderboards/show.json' do
            @game = Game.find_by_game_key(params[:game_id])
            unless @game
              return { code: 404, message: 'Not Found Game' }
            end
            
            @leaderboard = @game.leaderboards.find(params[:id])
            if @leaderboard.update_attribute(name: params[:name])
              { code: 0, message: 'ok', data: @leaderboard }
            else
              { code: 21001, message: 'updated failure.' }
            end
          end # end put
          
        end # end leaderboards
      end # end segment
    end # end games resources
  end
end