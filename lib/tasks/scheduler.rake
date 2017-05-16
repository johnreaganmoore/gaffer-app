desc "This task is called by the Heroku scheduler add-on"
# task :update_feed => :environment do
#   puts "Updating feed..."
#   NewsFeed.update
#   puts "done."
# end

task :send_reminders => :environment do

  orgs = []
  Org.all.each do |org|
    org.contacts.each do |contact|
      contact.reminders.where("status = ? AND next_date <= ?", "incomplete", Date.today).each do |task|
        orgs.push(org) unless orgs.include?(org)
      end
    end
  end

  orgs.each do |org|
    org.send_reminder_email
  end

end
