require "rake"

require File.join(File.dirname(__FILE__), "config", "boot")

namespace :db do
  desc "Update the database with the latest models and associations"
  task :update do
    DataMapper.auto_upgrade!
  end

  desc "Reset the database completely"
  task :reset do
    DataMapper.auto_migrate!
  end

  desc "Import all tickets from Unfuddle into the database"
  task :import do
    client  = Unfuddle::Client.new
    project = client.project(1)
    since   = Time.now.utc - 3.months

    first_time_import = Ticket.count == 0

    project.all_users.each do |unfuddle_user|
      user = User.first(:unfuddle_id => unfuddle_user.id)

      if user.nil?
        user = User.create_from_unfuddle(unfuddle_user)
        puts "Created user #{user.id} for Unfuddle user #{user.unfuddle_id}"

      elsif user.unfuddle_username.nil?
        user.update(:unfuddle_username => unfuddle_user.username)
        puts "Updated user #{user.id} for Unfuddle user #{user.unfuddle_id}"
      end
    end

    project.each_ticket do |unfuddle_ticket|
      ticket = Ticket.first(:unfuddle_id => unfuddle_ticket.id)

      if ticket.nil?
        # Only create new records for recent tickets.
        if (unfuddle_ticket.updated_at || unfuddle_ticket.created_at) < since
          puts "Skipping Unfuddle ticket #{unfuddle_ticket.id} (too old)"
          break false unless first_time_import
          next true
        end

        ticket = Ticket.create_from_unfuddle(unfuddle_ticket)

        puts "Created ticket #{ticket.id} for Unfuddle ticket #{ticket.unfuddle_id}"

      else
        if unfuddle_ticket.updated_at > ticket.unfuddle_updated_at || (ticket.resolution.blank? && !unfuddle_ticket.resolution.blank?)
          ticket.updates.create({
            :user               => User.first(:unfuddle_id => unfuddle_ticket.assignee_id),
            :summary            => unfuddle_ticket.summary,
            :description        => unfuddle_ticket.description,
            :status             => unfuddle_ticket.status,
            :resolution         => unfuddle_ticket.resolution,
            :unfuddle_timestamp => unfuddle_ticket.updated_at
          })

          puts "Updated ticket #{ticket.id} based on Unfuddle ticket #{ticket.unfuddle_id}"

        else
          puts "No updates for ticket #{ticket.id}"
        end
      end

      true
    end

    project.each_comment(since) do |unfuddle_comment|
      comment = Comment.first(:unfuddle_id => unfuddle_comment.id)

      if comment.nil?
        # Only create new records for recent comments.
        if unfuddle_comment.created_at < since
          puts "Skipping at Unfuddle comment #{unfuddle_comment.id} (too old)"
          break false
        end

        comment = Comment.create_from_unfuddle(unfuddle_comment)

        puts "Created comment #{comment.id} for Unfuddle comment #{comment.unfuddle_id}"
      end

      true
    end
  end
end

namespace :heroku do
  desc "Upload configuration variables to Heroku"
  task :config do
    config_vars = Heroku::Config.vars_from_yaml.map do |name, value|
      "#{name}='#{value}'"
    end

    sh "heroku config:add #{config_vars.join(' ')}"
  end
end
