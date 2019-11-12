require 'rails_helper'

RSpec.describe HistoriesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #delete" do
    it "returns http success" do
      get :delete
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #delete_all" do
    it "returns http success" do
      get :delete_all
      expect(response).to have_http_status(:success)
    end
  end

end
