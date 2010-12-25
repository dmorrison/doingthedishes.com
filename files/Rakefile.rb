MSBUILD_EXTENSIONS_PATH = "C:/Program Files (x86)/MSBuild"

task :deploy => ["util:validate_config_is_not_debug", "db:deploy", "site:deploy"]

namespace :db do
	
	task :deploy => [:sync_schema, :sync_data, :migrate]

	desc "If the configuration is staging, sync the release server's " +
		 "Db schema to the staging server's"
	task :sync_schema do
		if ENV["CONFIG"] == "staging"
			command = "sqlcompare /server1:MY_SERVER /db1:C4IFACT /server2:MY_SERVER /db2:C4IFACT_Test /sync"
			sh command do |ok, status|
				# If there was any other error status returned except 63
				# (error status for databases being identical), then fail.
				(ok or status.exitstatus == 63) or fail
			end
		end
	end
	
	desc "If the configuration is staging, sync the release server's " +
		 "Db data to the staging server's"
	task :sync_data do
		if ENV["CONFIG"] == "staging"
			command = "sqldatacompare /server1:My /db1:C4IFACT /server2:MY_SERVER /db2:C4IFACT_Test /sync"
			sh command do |ok, status|
				# If there was any other error status returned except 63
				# (error status for databases being identical), then fail.
				(ok or status.exitstatus == 63) or fail
			end
		end
	end
	
	desc "Runs all migrations against the configruation's DB"
	task :migrate => ["util:validate_config", "db:build_migrations_project"] do
		# Form the connection string.
		case ENV["CONFIG"]
			when "debug"
				server = "(local)"
				db = "C4IFACT_Dev"
			when "staging"
				server = "MY_SERVER"
				db = "C4IFACT_Test"
			when "release"
				server = "MY_SERVER"
				db = "C4IFACT"
		end
		
		conn_string = "Server=#{server};Database=#{db};User ID=MY_USER_ID;Password=MY_PASSWORD;"
		
		# Run any migrations new to the target Db.
		sh "..\\C4IFACT.DBMigrations\\Lib\\Migrator.Console.exe SqlServer \"#{conn_string}\" " +
		   "..\\C4IFACT.DBMigrations\\bin\\Debug\\C4IFACT.DBMigrations.dll"
	end
	
	desc "Builds the migrations project so that migrations can be run"
	task :build_migrations_project do
		sh "msbuild ..\\C4IFACT.DBMigrations\\C4IFACT.DBMigrations.csproj"
	end
	
	desc "Rebuilds the development db on the developer's local system"
	task :recreate_local_dev_db do
		sh 'powershell "CreateDevDB\Create_Dev_DB.ps1 \'(local)\'"'
	end
	
end

namespace :site do

	desc "Copy the built site to the staging or release server"
	task :deploy => :build do	
		if ENV["CONFIG"] == "staging"		
			sh "robocopy \"..\\Deployment\\Staging\" \"\\\\MY_SERVER_MACHINE\\PATH_TO_STAGING_SITE\" /MIR" do |ok, status|
				(ok or status.exitstatus == 1) or fail
			end
		elsif ENV["CONFIG"] == "release"
			sh "robocopy \"..\\Deployment\\Release\" \"\\\\MY_SERVER_MACHINE\\PATH_TO_PROD_SITE\\C4IFACT\" /MIR" do |ok, status|
				(ok or status.exitstatus == 1) or fail
			end
		end
	end
	
	desc "Builds the solution in a given configuration"
	task :build => "util:validate_config" do		
		sh "msbuild.exe " +
		   "/p:Configuration=#{ENV['CONFIG']};MSBuildExtensionsPath=\"#{MSBUILD_EXTENSIONS_PATH}\" " +
		   "../C4IFACT.sln"
	end
	
end

namespace :test do
	
	task :run_unit_tests => ["util:validate_config_is_debug", "site:build", "db:recreate_local_dev_db"] do
		sh 'mstest /testmetadata:..\C4IFACT.vsmdi /testlist:"Unit Tests"'
	end
	
end

namespace :util do
	
	task :validate_config do
		fail "CONFIG not defined" if !ENV["CONFIG"]
		
		ENV["CONFIG"] = ENV["CONFIG"].downcase
		
		if ENV["CONFIG"] != "debug" and ENV["CONFIG"] != "staging" and ENV["CONFIG"] != "release"
			fail "CONFIG is invalid"
		end
	end
	
	task :validate_config_is_debug => :validate_config do
		fail 'CONFIG should be "debug"' if ENV["CONFIG"] != "debug"
	end
	
	task :validate_config_is_not_debug => :validate_config do
		fail 'CONFIG should not be "debug"' if ENV["CONFIG"] == "debug"
	end
	
end