require 'spec_helper.rb'

describe WelcomeController do

  it "renders index page" do
    get :index
    expect(response).to render_template :index
  end

end
