puts "Seeding SpaceHub India..."

# ─── Users ────────────────────────────────────────────────────────────────────

admin = User.find_or_create_by!(email: "admin@spacehub.in") do |u|
  u.name     = "SpaceHub Admin"
  u.password = "password123"
  u.role     = "admin"
  u.city     = "Mumbai"
end
puts "  ✓ Admin: #{admin.email}"

host1 = User.find_or_create_by!(email: "host@spacehub.in") do |u|
  u.name           = "Priya Sharma"
  u.password       = "password123"
  u.role           = "host"
  u.city           = "Mumbai"
  u.bio            = "Interior designer turned space entrepreneur. I love creating beautiful, functional spaces for creative work."
  u.host_approved  = true
end

host2 = User.find_or_create_by!(email: "arjun@spacehub.in") do |u|
  u.name           = "Arjun Mehta"
  u.password       = "password123"
  u.role           = "host"
  u.city           = "Bangalore"
  u.bio            = "Tech entrepreneur with a passion for wellness. My spaces are designed for deep work and rejuvenation."
  u.host_approved  = true
end

host3 = User.find_or_create_by!(email: "kavya@spacehub.in") do |u|
  u.name           = "Kavya Nair"
  u.password       = "password123"
  u.role           = "host"
  u.city           = "Chennai"
  u.bio            = "Event designer with 10+ years experience. I host some of the most unique venues in South India."
  u.host_approved  = true
end

guest = User.find_or_create_by!(email: "guest@spacehub.in") do |u|
  u.name     = "Rohan Gupta"
  u.password = "password123"
  u.role     = "guest"
  u.city     = "Delhi"
end

# Extra guests for varied bookings
guest2 = User.find_or_create_by!(email: "ananya@spacehub.in") do |u|
  u.name     = "Ananya Reddy"
  u.password = "password123"
  u.role     = "guest"
  u.city     = "Bangalore"
end

guest3 = User.find_or_create_by!(email: "vikram@spacehub.in") do |u|
  u.name     = "Vikram Nair"
  u.password = "password123"
  u.role     = "guest"
  u.city     = "Mumbai"
end

guest4 = User.find_or_create_by!(email: "meera@spacehub.in") do |u|
  u.name     = "Meera Iyer"
  u.password = "password123"
  u.role     = "guest"
  u.city     = "Chennai"
end

puts "  ✓ Hosts and guests created"

# ─── Listings ─────────────────────────────────────────────────────────────────

listings_data = [
  # Mumbai
  {
    user: host1, city: "Mumbai", category: "wellness",
    title: "Serene Rooftop Spa Suite",
    description: "Step into a world of tranquility atop a heritage art deco building in Bandra West. Our private spa suite features floor-to-ceiling windows overlooking the Arabian Sea, a Japanese-style soaking tub, and curated aromatherapy stations.\n\nThe space is equipped with a professional massage table, ambient lighting controls, premium steam shower, and a curated selection of Ayurvedic oils. Every detail — from the teak-wood flooring to the handwoven linen — has been chosen to create a five-star experience.\n\nPerfect for solo retreats, couples' spa days, or wellness professionals seeking a premium venue for client sessions.",
    address: "Bandra West, Mumbai",
    price_per_hour: 3500, capacity: 4,
    amenities: "Private entrance, Sea view, Soaking tub, Steam shower, Aromatherapy, Massage table, WiFi, AC",
    avg_rating: 4.9, reviews_count: 23
  },
  {
    user: host1, city: "Mumbai", category: "creative",
    title: "Versova Photography Studio",
    description: "A professional photography and content creation studio in the heart of Versova's creative district. With 1,200 sq ft of open space, three switchable backdrop systems (white, black, and chroma green), and Profoto lighting equipment, this is where Mumbai's top photographers come to create.\n\nThe studio features a dedicated makeup station, changing room, product shooting table, and a lounge area for creative briefings. Natural light floods in from north-facing skylights, making morning shoots especially magical.\n\nIdeal for fashion shoots, product photography, YouTube creators, and podcast productions.",
    address: "Versova, Andheri West, Mumbai",
    price_per_hour: 2500, capacity: 15,
    amenities: "Profoto lighting, 3 backdrops, Makeup station, Green screen, Props room, WiFi, AC, Parking",
    avg_rating: 4.7, reviews_count: 41
  },
  {
    user: host1, city: "Mumbai", category: "events",
    title: "Colaba Terrace Event Space",
    description: "An intimate terrace venue in South Mumbai's most prestigious neighbourhood, with unobstructed views of the Gateway of India and the city's colonial skyline. Ideal for cocktail evenings, private dinners, engagement parties, and corporate sundowners.\n\nThe 2,000 sq ft terrace accommodates up to 60 guests seated or 100 standing. We provide basic furniture, a bar counter, and ambient string lighting. A full-service catering kitchen is available on request.\n\nThis is one of Mumbai's most sought-after sunset venues — your guests will never forget it.",
    address: "Colaba, South Mumbai",
    price_per_hour: 8000, capacity: 100,
    amenities: "City view, Bar counter, Kitchen access, Sound system, String lights, Seating, Parking",
    avg_rating: 4.8, reviews_count: 17
  },
  # Bangalore
  {
    user: host2, city: "Bangalore", category: "wellness",
    title: "Indiranagar Meditation & Yoga Loft",
    description: "A purpose-built wellness loft in the tree-lined lanes of Indiranagar. The 800 sq ft open-plan space is flooded with morning light, designed around Vastu principles, and soundproofed for uninterrupted practice.\n\nEquipped with premium yoga mats, bolsters, blocks, a sound healing gong, and a dedicated meditation corner with salt lamp lighting. The bamboo-floored space can be configured for group classes, private instruction, or solo retreats.\n\nBangalore's wellness community has made this their home — join them.",
    address: "12th Main, Indiranagar, Bangalore",
    price_per_hour: 1800, capacity: 20,
    amenities: "Yoga mats, Sound system, Meditation corner, Changing room, Shower, WiFi, AC",
    avg_rating: 4.8, reviews_count: 56
  },
  {
    user: host2, city: "Bangalore", category: "creative",
    title: "Koramangala Podcast & Recording Studio",
    description: "Professional-grade podcast and audio recording studio in Bangalore's tech hub, Koramangala. Acoustically treated with premium soundproofing, Rode microphones, and Focusrite interface — the same setup used by India's top podcasters.\n\nThe studio accommodates up to 4 people comfortably with individual microphone setups. Video recording with ring lights and DSLR camera support is available. A prep room with comfortable seating and a coffee bar keeps guests relaxed before going live.\n\nUsed by entrepreneurs, journalists, and content creators — this is where great conversations happen.",
    address: "4th Block, Koramangala, Bangalore",
    price_per_hour: 2000, capacity: 6,
    amenities: "Acoustic treatment, Rode mics, Focusrite interface, DSLR camera, Ring lights, WiFi, Coffee",
    avg_rating: 4.6, reviews_count: 34
  },
  {
    user: host2, city: "Bangalore", category: "events",
    title: "UB City Rooftop Party Deck",
    description: "Perched 22 floors above the UB City mall, this rooftop party deck offers panoramic views of Bangalore's glittering skyline. With capacity for 80 guests, it's the city's most glamorous private event space.\n\nThe deck features a permanent DJ booth, built-in LED lighting, a cocktail bar, and a catering prep station. Whether you're hosting a birthday bash, a product launch, or a milestone celebration, the city below becomes your backdrop.\n\nBookings must be confirmed 72 hours in advance. Catering partner list available on request.",
    address: "UB City, Vittal Mallya Road, Bangalore",
    price_per_hour: 12000, capacity: 80,
    amenities: "City view, DJ booth, LED lighting, Bar counter, Catering prep, Parking, Security",
    avg_rating: 4.9, reviews_count: 12
  },
  # Delhi
  {
    user: host3, city: "Delhi", category: "wellness",
    title: "Lodhi Colony Float & Spa Room",
    description: "Delhi's first private float tank suite, nestled in a quiet Lodhi Colony bungalow. The purpose-built float room features a state-of-the-art sensory deprivation pod with 500kg of Epsom salt solution, allowing complete physical and mental decompression.\n\nThe suite includes a pre-float shower, post-float rest lounge with herbal teas, and a guided audio meditation library. The surrounding garden provides a rare outdoor breathing space in the heart of Lutyens' Delhi.\n\nFor those seeking relief from stress, chronic pain, or creative block — floating is the answer.",
    address: "Lodhi Colony, New Delhi",
    price_per_hour: 4500, capacity: 2,
    amenities: "Float tank, Private shower, Rest lounge, Garden access, Herbal teas, WiFi",
    avg_rating: 4.9, reviews_count: 29
  },
  {
    user: host3, city: "Delhi", category: "creative",
    title: "Hauz Khas Village Art Studio",
    description: "A sun-drenched artist's studio in the legendary Hauz Khas Village, where Delhi's creative scene has lived for decades. The 600 sq ft whitewashed studio overlooks the medieval lake reservoir and features north-facing skylights for exceptional natural light.\n\nThe space comes stocked with easels, a sink, worktables, and ample storage. Digital creatives will appreciate the dedicated screen printing station and the 4K monitor available for design review.\n\nA short walk from some of Delhi's best cafes and galleries — inspiration is everywhere.",
    address: "Hauz Khas Village, New Delhi",
    price_per_hour: 1500, capacity: 8,
    amenities: "Natural light, Easels, Sink, Worktables, Screen printing, 4K monitor, WiFi",
    avg_rating: 4.5, reviews_count: 38
  },
  # Hyderabad
  {
    user: host2, city: "Hyderabad", category: "events",
    title: "Banjara Hills Private Dining Room",
    description: "An exclusive private dining room in a Banjara Hills villa, designed for intimate gatherings that demand discretion. The room seats 14 guests around a hand-carved teak dining table, with an adjoining butler's pantry for seamless service.\n\nThe space features warm lighting, original artwork, a curated wine cooler, and access to a professional-grade kitchen with a personal chef option. Every detail whispers old-world luxury.\n\nPopular with business dinners, anniversary celebrations, and high-profile social gatherings.",
    address: "Road No. 12, Banjara Hills, Hyderabad",
    price_per_hour: 5000, capacity: 14,
    amenities: "Private dining, Butler service, Wine cooler, Kitchen, Chef option, Valet parking",
    avg_rating: 4.8, reviews_count: 21
  },
  {
    user: host3, city: "Hyderabad", category: "wellness",
    title: "HITEC City Corporate Wellness Suite",
    description: "A premium corporate wellness suite near HITEC City, designed for employee wellbeing sessions, executive coaching, and mindfulness workshops. The 1,000 sq ft suite is divided into a movement space, a therapy room, and a quiet lounge.\n\nEquipment includes reformer Pilates equipment, TRX suspension systems, and a full air purification system. Ideal for HR teams running quarterly wellness days or coaches with corporate clients.\n\nFull-day, half-day, and hourly bookings available.",
    address: "Madhapur, HITEC City, Hyderabad",
    price_per_hour: 3000, capacity: 25,
    amenities: "Pilates equipment, TRX, Air purification, Lounge, Therapy room, Parking, WiFi",
    avg_rating: 4.6, reviews_count: 15
  },
  # Pune
  {
    user: host1, city: "Pune", category: "creative",
    title: "Koregaon Park Content Creator Studio",
    description: "A fully-loaded content creator studio in Pune's most vibrant neighbourhood, designed for YouTubers, reels creators, and digital storytellers. The studio has a living room set, a product flatlay table, and a separate green screen booth.\n\nLighting is handled by a 12-light grid system with colour control via app. The studio has been used for brand collaborations, course recordings, and live streams. 1Gbps fibre internet ensures zero-lag streaming.\n\nYour next viral moment starts here.",
    address: "Lane 7, Koregaon Park, Pune",
    price_per_hour: 1800, capacity: 8,
    amenities: "Living room set, Green screen, 12-light grid, Product flatlay, 1Gbps fibre, 4K camera, Teleprompter",
    avg_rating: 4.7, reviews_count: 44
  },
  # Chennai
  {
    user: host3, city: "Chennai", category: "events",
    title: "Nungambakkam Rooftop Event Terrace",
    description: "A beautifully appointed open-air event terrace in the heart of Nungambakkam, with a dramatic view over Chennai's cityscape. The 1,800 sq ft terrace has been designed for outdoor celebrations that balance modern aesthetics with traditional Tamil warmth.\n\nThe space includes a stage area, ambient lighting, a buffet station, and a dedicated photo corner. Air-cooled cabanas provide relief during the warmer months. Suitable for sangeet nights, product launches, alumni reunions, and corporate events.\n\nChennai's best outdoor event experience is waiting for you.",
    address: "Nungambakkam, Chennai",
    price_per_hour: 6000, capacity: 75,
    amenities: "Stage, Ambient lighting, Buffet station, Air-cooled cabanas, Photo corner, Sound system, Parking",
    avg_rating: 4.7, reviews_count: 19
  },
  {
    user: host3, city: "Chennai", category: "wellness",
    title: "Adyar Ayurvedic Treatment Room",
    description: "A purpose-built Ayurvedic treatment and consultation room in Chennai's serene Adyar neighbourhood, near the Theosophical Society gardens. The teak-panelled room has been designed to Kerala Ayurveda standards, with a Droni (treatment table), herb storage, and warm oil stations.\n\nThe space includes a bathroom with herb-infused steam option and a post-treatment rest area with Kerala herbal teas. Available for Ayurvedic practitioners, naturopaths, and wellness professionals.\n\nA rare authentic Ayurvedic setting in an urban context.",
    address: "Adyar, Chennai",
    price_per_hour: 2500, capacity: 3,
    amenities: "Ayurvedic treatment table, Herb storage, Steam room, Rest area, Herbal teas, AC",
    avg_rating: 4.9, reviews_count: 31
  },
  # More Bangalore
  {
    user: host2, city: "Bangalore", category: "wellness",
    title: "Whitefield Sound Bath & Healing Room",
    description: "A dedicated sound healing and therapeutic space in Whitefield, equipped with a complete set of crystal singing bowls, Tibetan singing bowls, and a gong. The room seats 12 on premium yoga mats and bolsters under warm amber lighting.\n\nUsed by certified sound healers for group sound baths, private sessions, and training workshops. The space is blessed, energetically cleansed weekly, and maintained with sacred geometry principles.\n\nIdeal for sound healers, yoga studios hosting special events, and wellness seekers looking for a deep reset.",
    address: "EPIP Zone, Whitefield, Bangalore",
    price_per_hour: 2200, capacity: 12,
    amenities: "Crystal bowls, Tibetan bowls, Gong, Yoga mats, Bolsters, Incense, WiFi",
    avg_rating: 4.8, reviews_count: 27
  },
  {
    user: host1, city: "Mumbai", category: "creative",
    title: "Lower Parel Boardroom & Filming Studio",
    description: "A hybrid boardroom and filming studio in Mumbai's business district, Lower Parel, ideal for corporate video productions, investor pitch recordings, and high-stakes presentations. The space is designed for efficiency and impact.\n\nThe room features an 85-inch display, teleconferencing setup, a DSLR filming corner with backdrop, and acoustic panels for crystal-clear audio. Seats 12 in boardroom configuration or can be rearranged for presentation mode.\n\nHalf-day (4hr) bookings available at a 15% discount.",
    address: "Lower Parel, Mumbai",
    price_per_hour: 3000, capacity: 12,
    amenities: "85-inch display, Teleconferencing, DSLR corner, Acoustic panels, Whiteboard, WiFi, Coffee",
    avg_rating: 4.6, reviews_count: 33
  }
]

listings_data.each do |data|
  listing = Listing.find_or_create_by!(title: data[:title]) do |l|
    l.user          = data[:user]
    l.city          = data[:city]
    l.category      = data[:category]
    l.description   = data[:description]
    l.address       = data[:address]
    l.price_per_hour = data[:price_per_hour]
    l.capacity      = data[:capacity]
    l.amenities     = data[:amenities]
    l.status        = "active"
    l.avg_rating    = data[:avg_rating]
    l.reviews_count = data[:reviews_count]
  end
end

puts "  ✓ #{Listing.count} listings created"

# ─── Bookings ─────────────────────────────────────────────────────────────────

guests   = [ guest, guest2, guest3, guest4 ]
all_listings = Listing.all.to_a

review_bodies = [
  "Absolutely stunning space. Every detail was perfect — will definitely book again!",
  "Great location and well-equipped. Exactly as described. Highly recommend.",
  "Loved the ambiance. Professional setup and the host was very responsive.",
  "One of the best spaces I've used in the city. Clean, quiet, and beautiful.",
  "Perfect for our needs. The amenities were top-notch and the booking was seamless.",
  "Incredible value for money. The space exceeded all expectations.",
  "Very well maintained. The host provided excellent support throughout.",
  "Booked for a client session — they were blown away. Will be a regular here.",
  "Clean, professional, and exactly what we needed. Smooth experience overall.",
  "The photos don't do it justice — even better in person. Highly recommended."
]

bookings_seed = [
  # Completed with reviews (past)
  { listing: all_listings[0], user: guest,  hours: 3, days_ago: 30, status: "completed", gateway: "razorpay",  payment_id: "pay_seed_001", rating: 5, review: review_bodies[0] },
  { listing: all_listings[1], user: guest2, hours: 2, days_ago: 25, status: "completed", gateway: "stripe",    payment_id: "pay_seed_002", rating: 5, review: review_bodies[1] },
  { listing: all_listings[3], user: guest3, hours: 4, days_ago: 22, status: "completed", gateway: "razorpay",  payment_id: "pay_seed_003", rating: 4, review: review_bodies[2] },
  { listing: all_listings[4], user: guest4, hours: 2, days_ago: 20, status: "completed", gateway: "stripe",    payment_id: "pay_seed_004", rating: 5, review: review_bodies[3] },
  { listing: all_listings[2], user: guest,  hours: 5, days_ago: 18, status: "completed", gateway: "razorpay",  payment_id: "pay_seed_005", rating: 4, review: review_bodies[4] },
  { listing: all_listings[6], user: guest2, hours: 2, days_ago: 15, status: "completed", gateway: nil,         payment_id: nil,            rating: 5, review: review_bodies[5] },
  { listing: all_listings[7], user: guest3, hours: 3, days_ago: 14, status: "completed", gateway: "razorpay",  payment_id: "pay_seed_007", rating: 4, review: review_bodies[6] },
  { listing: all_listings[5], user: guest4, hours: 4, days_ago: 12, status: "completed", gateway: "stripe",    payment_id: "pay_seed_008", rating: 5, review: review_bodies[7] },
  { listing: all_listings[8], user: guest,  hours: 2, days_ago: 10, status: "completed", gateway: "razorpay",  payment_id: "pay_seed_009", rating: 5, review: review_bodies[8] },
  { listing: all_listings[9], user: guest2, hours: 3, days_ago:  8, status: "completed", gateway: nil,         payment_id: nil,            rating: 4, review: review_bodies[9] },
  # Completed without reviews
  { listing: all_listings[10], user: guest3, hours: 2, days_ago: 7, status: "completed", gateway: "razorpay",  payment_id: "pay_seed_011" },
  { listing: all_listings[11], user: guest4, hours: 3, days_ago: 6, status: "completed", gateway: "stripe",    payment_id: "pay_seed_012" },
  { listing: all_listings[12], user: guest,  hours: 4, days_ago: 5, status: "completed", gateway: "razorpay",  payment_id: "pay_seed_013" },
  # Confirmed (upcoming)
  { listing: all_listings[0],  user: guest2, hours: 2, days_ago: -2, status: "confirmed", gateway: "stripe",   payment_id: "pay_seed_014" },
  { listing: all_listings[3],  user: guest3, hours: 3, days_ago: -3, status: "confirmed", gateway: "razorpay", payment_id: "pay_seed_015" },
  { listing: all_listings[1],  user: guest4, hours: 2, days_ago: -4, status: "confirmed", gateway: "stripe",   payment_id: "pay_seed_016" },
  { listing: all_listings[5],  user: guest,  hours: 5, days_ago: -5, status: "confirmed", gateway: nil,        payment_id: nil             },
  # Pending (awaiting confirmation)
  { listing: all_listings[2],  user: guest2, hours: 3, days_ago: -6,  status: "pending", gateway: "razorpay", payment_id: nil },
  { listing: all_listings[4],  user: guest3, hours: 2, days_ago: -7,  status: "pending", gateway: nil,        payment_id: nil },
  { listing: all_listings[6],  user: guest4, hours: 4, days_ago: -8,  status: "pending", gateway: "stripe",   payment_id: nil },
  { listing: all_listings[13], user: guest,  hours: 2, days_ago: -9,  status: "pending", gateway: "razorpay", payment_id: nil },
  # Cancelled
  { listing: all_listings[7],  user: guest2, hours: 2, days_ago: 35, status: "cancelled", gateway: "stripe",   payment_id: nil },
  { listing: all_listings[9],  user: guest3, hours: 3, days_ago: 40, status: "cancelled", gateway: "razorpay", payment_id: nil }
]

bookings_seed.each_with_index do |b, i|
  listing = b[:listing]
  next unless listing

  # Use a unique offset per booking to avoid time overlaps on same listing
  hour_offset = 8 + (i % 3) * 3  # 8am, 11am, or 2pm
  day = b[:days_ago].days.ago.to_date

  next if Booking.exists?(listing: listing, user: b[:user],
                           start_time: day.to_time.change(hour: hour_offset))

  booking = Booking.create!(
    listing:         listing,
    user:            b[:user],
    start_time:      day.to_time.change(hour: hour_offset),
    end_time:        day.to_time.change(hour: hour_offset + b[:hours]),
    hours:           b[:hours],
    total_price:     listing.price_per_hour * b[:hours],
    status:          b[:status],
    payment_gateway: b[:gateway],
    payment_id:      b[:payment_id]
  )

  if b[:rating] && b[:review]
    Review.find_or_create_by!(booking: booking) do |r|
      r.listing = listing
      r.user    = b[:user]
      r.rating  = b[:rating]
      r.body    = b[:review]
    end
  end
end

puts "  ✓ #{Booking.count} bookings created"
puts "  ✓ #{Review.count} reviews created"

# ─── Notifications ────────────────────────────────────────────────────────────

notifications_data = [
  { user: host1, kind: "booking_created",   read: false, created_at: 2.days.ago,
    message: "#{guest2.display_name} requested to book #{Listing.find_by(user: host1)&.title}" },
  { user: host1, kind: "booking_created",   read: false, created_at: 1.day.ago,
    message: "#{guest3.display_name} requested to book #{Listing.find_by(user: host1)&.title}" },
  { user: host2, kind: "booking_created",   read: false, created_at: 3.hours.ago,
    message: "#{guest.display_name} requested to book #{Listing.find_by(user: host2)&.title}" },
  { user: host2, kind: "booking_created",   read: false, created_at: 30.minutes.ago,
    message: "#{guest4.display_name} requested to book #{Listing.find_by(user: host2)&.title}" },
  { user: host3, kind: "booking_created",   read: false, created_at: 1.hour.ago,
    message: "#{guest2.display_name} requested to book #{Listing.find_by(user: host3)&.title}" },
  { user: guest,  kind: "booking_confirmed",  read: true,  created_at: 3.days.ago,
    message: "Your booking at #{Listing.find_by(user: host1)&.title} has been confirmed!" },
  { user: guest,  kind: "booking_confirmed",  read: false, created_at: 5.hours.ago,
    message: "Your booking at #{Listing.find_by(user: host3)&.title} has been confirmed!" },
  { user: guest2, kind: "booking_confirmed",  read: true,  created_at: 2.days.ago,
    message: "Your booking at #{Listing.find_by(user: host2)&.title} has been confirmed!" },
  { user: guest3, kind: "booking_confirmed",  read: false, created_at: 4.hours.ago,
    message: "Your booking at #{Listing.find_by(user: host2)&.title} has been confirmed!" },
  { user: guest,  kind: "booking_completed",  read: true,  created_at: 7.days.ago,
    message: "Your booking at #{Listing.find_by(user: host1)&.title} is complete. Leave a review!" },
  { user: guest2, kind: "booking_completed",  read: true,  created_at: 6.days.ago,
    message: "Your booking at #{Listing.find_by(user: host2)&.title} is complete. Leave a review!" },
  { user: guest4, kind: "booking_completed",  read: false, created_at: 2.days.ago,
    message: "Your booking at #{Listing.find_by(user: host3)&.title} is complete. Leave a review!" }
]

notifications_data.each do |attrs|
  next unless attrs[:user] && attrs[:message].present?
  Notification.find_or_create_by!(user: attrs[:user], message: attrs[:message]) do |n|
    n.kind       = attrs[:kind]
    n.read       = attrs[:read]
    n.created_at = attrs[:created_at]
    n.updated_at = attrs[:created_at]
  end
end

puts "  ✓ #{Notification.count} notifications created"

puts ""
puts "Seed complete! Demo accounts:"
puts "  Admin:  admin@spacehub.in  / password123"
puts "  Host 1: host@spacehub.in   / password123  (Mumbai)"
puts "  Host 2: arjun@spacehub.in  / password123  (Bangalore)"
puts "  Host 3: kavya@spacehub.in  / password123  (Chennai)"
puts "  Guest:  guest@spacehub.in  / password123"
