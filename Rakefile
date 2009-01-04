require 'pathname'
require 'fileutils'

APP_SHORT_NAME = 'InputSwitcher'
APP_NAME = SHORT_NAME + '.app'
BUNDLE_NAME = 'InputSwitcherClient.bundle'

ROOT_PATH = Pathname.new(__FILE__).dirname
APP_PATH = Pathname.new(__FILE__).dirname + 'app'
BUNDLE_PATH = Pathname.new(__FILE__).dirname + 'bundle'

TMP_PATH = Pathname.new("/tmp/#{SHORT_NAME}_build_image")
TMP_SOURCE_PATH = Pathname.new("/tmp/#{SHORT_NAME}_source")
SOURCE_ZIP_PATH = TMP_SOURCE_PATH + "source.zip"
DESKTOP_PATH = Pathname.new('~/Desktop').expand_path
BUILT_APP_PATH = APP_PATH + 'build/Release' + APP_NAME
BUILT_BUNDLE_PATH = BUNDLE_PATH + 'build/Release' + BUNDLE_NAME

task :default => [:package_source, :package]

task :build => [:build_app, :build_bundle] do |t|
end

task :build_app => :clean_app do |t|
  sh "cd app; xcodebuild -configuration Release"
end

task :build_bundle => :clean_bundle do |t|
  sh "cd bundle; xcodebuild -configuration Release"
end

task :package_source => :clean do |t|
	SOURCE_ZIP_PATH.rmtree
	TMP_SOURCE_PATH.mkpath
	TMP_PATH.rmtree
	TMP_PATH.mkpath
	ROOT_PATH.cptree(TMP_PATH)
	
	rmglob(TMP_PATH + '**/.DS_Store')
	
	Dir.chdir(TMP_PATH) do
		sh "zip -qr #{SOURCE_ZIP_PATH} *"
	end
	
	TMP_PATH.rmtree
end

task :package => :build do |t|
	ZIP_PATH = DESKTOP_PATH + "#{SHORT_NAME}_#{app_version}.zip"
	ZIP_PATH.rmtree
	TMP_PATH.rmtree
	TMP_PATH.mkpath
	BUILT_APP_PATH.cptree(TMP_PATH)
	BUILT_BUNDLE_PATH.cptree(TMP_PATH)
	SOURCE_ZIP_PATH.cptree(TMP_PATH)
	SOURCE_ZIP_PATH.cptree(TMP_PATH)
	
	Dir.glob(ROOT_PATH.to_s + '/*.txt').each do |file|
  	Pathname.new(file).cptree(TMP_PATH)
	end
	
	rmglob(TMP_PATH + '**/.DS_Store')
	
	Dir.chdir(TMP_PATH) do
		sh "zip -qr #{ZIP_PATH} *"
	end
	
	TMP_PATH.rmtree
end

task :clean => [:clean_app, :clean_bundle] do |t|
end

task :clean_app do |t|
  sh "cd app; rm -rf build check"
end

task :clean_bundle do |t|
  sh "cd bundle; rm -rf build check"
end

task :check => :clean do |t|
  sh "cd app; scan-build -o ./check --view xcodebuild -configuration Debug"
  sh "cd bundle; scan-build -o ./check --view xcodebuild -configuration Debug"
end


module Util
	def app_version
		file = APP_PATH + 'Info.plist'
		file.open do |f|
		  next_line = false
		  while s = f.gets
		    if next_line
		      next_line = false
		      if s =~ /<string>(.+)<\/string>/
		        return $1
		      end
		    elsif s =~ /<key>CFBundleVersion<\/key>/
		      next_line = true
		    end
		  end
		end
		nil
	end
	
	def rmglob(path)
	  FileUtils.rm_rf(Dir.glob(path.to_s))
	end
end
include Util

class Pathname
  def rmtree
    FileUtils.rm_rf(to_s)
  end
  
  def cptree(to)
    FileUtils.cp_r(to_s, to.to_s)
  end
end
