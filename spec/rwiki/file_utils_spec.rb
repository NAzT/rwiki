require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Rwiki::FileUtils do

  before :each do
    Rwiki::FileUtils.rwiki_path = File.join(TmpdirHelper::TMP_DIR, 'pages')
  end

  subject { Rwiki::FileUtils.new('folder/subfolder') }

  describe ".rwiki_path method" do
    it "should be defined" do
      Rwiki::FileUtils.should respond_to(:rwiki_path)
    end

    it "should return valid path" do
      Rwiki::FileUtils.rwiki_path.should == '/tmp/rwiki_test/pages'
    end
  end

  describe ".rwiki_path= method" do
    it "should be defined" do
      Rwiki::FileUtils.should respond_to(:rwiki_path=)
    end

    it "should set the path" do
      Rwiki::FileUtils.rwiki_path = '/some/path'
      Rwiki::FileUtils.rwiki_path.should == '/some/path'
    end
  end

  describe "#path method" do
    it "should be defined" do
      subject.should respond_to(:path)
    end

    it "should return valid node path" do
      subject.path.should == 'folder/subfolder'
    end
  end

  describe "#file_path method" do
    it "should be defined" do
      subject.should respond_to(:file_path)
    end

    it "should return valid file path" do
      subject.file_path.should == 'folder/subfolder.txt'
    end
  end

  describe "#full_path method" do
    it "should be defined" do
      subject.should respond_to(:full_path)
    end

    it "should return valid full path" do
      subject.full_path.should == '/tmp/rwiki_test/pages/folder/subfolder'
    end
  end

  describe "#full_file_path method" do
    it "should be defined" do
      subject.should respond_to(:full_file_path)
    end

    it "should return valid file path" do
      subject.full_file_path.should == '/tmp/rwiki_test/pages/folder/subfolder.txt'
    end
  end

  describe "#base_name method" do
    it "should be defined" do
      subject.should respond_to(:base_name)
    end

    it "should return valid base name" do
      subject.base_name.should == "subfolder"
    end
  end

  describe "#delete method" do
    it "should be defined" do
      subject.should respond_to(:delete)
    end

    it "should remove page file" do
      full_file_path = subject.full_file_path
      subject.delete

      File.exists?(full_file_path).should be_false
    end

    it "should remove subpages" do
      full_path = subject.full_path
      subject.delete

      Dir.exist?(full_path).should be_false
    end
  end

end