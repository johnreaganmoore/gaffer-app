class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :org

  has_many :team_memberships
  has_many :people, through: :team_memberships
  has_many :invites
  has_many :team_seasons
  accepts_nested_attributes_for :team_seasons

  mount_uploader :logo, ImageUploader

  def add_creator(person)
    self.people.push(person)
    self.save
  end

  def pending_invitations
    pending = []
    self.invites.each do |invite|
      unless self.people.include?(invite.recipient) || invite.created_at != invite.updated_at
        pending.push(invite)
      end
    end
    return pending
  end

  def open_team_seasons
    self.team_seasons.where(status: "open")
  end

  def closed_team_seasons
    self.team_seasons.where(status: "closed")
  end

  def archived_team_seasons
    self.team_seasons.where(status: "archived")
  end

  def display_logo
    if self.logo.file != nil
      return self.logo
    else
      puts "Logo should be sad face"
      return self.name[0].upcase
    end
  end


  def player_avatars
    avatars = []
    self.people.each do |person|
      if person.avatar.length > 2 then
        avatars.push(person)
      end
    end
    return avatars
  end

  def self.create_random
    names = [
      "Hounds",
      "Penguins",
      "Elephants"
    ]

    e_adjectives = [
      "Elegant",
      "Eager",
      "Elevated",
      "Enormous",
      "Excellent",
      "Exacting",
      "Excitable",
      "Eerie",
      "Eloquent",
      "Echoing"
    ]

    p_adjectives = [
      "Pensive",
      "Powerful",
      "Posh",
      "Popular",
      "Peculiar",
      "Pickled",
      "Plopping",
      "Pilfering",
      "Plausible"
    ]

    h_adjectives = [
      "Hopeful",
      "Hassling",
      "Heroic",
      "Haughty",
      "Howling",
      "Seeing Eye",
      "Happy",
      "Hefty",
      "Hillbilly",
      "Hipster",
      "Hopping",
    ]

    e_image = "app/assets/images/elephant.png"
    p_image = "app/assets/images/penguin.png"
    h_image = "app/assets/images/hound.png"

    selected_name = names.sample
    selected_adjective = ""
    selected_image = ""
    selected_color = ""

    if selected_name.first == "E"
      selected_adjective = e_adjectives.sample
      selected_image = e_image
      selected_color = "#6C5F5F"
    elsif selected_name.first == "H"
      selected_adjective = h_adjectives.sample
      selected_image = h_image
      selected_color = "#a82c2c"
    else
      selected_adjective = p_adjectives.sample
      selected_image = p_image
      selected_color = "#7085B2"
    end

    final_name = "#{selected_adjective} #{selected_name}"

    image_file = File.open(selected_image, "rb")

    team = self.create(name: final_name, color: selected_color, logo: image_file)
  end

end
