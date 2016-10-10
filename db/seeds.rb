# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

timeframes = Timeframe.create([
    {day_of_week: "Monday", part_of_day: "Morning"},
    {day_of_week: "Monday", part_of_day: "Afternoon"},
    {day_of_week: "Monday", part_of_day: "Night"},
    {day_of_week: "Tuesday", part_of_day: "Morning"},
    {day_of_week: "Tuesday", part_of_day: "Afternoon"},
    {day_of_week: "Tuesday", part_of_day: "Night"},
    {day_of_week: "Wednesday", part_of_day: "Morning"},
    {day_of_week: "Wednesday", part_of_day: "Afternoon"},
    {day_of_week: "Wednesday", part_of_day: "Night"},
    {day_of_week: "Thursday", part_of_day: "Morning"},
    {day_of_week: "Thursday", part_of_day: "Afternoon"},
    {day_of_week: "Thursday", part_of_day: "Night"},
    {day_of_week: "Friday", part_of_day: "Morning"},
    {day_of_week: "Friday", part_of_day: "Afternoon"},
    {day_of_week: "Friday", part_of_day: "Night"},
    {day_of_week: "Saturday", part_of_day: "Morning"},
    {day_of_week: "Saturday", part_of_day: "Afternoon"},
    {day_of_week: "Saturday", part_of_day: "Night"},
    {day_of_week: "Sunday", part_of_day: "Morning"},
    {day_of_week: "Sunday", part_of_day: "Afternoon"},
    {day_of_week: "Sunday", part_of_day: "Night"}
])
