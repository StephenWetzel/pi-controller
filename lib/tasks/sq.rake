namespace :migrate do
  desc "Sequel migration to a specific migration"
  # rake migrate:to[004]
  task :to, [:migration_number] => :environment do |t, args|
    current_version = Sequel::Model.db[:schema_info].first[:version].to_s
    Rails.logger.info "Going from #{current_version} to #{args[:migration_number]}"
    if args[:migration_number] < current_version
      Rails.logger.info "Migrating UP from #{current_version} to #{args[:migration_number]}"
      ENV['VERSION'] = args[:migration_number]
      Rake::Task["db:migrate:up"].invoke
    elsif args[:migration_number] > current_version
      Rails.logger.info "Migrating DOWN from #{current_version} to #{args[:migration_number]}"
      ENV['VERSION'] = args[:migration_number]
      Rake::Task["db:migrate:down"].invoke
    else
      Rails.logger.info "Nothing to do"
    end
  end
end
