require 'spec_helper'

describe "Launch Application" do

  before :each do
    visit root_path
  end

  it "Display Home Page" do
    expect(page.status_code).to be 200
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

    context "Upon clicking on Join Us link" do

      before :each do
        click_link "Join Us"
      end

      it "Display Member Registration page" do
        expect(page.status_code).to be 200
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
          end

        end

        shared_examples "a Settings and Log Out link" do

          it { page.should have_link("Settings", :href => edit_member_registration_path) }

          it { page.should have_link("Log Out", :href => destroy_member_session_path) }

        end

        context "Upon filling the form and clicking on Join button" do

          before :each do
            fill_in "First Name", with: "Kirti"
            fill_in "Last Name", with: "Thorat"
            fill_in "Email Address", with: "kirti@gmail.com"
            fill_in "Password", with: "12345678"
            fill_in "Confirm Password", with: "12345678"
            select "UK", from: "member_location"
            choose "member_gender_female"
            click_button "Join"
          end
=begin
          Lets test whether a new member is saved in database with the given "email".
          The reason for not testing all other fields is that Devise gem will only store
          email, password fields but within that password is encrypted. The only option here 
          to test email.
=end

          let(:member) {Member.find_by_email "kirti@gmail.com"}

          it "A new member is registered" do
=begin
          Now lets test all other field names(except password because of encryption) 
          supplied above. But before running any tests on them, field names must be 
          permitted in the application controller as they won't be stored in database. 
=end       
            expect(member).to be_a Member
            expect(member.firstname).to eq "Kirti"
            expect(member.lastname).to eq "Thorat"
            expect(member.location).to eq "UK"
            expect(member.gender).to eq "female"
          end

          it "and Dashboard Page is displayed for that member" do
            expect(page.status_code).to be 200
          end

          describe "where it:" do

            include_examples "a Settings and Log Out link"

            it { page.should have_link("Edit", :href => edit_member_registration_path) }

            it "should display the member's full name" do
              page.should have_text(member.name)
            end

            it "should display the member's description" do
              page.should have_text(member.description)
            end

            it "should display Board count as 0" do
              page.should have_text("0 Boards")
            end

            it "should display Pin count as 0" do
              page.should have_text("0 Pins")
            end

            it { page.should have_link("Create a Board", :href => new_board_path) }

            context "Upon clicking on Settings link" do

              before :each do
                click_link "Settings"
              end

              it "Display Account Settings Page" do
                expect(page.status_code).to be 200
              end

              describe "where it:" do

                include_examples "a Settings and Log Out link"

                it { page.should have_selector("form#edit_member[method = 'post'][action = '/members']", :count => 1) }


              end

            end

          end
        end

      end

    end
=begin
    context "Upon clicking on Log In link" do

      before :each do
        click_link "Log In"
      end

      it "Display Log In page" do
        expect(page.status_code).to be 200
      end


    end
=end
  end

end
