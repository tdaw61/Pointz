# encoding: utf-8
# require 'carrierwave/processing/mini_magick'

class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :fog
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    if model.class == User
      "" + [version_name, "default_avatar.jpeg"].compact.join('_')
    end
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    #{}"/images/fallback/" + [version_name, "default.png"].compact.join('_')
    #rails will look at 'app/assets/images/default_avatar.png'
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  version :large_avatar do
    # returns a 150x150 image
    process :resize_to_fit => [150, 150]
  end
  version :medium_avatar do
    # returns a 50x50 image
    process :resize_to_fill => [65, 65]
  end
  version :small_avatar do
    # returns a 35x35 image
    process :resize_to_fill => [35, 35]
  end

  # version :thumb do
  # process :resize_nocrop_noscale => [35, 35]
  #   :resize_to_fill
  # end
  #
  # def resize_nocrop_noscale(w,h)
  #   image = ::MiniMagick::Image.open(current_path)
  #   w_original = img[:width].to_f
  #   h_original = img[:height].to_f
  #
  #   if w_original < w && h_original < h
  #     return im
  #   end
  #
  #   # resize
  #   img.resize("#{w}x#{h}")
  #
  #   return img
  # end

  # Create different versions of your uploaded files:


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end