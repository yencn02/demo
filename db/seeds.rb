#Seed data for CardType
card_types = YAML.load_file("#{RAILS_ROOT}/db/fixtures/card_types.yml")
card_types.values.each do |type|
  CardType.find_or_create_by_name_and_code(:name => type["name"], :code => type["code"])
end

#Create some default users
users = YAML.load_file("#{RAILS_ROOT}/db/fixtures/users.yml")
users.values.each do |u|
  unless user = User.find_by_email(u["email"])
    user = User.create(:email => u["email"], :password => u["password"],
      :is_admin => u["is_admin"], :password_confirmation => u["password_confirmation"])
    Account.create(u["account"].merge({"user" => user}))
  end
end

#Add videos
videos = YAML.load_file("#{RAILS_ROOT}/db/fixtures/videos.yml")
videos.values.each do |vdo|
  video = Video.first(:conditions => {:title => vdo["title"], :description => vdo["description"], :duration_in_seconds => vdo["duration_in_seconds"], :demo_url => vdo["demo_url"]})
  unless video
    category = Category.find_or_create_by_name(vdo["category"])
    video = Video.create(:title => vdo["title"], :description => vdo["description"], :duration_in_seconds => vdo["duration_in_seconds"], :demo_url => vdo["demo_url"])
    category.categorizables.create(:categorized => video)
    vdo["trails"].values.each do |tr|
      video.trails.create(:name => tr)
    end
    vdo["formats"].values.each do |fm|
      format = Format.find_or_create_by_name(:name => fm["name"])
      video_format = VideoFormat.find_by_acutrack_sku(fm["acutrack_sku"])
      unless video_format
        price = Price.new(:amount_in_cents => fm["price"].to_money.cents)
        video.formats.create(:price => price, :format => format, :acutrack_sku => fm["acutrack_sku"], :cdn_url => "VAHK0101I_480_01(test).mp4")
      end
    end
  end
end

# add gym locations
gym_locations = YAML.load_file("#{RAILS_ROOT}/db/fixtures/gym_locations.yml")
gym_locations.values.each do |location|
  location_ = GymLocation.first(:conditions => {:location_name => location["location_name"], :address1 => location["address1"],
      :city => location["city"], :state => location["state"], :country => "US",
      :zipcode => location["zipcode"].to_s, :phone => location["phone"], :website => location["website"]})
  unless location_
    location_ = GymLocation.new(:location_name => location["location_name"], :address1 => location["address1"],
      :city => location["city"], :state => location["state"], :country => "US",
      :zipcode => location["zipcode"].to_s, :phone => location["phone"], :website => location["website"])
    unless location_.save
      puts location_.errors.inspect
    end
  end
end

#Add Video packs
['Running Videos', 'Cycling Videos', 'Touring Videos', 'Hiking Videos'].each do |video_pack_name|
  video_pack = VideoPack.find_by_title(video_pack_name)
  unless video_pack
    video_pack = VideoPack.create(:title => video_pack_name, :description => "Great #{video_pack_name}!", :image => '', :purchase_count => rand(1000))
    video_ids = (Video.minimum(:id)..rand(Video.count)+ Video.minimum(:id)).to_a.collect { num = rand(Video.count)+ Video.minimum(:id); num unless num.zero? }.compact
    video_pack.videos << Video.find(video_ids)

    # add format
    ["DVD"].each_with_index do |format_name, i|
      format = Format.find_or_create_by_name(:name => format_name)
      format.format_order = i + 1
      format.save
      price = Price.new(:amount_in_cents => rand(1000))
      video_pack.formats.create(:format => format, :price => price)
    end
  end
end