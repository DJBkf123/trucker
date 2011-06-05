require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class LegacyMuppet
  class << self
    def limit(number)
      self
    end
    def offset(number)
      self
    end
    def all
      self
    end
  end
end

describe "Trucker builds ActiveRecord queries in Rails 3 syntax" do
  before(:each) do
    ENV['offset'] = nil
    ENV['limit'] = nil
    ENV['where'] = nil
  end
  it "handles limits" do
    ENV['limit'] = "20"
    Trucker.number_of_records.should == ".limit(20)"
    Trucker.construct_query("muppets").should == "LegacyMuppet.limit(20)"
  end
  it "handles ordering" do
    ENV['offset'] = "20"
    Trucker.offset_for_records.should == ".offset(20)"
    Trucker.construct_query("muppets").should == "LegacyMuppet.offset(20)"
  end
  it "handles an unmodified .all()" do
    Trucker.construct_query("muppets").should == "LegacyMuppet.all"
  end
  it "handles where()" do
    ENV['where'] = ":username => 'fred'"
    Trucker.construct_query("muppets").should == "LegacyMuppet.where(:username => 'fred')"
  end
end

