class Admin::ImagesController < Admin::BaseController 
  layout "admin"
  def index
    @default = bg_image_path(BG_DEFAULT)
    @ipad = bg_image_path(BG_IPAD)
    @ipad = @default unless @ipad
  end

  def upload_image    
    if params[:image].nil?
      flash[:notice] = "Please select a image"
    else
      save_image(params[:image][:default], BG_DEFAULT) if params[:image][:default]
      save_image(params[:image][:ipad], BG_IPAD) if params[:image][:ipad]
    end
    redirect_to  :action => :index
  end

  def save_image(image, image_name)
    if valiation_image(image)
      name =  image.original_filename
      FileUtils.mkdir_p BG_DIRECTORY unless File.directory?(BG_DIRECTORY)
      rename_file(image_name)
      arrs = name.split(".")
      path = File.join(BG_DIRECTORY, "#{image_name}.#{arrs[arrs.size-1]}")
      File.open(path, "wb") { |f| f.write(image.read) }
    else
      flash[:notice] = "Image not valid"
    end
  end

  def valiation_image(image)
    if ['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg'].index(image.content_type)
      return true
    end
    return false
  end

  def rename_file(image_name)
    file_names = ["#{image_name}.jpg", "#{image_name}.png", "#{image_name}.gif"]
    file_names.each do |file_name|
      arrs = file_name.split(".")
      if(arrs.size > 0)
        old_name = File.join(BG_DIRECTORY, file_name)
        new_name = File.join(BG_DIRECTORY, "#{image_name}_#{Time.now.to_i}.#{arrs[arrs.size-1]}")
        File.rename(old_name, new_name) if File.exists?(old_name)
      end
    end
  end
  
  def bg_image_path(image_name)
    file_names = ["#{image_name}.jpg", "#{image_name}.png", "#{image_name}.gif"]
    image_path = nil
    file_names.each do |file_name|
      if File.exists?(File.join(BG_DIRECTORY, file_name))
        image_path = File.join("/system/background_images", file_name)
      end
    end
    return image_path
  end
  
end
