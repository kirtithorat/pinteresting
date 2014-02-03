require 'spec_helper.rb'

describe WelcomeController do

  it "renders index template" do
    get :index
    expect(response).to render_template :index
  end

end
