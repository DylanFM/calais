require File.expand_path("#{File.dirname(__FILE__)}/helper")

describe Calais do
  it "provides a version number" do
    Calais::VERSION.should_not be_nil
  end
end

describe Calais::Client, ".new" do
  it "accepts arguments as a hash" do
    client = nil
    
    lambda { client = Calais::Client.new(:content => SAMPLE_DOCUMENT, :license_id => LICENSE_ID) }.should_not raise_error(ArgumentError)
    
    client.license_id.should == LICENSE_ID
    client.content.should == SAMPLE_DOCUMENT
  end
  
  it "accepts arguments as a block" do
    client = nil
    
    lambda {
      client = Calais::Client.new do |c|
        c.content = SAMPLE_DOCUMENT
        c.license_id = LICENSE_ID
      end
    }.should_not raise_error(ArgumentError)
    
    client.license_id.should == LICENSE_ID
    client.content.should == SAMPLE_DOCUMENT
  end
  
  it "should not accept unknown attributes" do
    lambda { Calais::Client.new(:monkey => "monkey", :license_id => LICENSE_ID) }.should raise_error(NoMethodError)
  end
end

describe Calais::Client, ".call" do
  before(:all) do
    @client = Calais::Client.new(:content => SAMPLE_DOCUMENT, :license_id => LICENSE_ID)
  end

  it "accepts known methods" do
    lambda { @client.call('enlighten') }.should_not raise_error(ArgumentError)
  end

  it "complains about unkown methods" do
    lambda { @client.call('monkey') }.should raise_error(ArgumentError)
  end
end

describe Calais::Client, ".params_xml" do
  it "returns an xml encoded string" do
    client = Calais::Client.new(:content => SAMPLE_DOCUMENT, :content_type => :xml, :license_id => LICENSE_ID)
    client.send("params_xml").should_not be_nil
    client.send("params_xml").should == %[<c:params xmlns:c=\"http://s.opencalais.com/1/pred/\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"><c:processingDirectives c:contentType=\"TEXT/XML\" c:outputFormat=\"XML/RDF\" c:reltagBaseURL=\"\" c:calculateRelevanceScore=\"false\"></c:processingDirectives><c:userDirectives c:allowDistribution=\"false\" c:allowSearch=\"false\" c:externalID=\"f14fd3588ba6bfb91a9294240d2d081cfbdc079c\" c:submitter=\"calais.rb\"></c:userDirectives><c:externalMetadata></c:externalMetadata></c:params>]
  end
end