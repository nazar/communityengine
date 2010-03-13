class AddPages < ActiveRecord::Migration
  def self.up
    Page.create(:title=>:about, :body=>"<p>about page goes here</p>", :published_as=>"live", :page_public=>true)
    Page.create(:title=>:faq, :body=>"<pfaq page goes here</p>", :published_as=>"live", :page_public=>true)
  end

  def self.down
    Page.destroy_all
  end
end
