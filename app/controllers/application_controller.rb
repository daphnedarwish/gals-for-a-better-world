require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base
    
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, 'bubbles'
    end
    
    get '/' do
        erb :index
    end
    
    get '/info' do
        erb :info
    end
    
    get '/quiz' do
        @survey = Survey.find(1)
        @questions = @survey.questions
        erb :quiz
    end 
    
    post '/quiz' do
        current_user = User.find(session['user_id'])
        
        @total = params.inject(0) {|sum, (k,v)| sum += v.to_i}
        if current_user
            params.each do |q_id, answer|
                a = Answer.find_or_create_by(user_id: current_user.id, question_id: q_id)
                a.selected_answer = answer
                a.save
            end
        end
        
        if @total < 6
            @message = "Excellent. Your impact on the environment is below average, keep doing what you're doing."
        elsif @total >= 6 && @total < 13
            @message = "Good. You could be a bit better with the foods you eat and day to day electronic use, but you're environmentally friendly behavior is quite impressive."
        elsif @total >= 13 && @total < 18
            @message = "Average. Your answers indicate that like the majority of people on the planet, there are a lot of small things you can do on a daily basis that are better for our environment."
        elsif @total >=18 && @total < 24
            @message = "Bad. You should work on changing a lot of aspects of your life- do things like taking shorter showers and eating locally sourced food."
        elsif @total >= 24 && @total < 28
            @message = "Seriously... You're Better Than This. Not Good At All. It is essential for the health of our Earth that you work on reducing your impact in any way you can, whether that means eating more organic and locally-sourced fruits and vegetables or using less water."
        end
        current_user.score = @total
        current_user.save
        if(session[:user_id])
            @current_user = User.find(session[:user_id])
        else
            redirect '/signin'
        end    
        erb :userpage 
    end 
    
    post '/results' do
        if params[:region] == "northeast"
            redirect '/results/northeast'
        elsif params[:region]  == "northwest"
            redirect '/results/northwest'
        elsif params[:region]  == "southeast"
            redirect '/results/southeast'
        elsif params[:region]  == "southwest"
            redirect '/results/southwest'
        elsif params[:region]  == "midwest"
            redirect '/results/midwest'
        else 
            redirect '/info'
        end    
    end
    
    get '/score' do
        erb :score
    end 
    
    get '/results/northeast' do
        erb :'regions/northeast'
    end
    
    get '/results/northwest' do
        erb :'regions/northwest'   
    end
    
    get '/results/southeast' do
        erb :'regions/southeast'
    end
    
    get '/results/southwest' do
        erb :'regions/southwest'
    end

    
    get '/results/midwest' do
        erb :'regions/midwest'
    end
    
    get '/signin' do
        erb :'signin'
    end 
    
    get '/userpage' do
        if(session[:user_id])
            @current_user = User.find(session[:user_id])
        else
            redirect '/signin'
        end    
        erb :userpage 
    end
    
    post '/signin' do
        @current_name = params[:username]
        if User.exists?(:username => @current_name)
            session['user_id'] = User.find_by(:username => @current_name).id
            redirect to('/userpage')
        else 
            @temp_user = User.create(:username => @current_name)
            session['user_id'] = @temp_user.id
            redirect to('/quiz')
        end 
    end 
    
    get '/results' do
        if(session[:user_id])
            @current_user = User.find(session[:user_id])
        else
            redirect '/signin'
        end
        
        if(@current_user.answers.length == 0)
            redirect '/quiz'
        else(@current_user.answers.length > 0)
            @answers = @current_user.answers
        end
        erb :results
    end 
    
end