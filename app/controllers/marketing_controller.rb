class MarketingController < ApplicationController
  def home
  end

  def tos
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
              date: "November 11th",
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
            external_link: "https://www.facebook.com/events/609921559192439/",
            basics: [
              "Adult - Open",
              "Coed",
              "Pickup",
              "Outdoor"
            ],
            next_start: {
              date: "November 12th",
              time: "10:15am ET"
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
              address_link: "https://goo.gl/maps/4juzkqApgQx"
            }
            # location: {
            #   name: "Adams Ricci Park",
            #   location_link: "#",
            #   address: {
            #     street: "100 E Penn Dr",
            #     city: "Enola",
            #     state: "PA",
            #     zip: "17025"
            #   },
            #   address_link: "https://goo.gl/maps/XZSZayxBfbU2"
            # }
          }
        ]
      },
      {
        name: "Twin Ponds",
        external_link: "http://twinponds.com/soccer/",
        category: "Facility",
        opps: [
          {
            name: "Monday Night Indoor Pickup",
            timeframe: "Monday Night",
            in_or_outdoor: "Indoor",
            category: "Pickup",
            price: "$5",
            external_link: "http://twinponds.com/soccer/open-soccer/",
            basics: [
              "Adult - 16+",
              "Coed",
              "Pickup",
              "Indoor"
            ],
            next_start: {
              date: "November 7th",
              time: "9pm ET"
            },
            location: {
              name: "Twin Ponds West",
              location_link: "http://twinponds.com/soccer/",
              address: {
                street: "200 Lambs Gap Road",
                city: "Mechanicsburg",
                state: "PA",
                zip: "17050"
              },
              address_link: "https://goo.gl/maps/guQsjxiq9LR2"
            }
          },
          {
            name: "Wednesday Night Indoor Pickup",
            timeframe: "Wednesday Night",
            in_or_outdoor: "Indoor",
            category: "Pickup",
            price: "$5",
            external_link: "http://twinponds.com/soccer/open-soccer/",
            basics: [
              "Adult - 16+",
              "Coed",
              "Pickup",
              "Indoor"
            ],
            next_start: {
              date: "November 9th",
              time: "9pm ET"
            },
            location: {
              name: "Twin Ponds West",
              location_link: "http://twinponds.com/soccer/",
              address: {
                street: "200 Lambs Gap Road",
                city: "Mechanicsburg",
                state: "PA",
                zip: "17050"
              },
              address_link: "https://goo.gl/maps/guQsjxiq9LR2"
            }
          },
          {
            name: "Men's Over 30",
            timeframe: "Monday Night",
            in_or_outdoor: "Indoor",
            category: "League",
            price: "TBD",
            external_link: "http://twinponds.com/soccer/adult-soccer/",
            basics: [
              "Over 30",
              "Men",
              "Season",
              "Indoor"
            ],
            next_start: {
              date: "TBD",
              time: "TBD"
            },
            location: {
              name: "Twin Ponds West",
              location_link: "http://twinponds.com/soccer/",
              address: {
                street: "200 Lambs Gap Road",
                city: "Mechanicsburg",
                state: "PA",
                zip: "17050"
              },
              address_link: "https://goo.gl/maps/guQsjxiq9LR2"
            }
          },
          {
            name: "Women's Over 30",
            timeframe: "Friday Night",
            in_or_outdoor: "Indoor",
            category: "League",
            price: "TBD",
            external_link: "http://twinponds.com/soccer/adult-soccer/",
            basics: [
              "Over 30",
              "Women",
              "Season",
              "Indoor"
            ],
            next_start: {
              date: "TBD",
              time: "TBD"
            },
            location: {
              name: "Twin Ponds West",
              location_link: "http://twinponds.com/soccer/",
              address: {
                street: "200 Lambs Gap Road",
                city: "Mechanicsburg",
                state: "PA",
                zip: "17050"
              },
              address_link: "https://goo.gl/maps/guQsjxiq9LR2"
            }
          },
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
        category: "Facility",
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
      },
      {
        name: "In The Net",
        external_link: "http://www.inthenet.com/",
        category: "Facility",
        opps: [
          {
            name: "Wednesday Night Men's League",
            timeframe: "Wednesday Night",
            in_or_outdoor: "Indoor",
            category: "Season",
            price: "$975/team",
            external_link: "http://www.inthenet.com/leagues/soccer/2016-05-19-18-08-56.html",
            basics: [
              "Adult - Open",
              "Men",
              "Season",
              "Indoor"
            ],
            next_start: {
              date: "December 7th",
              time: "TBD"
            },
            location: {
              name: "In The Net Sports Complex",
              location_link: "http://www.inthenet.com/",
              address: {
                street: "798 Airport Road",
                city: "Palmyra",
                state: "PA",
                zip: "17078"
              },
              address_link: "https://goo.gl/maps/fiyXAE2tsDy"
            }
          }
        ]
      },

    ]





  end

  def coming_soon
    @lead = Lead.new
  end

  def subs
  end

  def register
  end

  def tryout
    @lead = Lead.new
  end

  def collect
    @lead = Lead.new
  end

end
