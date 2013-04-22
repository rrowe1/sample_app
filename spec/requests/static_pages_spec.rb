require 'spec_helper'

describe "Static pages" do

subject { page }

shared_examples_for "all static pages" do
	it { should have_selector('h1',text: heading) }
	it { should have_selector('title', text: full_title(page_title)) }
end

describe "Home page" do
	before { visit root_path }
	let(:heading) { 'Sample App' }
	let(:page_title) { '' }

	it_should_behave_like "all static pages"
	it { should_not have_selector 'title', text: '| Home'}
	describe "for signed-in users" do
	let(:user) { FactoryGirl.create(:user) }
		before do
			FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
			FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
			sign_in user
			visit root_path
		end
		it "should render the user's feed" do
			user.feed.each do |item|
				page.should have_selector("li##{item.id}", text: item.content)
			end
		end
		it "should render the user's feed" do
		  user.feed.paginate(page: 1).each do |item|
		    page.should have_selector("li##{item.id}", text: item.content)
		  end
		end

		
	end
end

describe "Help page" do
	before {visit help_path}
	let(:page_title) {'Help'}
	let(:heading) {'Help'}
	
	it_should_behave_like "all static pages"
	it { should have_selector 'title', text: '| Help'}

end

describe "About page" do
	before {visit about_path}
	let(:page_title) {'About'}
	let(:heading) {'About'}
	
	it_should_behave_like "all static pages"
	it { should have_selector 'title', text: '| About'}

end

describe "Contact page" do
	before {visit contact_path}
	let(:page_title) {'Contact'}
	let(:heading) {'Contact'}
	
	it_should_behave_like "all static pages"
	it { should have_selector 'title', text: '| Contact'}

end

	it "should have the right links on the layout" do
		visit root_path
		click_link "About"
		page.should have_selector 'title', text: full_title('About Us')
		click_link "Help"
		page.should have_selector 'title', text: full_title('Help')
		click_link "Contact"
		page.should have_selector 'title', text: full_title('Contact')
		click_link "Home"
		click_link "Sign up now!"
		page.should have_selector 'title', text: full_title('Sign up')
		click_link "sample app"
		page.should have_selector 'title', text: full_title('')
	end
end