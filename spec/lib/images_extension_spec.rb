require 'spec_helper'

describe ImagesExtension do
  
  describe 's3_credentials' do
    
    context 'load through yaml' do
      
      before :each do
        
        if File.exists?(File.join(Rails.root,'config','amazon_s3.yml'))
          FileUtils.mv(File.join(Rails.root,'config','amazon_s3.yml'),File.join(Rails.root,'config','amazon_s3-back.yml'))
        end
        
        f = File.new(File.join(Rails.root,'config','amazon_s3.yml'), 'w')
        f << "#{RAILS_ENV}:\n"
        f << "  access_key_id: FILE KEY\n"
        f << "  secret_access_key: FILE SECRET"
        f.close
        
      end
      
      it 'should return the file config strings' do
        ImagesExtension.s3_credentials.should == { 'access_key_id' => 'FILE KEY', 'secret_access_key' => 'FILE SECRET' }
      end
      
      after :each do
        File.delete(File.join(Rails.root,'config','amazon_s3.yml'))
          
        if File.exists?(File.join(Rails.root,'config','amazon_s3-back.yml'))
          FileUtils.mv(File.join(Rails.root,'config','amazon_s3-back.yml'),File.join(Rails.root,'config','amazon_s3.yml'))
        end
      end
      
    end
    
    context 'load through Radiant::Config' do
      
      before :each do
        
        Radiant::Config['s3.key']    = 'DB KEY'
        Radiant::Config['s3.secret'] = 'DB SECRET'
        
        if File.exists?(File.join(Rails.root,'config','amazon_s3.yml'))
          FileUtils.mv(File.join(Rails.root,'config','amazon_s3.yml'),File.join(Rails.root,'config','amazon_s3-back.yml'))
        end
        
      end
      
      it 'should return the radiant config strings' do
        ImagesExtension.s3_credentials.should == { 'access_key_id' => 'DB KEY', 'secret_access_key' => 'DB SECRET' }
      end
      
      after :each do
        if File.exists?(File.join(Rails.root,'config','amazon_s3-back.yml'))
          FileUtils.mv(File.join(Rails.root,'config','amazon_s3-back.yml'),File.join(Rails.root,'config','amazon_s3.yml'))
        end
      end
      
    end
    
  end
  
end