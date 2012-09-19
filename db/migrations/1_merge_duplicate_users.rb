require "dm-migrations/migration_runner"

require File.join(File.dirname(__FILE__), "..", "..", "config", "boot")

migration 1, :merge_duplicate_users do
  up do
    # Find all users without Unfuddle IDs.
    User.all(:unfuddle_id => nil).each do |user|
      # For each users, find the equivalent user WITH an Unfuddle ID.
      duplicate_user = User.first(:name => user.name, :unfuddle_id.not => nil)

      # Update the original user (because he/she will have a lot more tickets than the new user).
      user.update(:unfuddle_id => duplicate_user.unfuddle_id)

      # Assign all of the new user's Unfuddle tickets to the original user.
      duplicate_user.tickets.each do |ticket|
        ticket.update(:user => user)
      end

      # Same with comments.
      duplicate_user.comments.each do |comment|
        comment.update(:user => user)
      end

      # Blow away the dupe.
      duplicate_user.destroy
    end
  end

  down do
    # Can't undo this bad boy.
  end
end
