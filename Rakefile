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

    project.all_users.each do |unfuddle_user|
      user = User.first(:unfuddle_id => unfuddle_user.id)

      if user.nil?
        user = User.create({
          :unfuddle_id => unfuddle_user.id,
          :name        => unfuddle_user.name,
          :email       => unfuddle_user.email
        })

        puts "Created user #{user.id} for Unfuddle user #{user.unfuddle_id}"
      end
    end

    project.each_ticket do |unfuddle_ticket|
      ticket = Ticket.first(:unfuddle_id => unfuddle_ticket.id)

      if ticket.nil?
        # Only create new records for recent tickets.
        if (unfuddle_ticket.updated_at || unfuddle_ticket.created_at) < since
          puts "Quitting at Unfuddle ticket #{unfuddle_ticket.id} (too old)"
          break false
        end

        ticket = Ticket.create({
          :unfuddle_id         => unfuddle_ticket.id,
          :user                => User.first(:unfuddle_id => unfuddle_ticket.assignee_id),
          :summary             => unfuddle_ticket.summary,
          :description         => unfuddle_ticket.description,
          :status              => unfuddle_ticket.status,
          :unfuddle_created_at => unfuddle_ticket.created_at,
          :unfuddle_updated_at => unfuddle_ticket.updated_at
        })

        puts "Created ticket #{ticket.id} for Unfuddle ticket #{ticket.unfuddle_id}"

      else
        if unfuddle_ticket.updated_at > ticket.unfuddle_updated_at
          ticket.updates.create({
            :user               => User.first(:unfuddle_id => unfuddle_ticket.assignee_id),
            :summary            => unfuddle_ticket.summary,
            :description        => unfuddle_ticket.description,
            :status             => unfuddle_ticket.status,
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
          puts "Quitting at Unfuddle comment #{unfuddle_comment.id} (too old)"
          break false
        end

        user = User.first(:unfuddle_id => unfuddle_comment.user_id)

        if user.nil?
          puts "Cannot create comment for Unfuddle comment #{unfuddle_comment.id} -- user not found"
          next
        end

        comment = user.comments.create({
          :unfuddle_id         => unfuddle_comment.id,
          :ticket              => Ticket.first(:unfuddle_id => unfuddle_comment.ticket_id),
          :body                => unfuddle_comment.body,
          :unfuddle_created_at => unfuddle_comment.created_at,
          :unfuddle_updated_at => unfuddle_comment.updated_at
        })

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
