require 'fastercsv'

namespace :app do

  namespace :video do
    namespace :images do
      desc "Add video_player image size (672x380)"
      task :add_video_player_size => :environment do
        videos = Video.all
        videos.each do |video|
          path = "#{RAILS_ROOT}/public#{video.image.url(:original, include_updated_timestamp = false)}"
          if !path.index("/images/original/missing.png")
            video.image = File.new(path, "r")
            video.save
          end
        end
      end
    end
  end
  
  namespace :export do
    namespace :acutrack_orders do
      desc "Export orders to CSV format"
      task :to_csv => :environment do
        orders = Order.paginate(:page => 1, :per_page =>  10, :order => "id")
        total_pages = orders.total_pages
        FasterCSV.open("orders.csv", "w") do |csv|
          csv << ["PurchaseOrderNo", "ItemNo", "ProductId", "Quantity", "ShipFirstName", "ShipLastName", "ShipAddress1", "ShipAddress2", "ShipCity", "ShipState", "ShipPostalCode", "ShipCountry", "ShipPhone", "ShipEmail", "ShippingTypeId"]
          for page in 1..total_pages
            orders = Order.paginate(:page => page, :per_page =>  10, :order => "id")
            orders.each do |order|
              order.to_csv(csv) if order.shipping_address
            end
          end
        end
      end
    end
  end
end