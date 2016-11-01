class PersonMailerPreview < ActionMailer::Preview

  def temp_password
    PersonMailer.temp_password(Person.first, "dafhajca")
  end

end
