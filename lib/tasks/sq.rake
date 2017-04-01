namespace :migrate do
  desc "Sequel migration to a specific migration"
  # rake migrate:to[004]
  task :to, [:migration_number] => :environment do |t, args|
    current_version = Sequel::Model.db[:schema_info].first[:version]
    new_version = args[:migration_number].to_i
    Rails.logger.info "Going from #{current_version} to #{new_version}"
    if new_version < current_version
      Rails.logger.info "Migrating UP from #{current_version} to #{new_version}"
      ENV['VERSION'] = new_version.to_s
      Rake::Task["db:migrate:up"].invoke
    elsif new_version > current_version
      Rails.logger.info "Migrating DOWN from #{current_version} to #{new_version}"
      ENV['VERSION'] = new_version.to_s
      Rake::Task["db:migrate:down"].invoke
    else
      Rails.logger.info "Nothing to do"
    end
  end
end
