require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#destroy action" do
    
    it "shouldnt let anautheinticated users detroy a gram" do 
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end

    it 'successfully destroy gram in the database' do
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it 'should return 404 if gram not found' do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'spaceduck'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'grams#update action' do

    it "shouldnt let users who didnt create gram update it " do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: gram.id, gram: { message: "Hello!"} }
      expect(response).to have_http_status(:forbidden)
    end

    it 'shouldnt let unauthenicated users update a gram ' do
      gram = FactoryBot.create(:gram)
      patch :update, params: { id: gram.id, gram: { message: "Hello!"} }
      expect(response).to redirect_to new_user_session_path
    end


    it 'successfully update grams' do
      gram = FactoryBot.create(:gram, message: 'Initial Value')
      sign_in gram.user

      patch :update, params: { id: gram.id, gram: {message: 'Changed!'}}
      

      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq 'Changed!'
    end

    it 'display 404 if gram isnt found' do 
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: 'YOLOSWAG', gram: {message: 'Changed'} }
      expect(response).to have_http_status(:not_found)
    end

    it 'if errors-render new form' do 
      gram = FactoryBot.create(:gram, message: 'Initial Value')
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: ''}}
      
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq 'Initial Value'
    end
  end

  describe "grams#edit action" do

    it "shouldn't let unauthenticated users edit a gram" do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end


    it "should show the edit form if the gram is found" do
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end


    it "return a 404 if gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'TACOCAT'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#show action" do
    it 'should successfully show the page if the gram is found' do
      gram = FactoryBot.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end



  describe "grams#index action" do 
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do

    it 'should require a user to be logged in' do
      post :create, params: { gram: { message: "Hello!"} }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do

    it "should require users to be logged in" do
      post :create, params: {gram: { message: 'Hello'}}
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully create a new gram in our database"  do
      
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { 
        gram: { 
          message: 'Hello!',
        picture: fixture_file_upload("/picture.png", 'image/png')
        }
       }
      expect(response).to redirect_to root_path 
      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do

      user = FactoryBot.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, params: { gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end
end
