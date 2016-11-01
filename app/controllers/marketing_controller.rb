class MarketingController < ApplicationController
  def home
  end

  def harrisburg


    @orgs = [
      {
        name: "Harrisburg Area Co-ed Pickup",
        external_link: "https://www.facebook.com/groups/437756026254931/",
        category: "Pickup",
        opps: [
          {
            name: "Friday Night Indoor Pickup",
            timeframe: "Friday Night",
            in_or_outdoor: "Indoor",
            category: "Pickup",
            price: "$7",
            external_link: "http://www.meetup.com/Harrisburg-Area-Co-ed-Pick-up-Soccer/",
            basics: [
              "Adult - Open",
              "Coed",
              "Pickup",
              "Indoor"
            ],
            next_start: {
              date: "November 4th",
              time: "9pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Saturday Morning Pickup",
            timeframe: "Saturday Morning",
            in_or_outdoor: "Outdoor",
            category: "Pickup",
            price: "FREE",
            external_link: "https://www.facebook.com/events/150231985442535/",
            basics: [
              "Adult - Open",
              "Coed",
              "Pickup",
              "Outdoor"
            ],
            next_start: {
              date: "November 5th",
              time: "10am ET"
            },
            location: {
              name: "Sporting Hill Elementary School",
              location_link: "#",
              address: {
                street: "210 S Sporting Hill Rd",
                city: "Mechanicsburg",
                state: "PA",
                zip: "17050"
              },
              address_link: "https://goo.gl/maps/WtZbqo6QCHD2"
            }
          }
        ]
      },
      {
        name: "Harrisburg City Islanders",
        external_link: "http://cityislanders.com/",
        category: "Club",
        opps: [
          {
            name: "Pro Tryout",
            timeframe: "Tuesday and Wednesday Morning and Afternoon",
            in_or_outdoor: "Indoor",
            category: "Tryout",
            price: "$100",
            external_link: "http://cityislanders.com/press-releases/harrisburg-city-islanders-announce-pro-team-tryout/",
            basics: [
              "Pro",
              "Tryout"
            ],
            next_start: {
              date: "November 22th",
              time: "9am ET"
            },
            location: {
              name: "In The Net",
              location_link: "http://www.inthenet.com/",
              address: {
                street: "798 Airport Road",
                city: "Palmyra",
                state: "PA",
                zip: "17078"
              },
              address_link: "https://goo.gl/maps/q8oEaJzjTYC2"
            }
          }
        ]
      },
      {
        name: "Yellow Breeches Sports Center",
        external_link: "http://yellowbreechessports.com/sports/soccer/",
        category: "League",
        opps: [
          {
            name: "Tuesday Men's Indoor",
            timeframe: "Tuesday Nights",
            in_or_outdoor: "Indoor",
            category: "Season",
            price: "$35",
            external_link: "http://yellowbreechessports.com/docs/soccer/ADULT-SOCCER-LEAGUE-Winter-1-2016.pdf",
            basics: [
              "Season",
              "Indoor",
              "Men's - Open",
            ],
            next_start: {
              date: "November 8th",
              time: "9pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Thursday Men's Indoor",
            timeframe: "Thursdays Nights",
            in_or_outdoor: "Indoor",
            category: "Season",
            price: "$35",
            external_link: "http://yellowbreechessports.com/docs/soccer/ADULT-SOCCER-LEAGUE-Winter-1-2016.pdf",
            basics: [
              "Season",
              "Indoor",
              "Men's - Open",
            ],
            next_start: {
              date: "November 10th",
              time: "9pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Monday Coed Indoor",
            timeframe: "Monday Nights",
            in_or_outdoor: "Indoor",
            category: "Season",
            price: "$35",
            external_link: "http://yellowbreechessports.com/docs/soccer/ADULT-SOCCER-LEAGUE-Winter-1-2016.pdf",
            basics: [
              "Season",
              "Indoor",
              "Adult - Open",
              "Coed",
            ],
            next_start: {
              date: "November 7th",
              time: "9pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Wednesday Coed Indoor",
            timeframe: "Wednesday Nights",
            in_or_outdoor: "Indoor",
            category: "Season",
            price: "$35",
            external_link: "http://yellowbreechessports.com/docs/soccer/ADULT-SOCCER-LEAGUE-Winter-1-2016.pdf",
            basics: [
              "Season",
              "Indoor",
              "Adult - Open",
              "Coed",
            ],
            next_start: {
              date: "November 9th",
              time: "9pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Tuesday Women's Indoor",
            timeframe: "Tuesday Nights",
            in_or_outdoor: "Indoor",
            category: "Season",
            price: "$35",
            external_link: "http://yellowbreechessports.com/docs/soccer/ADULT-SOCCER-LEAGUE-Winter-1-2016.pdf",
            basics: [
              "Season",
              "Indoor",
              "Women's - Open",
            ],
            next_start: {
              date: "November 8th",
              time: "9pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Men's November Tournament",
            timeframe: "Saturday Afternoon and Night",
            in_or_outdoor: "Indoor",
            category: "Tournament",
            price: "$150/team",
            external_link: "http://yellowbreechessports.com/docs/soccer/November-2016-Adult-Soccer-Tournament.pdf",
            basics: [
              "Tournament",
              "Indoor",
              "Men's - Open",
            ],
            next_start: {
              date: "November 26th",
              time: "3pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Women's November Tournament",
            timeframe: "Saturday Afternoon and Night",
            in_or_outdoor: "Indoor",
            category: "Tournament",
            price: "$150/team",
            external_link: "http://yellowbreechessports.com/docs/soccer/November-2016-Adult-Soccer-Tournament.pdf",
            basics: [
              "Tournament",
              "Indoor",
              "Women's - Open",
            ],
            next_start: {
              date: "November 26th",
              time: "3pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Coed November Tournament",
            timeframe: "Saturday Afternoon and Night",
            in_or_outdoor: "Indoor",
            category: "Tournament",
            price: "$150/team",
            external_link: "http://yellowbreechessports.com/docs/soccer/November-2016-Adult-Soccer-Tournament.pdf",
            basics: [
              "Tournament",
              "Indoor",
              "Coed",
              "Adult - Open",
            ],
            next_start: {
              date: "November 26th",
              time: "3pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Men's December Tournament",
            timeframe: "Saturday Afternoon and Night",
            in_or_outdoor: "Indoor",
            category: "Tournament",
            price: "$150/team",
            external_link: "http://yellowbreechessports.com/docs/soccer/December-2016-Adult-Soccer-Tournament.pdf",
            basics: [
              "Tournament",
              "Indoor",
              "Men's - Open",
            ],
            next_start: {
              date: "December 17th",
              time: "3pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Women's December Tournament",
            timeframe: "Saturday Afternoon and Night",
            in_or_outdoor: "Indoor",
            category: "Tournament",
            price: "$150/team",
            external_link: "http://yellowbreechessports.com/docs/soccer/December-2016-Adult-Soccer-Tournament.pdf",
            basics: [
              "Tournament",
              "Indoor",
              "Women's - Open",
            ],
            next_start: {
              date: "December 17th",
              time: "3pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
          {
            name: "Coed December Tournament",
            timeframe: "Saturday Afternoon and Night",
            in_or_outdoor: "Indoor",
            category: "Tournament",
            price: "$150/team",
            external_link: "http://yellowbreechessports.com/docs/soccer/December-2016-Adult-Soccer-Tournament.pdf",
            basics: [
              "Tournament",
              "Indoor",
              "Coed",
              "Adult - Open",
            ],
            next_start: {
              date: "December 17th",
              time: "3pm ET"
            },
            location: {
              name: "Yellow Breeches Sports Center",
              location_link: "http://yellowbreechessports.com/",
              address: {
                street: "700 Shawnee Court",
                city: "New Cumberland",
                state: "PA",
                zip: "17070"
              },
              address_link: "https://goo.gl/maps/2QabFnC3d7S2"
            }
          },
        ]
      }

    ]





  end

  def coming_soon
    @lead = Lead.new
  end
end
