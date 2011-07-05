describe MongodbRestEngine do

  it "should be declared and have version" do
    MongodbRestEngine.constants.should include(:VERSION)
  end

end
