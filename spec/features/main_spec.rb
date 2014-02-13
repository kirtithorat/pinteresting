require 'spec_helper'

describe "Launch Application" do

  before :each do
    visit root_path
  end

  it "Display Home Page" do
    expect(page.status_code).to be 200
    # To compare against _path use below
    # uri = URI.parse(current_url).request_uri
    expect(current_url).to eq root_url
  end

  # check for <meta charset="UTF-8"> on every page
  it "enforce that meta charset UTF-8 is declared at Application level layout" do
    expect(page).to have_selector("head>meta[charset='UTF-8']", :visible => false)
  end

  describe "and make sure that it:" do

    it "has a text logo" do
      expect(page).to have_selector("a", text: "Pinteresting")
    end

    it "has an introduction" do
      expect(page).to have_text("Save all the stuff you love (recipes! articles! travel ideas!) right here on Pinteresting.")
    end

    it "has Join Us link" do
      expect(page).to have_link("Join Us", :href => new_member_registration_path)
    end

    it "has Log In link" do
      expect(page).to have_link("Log In", :href => new_member_session_path)
    end

    let(:logged_member) {build(:member)}
    # Non Lazy method must specify the Class name
    # logged_member = FactoryGirl.build(:member)

    let(:member) { Member.find_by_email logged_member.email }


    shared_examples "Dashboard Page" do

      # include_examples "a Settings and Log Out link"
      it { page.should have_link("Settings", :href => edit_member_registration_path) }

      it { page.should have_link("Log Out", :href => destroy_member_session_path) }

      mymember = FactoryGirl.build(:member)

      it "should display full name of logged in member e.g. #{mymember.fullname}" do
        expect(page).to have_text(logged_member.fullname)
      end

      it { page.should have_link("Edit", :href => edit_member_registration_path) }

      it { page.should have_link("Create a Board", :href => new_board_path) }

    end

    context "Upon clicking on Log In link" do

      before :each do
        click_link "Log In"
      end

      it "Display Log In Page" do
        expect(page.status_code).to be 200
        expect(current_url).to eq new_member_session_url
      end

      describe "where it:" do

        it "should display Log In text" do
          expect(page).to have_text("Log In")
        end

        it { page.should have_selector("form#new_member[method = 'post'][action = '/members/sign_in']", :count => 1) }

        it { page.should have_field("Email", :type => "email") }

        it { page.should have_field("Password", :type => "password") }

        it { page.should have_button("Log In") }

        context "Log In with valid credentials:" do

          context "when no boards and no pins" do

            before(:each) do
              FactoryGirl.create(:member)
              fill_in "Email", with: logged_member.email
              fill_in "Password", with: logged_member.password
              click_button "Log In"
            end

            it "authenticate member and visit Dashboard" do
              expect(page.status_code).to be 200
              expect(current_url).to eq dashboard_url
            end

            describe "where it:" do
              include_examples "Dashboard Page"
            end

          end

          context "when boards and or pins exists" do
            FactoryGirl.create(:member)


            before(:each) do
              FactoryGirl.create(:pin)
              fill_in "Email", with: logged_member.email
              fill_in "Password", with: logged_member.password
              click_button "Log In"
            end

            it "authenticate member and visit member Dashboard" do
              expect(page.status_code).to be 200
              expect(current_url).to eq dashboard_url
            end

            describe "where it:" do

              include_examples "Dashboard Page"

              it "matched Board count correctly against the database" do
                page.should have_text("#{member.boardcount} Boards")
              end

              it "matched Pin count correctly against the database" do
                page.should have_text("#{member.pincount} Pins")
              end

            end

          end

        end

        context "Upon filling the form with invalid credentials" do

          it "user authentication failed - Display Log In page again" do
            logged_member= build(:member)

            fill_in "Email", with: logged_member.email
            fill_in "Password", with: logged_member.password
            click_button "Log In"

            expect(page.status_code).to be 200
            expect(current_url).to eq new_member_session_url
          end

        end

      end

    end

    context "Upon clicking on Join Us link" do

      before :each do
        click_link "Join Us"
      end

      it "Display Member Registration page" do
        expect(page.status_code).to be 200
        expect(current_url).to eq new_member_registration_url
      end

      describe "where it:" do

        it "should display Join Us text" do
          expect(page).to have_text("Join Us")
        end

        # form#new_member could also be written as form[id = new_member]
        it { page.should have_selector("form#new_member[method = 'post'][action = '/members']", :count => 1) }

        it { page.should have_field("First Name") }

        it { page.should have_field("Last Name") }

        it { page.should have_field("Email Address", :type => "email") }

        it { page.should have_field("Password", :type => "password") }

        it { page.should have_field("Confirm Password", :type => "password") }

        it { page.should have_select("member_location", :options => ["United States", "India", "UK"]) }

        it { page.should have_field("member_gender_female", :type => "radio") }

        it { page.should have_field("member_gender_male", :type => "radio") }

        it { page.should have_link("Cancel", :href => root_path) }

=begin
    The following could be written as: 
      page.should have_button("Join")
    -- but RSpec would not validate "type", "name" attributes because have_button doesn't 
       have that facility.
=end
        it { page.should have_selector("input[type = 'submit'][name = 'commit'][value = 'Join']") }
=begin
    If you have an "image button" then the above could be written as below: 
    it { page.should have_selector("input[type = 'image'][src = 'submit.jpg'][name = 'commit'][value = 'Join']") }
=end
        context "Upon clicking on Cancel link" do

          it "Display Home Page" do
            click_link "Cancel"
            expect(page.status_code).to be 200
            expect(current_url).to eq root_url
          end

        end

        shared_examples "a Settings and Log Out link" do

          it { page.should have_link("Settings", :href => edit_member_registration_path) }

          it { page.should have_link("Log Out", :href => destroy_member_session_path) }

        end

        context "Upon filling the form and clicking on Join button" do

          before(:each) do
            fill_in "First Name", with: logged_member.firstname
            fill_in "Last Name", with: logged_member.lastname
            fill_in "Email Address", with: logged_member.email
            fill_in "Password", with: logged_member.password
            fill_in "Confirm Password", with: logged_member.password
            select logged_member.location, from: "member_location"
            choose "member_gender_male"
            click_button "Join"
          end

          it "A new member is registered" do
=begin
          Lets test whether a new member is saved in database with the given details.
          We have already assigned let(:member) which upon invoke will pull the record 
          by unique email address(This is equivalent of "username").
          The reason for not testing password is that Devise gem will store
          password in encrypted format. But before running any tests on all field names, 
          they must be permitted in the application controller as they won't be stored 
          in database. 
=end  
            expect(member.firstname).to eq logged_member.firstname
            expect(member.lastname).to eq logged_member.lastname
            expect(member.location).to eq logged_member.location
            expect(member.gender).to eq "male"

          end

          it "and Dashboard Page is displayed for that member" do
            expect(page.status_code).to be 200
            expect(current_url).to eq dashboard_url
          end

          describe "where it:" do
            include_examples "Dashboard Page"

            context "Upon clicking on Create a Board link" do

              before(:each) do
                click_link "Create a Board"
              end

              it "Display New Board page" do
                expect(page.status_code).to be 200
                expect(current_url).to eq new_board_url
              end

              describe "where it:" do

                let(:board) { Board.new(FactoryGirl.attributes_for(:board)) }
                let(:created_board) { Board.find_by(member_id: member.id, name: board.name) }

                it "should have text \"Create a Board\" " do
                  page.should have_text("Create a Board")
                end

                it { page.should have_field("Name") }

                it { page.should have_field("Description") }

                it { page.should have_select("Category") }

                it { page.should have_link("Cancel", href: dashboard_path) }

                it { page.should have_button("Create Board") }

                context "Upon filling the form and clicking on Create Board button" do

                  before(:each){
                    fill_in "Name", with: board.name
                    fill_in "Description", with: board.description
                    select board.category, from: "Category"
                    click_button "Create Board"
                  }

                  it "A new board is created" do
                    expect(created_board.name).to eq board.name
                    expect(created_board.description).to eq board.description
                    expect(created_board.category).to eq board.category
                  end

                  context "Dashboard Page is displayed" do

                    it "with new board details" do
                      expect(page.status_code).to be 200
                      expect(current_url).to eq dashboard_url
                      expect(page).to have_text("#{member.boards[0].name}")
                    end

                    context "Upon clicking on the Board Name" do

                      before(:each){
                        click_link "#{member.boards[0].name}"
                      }

                      it "Display Show Board Page" do
                        expect(page.status_code).to be 200
                        expect(current_url).to eq board_url(created_board)
                      end

                      describe "where it:" do

                        it "should display Board Name" do
                          expect(page).to have_text(created_board.name)
                        end

                        it { page.should have_link("Edit Board") }

                        it { page.should have_link("Add a Pin") }

                        context "Upon clicking on Edit Board link" do

                          before(:each){
                            click_link "Edit Board"
                          }

                          it "Display Edit Board Page" do
                            expect(page.status_code).to be 200
                            expect(current_url).to eq edit_board_url(created_board)
                          end

                          describe "where it:" do

                            it { page.should have_text("Edit Board") }

                            it { page.should have_field("Name", :with => created_board.name) }

                            it { page.should have_field("Description", :with => created_board.description) }

                            it { page.should have_select("Category", :selected => created_board.category) }

                            it { page.should have_link("Delete Board") }

                            it { page.should have_link("Cancel") }

                            it { page.should have_button("Save Changes") }

                            context "Upon clicking on Delete Board link" do
                              before(:each) do
                                click_link "Delete Board"
                              end

                              it "board is removed from the database" do
                                expect(Board.find_by(member_id: logged_member.id, name: board.name)).to be nil
                              end

                              it "and Dashboard Page is displayed" do
                                expect(page.status_code).to be 200
                                expect(current_url).to eq dashboard_url
                              end
                            end

                            context "Upon clicking on Cancel link" do
                              it "Display Show Board Page" do
                                click_link "Cancel"
                                expect(page.status_code).to be 200
                                expect(current_url).to eq board_url(created_board)
                              end
                            end

                            context "Upon submitting the form by clicking Save Changes" do
                              before :each do
                                fill_in "Description", :with => "Its a Fashion Board."
                                click_button "Save Changes"
                              end

                              it "board is updated successfully" do
                                expect(created_board).to be_a Board
                                expect(created_board.description).to eq "Its a Fashion Board."
                              end

                              it "and Show Board Page is displayed" do
                                expect(page.status_code).to be 200
                                expect(current_url).to eq board_url(created_board)
                              end

                            end

                          end

                        end

                        context "Upon clicking on Add a Pin link" do

                          before(:each){
                            click_link "Add a Pin"
                          }

                          it "Display New Pin Page" do
                            expect(page.status_code).to eq 200
                            expect(current_url).to eq new_board_pin_url(created_board.id)
                          end

                          describe "where it:" do

                            it { page.should have_field("pin_image", :type => "file") }

                            it { page.should have_field("Description") }

                            it { page.should have_select("pin_board_id") }

                            it { page.should have_link("Close") }

                            it { page.should have_button("Pin it") }

                            context "Upon filling the form and clicking Pin it" do

                              let(:created_pin) { Pin.find_by(description: "Google Image", board_id: created_board.id) }

                              before(:each){
                                fill_in "Description", :with => "Google Image"
                                select created_board.name, from: "pin_board_id"
                                attach_file("pin_image", "#{Rails.root}/spec/support/google.png")
                                click_button "Pin it"
                              }

                              it "A new pin is created" do
                                expect(created_pin.description).to eq "Google Image"
                                expect(created_pin.image_file_name).to eq "google.png"
                              end

                              describe "Display Show Board Page" do

                                it "with new pin details" do
                                  expect(page.status_code).to be 200
                                  expect(current_url).to eq board_url(created_board)
                                  expect(page).to have_text("#{created_board.pins[0].description}")
                                end

                                context "Upon clicking on the Pin" do

                                  before(:each) {
                                    click_link "#{created_board.pins[0].description}"
                                  }

                                  it "Display Show Pin Page" do
                                    expect(page.status_code).to be 200
                                    expect(current_url).to eq pin_url(created_pin)
                                  end

                                  describe "where it:" do

                                    it "should display Board Name" do
                                      expect(page).to have_link("#{created_pin.board.name}")
                                    end

                                    it "should have an Image" do
                                      expect(page).to have_selector("img", count: 2 )
                                    end

                                    it { page.should have_link("Edit Pin") }

                                    context "Upon clicking on Edit Pin link" do

                                      before(:each){
                                        click_link "Edit Pin"
                                      }

                                      it "Display Edit Pin Page" do
                                        expect(page.status_code).to eq 200
                                        expect(current_url).to eq edit_pin_url(created_pin)
                                      end

                                      describe "where it:" do

                                        it { page.should have_field("Description") }

                                        it { page.should have_select("pin_board_id") }

                                        it { page.should have_link("Delete") }

                                        it { page.should have_button("Save Changes") }


                                        context "Upon clicking on Delete" do

                                          before(:each){
                                            click_link "Delete"
                                          }

                                          it "pin is removed from the database" do
                                            expect(Pin.find_by(board_id: created_board.id, description: "Google Image")).to be nil
                                          end

                                          it "and Show Board Page is displayed" do
                                            expect(page.status_code).to be 200
                                            expect(current_url).to eq board_url(created_board)
                                          end

                                        end

                                        context "Upon clicking on Cancel" do

                                          it "Display Show Pin Page" do
                                            click_link "Cancel"
                                            expect(page.status_code).to eq 200
                                            expect(current_url).to eq pin_url(created_pin)
                                          end

                                        end

                                        context "Upon submitting the form by clicking on Save Changes" do

                                          let(:created_pin) {Pin.find_by(board_id: created_board.id, description: "This is my Google Image.")}
                                          before(:each){
                                            fill_in "Description", :with => "This is my Google Image."
                                            click_button "Save Changes"
                                          }

                                          it "pin is updated successfully" do
                                            expect(created_pin).to be_a Pin
                                            expect(created_pin.description).to eq "This is my Google Image."
                                          end

                                          it "and Show Pin Page is displayed" do
                                            expect(page.status_code).to be 200
                                            expect(current_url).to eq pin_url(created_pin)
                                          end

                                        end

                                      end

                                    end

                                  end

                                end

                              end

                            end

                            context "Upon clicking Close link" do

                              it "Display Show Board Page" do
                                click_link "Close"
                                expect(page.status_code).to eq 200
                                expect(current_url).to eq board_url(created_board)
                              end

                            end

                          end

                        end









                      end

                    end


                  end



                end

                context "Upon clicking on Cancel link" do

                  it "Display Dashboard Page" do
                    click_link "Cancel"
                    expect(page.status_code).to be 200
                    expect(current_url).to eq dashboard_url
                  end

                end

              end

            end

            context "Upon clicking on Settings link" do

              before :each do
                click_link "Settings"
              end

              it "Display Account Settings Page" do
                expect(page.status_code).to be 200
                expect(current_url).to eq edit_member_registration_url
              end

              describe "where it:" do

                it { page.should have_field("Email Address", :type => "email", :with => logged_member.email ) }

                it { page.should have_field("Current Password", :type => "password") }

                it { page.should have_field("New Password", :type => "password") }

                it { page.should have_field("Confirm New Password", :type => "password") }

                it { page.should have_field("Avatar", :type => "file") }

                it { page.should have_selector("textarea#member_description") }

                it { page.should have_link("Deactivate Account") }

                it { page.should have_link("Cancel", :href => dashboard_path) }

                it { page.should have_button("Save Profile") }

              end

              context "Upon clicking on Deactivate Account link" do

                before(:each) do
                  click_link "Deactivate Account"
                end

                it "member is removed from the database" do
                  expect(Member.find_by_email logged_member.email).to be nil
                end

                it "and Home Page is displayed" do
                  expect(page.status_code).to be 200
                  expect(current_url).to eq root_url
                end

              end

              context "Upon clicking on Cancel link" do

                it "Display Dashboard Page" do
                  click_link "Cancel"
                  expect(page.status_code).to be 200
                  expect(current_url).to eq dashboard_url
                end

              end


              context "Upon submitting form by clicking on Save Profile button" do

                before :each do
                  fill_in "Current Password", :with => logged_member.password
                  fill_in "member_firstname", :with => "Jack"
                  fill_in "About You", with: "I love Music, Fashion and Food."
                  attach_file("Avatar", "#{Rails.root}/spec/support/avatar.png")
                  click_button "Save Profile"
                end

                it "member profile is updated successfully" do
                  expect(member).to be_a Member
                  expect(member.firstname).to eq "Jack"
                  expect(member.description).to eq "I love Music, Fashion and Food."
                  expect(member.avatar_file_name).to eq "avatar.png"
                end

                it "and Dashboard Page is displayed" do
                  expect(page.status_code).to be 200
                  expect(current_url).to eq dashboard_url
                end

              end

            end




          end

        end

      end

    end

  end

end
