class Photo < ActiveRecord::Base
  belongs_to :picture, polymorphic: true
  mount_uploader :picture, PictureUploader
  crop_uploaded :picture

  # validates_presence_of :picture_id, :picture_type

  def self.update_photo model, picture
     if model.photo.nil?
       model.create_photo(picture: picture)
     else
       photo = Photo.new(picture: picture)
       model.update_attribute(:photo, photo)
     end
  end
end
