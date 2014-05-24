# coding: utf-8
module KeKeGameLeaderboard
  class UsersAPI < Grape::API
    format :json
    
    resources 'leaderboards' do
      segment ':leaderboard_id' do
        resources 'users' do
          get '/' do
            @leaderboard = Leaderboard.find(params[:leaderboard_id])
            page = params[:page] ? params[:page].to_i : 1
            @scores = @leaderboard.scores.sort_by_value.page(page)
            { code: 0, message: 'ok', data: @scores }
          end # end get '/'
          
          get ':id' do
            @leaderboard =  Leaderboard.find(params[:leaderboard_id])
            @user = User.find_by_udid(params[:id])
            @score = @leaderboard.scores.where(user_id: @user.id).first
            { code: 0, message: 'ok', data: { score: @score.value, rank: @score.rank } }
          end #end get '/users/1.json'
          
          # 上传分数
          params do
            requires :score, type: Integer
            requires :uid, type: String
          end
          
          post '/' do
            @leaderboard = Leaderboard.find(params[:leaderboard_id])
            @user = User.find_by_udid(params[:uid])
            @score = @leaderboard.scores.create!(value: params[:score].to_i, user_id: @user.id)
            if @score
              { code: 0, message: 'ok', data: @score }
            else
              { code: 21001, message: 'created failure.' }
            end
          end # end post
          
        end # end users resources
      end # end segment
    end # end resources
  end # end class
end # end module